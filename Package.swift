// swift-tools-version: 6.2
// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi

import PackageDescription

private let name: String = "SPFKMetadata" // Swift target
private let dependencyNames: [String] = ["SPFKBase", "SPFKAudioBase", "SPFKUtils", "SPFKTesting"]
private let dependencyNamesC: [String] = []
private let dependencyBranch: String = "main"
private let useLocalDependencies: Bool = false
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
          product: .product(name: "vorbis", package: "vorbis-binary-xcframework"))
]

// MARK: - Reusable Code for a dual Swift + C package

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
            .package(name: "\($0)", path: "../\($0)")
        }

    let remote: [PackageDescription.Package.Dependency] =
        dependencyNames.map {
            .package(url: "\(githubBase)/\($0)", branch: dependencyBranch)
        }

    var value = useLocalDependencies ? local : remote

    if !remoteDependenciesC.isEmpty {
        value.append(contentsOf: remoteDependenciesC.map { $0.package })
    }

    return value
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
    resources: nil
)

private var testTargetDependencies: [PackageDescription.Target.Dependency] {
    var array: [PackageDescription.Target.Dependency] = [
        .byNameItem(name: name, condition: nil),
        .byNameItem(name: nameC, condition: nil)
    ]

    if dependencyNames.contains("SPFKTesting") {
        array.append(.byNameItem(name: "SPFKTesting", condition: nil))
    }

    return array
}

private let testTarget: PackageDescription.Target = .testTarget(
    name: nameTests,
    dependencies: testTargetDependencies,
    resources: nil
)

private var cTargetDependencies: [PackageDescription.Target.Dependency] {
    var value: [PackageDescription.Target.Dependency] = dependencyNamesC.map {
        .byNameItem(name: "\($0)", condition: nil)
    }

    if !remoteDependenciesC.isEmpty {
        value.append(contentsOf: remoteDependenciesC.map { $0.product })
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
