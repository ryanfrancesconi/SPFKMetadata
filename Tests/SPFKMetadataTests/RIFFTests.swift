// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
@testable import SPFKTesting
import SPFKUtils
import Testing

@Suite(.serialized)
class RIFFTests: BinTestCase {
    @Test func parseInfo() async throws {
        // let url = try copyToBin(url: TestBundleResources.shared.wav_bext_v2)
        // let url = URL(fileURLWithPath: "/Users/rf/Downloads/M1F1-float64WE-AFsp.wav")

        let url = TestBundleResources.shared.wav_bext_v2
        let waveFile = try #require(WaveFile(path: url.path))
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
        var dictionary = try #require(waveFile.dictionary as? [String: String])

        dictionary["IBPM"] = "666"

        WaveFile.write(dictionary, path: tmpfile.path)

        let newFile = try #require(WaveFile(path: tmpfile.path))
        let newDict = try #require(newFile.dictionary)
        Log.debug(newDict)
    }
}
