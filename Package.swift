// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// This package will assume C / Objective-C interoperability as it's more common.
// C++ could be enabled with:
// swiftSettings: [.interoperabilityMode(.Cxx)]

// Swift target
private let name: String = "SPFKMetadata"

// C/C++ target
private let nameC: String = "\(name)C"

private let platforms: [PackageDescription.SupportedPlatform]? = [
    .macOS(.v11),
    .iOS(.v15)
]

private let products: [PackageDescription.Product] = [
    .library(
        name: name,
        targets: [name, nameC]
    )
]

private let targets: [PackageDescription.Target] = [
    // Swift
    .target(
        name: name,
        dependencies: [.target(name: nameC)]
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
        ],
        resources: [
            .process("Resources")
        ]
    )
]

let package = Package(
    name: name,
    platforms: platforms,
    products: products,
    targets: targets,
    cxxLanguageStandard: .cxx20
)
