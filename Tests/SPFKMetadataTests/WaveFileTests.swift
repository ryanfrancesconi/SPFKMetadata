
// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
@testable import SPFKTesting
import SPFKUtils
import Testing

@Suite(.serialized)
class WaveFileTests: BinTestCase {
    @Test func parseInfo() async throws {
        // let url = try copyToBin(url: BundleResources.shared.wav_bext_v2)

        let url = URL(fileURLWithPath: "/Users/rf/Downloads/M1F1-float64WE-AFsp.wav")

        let waveFile = try #require(WaveFile(path: url.path))
        let dictionary = try #require(waveFile.dictionary)

        Log.debug(dictionary)

        for (key, value) in dictionary {
            Log.debug("\(key) = \(value)")
        }
    }
}
