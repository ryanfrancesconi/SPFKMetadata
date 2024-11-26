// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

class TagPropertiesTests: SPFKMetadataTestModel {
    @Test func parseID3MP3() async throws {
        let metadata = try TagProperties(url: id3)
        Swift.print(metadata)

        #expect(metadata[.title] == "Shine On (inst)")
    }

    @Test func parseID3Wave() async throws {
        let metadata = try TagProperties(url: bext_v2)
        Swift.print(metadata)

        #expect(metadata[.title] == "ID3: 12345678910 mono 48k")
    }

    @Test func parseInfoWave() async throws {
        let metadata = try TagProperties(url: bext_v1)
        Swift.print(metadata)

        #expect(metadata[.title] == "INFO: bext")
    }


    @Test func parseMetadataTags1() async throws {
        let url = bext_v2 // has both INFO and ID3

        let dict = try #require(TagLibBridge.getProperties(url.path))

        #expect(dict["TITLE"] as? String == "ID3: 12345678910 mono 48k")
    }

    @Test func parseMetadataTags2() async throws {
        let url = bext_v1 // only has an INFO tag, no ID3
        let dict = try #require(TagLibBridge.getProperties(url.path))

        #expect(dict["TITLE"] as? String == "INFO: bext")
    }
}
