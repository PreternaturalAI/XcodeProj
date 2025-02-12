// swift-tools-version:5.10

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
            targets: ["XcodeProj"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/tadija/AEXML.git", from: "4.6.1"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
        .package(url: "https://github.com/vmanot/Swallow.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "XcodeProj",
            dependencies: [
                .product(name: "PathKit", package: "PathKit"),
                .product(name: "AEXML", package: "AEXML"),
                "Swallow"
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "XcodeProjTests",
            dependencies: ["XcodeProj"]
        ),
    ]
)
