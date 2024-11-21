// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SPFKMetadata",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "SPFKMetadata",
            targets: [
                "SPFKMetadata",
                "SPFKMetadataC"
            ]
        ),
    ],
    
    targets: [

        // Swift
        .target(
            name: "SPFKMetadata",
            dependencies: [
                .target(name: "SPFKMetadataC"),
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
        
        // C++
        .target(
            name: "SPFKMetadataC",
            dependencies: [
                .target(name: "tag"),
                .target(name: "libsndfile")
            ],
            publicHeadersPath: "include",
            cxxSettings: []
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
            name: "SPFKMetadataTests",
            dependencies: [
                "SPFKMetadata",
                "SPFKMetadataC"
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        )
    ],
    cxxLanguageStandard: .cxx20
)
