// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
@testable import SPFKTesting
import SPFKUtils
import Testing

@Suite(.serialized)
class AudioMarkerTests: BinTestCase {
    @Test func parseMarkers() async throws {
        let markers = AudioMarkerUtil.getMarkers(TestBundleResources.shared.wav_bext_v2) as? [AudioMarker] ?? []

        Log.debug(markers.map { ($0.name ?? "nil") + " @ \($0.time) \($0.timecode)" })
        #expect(markers.count == 3)
    }

    @Test func writeMarkers() async throws {
        let tmpfile = try copyToBin(url: TestBundleResources.shared.wav_bext_v2)

        let markers: [AudioMarker] = [
            AudioMarker(name: "New 1", time: 2, sampleRate: 44100, markerID: 0),
            AudioMarker(name: "New 2", time: 4, sampleRate: 44100, markerID: 1),
        ]

        #expect(
            AudioMarkerUtil.update(tmpfile, markers: markers)
        )

        #expect(
            FileManager.default.fileExists(atPath: tmpfile.path)
        )

        let editedMarkers = AudioMarkerUtil.getMarkers(tmpfile) as? [AudioMarker] ?? []
        let names = editedMarkers.compactMap { $0.name }
        let times = editedMarkers.map { $0.time }

        #expect(editedMarkers.count == 2)
        Log.debug(editedMarkers.map { ($0.name ?? "nil") + " @ \($0.time)" })

        #expect(names == ["New 1", "New 2"])
        #expect(times == [2, 4])
    }

    @Test func removeMarkers() async throws {
        let tmpfile = try copyToBin(url: TestBundleResources.shared.wav_bext_v2)

        #expect(AudioMarkerUtil.removeAllMarkers(tmpfile))

        let editedMarkers = AudioMarkerUtil.getMarkers(tmpfile) as? [AudioMarker] ?? []
        Log.debug(editedMarkers.map { ($0.name ?? "nil") + " @ \($0.time)" })
        #expect(editedMarkers.count == 0)
    }
}
