// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
@testable import SPFKTesting
import SPFKUtils
import Testing

@Suite(.serialized)
class ID3FileTests: BinTestCase {
    @Test func xmp() async throws {
        // use the xmp file as it has the non standard PRIV frame
        let url = TestBundleResources.shared.mp3_xmp

        let id3File = ID3File(path: url.path)
        #expect(id3File.update())

        Log.debug(id3File[.private])
    }

    @Test func frames() async throws {
        let url = TestBundleResources.shared.mp3_id3

        let id3File = ID3File(path: url.path)
        #expect(id3File.update())

        Log.debug(id3File.frames)
        
        #expect(id3File.frames.count == 28)
    }
}
