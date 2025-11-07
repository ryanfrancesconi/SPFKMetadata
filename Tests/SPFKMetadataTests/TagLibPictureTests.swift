// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
@testable import SPFKTesting
import SPFKUtils
import Testing

@Suite(.serialized)
class TagLibPictureTests: BinTestCase {
    @Test func getPicture() async throws {
        deleteBinOnExit = false

        let source = TestBundleResources.shared.mp3_id3

        let tagPicture = try #require(TagLibPicture.getPicture(source.path))
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

        Log.debug(tagPicture.cgImage)
    }

    @Test func getPictureFail() async throws {
        let source = TestBundleResources.shared.toc_many_children
        #expect(source.exists)

        let tagPicture = TagLibPicture.getPicture(source.path)
        #expect(tagPicture == nil)
    }

    @Test func setPicture() async throws {
        deleteBinOnExit = false

        let imageURL = TestBundleResources.shared.sharksandwich

        let pictureRef = try #require(
            TagPictureRef(
                url: imageURL,
                pictureDescription: "Shit Sandwich",
                pictureType: "Back Cover"
            )
        )

        #expect(pictureRef.utType == .jpeg)

        for item in TestBundleResources.shared.formats {
            let tmpfile = try copyToBin(url: item)

            Log.debug(tmpfile.path)

            let result = TagLibPicture.setPicture(pictureRef, path: tmpfile.path)
            #expect(result)

            // open the tmp file up and double check properties were correctly set
            let outputPicture = try #require(TagLibPicture.getPicture(tmpfile.path))
            #expect(outputPicture.cgImage.width == pictureRef.cgImage.width)
            #expect(outputPicture.cgImage.height == pictureRef.cgImage.height)

            // not all formats support these? mp4 / m4a
            // #expect(outputPicture.pictureDescription == "Shit Sandwich", "\(tmpfile.lastPathComponent)")
            // #expect(outputPicture.pictureType == "Back Cover", "\(tmpfile.lastPathComponent)")
        }
    }
}
