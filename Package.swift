// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DSKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "DSKit",
            targets: ["DSKit"]
        ),
    ],
    targets: [
        .target(
            name: "DSKit",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "DSKitTests",
            dependencies: ["DSKit"]
        ),
    ],
    swiftLanguageModes: [.v5]
)
