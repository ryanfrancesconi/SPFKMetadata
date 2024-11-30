// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

@Suite(.serialized) // don't run in parallel as they're using the same file URL
class MP3MarkerTests: SPFKMetadataTestModel {
    @Test func parseMarkers() async throws {
        let markers = TagLibBridge.getMP3Chapters(chapters_mp3.path)
    }
    
    @Test func writeMarkers() async throws {
    }
    
    @Test func removeMarkers() async throws {
    }
}
