// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

@Suite(.serialized) // don't run in parallel as they're using the same file URL
class RIFFMarkerTests: SPFKMetadataTestModel {
    @Test func parseMarkers() async throws {
        let markers = RIFFMarker.getAudioFileMarkers(bext_v2) as? [SimpleAudioFileMarker] ?? []
        Swift.print(markers.map { ($0.name ?? "nil") + " @ \($0.time)" })
        #expect(markers.count == 7)
    }

    @Test func writeMarkers() async throws {
        let input = bext_v2
        let tmp = bin.appendingPathComponent("Copy of \(bext_v2.lastPathComponent)")
        try? FileManager.default.removeItem(at: tmp)
        try FileManager.default.copyItem(at: input, to: tmp)

        let markers: [SimpleAudioFileMarker] = [
            SimpleAudioFileMarker(name: "New 1", time: 2, sampleRate: 48000, markerID: 0),
            SimpleAudioFileMarker(name: "New 2", time: 4, sampleRate: 48000, markerID: 1),
        ]

        #expect(
            RIFFMarker.setAudioFileMarkers(tmp, markers: markers)
        )

        #expect(FileManager.default.fileExists(atPath: tmp.path))

        let editedMarkers = RIFFMarker.getAudioFileMarkers(tmp) as? [SimpleAudioFileMarker] ?? []

        let names = editedMarkers.compactMap { $0.name }
        let times = editedMarkers.map { $0.time }

        #expect(editedMarkers.count == 2)
        #expect(names == ["New 1", "New 2"])
        #expect(times == [2, 4])

        Swift.print(editedMarkers.map { ($0.name ?? "nil") + " @ \($0.time)" })
    }

    @Test func removeMarkers() async throws {
        let input = bext_v2
        let tmp = bin.appendingPathComponent("Copy of \(bext_v2.lastPathComponent)")

        try? FileManager.default.removeItem(at: tmp)
        try FileManager.default.copyItem(at: input, to: tmp)

        #expect(RIFFMarker.removeAllAudioFileMarkers(tmp))

        let editedMarkers = RIFFMarker.getAudioFileMarkers(tmp) as? [SimpleAudioFileMarker] ?? []
        Swift.print(editedMarkers.map { ($0.name ?? "nil") + " @ \($0.time)" })
        #expect(editedMarkers.count == 0)
    }
}
