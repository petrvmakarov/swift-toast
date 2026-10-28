// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftToast",
    platforms: [
        .iOS(.v18),
        .macCatalyst(.v18),
        .watchOS(.v11),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftToast",
            targets: ["swift_toast"]
        ),
        .library(
            name: "ExampleAppFeature",
            targets: ["ExampleAppFeature"]
        ),
        .executable(
            name: "ExampleApp",
            targets: ["ExampleApp"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "swift_toast",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .target(
            name: "ExampleAppFeature",
            dependencies: ["swift_toast"],
            path: "Example/Sources/ExampleAppFeature",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .executableTarget(
            name: "ExampleApp",
            dependencies: ["ExampleAppFeature"],
            path: "Example/Sources/ExampleApp",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "swift_toastTests",
            dependencies: ["swift_toast"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ]
)
