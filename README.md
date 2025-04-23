# SPFKMetadata

[![build](https://github.com/ryanfrancesconi/SPFKMetadata/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/ryanfrancesconi/SPFKMetadata/actions/workflows/swift.yml)
![Platforms - macOS 12+](https://img.shields.io/badge/platforms-macOS%2012+-lightgrey.svg?style=flat)
[![Swift 5.9-6.0](https://img.shields.io/badge/Swift-5.9–6.0-orange.svg?style=flat)](https://developer.apple.com/swift) 
[![Xcode 16+](https://img.shields.io/badge/Xcode-16+-lightgrey.svg?style=flat)](https://developer.apple.com/swift) 


SPFKMetadata wraps [TagLib](https://github.com/taglib/taglib) (v2.0.2), [libsndfile](https://github.com/libsndfile/libsndfile) (v1.2.2) and Core Audio metadata C/C++ frameworks for Swift compatibility. This library is currently macOS only, though may be updated to include iOS.

The current state of metadata parsing via Swift means that no one single framework is a do-it-all solution, so this framework covers some missing functionalities from [AVFoundation](https://developer.apple.com/av-foundation/) such as RIFF Audio Markers, Chaptering, Broadcast Wave and writing tags to file. SPFKMetadata embeds arm64/x86_64 xcframeworks for the needed dylibs and uses an intuitive Swift API to access metadata functions from each. While Apple's C++ → Swift interoperability looks promising, it doesn't yet seem ready for integration in which you don't control both sides of the integration. For this reason, open source frameworks like TagLib and libsndfile seem better bridged via Objective C++. I'm sure this will eventually change as Swift moves closer to C++ interoperability.

![SPFKMetadata-logo-03-256](https://github.com/user-attachments/assets/1ad2a41c-5f4f-458f-9488-b916d355506e)

## Installation

### Swift Package Manager (SPM)

There are two targets in the package: SPFKMetadata and SPFKMetadataC. The first is pure Swift whereas the second is C++ bridged by Objective C++. For full functionality both imports are required.

1. Add SPFKMetadata as a dependency in the usual ways.
   - In a project or framework, in Xcode:
     - Select the menu: **File → Swift Packages → Add Package Dependency...**
     - Enter this URL: `https://github.com/ryanfrancesconi/SPFKMetadata`
   - In a Swift Package, add it to the Package.swift dependencies:
     ```swift
     .package(url: "https://github.com/ryanfrancesconi/SPFKMetadata", branch: "main")
     ```
2. Import the libraries:
   ```swift
   import SPFKMetadata
   import SPFKMetadataC
   ```

## About

Spongefork (SPFK) is the personal software projects of [Ryan Francesconi](https://github.com/ryanfrancesconi). Dedicated to creative sound manipulation, his first application, Spongefork, was released in 1999 for macOS 7. Since 2016 he has been the lead macOS developer at [Audio Design Desk](https://add.app).
