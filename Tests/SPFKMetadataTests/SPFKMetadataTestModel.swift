// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
import SPFKMetadataC

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
    var chapters_mp3: URL { getResource(named: "chapters.mp3") }
    var tabla_mp4: URL { getResource(named: "tabla.mp4") }
    var toc_many_children: URL { getResource(named: "toc_many_children.mp3") }
    var mp4_chaptered: URL { getResource(named: "mp4_chaptered.m4a") }
}

extension SPFKMetadataTestModel {
    func createBin(suite: String, in baseURL: URL? = nil) -> URL {
        // move this to temporary directory when don't need to access files for testing
        var bin = baseURL ??
            FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop")

        bin = bin.appendingPathComponent(suite)

        if !FileManager.default.fileExists(atPath: bin.path) {
            do {
                try FileManager.default.createDirectory(at: bin, withIntermediateDirectories: true)

            } catch {
                Swift.print(error)

                if bin != FileManager.default.temporaryDirectory {
                    return createBin(suite: suite, in: FileManager.default.temporaryDirectory)
                }
            }
        }

        return bin
    }

    func copy(to bin: URL, url input: URL) throws -> URL {
        let tmp = bin.appendingPathComponent(input.lastPathComponent)
        try? FileManager.default.removeItem(at: tmp)
        try FileManager.default.copyItem(at: input, to: tmp)
        return tmp
    }

    func getMP3Chapters(in url: URL) -> [SimpleChapterFrame] {
        let chapters = TagLibBridge.getMP3Chapters(url.path) as? [SimpleChapterFrame] ?? []
        Swift.print(chapters.map { ($0.name ?? "nil") + " @ \($0.startTime)" })
        return chapters
    }
}
