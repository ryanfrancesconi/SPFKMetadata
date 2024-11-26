
// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

class SFFileTests: SPFKMetadataTestModel {
    @Test func parseMarkers() async throws {
        let markers = SFFile.markers(withPath: bext_v2.path) as? [SimpleMarker] ?? []

        Swift.print(markers.map { $0.name + " @ \($0.time)" })
        
        #expect(markers.count == 7)
    }

    @Test func writeMarkers() async throws {
        let url = bext_v2
        let tmp = bin.appendingPathComponent(url.lastPathComponent)

        if FileManager.default.fileExists(atPath: tmp.path) {
            try? FileManager.default.removeItem(at: tmp)
        }

        try FileManager.default.copyItem(at: url, to: tmp)

        let markers = SFFile.markers(withPath: tmp.path) as? [SimpleMarker] ?? []

        let evenMarkers = markers.filter {
            $0.time.truncatingRemainder(dividingBy: 2) == 0
        }

        #expect(
            SFFile.updateMarkers(withPath: tmp.path, markers: evenMarkers)
        )
    }

    @Test func parseBEXT() async throws {
        let desc = try BEXTDescription(url: bext_v2)

        Swift.print(desc)

        #expect(desc.version == 2)
        #expect(desc.originator == "RF")
    }

    deinit {
        // try? FileManager.default.removeItem(at: bin)
    }
}
