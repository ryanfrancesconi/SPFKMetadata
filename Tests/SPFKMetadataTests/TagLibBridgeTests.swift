// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

@Suite(.serialized)
class TagLibBridgeTests: SPFKMetadataTestModel {
    var deleteBin = false

    lazy var bin: URL = createBin(suite: "TagLibBridgeTests")
    deinit { if deleteBin { removeBin() } }

    @Test func readWriteProperties() async throws {
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

    @Test func removeAllTags() async throws {
        let tmpfile = try copy(to: bin, url: mp3_id3)

        let success = TagLibBridge.removeAllTags(tmpfile.path)
        #expect(success)

        let dict = TagLibBridge.getProperties(tmpfile.path) as? [String: String]
        #expect(dict == nil)
    }

    @Test func copyMetadata() async throws {
        let source = mp3_id3
        let destination = tabla_mp4
        let tmpfile = try copy(to: bin, url: destination)

        let success = TagLibBridge.copyTags(fromPath: source.path, toPath: tmpfile.path)
        #expect(success)

        let dict = try #require(TagLibBridge.getProperties(tmpfile.path) as? [String: String])
        #expect(dict["TITLE"] == "Stonehenge")
    }

    @Test func getPicture() async throws {
        let source = mp3_id3

        let tagPicture = try #require(TagLibBridge.getPicture(source.path))
        let desc = try #require(tagPicture.pictureDescription)
        let type = try #require(tagPicture.pictureType)
        let cgImage = tagPicture.cgImage

        #expect(cgImage.width == 600)
        #expect(cgImage.height == 592)
        #expect(type == "Front Cover")
        #expect(desc == "Smell the glove")

        // test export to file
        let exportType: CGImage.ExportType = .jpeg
        let filename = "\(type) - \(desc).\(exportType.rawValue)"
        let url = bin.appendingPathComponent(filename, conformingTo: exportType.utType)
        try cgImage.export(type: exportType, to: url)

        Swift.print(tagPicture.cgImage)
    }

    @Test func setPicture() async throws {
        let tmpfile = try copy(to: bin, url: mp3_id3)
        let imageURL = sharksandwich

        let utType = try #require(
            UTType(filenameExtension: imageURL.pathExtension)
        )

        let tagPicture = try #require(
            TagPicture(
                url: imageURL,
                utType: utType,
                pictureDescription: "Shit Sandwich",
                pictureType: "Back Cover"
            )
        )

        Swift.print(tagPicture.cgImage)

        let result = TagLibBridge.setPicture(tmpfile.path, picture: tagPicture)
        #expect(result)

        // open the tmp file up and double check properties were correctly set
        let outputPicture = try #require(TagLibBridge.getPicture(tmpfile.path))
        #expect(outputPicture.cgImage.width == 425)
        #expect(outputPicture.cgImage.height == 425)
        #expect(outputPicture.pictureDescription == "Shit Sandwich")
        #expect(outputPicture.pictureType == "Back Cover")
    }
}
