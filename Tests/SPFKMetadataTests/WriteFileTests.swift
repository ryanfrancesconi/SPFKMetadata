// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

class WriteFileTests: SPFKMetadataTestModel {
    @Test func writeWave() async throws {
        let url = bext_v1 // only has an INFO tag, no ID3
        let tmp = bin.appendingPathComponent(url.lastPathComponent)

        if FileManager.default.fileExists(atPath: tmp.path) {
            try? FileManager.default.removeItem(at: tmp)
        }

        try FileManager.default.copyItem(at: url, to: tmp)

        var dict = try #require(TagLibBridge.getProperties(tmp.path) as? [String: String])

        dict["TITLE"] = "New Title"

        let success = TagLibBridge.setProperties(tmp.path, dictionary: dict)

        #expect(success)

        dict = try #require(TagLibBridge.getProperties(tmp.path) as? [String: String])

        #expect(dict["TITLE"] == "New Title")
    }

    deinit {
        try? FileManager.default.removeItem(at: bin)
    }
}
