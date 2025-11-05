// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
@testable import SPFKTesting
import SPFKUtils
import Testing

@Suite(.serialized)
class TagFileTests: BinTestCase {
    @Test func testParseID3() async throws {
        let tagFile = try #require(TagFile(path: TestBundleResources.shared.wav_bext_v2.path))

        // this is the TagLib properties map
        #expect(
            tagFile.dictionary?["TITLE"] as? String == "Stonehenge"
        )
    }
}
