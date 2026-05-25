// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
    swiftLanguageModes: [.v6]
)
