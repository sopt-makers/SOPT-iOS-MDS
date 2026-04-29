// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MDS",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MDS",
            targets: ["MDS"]
        ),
    ],
    targets: [
        .target(
            name: "MDS",
            resources: [
                .process("Foundation/Resources")
            ]
        ),

    ],
    swiftLanguageModes: [.v6]
)
