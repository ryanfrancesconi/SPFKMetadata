// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

@Suite(.serialized)
class TagLibBridgeTests: SPFKMetadataTestModel {
    lazy var bin: URL = createBin(suite: "TagLibBridgeTests")

    deinit {
        // try? FileManager.default.removeItem(at: bin)
    }

    @Test func readWriteTagProperties() async throws {
        let tmpfile = try copy(to: bin, url: wav_bext_v2)
        var dict = try #require(TagLibBridge.getProperties(tmpfile.path) as? [String: String])

        #expect(dict["TITLE"] == "Stonehenge")

        // set
        dict["TITLE"] = "New Title"

        // set and save
        let success = TagLibBridge.setProperties(tmpfile.path, dictionary: dict)
        #expect(success)

        // reparse
        dict = try #require(TagLibBridge.getProperties(tmpfile.path) as? [String: String])
        #expect(dict["TITLE"] == "New Title")
    }

    @Test func removeMetadata() async throws {
        let tmpfile = try copy(to: bin, url: mp3_id3)

        let success = TagLibBridge.removeAllTags(tmpfile.path)
        #expect(success)

        let dict = TagLibBridge.getProperties(tmpfile.path) as? [String: String]
        #expect(dict == nil)
    }

    @Test func copyMetadata() async throws {
        let source = URL(fileURLWithPath: "/Users/rf/Desktop/tag/id3.mp3")
        let destination = URL(fileURLWithPath: "/Volumes/ADD2/mp3/Spinal Tap/This Is Spinal Tap/and-oh-how-they-danced.mp3")
        let tmpfile = try copy(to: bin, url: destination)

        let success = TagLibBridge.copyTags(fromPath: source.path, toPath: tmpfile.path)
        #expect(success)
    }
}
