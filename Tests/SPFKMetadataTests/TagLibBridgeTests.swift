// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
@testable import SPFKTesting
import SPFKUtils
import Testing

@Suite(.serialized)
class TagLibBridgeTests: BinTestCase {
    @Test func readWriteProperties() async throws {
        let tmpfile = try copyToBin(url: BundleResources.shared.wav_bext_v2)
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
        let tmpfile = try copyToBin(url: BundleResources.shared.mp3_id3)

        let success = TagLibBridge.removeAllTags(tmpfile.path)
        #expect(success)

        let dict = TagLibBridge.getProperties(tmpfile.path) as? [String: String]
        #expect(dict == nil)
    }

    @Test func copyMetadata() async throws {
        let source = BundleResources.shared.mp3_id3
        let destination = BundleResources.shared.tabla_mp4
        let tmpfile = try copyToBin(url: destination)

        let success = TagLibBridge.copyTags(fromPath: source.path, toPath: tmpfile.path)
        #expect(success)

        let dict = try #require(TagLibBridge.getProperties(tmpfile.path) as? [String: String])
        #expect(dict["TITLE"] == "Stonehenge")
    }

    @Test func getPicture() async throws {
        let source = BundleResources.shared.mp3_id3

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

    @Test func getPictureFail() async throws {
        let source = BundleResources.shared.toc_many_children
        #expect(source.exists)

        let tagPicture = TagLibBridge.getPicture(source.path)
        #expect(tagPicture == nil)
    }

    @Test func setPicture() async throws {
        let tmpfile = try copyToBin(url: BundleResources.shared.mp3_id3)
        let imageURL = BundleResources.shared.sharksandwich

        let tagPicture = try #require(
            TagPicture(
                url: imageURL,
                pictureDescription: "Shit Sandwich",
                pictureType: "Back Cover"
            )
        )

        #expect(tagPicture.utType == .jpeg)

        Swift.print(tmpfile.path, tagPicture.cgImage)

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
