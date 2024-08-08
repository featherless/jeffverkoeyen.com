import Foundation

import Markdown
import Slipstream

let thisFileURL = URL(filePath: #filePath)
let thisFolderURL = thisFileURL.deletingLastPathComponent()

let projectRootURL = thisFolderURL
  .deletingLastPathComponent()
  .deletingLastPathComponent()
let sourceURL = projectRootURL.appending(path: ".src")
let siteURL = projectRootURL.appending(path: "site")
guard let blogURLPrefix = URL(string: "/blog/") else {
  fatalError()
}
let postsURL = thisFolderURL.appending(path: "Posts")

if !FileManager.default.fileExists(atPath: sourceURL.absoluteString) {
  try FileManager.default.createDirectory(at: sourceURL, withIntermediateDirectories: true)
}

var sitemap: Sitemap = [
  "index.html": Home(),
  "about/index.html": About(),
  "contact/index.html": Contact(),
  "portfolio/index.html": Portfolio(),
]

func allBlogFiles(in directory: URL?) -> [URL] {
  guard let directory else {
    return []
  }
  var markdownFiles: [URL] = []
  guard let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: nil) else {
    return markdownFiles
  }
  for case let fileURL as URL in enumerator {
    if fileURL.pathExtension == "md" {
      markdownFiles.append(fileURL)
    }
  }
  return markdownFiles.sorted { $0.path() < $1.path() }
}

func postURL(filePath file: URL) throws -> BlogPost? {
  let datedSlug = file.deletingPathExtension().lastPathComponent
  var parts = datedSlug.components(separatedBy: "-")
  guard parts.count > 3 else {
    print("Malformed slug: ", file)
    return nil
  }
  guard let year = Int(parts[0]),
        let month = Int(parts[1]),
        let day = Int(parts[2]) else {
    print("Malformed slug date: ", file)
    return nil
  }
  let components = DateComponents(calendar: .current, year: year, month: month, day: day)
  guard let date = Calendar.current.date(from: components) else {
    print("Invalid date components: \(components)")
    return nil
  }

  parts.removeFirst(3)
  let slug = parts.joined(separator: "-")

  let postContent = try String(contentsOf: file)
  let document = Document(parsing: postContent)

  let documentHeading = (document.children.first { node in
    if let heading = node as? Markdown.Heading,
       heading.level == 1 {
      return true
    }
    return false
  } as? Markdown.Heading)?.plainText

  let outputURL = blogURLPrefix
    .appending(components: String(format: "%04d", year), String(format: "%02d", month), String(format: "%02d", day))
    .appending(path: slug)
    .appending(path: "index")
    .appendingPathExtension("html")
  return BlogPost(
    fileURL: file,
    slug: slug,
    outputURL: outputURL,
    url: outputURL.deletingLastPathComponent(),
    date: date,
    title: documentHeading,
    content: postContent,
    document: document
  )
}

let posts = try allBlogFiles(in: postsURL).compactMap { try postURL(filePath: $0) }
for (index, post) in posts.enumerated() {
  let previous = index > 0 ? posts[index - 1] : nil
  let next = (index < posts.count - 1) ? posts[index + 1] : nil

  sitemap[post.outputURL.path()] = BlogPostView(
    post: post,
    next: next,
    previous: previous
  )
}
if let mostRecentPost = posts.last {
  sitemap["blog/index.html"] = BlogPostView(
    post: mostRecentPost,
    next: nil,
    previous: posts.dropLast().last
  )
}

try renderSitemap(sitemap, to: siteURL)

let site = "https://jeffverkoeyen.com"
let feedFilename = "feed.atom"

struct AtomEntry {
  let title: String?
  let url: URL
  let date: Date
  let html: String

  var toString: String {
    return """
<entry>
  <title>\(title ?? "No title")</title>
  <link rel="alternate" type="text/html" href="\(site)\(url.path())"/>
  <id>\(site)\(url.path())</id>
  <published>\(ISO8601DateFormatter().string(from: date))</published>
  <updated>\(ISO8601DateFormatter().string(from: date))</updated>
  <content type="html">><![CDATA[\(html)]]></content>
</entry>
"""
  }
}
let atomEntries = try posts.reversed().map {
  AtomEntry(
    title: $0.title,
    url: $0.url,
    date: $0.date,
    html: try renderHTML(Article($0.content))
  )
}.map { $0.toString }.joined(separator: "\n")

let atomFeed = """
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:fh="http://purl.org/syndication/history/1.0" xml:base="/feed.atom" xml:lang="en-US">
	<title>featherless software design</title>
	<id>\(site)</id>
	<link rel="alternate" href="\(site)"/>
  <link href="\(site)/\(feedFilename)" rel="self"/>
  <link href="\(site)/\(feedFilename)" rel="first"/>
 <updated>\(ISO8601DateFormatter().string(from: .now))</updated>
	<author>
		<name>Jeff Verkoeyen</name>
    <uri>\(site)</uri>
    <email>jverkoey@gmail.com</email>
	</author>
\(atomEntries)
</feed>
"""

try atomFeed.write(to: siteURL.appending(path: feedFilename), atomically: true, encoding: .utf8)

let process = Process()
let pipe = Pipe()
process.standardOutput = pipe
process.executableURL = URL(fileURLWithPath: "/bin/zsh")
process.environment = ["PATH": "/opt/homebrew/bin:/Applications/Xcode-beta.app/Contents/Developer/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin"]
process.arguments = [
  "-c",
  "cd \(projectRootURL.path(percentEncoded: false)) && npx tailwindcss -i .src/tailwind.css -o ./site/css/main.css --minify",
]

try process.run()
let data = pipe.fileHandleForReading.readDataToEndOfFile()

guard let standardOutput = String(data: data, encoding: .utf8) else {
  FileHandle.standardError.write(Data("Error in reading standard output data".utf8))
  fatalError() // or exit(EXIT_FAILURE) and equivalent
  // or, you might want to handle it in some other way instead of a crash
}

print(standardOutput)
