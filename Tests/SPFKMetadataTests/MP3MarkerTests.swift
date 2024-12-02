// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

@Suite(.serialized)
class MP3MarkerTests: SPFKMetadataTestModel {
    lazy var bin: URL = createBin(suite: "MP3MarkerTests")

    func getChapters(in url: URL) -> [ChapterMarker] {
        let chapters = MPEGChapterUtil.getChapters(url.path) as? [ChapterMarker] ?? []
        Swift.print(chapters.map { ($0.name ?? "nil") + " @ \($0.startTime)" })
        return chapters
    }

    @Test func parseMarkers() async throws {
        let markers = getChapters(in: chapters_mp3)
        
        let names = markers.compactMap { $0.name }
        let times = markers.map { $0.startTime }
        
        #expect(markers.count == 10)
        #expect(names == ["ch0", "ch1", "ch2", "ch3", "ch4", "ch5", "ch6", "ch7", "ch8", "ch9"])
        #expect(times == [0.0, 1.081, 2.087, 3.073, 4.094, 5.081, 6.079, 7.059, 8.083, 9.088])
    }

    @Test func parseMarkers2() async throws {
        let markers = getChapters(in: toc_many_children)
        #expect(markers.count == 129)
    }

    @Test func writeMarkers() async throws {
        let tmpfile = try copy(to: bin, url: chapters_mp3)
        #expect(MPEGChapterUtil.removeAllChapters(tmpfile.path))

        let markers: [ChapterMarker] = [
            ChapterMarker(name: "New 1", startTime: 2, endTime: 4),
            ChapterMarker(name: "New 2", startTime: 4, endTime: 6),
        ]

        #expect(MPEGChapterUtil.update(tmpfile.path(), chapters: markers))

        let editedMarkers = getChapters(in: tmpfile)

        let names = editedMarkers.compactMap { $0.name }
        let times = editedMarkers.map { $0.startTime }

        #expect(editedMarkers.count == 2)
        #expect(names == ["New 1", "New 2"])
        #expect(times == [2, 4])
    }

    @Test func removeMarkers() async throws {
        let tmpfile = try copy(to: bin, url: chapters_mp3)
        #expect(MPEGChapterUtil.removeAllChapters(tmpfile.path))

        let chapters = getChapters(in: tmpfile)
        #expect(chapters.count == 0)
    }

    deinit {
        try? FileManager.default.removeItem(at: bin)
    }
}
