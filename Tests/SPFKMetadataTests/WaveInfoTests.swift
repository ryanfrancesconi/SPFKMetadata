// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import SPFKTesting
import SPFKBase
import Testing

@Suite(.serialized)
class WaveInfoTests: BinTestCase {
    @Test func parseInfo() async throws {
        let url = TestBundleResources.shared.wav_bext_v2
        let file = try #require(WaveFile(path: url.path))
        #expect(file.load())

        let dictionary = try #require(file.dictionary)
        Log.debug(dictionary)

        #expect(file[.product] == "This Is Spinal Tap")
        #expect(file[.artist] == "Spinal Tap")
        #expect(file[.comment] == "And oh how they danced. The little children of Stonehenge.Beneath the haunted moon.For fear that daybreak might come too soon.")
        #expect(file[.editedBy] == "SPFKMetadata")
        #expect(file[.title] == "Stonehenge")
        #expect(file[.bpm] == "666")
    }

    @Test func writeCustom() async throws {
        deleteBinOnExit = false
        let tmpfile = try copyToBin(url: TestBundleResources.shared.wav_bext_v2)

        let file = try #require(WaveFile(path: tmpfile.path))
        #expect(file.load())
        file[.bpm] = "667"
        file.save()

        let newFile = try #require(WaveFile(path: tmpfile.path))
        #expect(newFile.load())

        let newDict = try #require(newFile.dictionary)
        Log.debug(newDict)
        
        #expect(newFile[.bpm] == "667")
    }
}
