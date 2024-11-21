import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

/*
 swift test -Xswiftc -cxx-interoperability-mode=default
 */

class ParseFileTests: SPFKMetadataTestModel {
    @Test func parseMP3() async throws {
        let url = getResource(named: "id3.mp3")

        let metadata = try ID3Metadata(url: url)
        Swift.print(metadata)

        #expect(metadata[.title] == "Shine On (inst)")
    }

    @Test func parseBEXT() async throws {
        let url = getResource(named: "bext_v2.wav")

        let metadata = try BEXTMetadata(url: url)

        Swift.print(metadata)

        #expect(metadata.info.version == 2)
    }
}
