// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DSKit",
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
            name: "DSKit"
        ),
        .testTarget(
            name: "DSKitTests",
            dependencies: ["DSKit"]
        ),
    ],
    swiftLanguageModes: [.v5]
)
