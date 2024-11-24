// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

class TagFileTests: SPFKMetadataTestModel {
    
    @Test func testParseID3() async throws {
        let tagFile = TagFile(path: bext_v2.path)
        
        //#expect(tagFile?.title() == "Shine On (inst)")

    }
    
}
