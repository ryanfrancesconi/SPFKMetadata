import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

class ParseFileTests: SPFKMetadataTestModel {
    @Test func parseID3MP3() async throws {
        let metadata = try TagProperties(url: id3)
        Swift.print(metadata)

        #expect(metadata[.title] == "Shine On (inst)")
    }
    
    @Test func parseID3Wave() async throws {
        let metadata = try TagProperties(url: bext_v2)
        Swift.print(metadata)

        #expect(metadata[.title] == "12345678910 mono 48k")
    }
    
    @Test func parseInfoWave() async throws {
        let metadata = try TagProperties(url: bext_v1)
        Swift.print(metadata)

        #expect(metadata[.title] == "bext")
    }

    @Test func parseBEXT() async throws {
        let desc = try BEXTDescription(url: bext_v2)

        Swift.print(desc)

        #expect(desc.version == 2)
    }
}
