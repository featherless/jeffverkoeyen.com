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

var sitemap: [String: any View] = [
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

struct BlogPost {
  let fileURL: URL
  let slug: String
  let outputURL: URL
  let url: URL
  let date: Date
  let title: String?
  let content: String
  let document: Document
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

for (path, view) in sitemap {
  let output = try "<!DOCTYPE html>\n" + renderHTML(view)
  let fileURL = siteURL.appending(path: path)
  let folderURL = fileURL.deletingLastPathComponent()
  if !FileManager.default.fileExists(atPath: folderURL.path(percentEncoded: false)) {
    try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
  }
  try output.write(to: siteURL.appending(path: path), atomically: true, encoding: .utf8)
}

let process = Process()
let pipe = Pipe()
process.standardOutput = pipe
process.executableURL = URL(fileURLWithPath: "/bin/zsh")
process.environment = ["PATH": "/opt/homebrew/bin:/Applications/Xcode-beta.app/Contents/Developer/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin"]
process.arguments = [
  "-c",
  "cd \(projectRootURL.path(percentEncoded: false)) && npx tailwindcss -i .src/tailwind.css -o ./site/css/main.css --minify",
]

try! process.run()
let data = pipe.fileHandleForReading.readDataToEndOfFile()

guard let standardOutput = String(data: data, encoding: .utf8) else {
  FileHandle.standardError.write(Data("Error in reading standard output data".utf8))
  fatalError() // or exit(EXIT_FAILURE) and equivalent
  // or, you might want to handle it in some other way instead of a crash
}

print(standardOutput)
