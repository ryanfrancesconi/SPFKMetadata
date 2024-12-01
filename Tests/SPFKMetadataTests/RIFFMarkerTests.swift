// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

@Suite(.serialized)
class RIFFMarkerTests: SPFKMetadataTestModel {
    lazy var bin: URL = createBin(suite: "RIFFMarkerTests")

    @Test func parseMarkers() async throws {
        let markers = RIFFMarker.getAudioFileMarkers(bext_v2) as? [SimpleAudioFileMarker] ?? []
        Swift.print(markers.map { ($0.name ?? "nil") + " @ \($0.time)" })
        #expect(markers.count == 7)
    }

    @Test func writeMarkers() async throws {
        let tmpfile = try copy(to: bin, url: bext_v2)

        let markers: [SimpleAudioFileMarker] = [
            SimpleAudioFileMarker(name: "New 1", time: 2, sampleRate: 48000, markerID: 0),
            SimpleAudioFileMarker(name: "New 2", time: 4, sampleRate: 48000, markerID: 1),
        ]

        #expect(
            RIFFMarker.setAudioFileMarkers(tmpfile, markers: markers)
        )

        #expect(FileManager.default.fileExists(atPath: tmpfile.path))

        let editedMarkers = RIFFMarker.getAudioFileMarkers(tmpfile) as? [SimpleAudioFileMarker] ?? []

        let names = editedMarkers.compactMap { $0.name }
        let times = editedMarkers.map { $0.time }

        #expect(editedMarkers.count == 2)
        #expect(names == ["New 1", "New 2"])
        #expect(times == [2, 4])

        Swift.print(editedMarkers.map { ($0.name ?? "nil") + " @ \($0.time)" })
    }

    @Test func removeMarkers() async throws {
        let tmpfile = try copy(to: bin, url: bext_v2)

        #expect(RIFFMarker.removeAllAudioFileMarkers(tmpfile))

        let editedMarkers = RIFFMarker.getAudioFileMarkers(tmpfile) as? [SimpleAudioFileMarker] ?? []
        Swift.print(editedMarkers.map { ($0.name ?? "nil") + " @ \($0.time)" })
        #expect(editedMarkers.count == 0)
    }

    deinit {
        try? FileManager.default.removeItem(at: bin)
    }
}
