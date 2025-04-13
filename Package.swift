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
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMinor(from: "1.0.1")),
        .package(url: "https://github.com/vmanot/CorePersistence.git", branch: "main"),
        .package(url: "https://github.com/vmanot/Swallow.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "XcodeProj",
            dependencies: [
                "CorePersistence",
                "PathKit",
                "Swallow"
            ],
            swiftSettings: []
        ),
        .testTarget(
            name: "XcodeProjTests",
            dependencies: [
                "XcodeProj"
            ]
        ),
    ]
)
