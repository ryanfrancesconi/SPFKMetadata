// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

@Suite(.serialized)
class MP3MarkerTests: SPFKMetadataTestModel {
    lazy var bin: URL = createBin(suite: "MP3MarkerTests")

    @Test func parseMarkers() async throws {
        let markers = getMP3Chapters(in: chapters_mp3)
        #expect(markers.count == 10)
    }

    @Test func parseMarkers2() async throws {
        let markers = getMP3Chapters(in: toc_many_children)
        #expect(markers.count == 129)
    }

    @Test func writeMarkers() async throws {
        let tmpfile = try copy(to: bin, url: chapters_mp3)
        #expect(MPEGChapterUtil.removeAllChapters(tmpfile.path))

        let markers: [ChapterMarker] = [
            ChapterMarker(name: "New 1", startTime: 2, endTime: 4),
            ChapterMarker(name: "New 2", startTime: 4, endTime: 6),
        ]

        #expect(MPEGChapterUtil.setMP3Chapters(tmpfile.path(), array: markers))

        let editedMarkers = getMP3Chapters(in: tmpfile)

        let names = editedMarkers.compactMap { $0.name }
        let times = editedMarkers.map { $0.startTime }

        #expect(editedMarkers.count == 2)
        #expect(names == ["New 1", "New 2"])
        #expect(times == [2, 4])
    }

    @Test func removeMarkers() async throws {
        let tmpfile = try copy(to: bin, url: chapters_mp3)
        #expect(MPEGChapterUtil.removeAllChapters(tmpfile.path))

        let chapters = getMP3Chapters(in: tmpfile)
        #expect(chapters.count == 0)
    }

    deinit {
        try? FileManager.default.removeItem(at: bin)
    }
}
