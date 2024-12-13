// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

@Suite(.serialized)
class TagPropertiesTests: SPFKMetadataTestModel {
    lazy var bin: URL = createBin(suite: "TagPropertiesTests")
    deinit { removeBin() }

    @Test func parseID3MP3() async throws {
        let elapsed = try ContinuousClock().measure {
            let properties = try TagProperties(url: mp3_id3)
            Swift.print(properties.description)
            verify(dictionary: properties.tags)
        }

        Swift.print(elapsed) // benchmark
    }

    private func verify(dictionary: TagKeyDictionary) {
        #expect(dictionary[.title] == "Stonehenge")
        #expect(dictionary[.bpm] == "666")
    }

    @Test func parseID3MP3_AV() async throws {
        let elapsed = try await ContinuousClock().measure {
            let properties = try await TagPropertiesAV(url: mp3_id3)
            Swift.print(properties.description)
            verify(dictionary: properties.tags)
        }

        Swift.print(elapsed) // benchmark
    }

    @Test func parseID3Wave() async throws {
        let properties = try TagProperties(url: wav_bext_v2)
        Swift.print(properties)

        #expect(properties[.title] == "Stonehenge")
    }

    @Test func readWriteTagProperties() async throws {
        let tmpfile = try copy(to: bin, url: wav_bext_v2)

        var properties = try TagProperties(url: tmpfile)
        #expect(properties[.title] == "Stonehenge")

        properties[.title] = "New Title"
        try properties.save()

        #expect(properties[.title] == "New Title")
    }
}
