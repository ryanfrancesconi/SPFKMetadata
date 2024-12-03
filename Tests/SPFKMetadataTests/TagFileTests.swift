// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

class TagFileTests: SPFKMetadataTestModel {
    @Test func testParseID3() async throws {
        let tagFile = try #require(TagFile(path: bext_v2.path))

        #expect(tagFile.dictionary?["TITLE"] as? String == "ID3: 12345678910 mono 48k")
    }
    
    
    @Test func testParseID3_2() async throws {
        let tagFile = try #require(TagFile(path: "/Users/rf/Downloads/sounds/packs/app.add.soundpack.drones_vol_2_wav/DRN02_Bed_Drone_Synthetic_Wow_Key E.mp3"))

        Swift.print(tagFile.dictionary)
    }
}
