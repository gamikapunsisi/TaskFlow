// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "UniversityN",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "UniversityN",
            targets: ["UniversityN"]),
    ],
    dependencies: [
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.14.1"),
    ],
    targets: [
        .target(
            name: "UniversityN",
            dependencies: [
                .product(name: "SQLite", package: "SQLite.swift"),
            ]),
        .testTarget(
            name: "UniversityNTests",
            dependencies: ["UniversityN"]),
    ]
) 