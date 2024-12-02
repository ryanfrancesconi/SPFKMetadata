
// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

class BroadcastInfoTests: SPFKMetadataTestModel {
    @Test func parseBEXT_v2() async throws {
        let desc = try #require(BEXTDescription(url: bext_v2))

        Swift.print(desc)

        #expect(desc.version == 2)
        #expect(desc.umid == "")
        #expect(desc.codingHistory == nil)
        #expect(desc.originator == "RF")
        #expect(desc.originatorReference == "USIZT00QJVDHQ34QG0000009758431952024-11-2021:29:25")
        #expect(desc.originationDate == "2024-11-2021:29:25") // likely wrong that the time is in here
        #expect(desc.originationTime == "21:29:25")
        #expect(desc.loudnessValue == -32.0)
        #expect(desc.loudnessRange == 0) // ?
        #expect(desc.maxTruePeakLevel == -12)
        #expect(desc.maxMomentaryLoudness == -26)
        #expect(desc.maxShortTermLoudness == -32)
        #expect(desc.timeReference == 175728049)
        #expect(desc.timeReferenceInSeconds == 3661.0010208333333)
    }

    @Test func parse_missing_BEXT() async throws {
        let desc = BroadcastInfo(path: "/Users/rf/Desktop/_av/Vocalizations/Element/Human/Sarcasm/12345678910_01.wav")
        #expect(desc == nil)
    }
}
