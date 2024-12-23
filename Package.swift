// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TwilioTaskrouterSwift",
    platforms: [.macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TwilioTaskrouterSwift",
            targets: ["TwilioTaskrouterSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.0")),
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.6"),
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.0.0"),
        .package(url: "https://github.com/Dev1an/FlexEmit.git", from: "0.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TwilioTaskrouterSwift",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "AnyCodable", package: "AnyCodable"),
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "Starscream", package: "Starscream"),
                .product(name: "FlexEmit", package: "FlexEmit"),
            ]
        ),
        .testTarget(
            name: "TwilioTaskrouterSwiftTests",
            dependencies: ["TwilioTaskrouterSwift"]
        ),
    ]
)
