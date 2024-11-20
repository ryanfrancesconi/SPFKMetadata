// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftTagLib",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "SwiftTagLib",
            targets: [
                "SwiftTagLib",
                "SwiftTagLibC"
            ]
        ),
    ],
    
    targets: [

        // SWIFT
        .target(
            name: "SwiftTagLib",
            dependencies: [
                .target(name: "SwiftTagLibC"),
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
        
        // C++
        .target(
            name: "SwiftTagLibC",
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
            name: "SwiftTagLibTests",
            dependencies: [
                "SwiftTagLib",
                "SwiftTagLibC"
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        )
    ],
    cxxLanguageStandard: .cxx14
)
