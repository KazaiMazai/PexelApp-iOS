// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DI",
            targets: ["DI"])

    ],
    dependencies: [
        .package(name: "PexelAPI", path: "../PexelAPI"),
        .package(name: "MainFeed", path: "../MainFeed"),
        .package(name: "SwiftUIExtensions", path: "../SwiftUIExtensions")

    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DI",
            dependencies: [
                .product(name: "PexelAPI", package: "PexelAPI"),
                .product(name: "MainFeed", package: "MainFeed"),
                .product(name: "SwiftUIExtensions", package: "SwiftUIExtensions")
            ]
        ),
        .testTarget(
            name: "DITests",
            dependencies: ["DI"])
    ]
)
