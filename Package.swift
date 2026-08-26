// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "XcodeProj",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "XcodeProj",
            targets: [
                "XcodeProj"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vmanot/CorePersistence.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "XcodeProj",
            dependencies: [
                .product(name: "_AEXML", package: "CorePersistence"),
                "XcodeProjPathKit",
            ],
            swiftSettings: []
        ),
        .target(
            name: "XcodeProjPathKit",
            path: "Dependencies/PathKit",
            exclude: [
                "LICENSE"
            ]
        ),
        .testTarget(
            name: "XcodeProjTests",
            dependencies: [
                "XcodeProj"
            ]
        ),
    ]
)
