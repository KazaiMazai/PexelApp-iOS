// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MainFeed",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MainFeed",
            targets: ["MainFeed"])
    ],
    dependencies: [
        .package(name: "DomainModel", path: "../DomainModel"),
        .package(name: "DesignSystem", path: "../DesignSystem"),
        .package(name: "SwiftUIExtensions", path: "../SwiftUIExtensions"),
        .package(name: "PexelAPI", path: "../PexelAPI")

    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MainFeed",
            dependencies: [
                 "DomainModel",
                 "DesignSystem",
                 "SwiftUIExtensions",
                 "PexelAPI"
            ]
        ),
        .testTarget(
            name: "MainFeedTests",
            dependencies: ["MainFeed"])
    ]
)
