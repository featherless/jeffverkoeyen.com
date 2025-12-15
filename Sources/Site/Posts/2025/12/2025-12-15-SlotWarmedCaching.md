# 10× faster Xcode CI builds with slot caching

[Two months ago](/2025/10/2025-10-17-SelfHostingMacMinis), I started saving roughly $4,000/month by self-hosting Mac minis for Sidecar’s CI. For the first time, I had reliable continuous integration for [Sidecar](https://sidecar.clutch.engineering).

Over the following two months, I expanded test coverage organically, growing from zero to **91 workflows**. Each Clutch Engineering app had its own build-and-test workflow; each Swift package had its own test workflow; and all workflows used GitHub Actions’ `paths` filtering to determine when they needed to run.

As you might expect, even with three machines, end-to-end pull request times eventually grew to **15–30 minutes per PR**. Sidecar alone takes ~12 minutes to build from a clean state, and depending on how many packages needed testing, total CI time could spiral quickly.

This became a critical problem this month. I strongly believe that if you aren't getting meaningful presubmit feedback within five minutes, you are at serious risk of a *regretted context switch*. At that point, pull requests become a productivity bottleneck rather than a safety net.

So last week I sat down and, after several failed experiments, landed on a solution that now delivers **~2.5-minute** average end-to-end presubmits; this includes full Sidecar builds and all affected tests. That is roughly a **10× improvement**.

I went down a number of rabbit holes to get here, and none of them documented the approach I ultimately adopted. I suspect this is because relatively few people run self-hosted macOS CI infrastructure, which is a hard requirement for this setup.

What follows is a full technical breakdown of the solution I ended up implementing, which I call **slot-warmed caching**.

---

## How I got here: organic growth to 91 workflows

A quick recap from October.

Sidecar had tests, but running them on GitHub’s hosted macOS runners would have cost thousands of dollars per month. The incentive structure was backwards; more tests meant higher costs. As a result, I largely avoided CI, ran tests manually, and hoped I didn't miss anything.

Then I [set up self-hosted Mac minis](/2025/10/2025-10-17-SelfHostingMacMinis). Overnight, CI costs effectively dropped to zero; electricity plus amortized hardware costs work out to roughly $70/month. I could finally add tests without worrying about the bill.

I started small; one test, then another, then a few more.

Each package got its own workflow file:

- `AlgorithmKit-tests.yml`
- `JourneyLoggingKit-tests.yml`
- `IdentifierRegistry-tests.yml`
- …and so on

Each workflow included change detection so it would only run when necessary. This worked well at first; coverage improved, confidence increased, and I kept adding more tests.

Eventually: **91 workflows**.

This wasn't a deliberate design decision. It was incremental improvement that compounded over time; each individual step made sense, but the aggregate didn't.

---

## The problem: fast hardware, slow builds

I had three self-hosted Mac minis running workflows in parallel. GitHub Actions would fan out work across them; change ten packages and ten or more workflows would run concurrently across the cluster.

Even with this parallelism, pull requests still took **12–20 minutes at a minimum**, and often **15–30 minutes** when another PR was running and contending for resources.

**Why so slow despite parallelism?**

The Sidecar app build alone takes about 12 minutes. That sets a hard floor; no amount of parallelism can push total CI time below that.

But the deeper inefficiency was this:

- Every workflow started from a cold `DerivedData`
- A single-line change in `IdentifierRegistry` could trigger 20+ workflows, each rebuilding it independently
- There was no cache sharing between workflows
- Different machines meant rebuilding the same dependencies repeatedly

---

## The search for a caching solution

I needed a way to cache Xcode build artifacts.

Unfortunately, Xcode caching is finicky.

`DerivedData` works well locally, but it isn't designed for CI. As I discovered the hard way, you cannot simply copy a `DerivedData` directory to a new location and expect Xcode to use it; the build path is baked into the artifacts. Xcode 26 introduces a new caching system, but in practice it has been unreliable for speeding up iterative builds across multiple target contexts.

### Sharing cache artifacts between apps and Swift packages

Sidecar’s dependency graph includes hundreds of Swift packages and targets. Across Sidecar, CANStudio, and ELMCheck, there is a significant amount of shared code.

So it was particularly frustrating to discover that **Xcode doesn't share build artifacts between app targets and Swift packages**.

Build Sidecar, then build a Swift package test target that depends on the same code, and Xcode happily recompiles everything; this happens even if both builds point at the same `DerivedData`.

I ran a series of experiments to understand the scope of the problem:

| Scenario | Cache Shared? | Notes |
|---------|---------------|-------|
| Xcode project → Xcode project | ✅ Yes | CANStudio → ELMCheck: 28s → 18s (36% faster) |
| Swift package → Swift package | ❌ No | Each uses its own `.swiftpm/xcode` context |
| Xcode project → Swift package | ❌ No | Different workspace contexts |

Combine this with the fact that you cannot easily add Swift package dependency tests to an app’s test plan without manually adding each package to the Xcode project, and you end up wasting a lot of CI time. The fact that artifacts weren't even shared between Swift packages was the most painful discovery.

This confirmed two core issues:

1. Building an app doesn't accelerate Swift package testing.
2. Swift packages don't share build artifacts with each other.

At a minimum, I would need separate caches for app targets and Swift packages. The latter is especially problematic, as it implies duplicated build artifacts for each node in the dependency graph.

---

## Solving package-to-package caching with an umbrella package

To solve package-to-package caching, I asked an obvious but radical question: what if there were only *one* Swift package?

That would be terrible for day-to-day development, but what if this package were generated dynamically as part of CI?

With a single Swift package, there is a single `DerivedData` context. Tests require one build pass and one copy of all artifacts.

To make this work, I use a Python script invoked like this:

```bash
python3 .github/scripts/generate_umbrella_package.py \
  --platform ios \
  --output packages/Package.swift
```

The generator:

1. Runs `swift package dump-package` on all 89 packages, in parallel
2. Filters by platform support
3. Validates dependencies; this excludes internal-only targets and third-party packages
4. Generates a platform-specific `Package.swift`

### Important caveat: API visibility

In the umbrella package, all packages become `package`-visible to one another. Tests could accidentally reach into APIs that shouldn't be accessible.

This is where app builds matter.

Apps are built using the real dependency graph, not the umbrella. If a test leaks an internal API, the app build fails.

That is why each slot maintains **two caches**:

- `app-cache`: Builds apps using the correct dependency graph and enforces API boundaries
- `package-cache`: Builds the umbrella package and enables artifact sharing across tests

This dual-cache approach preserves correctness while delivering performance.

---

## Implementing cache reuse

Armed with a clearer understanding of Xcode’s behavior, I tried three approaches.

### 1. GitHub Actions cache

The obvious first option was `actions/cache`.

Unfortunately, `DerivedData` weighed in at roughly 20 GB. Uploading and downloading that on every run would be slower than rebuilding from scratch, especially on a home internet connection already busy uploading routing data for Clutch Engineering.

### 2. Copying a "golden" cache

Next, I tried keeping a prebuilt "golden" cache on each machine and copying it into each workflow directory.

This failed because **Xcode bakes absolute build paths into `DerivedData`**. Copy the cache to a new path and Xcode ignores it entirely.

### 3. Fixed paths with allocatable slots

The solution that worked was deceptively simple: keep `DerivedData` at fixed paths and have workflows build in place.

No copying; no moving; just reuse the same directories.

This is what I call a **slot-based cache**.

---

## The slot-based cache

With fixed paths established as the only viable approach, the remaining problem was concurrency.

### Directory layout

```
/opt/ci-cache/
  slots/
    ios/
      0/
        app-cache/
        package-cache/
        lock
        affinity
      1/
        …
    macos/
      0/
        …
    watchos/
      0/
        …
```

### Why slots instead of per-PR caches?

Because `DerivedData` embeds its build path in many files; relocating it would require rewriting binary artifacts. That approach would be extremely brittle and fragile.

Slots avoid that entirely.

### Platform specialization

Sidecar, CANStudio, and ELMCheck target iOS, macOS, and watchOS. Each platform requires distinct build artifacts.

Rather than having every machine build every platform, I specialized:

- **Mac mini M4 Pro**: iOS
- **Mac mini M4**: macOS
- **MacBook Pro M1 Max**: watchOS

The benefits:

- Each machine maintains caches for exactly one platform, minimizing the cache footprint on each machine
- Performance is predictable; I can easily swap machine specialization if needed
- Parallelism comes naturally from platform separation

### Slot acquisition

1. A PR arrives
2. The workflow checks affinity files to find the slot last used by that PR
3. If the slot is locked, it tries the next one
4. It acquires a free slot and creates a lock file
5. Builds using the slot’s caches
6. Releases the lock when finished

Affinity is crucial; force-pushes to the same PR get excellent cache reuse.

Each PR does "dirty" its slot, but this mirrors normal local development. After merges, a separate workflow re-warms caches from `main` to keep them close to head.

---

## Running only affected tests

Previously, I relied on GitHub workflow-level filtering. With a single consolidated workflow, I needed a new approach.

### Dependency map

The monorepo now maintains a cached dependency graph mapping packages to their dependencies and dependents:

```json
{
  "IdentifierRegistry": {
    "dependencies": [],
    "dependents": ["GarageKit", "VehicleKit"]
  }
}
```

### Detection algorithm

Script: `detect_affected_packages.py`

1. `git diff` to find changed files
2. Map files to packages
3. Look up dependents
4. Compute the transitive closure
5. Determine affected apps
6. Output test targets and app builds

### Example

- **Changed**: `IdentifierRegistry/Sources/Registry.swift`
- **Affected packages**: 12
- **Affected apps**: All three
- **Executed**: 12 test targets and 3 app builds
- **Skipped**: 61 unrelated test targets

Combined with warm caches, most PRs test less than 20% of the codebase while maintaining full confidence.

---

## Results

**Before**: 15–30 minutes per PR
**After**: ~2.5 minutes average, over the last 96 runs
**Improvement**: ~10×

Typical breakdown:

- Slot acquisition: less than one second
- App build, warm cache: about one minute
- Affected tests: about one minute
- **Total**: 2–3 minutes

---

## The real win: staying in flow

There is a hard productivity threshold around five minutes.

**Above five minutes**:
- You context switch
- You lose momentum
- Fixing failures takes longer

**Below five minutes**:
- You stay engaged
- Failures are fixed immediately
- Multiple iterations land per hour

Dropping CI time from 15–30 minutes to roughly 2.5 minutes didn't just about make CI faster, it removed an entire hurdle to my ability to iterate efficiently on Sidecar.

---

## P.S. Why not Bazel or Buck?

Bazel and Buck solve this class of problem well, but at a cost.

I want to stay within Apple’s ecosystem:

- First-class Xcode support
- SwiftUI previews
- Native debugging and profiling

Bazel and Buck introduce parallel build systems, duplicate configuration, and constant tooling drift. For my goals, squeezing performance out of Xcode itself was the right tradeoff.
