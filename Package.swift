// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

private let name: String = "SPFKMetadata" // Swift target
private let dependencyNames: [String] = ["SPFKBase", "SPFKAudioBase", "SPFKUtils", "SPFKTesting"]
private let dependencyNamesC: [String] = []
private let dependencyBranch = "main"
private let useLocalDependencies: Bool = true
private let platforms: [PackageDescription.SupportedPlatform]? = [
    .macOS(.v12),
    .iOS(.v15)
]

let remoteDependenciesC: [RemoteDependency] = [
    .init(package: .package(url: "https://github.com/sbooth/CXXTagLib", branch: "main"),
          product: .product(name: "taglib", package: "CXXTagLib")),
    .init(package: .package(url: "https://github.com/sbooth/sndfile-binary-xcframework", branch: "main"),
          product: .product(name: "sndfile", package: "sndfile-binary-xcframework")),
    .init(package: .package(url: "https://github.com/sbooth/ogg-binary-xcframework", branch: "main"),
          product: .product(name: "ogg", package: "ogg-binary-xcframework")),
    .init(package: .package(url: "https://github.com/sbooth/flac-binary-xcframework", branch: "main"),
          product: .product(name: "FLAC", package: "flac-binary-xcframework")),
    .init(package: .package(url: "https://github.com/sbooth/opus-binary-xcframework", branch: "main"),
          product: .product(name: "opus", package: "opus-binary-xcframework")),
    .init(package: .package(url: "https://github.com/sbooth/vorbis-binary-xcframework", branch: "main"),
          product: .product(name: "vorbis", package: "vorbis-binary-xcframework")),
]

// MARK: - Reusable Code for a Swift + C package

struct RemoteDependency {
    let package: PackageDescription.Package.Dependency
    let product: PackageDescription.Target.Dependency
}

private let nameC: String = "\(name)C" // C/C++ target
private let nameTests: String = "\(name)Tests" // Test target
private let githubBase = "https://github.com/ryanfrancesconi"

private let products: [PackageDescription.Product] = [
    .library(name: name, targets: [name, nameC])
]

private var packageDependencies: [PackageDescription.Package.Dependency] {
     let local: [PackageDescription.Package.Dependency] =
        dependencyNames.map {
            .package(name: "\($0)", path: "../\($0)") // assumes the package garden is in one folder
        }

        
     let remote: [PackageDescription.Package.Dependency] =
        dependencyNames.map {
            .package(url: "\(githubBase)/\($0)", branch: dependencyBranch)
        }
    
    var value = useLocalDependencies ? local : remote
    
    if !remoteDependenciesC.isEmpty {
        value.append(contentsOf: remoteDependenciesC.map { $0.package } )
    }
    
    return value
}

// is there a Sources/[NAME]/Resources folder?
private var swiftTargetResources: [PackageDescription.Resource]? {
    // package folder
    let root = URL(fileURLWithPath: #file).deletingLastPathComponent()
    
    let dir = root.appending(component: "Sources")
        .appending(component: name)
        .appending(component: "Resources")
    
    let exists = FileManager.default.fileExists(atPath: dir.path)
    
    return exists ? [.process("Resources")] : nil
}

private var swiftTargetDependencies: [PackageDescription.Target.Dependency] {
    let names = dependencyNames.filter { $0 != "SPFKTesting" }
    
    var value: [PackageDescription.Target.Dependency] = names.map {
        .byNameItem(name: "\($0)", condition: nil)
    }
    
    value.append(.target(name: nameC))
    
    return value
}

private let swiftTarget: PackageDescription.Target = .target(
    name: name,
    dependencies: swiftTargetDependencies,
    resources: swiftTargetResources
)

private var testTargetDependencies: [PackageDescription.Target.Dependency] {
    var array: [PackageDescription.Target.Dependency] = [
        .byNameItem(name: name, condition: nil),
        .byNameItem(name: nameC, condition: nil),
    ]

    if dependencyNames.contains("SPFKTesting") {
        array.append(.byNameItem(name: "SPFKTesting", condition: nil))
    }
    
    return array
}

private let testTarget: PackageDescription.Target = .testTarget(
    name: nameTests,
    dependencies: testTargetDependencies
)

private var cTargetDependencies: [PackageDescription.Target.Dependency] {
   var value: [PackageDescription.Target.Dependency] = dependencyNamesC.map {
        .byNameItem(name: "\($0)", condition: nil)
    }
    
    if !remoteDependenciesC.isEmpty {
        value.append(contentsOf: remoteDependenciesC.map { $0.product } )
    }
    
    return value
}

private let cTarget: PackageDescription.Target = .target(
    name: nameC,
    dependencies: cTargetDependencies,
    publicHeadersPath: "include",
    cSettings: [
        .headerSearchPath("include_private")
    ],
    cxxSettings: [
        .headerSearchPath("include_private")
    ]
)


private let targets: [PackageDescription.Target] = [
    swiftTarget, cTarget, testTarget
]

let package = Package(
    name: name,
    defaultLocalization: "en",
    platforms: platforms,
    products: products,
    dependencies: packageDependencies,
    targets: targets,
    cxxLanguageStandard: .cxx20
)








/*
// C/C++ target
private let nameC: String = "\(name)C"


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

    
    // Standalone dependencies from source
    .package(url: "https://github.com/sbooth/CXXTagLib", branch: "main"),
    
    // Standalone dependencies not easily packaged using SPM

    // sndfile-binary-xcframework requires ogg, flac, opus, and vorbis
    .package(url: "https://github.com/sbooth/sndfile-binary-xcframework", branch: "main"),

    // Xiph ecosystem - requires ogg-binary-xcframework
    .package(url: "https://github.com/sbooth/ogg-binary-xcframework", branch: "main"),
    .package(url: "https://github.com/sbooth/flac-binary-xcframework", branch: "main"),
    .package(url: "https://github.com/sbooth/opus-binary-xcframework", branch: "main"),
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
*/
