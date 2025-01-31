// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target.Dependency {
    static var dependencies: Self {
        .product(name: "Dependencies", package: "swift-dependencies")
    }
    static var dependenciesMacros: Self {
        .product(name: "DependenciesMacros", package: "swift-dependencies")
    }
}

let package = Package(
    name: "swift-sensory-feedback",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "SensoryFeedbackClient",
            targets: ["SensoryFeedbackClient"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            .upToNextMajor(from: "1.0.0")
        )
    ],
    targets: [
        .target(
            name: "SensoryFeedbackClient",
            dependencies: [.dependencies, .dependenciesMacros]
        )
    ]
)
