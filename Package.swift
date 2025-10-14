// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// This package will assume C / Objective-C interoperability

// Swift target
private let name: String = "SPFKMetadata"

// C/C++ target
private let nameC: String = "\(name)C"

private let platforms: [PackageDescription.SupportedPlatform]? = [
    .macOS(.v12)
]

private let products: [PackageDescription.Product] = [
    .library(
        name: name,
        targets: [name, nameC]
    )
]

private let dependencies: [PackageDescription.Package.Dependency] = [
    .package(name: "SPFKUtils", path: "../SPFKUtils"),
    .package(name: "SPFKTesting", path: "../SPFKTesting"),
    
//     .package(url: "https://github.com/ryanfrancesconi/SPFKUtils", branch: "main"),
//     .package(url: "https://github.com/ryanfrancesconi/SPFKTesting", branch: "main"),
]

private let targets: [PackageDescription.Target] = [
    // Swift
    .target(
        name: name,
        dependencies: [
            .target(name: nameC),
            .byNameItem(name: "SPFKUtils", condition: nil),
        ]
    ),
    
    // C
    .target(
        name: nameC,
        dependencies: [
            .target(name: "tag"),
            .target(name: "libsndfile")
        ],
        publicHeadersPath: "include",
        cSettings: [
            .headerSearchPath("include_private")
        ],
        cxxSettings: [
            .headerSearchPath("include_private")
        ]
    ),
    
    .binaryTarget(
        name: "tag",
        path: "Frameworks/tag.xcframework"
    ),
    
    .binaryTarget(
        name: "libsndfile",
        path: "Frameworks/libsndfile.xcframework"
    ),

    .testTarget(
        name: "\(name)Tests",
        dependencies: [
            .byNameItem(name: name, condition: nil),
            .byNameItem(name: nameC, condition: nil),
            .byNameItem(name: "SPFKTesting", condition: nil)
        ],
        resources: [
            .process("Resources")
        ]
    )
]

let package = Package(
    name: name,
    defaultLocalization: "en",
    platforms: platforms,
    products: products,
    dependencies: dependencies,
    targets: targets,
    cxxLanguageStandard: .cxx20
)
