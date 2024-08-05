// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "jeffverkoeyen.com",
  platforms: [
    .macOS("14"),
    .iOS("17"),
  ],
  dependencies: [
    .package(url: "https://github.com/jverkoey/slipstream.git", branch: "main"),
  ],
  targets: [
    .executableTarget(name: "Site", dependencies: [
      .product(name: "Slipstream", package: "slipstream")
    ]),
  ]
)
