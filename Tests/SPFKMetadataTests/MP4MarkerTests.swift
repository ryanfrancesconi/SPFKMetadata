// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

@Suite(.serialized)
class MP4MarkerTests: SPFKMetadataTestModel {
    lazy var bin: URL = createBin(suite: "MP4MarkerTests")

    func getChapters(in url: URL) async throws -> [SimpleChapterFrame] {
        let chapters = try await ChapterParser.parse(url: url)
        Swift.print(chapters.map { ($0.name ?? "nil") + " @ \($0.startTime)" })
        return chapters
    }

    func getChapters_(in url: URL) async throws -> [SimpleChapterFrame] {
        let chapters = TagLibBridge.getMP4Chapters(url.path) as? [SimpleChapterFrame] ?? []
        Swift.print(chapters.map { ($0.name ?? "nil") + " @ \($0.startTime)" })
        return chapters
    }
    
    @Test func parseMarkers() async throws {
        let markers = try await getChapters(in: tabla_mp4)
        #expect(markers.count == 5)
    }

    @Test func writeMarkers() async throws {
        let tmpfile = try copy(to: bin, url: tabla_mp4)
        
        let output = tmpfile.deletingLastPathComponent().appendingPathComponent("output.mp4")

        if FileManager.default.fileExists(atPath: output.path) {
            try? FileManager.default.removeItem(at: output)
        }
        
        try await ChapterWriter.write(url: tmpfile, to: output, chapters: [])
        
        let properties = try TagProperties(url: output)
        #expect(properties[.comment] == "RFRFRFRF")
    }
    
    
    @Test func removeMarkers() async throws {
    }

    deinit {
        // try? FileManager.default.removeItem(at: bin)
    }
}
