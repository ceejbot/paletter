// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "paletter",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "PaletterCore",
            dependencies: ["Yams"]),
        .executableTarget(
            name: "paletter",
            dependencies: [
                "PaletterCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "PaletterCoreTests",
            dependencies: ["PaletterCore", "Yams"]),
    ]
)
