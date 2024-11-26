// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation

protocol SPFKMetadataTestModel: AnyObject {
    //
}

extension SPFKMetadataTestModel {
    var testBundle: URL {
        let bundleURL = Bundle(for: Self.self).bundleURL

        return bundleURL
            .appending(component: "Contents")
            .appending(component: "Resources")
            .appending(component: "SPFKMetadata_SPFKMetadataTests.bundle")
    }

    func getResource(named name: String) -> URL {
        testBundle
            .appending(component: "Contents")
            .appending(component: "Resources")
            .appending(component: name)
    }
}

extension SPFKMetadataTestModel {
    var id3: URL { getResource(named: "id3.mp3") }
    var bext_v1: URL { getResource(named: "bext_v1.wav") }
    var bext_v2: URL { getResource(named: "bext_v2.wav") }
}

extension SPFKMetadataTestModel {
    var bin: URL {
        var bin = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop")

        bin = bin.appendingPathComponent("SPFKMetadataTests")

        if !FileManager.default.fileExists(atPath: bin.path) {
            try? FileManager.default.createDirectory(at: bin, withIntermediateDirectories: true)
        }

        return bin
    }
}
