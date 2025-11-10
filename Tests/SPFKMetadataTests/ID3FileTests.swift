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

        let file = ID3File(path: url.path)
        #expect(file.load())

        // xmp
        Log.debug(file[.private])
    }

    @Test func parse() async throws {
        let url = TestBundleResources.shared.mp3_id3

        let file = ID3File(path: url.path)
        #expect(file.load())

        #expect(file[.album] == "This Is Spinal Tap")
        #expect(file[.artist] == "Spinal Tap")
        #expect(file[.comment] == """
            And oh how they danced. The little children of Stonehenge.
            Beneath the haunted moon.
            For fear that daybreak might come too soon.
            """
        )
        #expect(file[.remixer] == "SPFKMetadata")
        #expect(file[.title] == "Stonehenge")
        #expect(file[.bpm] == "666")
    }
}
