// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKBase
import SPFKTesting
import Testing

@testable import SPFKMetadata
@testable import SPFKMetadataC

@Suite(.serialized)
class ChapterMarkerTests: BinTestCase {
    func getChapters(in url: URL) async throws -> [ChapterMarker] {
        let chapters = try await ChapterParser.parse(url: url)
        Log.debug(chapters.map { ($0.name ?? "nil") + " @ \($0.startTime)" })
        return chapters
    }

    @Test func parseMarkers() async throws {
        let markers = try await getChapters(in: TestBundleResources.shared.tabla_mp4)
        let names = markers.compactMap(\.name)
        let times = markers.map(\.startTime)

        #expect(markers.count == 5)
        #expect(names == ["Marker 0", "Marker 1", "Marker 2", "Marker 3", "Marker 4"])
        #expect(times == [0.0, 1.0, 2.0, 3.0, 4.0])
    }
}
