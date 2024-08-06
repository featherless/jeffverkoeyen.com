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
]

for (path, view) in sitemap {
  let output = try "<!DOCTYPE html>\n" + renderHTML(view)
  try output.write(to: siteURL.appending(path: path), atomically: true, encoding: .utf8)
}

try """
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./**/*.html"],
  theme: {
    extend: {
      boxShadow: {
        'puck': '0 0 4px 0 #0003,0 2px 0 0 #0000001a' 
      }
    },
    fontFamily: {
      'rounded': ['ui-rounded', '-apple-system', 'system-ui', 'BlinkMacSystemFont', '"Segoe UI"', 'Roboto', '"Helvetica Neue"', 'Arial', 'sans-serif']
    },
    container: {
      center: true
    },
    screens: {
      'sm': '375px',
      'md': '900px',
    }
  },
  plugins: [],
}
""".write(
  to: projectRootURL.appending(path: "tailwind.config.js"),
  atomically: true,
  encoding: .utf8
)

try """
@tailwind base;
@tailwind components;
@tailwind utilities;
""".write(
  to: sourceURL.appending(path: "tailwind.css"),
  atomically: true,
  encoding: .utf8
)

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



//module.exports = {
//  content: [
//    "./index.html",
//    "./privacy-policy/*.html",
//    "./scanning/*.html",
//    "./scanning/extended-pids/*.html",
//    "./scanning/repo-status/*.html",
//    "./shortcuts/*.html"
//  ],
//  darkMode: 'media',
//  theme: {
//    extend: {
//      colors: {
//        'sidecar-gray': '#262625',
//      }
//    },
//    fontFamily: {
//      'rounded': ['ui-rounded', '-apple-system', 'system-ui', 'BlinkMacSystemFont', '"Segoe UI"', 'Roboto', '"Helvetica Neue"', 'Arial', 'sans-serif']
//    },
//    container: {
//      center: true
//    },
//    screens: {
//      'sm': '375px',
//      'md': '900px',
//    }
//  },
//  plugins: [],
//}
