
// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKBase
@testable import SPFKMetadata
@testable import SPFKMetadataC
import SPFKTesting
import Testing

@Suite(.serialized)
class AudioMarkerDescriptionTests: BinTestCase {

    @Test(arguments: TestBundleResources.shared.markerFormats)
    func parseFormat(url: URL) async throws {
        let collection = try await AudioMarkerDescriptionCollection(url: url)
        let markers = collection.markers

        #expect(markers.count == 5, "\(url.lastPathComponent)")

        let names = markers.compactMap(\.name)
        let startTimes = markers.compactMap(\.startTime)
        
        #expect(names == ["Marker 0", "Marker 1", "Marker 2", "Marker 3", "Marker 4"], "\(url.lastPathComponent)")
        #expect(startTimes == [0.0, 1.0, 2.0, 3.0, 4.0], "\(url.lastPathComponent)")
        
        Log.debug(
    }
}
