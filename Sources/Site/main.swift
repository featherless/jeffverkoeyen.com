import Foundation
import Slipstream

let projectRootURL = URL(filePath: #filePath)
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .deletingLastPathComponent()
let sourceURL = projectRootURL.appending(path: ".src")
let siteURL = projectRootURL.appending(path: "site")

if !FileManager.default.fileExists(atPath: sourceURL.absoluteString) {
  try FileManager.default.createDirectory(at: sourceURL, withIntermediateDirectories: true)
}

let sitemap: [String: any View] = [
  "index.html": Home(),
  "about/index.html": About(),
  "contact/index.html": Contact(),
  "portfolio/index.html": Portfolio(),
]

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
