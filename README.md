# SPFKMetadata

[![build](https://github.com/ryanfrancesconi/SPFKMetadata/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/ryanfrancesconi/SPFKMetadata/actions/workflows/swift.yml)
![Platforms - macOS 12+](https://img.shields.io/badge/macOS-12%2B-lightgrey?logo=apple)
![Platforms - iOS 15+](https://img.shields.io/badge/iOS-15%2B-lightgrey)
[![Swift 6.2](https://img.shields.io/badge/Swift-6.2-orange.svg?style=flat)](https://developer.apple.com/swift) 
[![Xcode 26+](https://img.shields.io/badge/Xcode-26+-lightgrey.svg?style=flat)](https://developer.apple.com/swift) 

SPFKMetadata wraps [TagLib](https://github.com/taglib/taglib) (v2.1.1), [libsndfile](https://github.com/libsndfile/libsndfile) (v1.2.2) and Core Audio metadata C/C++ frameworks for Swift compatibility.

The current state of metadata parsing via Swift means that no one single framework is a do-it-all solution, so this framework covers some missing functionalities from [AVFoundation](https://developer.apple.com/av-foundation/) such as RIFF Audio Markers, Chaptering, Broadcast Wave and writing tags to file.

![SPFKMetadata-logo-03-256](https://github.com/user-attachments/assets/1ad2a41c-5f4f-458f-9488-b916d355506e)

## Installation

There are two targets in the package: SPFKMetadata and SPFKMetadataC. The first is pure Swift whereas the second is C++ bridged by Objective C++.

1. Add SPFKMetadata as a dependency in the usual ways.
   - In a project or framework, in Xcode:
     - Select the menu: **File → Swift Packages → Add Package Dependency...**
     - Enter this URL: `https://github.com/ryanfrancesconi/SPFKMetadata`
   - In a Swift Package, add it to the Package.swift dependencies:
     ```swift
     .package(url: "https://github.com/ryanfrancesconi/spfk-metadata", branch: "development")
     ```
2. Import the libraries:
   ```swift
   import SPFKMetadata
   import SPFKMetadataC
   ```

## About

Spongefork (SPFK) is the personal software projects of [Ryan Francesconi](https://github.com/ryanfrancesconi). Dedicated to creative sound manipulation, his first application, Spongefork, was released in 1999 for macOS 7. From 2016 to 2025 he was the lead macOS developer at [Audio Design Desk](https://add.app).
5
