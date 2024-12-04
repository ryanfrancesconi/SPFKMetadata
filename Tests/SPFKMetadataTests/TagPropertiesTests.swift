// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

@Suite(.serialized)
class TagPropertiesTests: SPFKMetadataTestModel {
    lazy var bin: URL = createBin(suite: "TagPropertiesTests")

    @Test func parseID3MP3() async throws {
        let metadata = try TagProperties(url: id3)
        Swift.print(metadata)
        #expect(metadata[.title] == "Shine On (inst)")
    }

    @Test func parseID3MP3_AV() async throws {
        let metadata = try await TagPropertiesAV(url: id3)
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

extension TagPropertiesTests {
    @Test func readWriteTagProperties() async throws {
        let tmpfile = try copy(to: bin, url: bext_v1)

        var properties = try TagProperties(url: tmpfile)
        #expect(properties[.title] == "INFO: bext")

        properties[.title] = "New Title"

        try properties.save()

        #expect(properties[.title] == "New Title")
    }

    @Test func readWriteTagProperties_C() async throws {
        let tmpfile = try copy(to: bin, url: bext_v1)

        var dict = try #require(TagLibBridge.getProperties(tmpfile.path) as? [String: String])
        #expect(dict["TITLE"] == "INFO: bext")

        dict["TITLE"] = "New Title"

        let success = TagLibBridge.setProperties(tmpfile.path, dictionary: dict)

        #expect(success)

        dict = try #require(TagLibBridge.getProperties(tmpfile.path) as? [String: String])

        #expect(dict["TITLE"] == "New Title")
    }
}

// - dev tests

extension TagPropertiesTests {
    @Test func testParseID3_2() async throws {
        let path = "/Users/rf/Downloads/sounds 3/packs/app.add.soundpack.activity_wav/Sound Effects/Element/Water/Bubbles/Blow Bubbles Into Metal Pan 02.mp3"
        let tagFile = try #require(TagFile(path: path))
        Swift.print(tagFile.dictionary)

        let comment = TagLibBridge.getComment(path)
        Swift.print(comment)
    }

    @Test func testParseID3_3() async throws {
        let path = "/Users/rf/Downloads/sounds 3/packs/app.add.soundpack.activity_wav/Sound Effects/Element/Water/Bubbles/Blow Bubbles Into Metal Pan 02.mp3"
        let url = URL(fileURLWithPath: path)

        let properties = try await TagPropertiesAV(url: url)
        Swift.print(properties)
    }
}
