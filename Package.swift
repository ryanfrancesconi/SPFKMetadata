// swift-tools-version: 6.2
// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi

import PackageDescription

let name: String = "SPFKMetadata" // Swift target
let dependencyNames: [String] = ["SPFKBase", "SPFKAudioBase", "SPFKUtils", "SPFKTesting"]
let spfkDependencyBranch: String = "development"
let remoteDependencies: [RemoteDependency] = []

let nameC: String? = "\(name)C" // C/C++ target, nil if no C target
let dependencyNamesC: [String] = []
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
          product: .product(name: "vorbis", package: "vorbis-binary-xcframework"))
]

let platforms: [PackageDescription.SupportedPlatform]? = [
    .macOS(.v12),
    .iOS(.v15)
]

// MARK: - Reusable Code for a dual Swift + C package ---------------------------------------------------

struct RemoteDependency {
    let package: PackageDescription.Package.Dependency
    let product: PackageDescription.Target.Dependency
}

var swiftTarget: PackageDescription.Target {
    var targetDependencies: [PackageDescription.Target.Dependency] {
        let names = dependencyNames.filter { $0 != "SPFKTesting" }

        var value: [PackageDescription.Target.Dependency] = names.map {
            .byNameItem(name: "\($0)", condition: nil)
        }

        if let nameC {
            value.append(.target(name: nameC))
        }

        return value
    }

    return .target(
        name: name,
        dependencies: targetDependencies,
        resources: nil
    )
}

var testTarget: PackageDescription.Target {
    var targetDependencies: [PackageDescription.Target.Dependency] {
        var array: [PackageDescription.Target.Dependency] = [
            .byNameItem(name: name, condition: nil)
        ]

        if let nameC {
            array.append(.byNameItem(name: nameC, condition: nil))
        }

        if dependencyNames.contains("SPFKTesting") {
            array.append(.byNameItem(name: "SPFKTesting", condition: nil))
        }

        return array
    }

    let nameTests: String = "\(name)Tests" // Test target

    return .testTarget(
        name: nameTests,
        dependencies: targetDependencies,
        resources: nil,
        swiftSettings: [
            .swiftLanguageMode(.v5),
            .unsafeFlags(["-strict-concurrency=complete"]),
        ],
    )
}

var cTarget: PackageDescription.Target? {
    guard let nameC else { return nil }

    var targetDependencies: [PackageDescription.Target.Dependency] {
        var value: [PackageDescription.Target.Dependency] = dependencyNamesC.map {
            .byNameItem(name: "\($0)", condition: nil)
        }

        value.append(contentsOf: remoteDependenciesC.map(\.product))

        return value
    }

    // all spfk c targets have the same folder structure currently
    return .target(
        name: nameC,
        dependencies: targetDependencies,
        publicHeadersPath: "include",
        cSettings: [
            .headerSearchPath("include_private")
        ],
        cxxSettings: [
            .headerSearchPath("include_private")
        ]
    )
}

var targets: [PackageDescription.Target] {
    [swiftTarget, cTarget, testTarget].compactMap(\.self)
}

var packageDependencies: [PackageDescription.Package.Dependency] {
    var spfkDependencies: [RemoteDependency] {
        let githubBase = "https://github.com/ryanfrancesconi"

        return dependencyNames.map {
            RemoteDependency(
                package: .package(url: "\(githubBase)/\($0)", branch: spfkDependencyBranch),
                product: .product(name: "\($0)", package: "\($0)")
            )
        }
    }

    return spfkDependencies.map(\.package) +
        remoteDependencies.map(\.package) +
        remoteDependenciesC.map(\.package)
}

var products: [PackageDescription.Product] {
    let targets: [String] = [name, nameC].compactMap(\.self)

    return [
        .library(name: name, targets: targets)
    ]
}

// This is required to be at the bottom

let package = Package(
    name: name,
    defaultLocalization: "en",
    platforms: platforms,
    products: products,
    dependencies: packageDependencies,
    targets: targets,
    cxxLanguageStandard: .cxx20
)
