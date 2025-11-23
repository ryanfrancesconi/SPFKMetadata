// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// This package will assume C / Objective-C interoperability

// Swift target
private let name: String = "SPFKMetadata"

// C/C++ target
private let nameC: String = "\(name)C"

private let platforms: [PackageDescription.SupportedPlatform]? = [
    .macOS(.v12),
    .iOS(.v15),
]

private let products: [PackageDescription.Product] = [
    .library(
        name: name,
        targets: [name, nameC]
    )
]

private let dependencies: [PackageDescription.Package.Dependency] = [
    .package(name: "SPFKAudioBase", path: "../SPFKAudioBase"),
    .package(name: "SPFKUtils", path: "../SPFKUtils"),
    .package(name: "SPFKTesting", path: "../SPFKTesting"),
    
//    .package(url: "https://github.com/ryanfrancesconi/SPFKUtils", branch: "main"),
//    .package(url: "https://github.com/ryanfrancesconi/SPFKTesting", branch: "main"),
    
    // Standalone dependencies from source
    .package(url: "https://github.com/ryanfrancesconi/CXXTagLib", branch: "main"),
    
    // Standalone dependencies not easily packaged using SPM

    // sndfile-binary-xcframework requires ogg-binary-xcframework, flac-binary-xcframework, opus-binary-xcframework, and vorbis-binary-xcframework
    .package(url: "https://github.com/sbooth/sndfile-binary-xcframework", branch: "main"),

    // Xiph ecosystem
    .package(url: "https://github.com/sbooth/ogg-binary-xcframework", branch: "main"),
    // flac-binary-xcframework requires ogg-binary-xcframework
    .package(url: "https://github.com/sbooth/flac-binary-xcframework", branch: "main"),
    // opus-binary-xcframework requires ogg-binary-xcframework
    .package(url: "https://github.com/sbooth/opus-binary-xcframework", branch: "main"),
    // vorbis-binary-xcframework requires ogg-binary-xcframework
    .package(url: "https://github.com/sbooth/vorbis-binary-xcframework", branch: "main"),

]

private let targets: [PackageDescription.Target] = [
    // Swift
    .target(
        name: name,
        dependencies: [
            .target(name: nameC),
            .byNameItem(name: "SPFKUtils", condition: nil),
            .byNameItem(name: "SPFKAudioBase", condition: nil),
        ]
    ),
    
    // C
    .target(
        name: nameC,
        dependencies: [
            .product(name: "taglib", package: "CXXTagLib"),

            .product(name: "sndfile", package: "sndfile-binary-xcframework"),

            // Xiph ecosystem
            .product(name: "ogg", package: "ogg-binary-xcframework"),
            .product(name: "FLAC", package: "flac-binary-xcframework"),
            .product(name: "opus", package: "opus-binary-xcframework"),
            .product(name: "vorbis", package: "vorbis-binary-xcframework"),
        ],
        publicHeadersPath: "include",
        cSettings: [

        ],
        cxxSettings: [
            .headerSearchPath("include_private"),
        ]
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
