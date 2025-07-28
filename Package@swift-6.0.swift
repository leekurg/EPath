// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EPath",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .visionOS(.v1), .watchOS(.v4)],
    products: [
        .library(
            name: "EPath",
            targets: ["EPath"]
        )
    ],
    targets: [
        .target(
            name: "EPath")
    ],
    swiftLanguageModes: [.v6]
)
