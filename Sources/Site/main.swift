import Foundation
import Slipstream

struct Site: View {
  var body: some View {
    HTML {
      Head {
        Charset(.utf8)
        Title("featherless software design")
        Viewport.mobileFriendly
        Meta(.description, content: "Jeff Verkoeyen is a software designer under the alias featherless@.")
        Meta(.generator, content: "Slipstream")
        Meta(.author, content: "Jeff Verkoeyen")
        Preload(URL(string: "/gfx/feather.svg"), as: .image)
        Stylesheet(URL(string: "/css/main.css"))
      }
      Body {
        Container {
          VStack(spacing: 8) {
            H1 {
              Text("featherless")
              Linebreak()
              Text("software design")
            }
            .textAlignment(.right)
            .padding(.bottom, 16)
            .padding(.bottom, 0, condition: .desktop)
            .margin(.horizontal, .auto, condition: .desktop)
            .fontWeight(300)

            .fontSize(40)
            .padding(.top, 75)
            .margin(.left, 45)
            .backgroundImage(
              URL(string: "/gfx/feather.svg"),
              size: .size(width: 184, height: 184),
              repeat: .no
            )

            .fontSize(48, condition: .desktop)
            .padding(.top, 125, condition: .desktop)
            .padding(.left, 150, condition: .desktop)
            .padding(.right, 48, condition: .desktop)
            .backgroundImage(
              URL(string: "/gfx/feather.svg"),
              size: .size(width: 256, height: 256),
              condition: .desktop
            )

            Div {
              HomeLink("portfolio", destination: URL(string: "/portfolio"))
              HomeLink("blog", destination: URL(string: "http://blog.jeffverkoeyen.com/"))
              HomeLink("contact", destination: URL(string: "/contact"))
              HomeLink("about", destination: URL(string: "/about"))
            }
            .fontSize(32)
            .fontWeight(300)
            .textAlignment(.right)
            .display(.flex)
            .flexDirection(.y)
            .flexGap(.y, width: 8)
            .textAlignment(.center, condition: .desktop)
            .flexDirection(.x, condition: .desktop)
            .flexGap(.x, width: 8, condition: .desktop)
            .justifyContent(.center)
            .alignItems(.end)
            .alignItems(.start, condition: .desktop)
          }
        }
        .textColor(.zinc, darkness: 950)
        .fontDesign("rounded")
      }
      .antialiased()
    }
    .language("en")
  }
}

let projectRootURL = URL(filePath: #filePath)
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .deletingLastPathComponent()
let sourceURL = projectRootURL.appending(path: ".src")

if !FileManager.default.fileExists(atPath: sourceURL.absoluteString) {
  try FileManager.default.createDirectory(at: sourceURL, withIntermediateDirectories: true)
}




try """
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./**/*.html"],
  theme: {
    extend: {},
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

let output = try "<!DOCTYPE html>\n" + renderHTML(Site())
try output.write(to: projectRootURL.appending(path: "site/index.html"), atomically: true, encoding: .utf8)

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
