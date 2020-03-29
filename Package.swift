// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "httpClient",
            targets: ["httpClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/hectr/swift-idioms.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "httpClient",
            dependencies: ["Idioms"]
        ),
        .testTarget(
            name: "httpClientTests",
            dependencies: ["httpClient"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
