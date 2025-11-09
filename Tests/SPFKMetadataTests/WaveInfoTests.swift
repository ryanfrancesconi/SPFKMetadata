// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
@testable import SPFKTesting
import SPFKUtils
import Testing

@Suite(.serialized)
class WaveInfoTests: BinTestCase {
    @Test func parseInfo() async throws {

        let url = TestBundleResources.shared.wav_bext_v2
        let waveFile = try #require(WaveFile(path: url.path))
        #expect(waveFile.update())

        let dictionary = try #require(waveFile.dictionary)
        Log.debug(dictionary)

//        for (key, value) in dictionary {
//            Log.debug("\(key) = \(value)")
//        }
    }

    @Test func writeCustom() async throws {
        deleteBinOnExit = false
        let tmpfile = try copyToBin(url: TestBundleResources.shared.wav_bext_v2)

        let waveFile = try #require(WaveFile(path: tmpfile.path))
        #expect(waveFile.update())
        waveFile[.bpm] = "666"
        waveFile.save()

        let newFile = try #require(WaveFile(path: tmpfile.path))
        #expect(newFile.update())

        let newDict = try #require(newFile.dictionary)
        Log.debug(newDict)
    }
}
