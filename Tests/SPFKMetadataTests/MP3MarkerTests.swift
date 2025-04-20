// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
@testable import SPFKTesting
import Testing

@Suite(.serialized)
class MP3MarkerTests: BinTestCase {
    func getChapters(in url: URL) -> [ChapterMarker] {
        let chapters = MPEGChapterUtil.getChapters(url.path) as? [ChapterMarker] ?? []
        Swift.print(chapters.map { ($0.name ?? "nil") + " @ \($0.startTime)" })
        return chapters
    }

    @Test func parseMarkers() async throws {
        let markers = getChapters(in: resources.mp3_id3)

        let names = markers.compactMap { $0.name }
        let times = markers.map { $0.startTime }

        #expect(markers.count == 3)
        #expect(names == ["M0", "M1", "M2"])
        #expect(times == [0.0, 1, 2])
    }

    @Test func parseMarkers2() async throws {
        let markers = getChapters(in: resources.toc_many_children)
        #expect(markers.count == 129)
    }

    @Test func writeMarkers() async throws {
        let tmpfile = try copyToBin(url: resources.mp3_id3)
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
        let tmpfile = try copyToBin(url: resources.mp3_id3)
        #expect(MPEGChapterUtil.removeAllChapters(tmpfile.path))

        let chapters = getChapters(in: tmpfile)
        #expect(chapters.count == 0)
    }
}
