// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIExtensions",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SwiftUIExtensions",
            targets: ["SwiftUIExtensions"]),
    ],
    dependencies: [
        .package(
             url: "https://github.com/apple/swift-collections.git",
             .upToNextMajor(from: "1.1.0")
           )
    ],
    targets: [
        .target(
            name: "SwiftUIExtensions", dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ]),
        .testTarget(
            name: "SwiftUIExtensionsTests",
            dependencies: ["SwiftUIExtensions"]),
    ]
)
