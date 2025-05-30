// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopupView",
    platforms: [.iOS("13.0")],
    products: [
        .library(
            name: "PopupView",
            targets: ["PopupView"]),
        .library(
            name: "PickerView",
            targets: ["PickerView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftKickMobile/SwiftMessages.git", .upToNextMajor(from: "10.0.0"))
    ],
    targets: [
        .target(
            name: "PopupView",
            dependencies: [
                .product(name: "SwiftMessages", package: "SwiftMessages")
            ]),
        .target(
            name: "PickerView",
            dependencies: []),
        .testTarget(
            name: "PopupViewTests",
            dependencies: ["PopupView"]
        ),
    ]
)
