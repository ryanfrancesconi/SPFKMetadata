// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
import Testing

@Suite(.serialized)
class BroadcastInfoTests: SPFKMetadataTestModel {
    @Test func parseBEXT_v2() async throws {
        let desc = try #require(BEXTDescription(url: bext_v2))

        Swift.print(desc)

        #expect(desc.version == 2)
        #expect(desc.umid == "")
        #expect(desc.description == "Here is a description")
        #expect(desc.codingHistory == "A=PCM,F=48000,W=16,M=mono,T=original\n")
        #expect(desc.originator == "RF")
        #expect(desc.originatorReference == "SPFKSPFKSPFKSPFKSPFKSPFKSPFKSPFK")
        #expect(desc.originationDate == "2011:11:11")
        #expect(desc.originationTime == "21:29:25")
        #expect(desc.loudnessValue == -32.55)
        #expect(desc.loudnessRange == 0.69)
        #expect(desc.maxTruePeakLevel == -12.47)
        #expect(desc.maxMomentaryLoudness == -26.25)
        #expect(desc.maxShortTermLoudness == -32.12)
        #expect(desc.timeReference == 175728049)
        #expect(desc.timeReferenceInSeconds == 3661.0010208333333)
    }

    @Test func writeBEXT() async throws {
        lazy var bin: URL = createBin(suite: "BroadcastInfoTests")
        let tmpfile = try copy(to: bin, url: bext_v2)

        var desc = BEXTDescription()
        desc.description = "A new description"
        desc.umid = "XXXXXX"
        desc.originator = "Ryan Francesconi"
        desc.originatorReference = "ITRAIDA88396FG347125324098748726"
        desc.originationDate = "2011:01:1" // under
        desc.originationTime = "01:01:01__Garbage" // truncate
        desc.codingHistory = "A=PCM,F=48000,W=16,M=mono,T=original"
        desc.loudnessValue = -20.123456 // truncate
        desc.loudnessRange = -21
        desc.maxTruePeakLevel = -22
        desc.maxShortTermLoudness = -1
        desc.maxMomentaryLoudness = -2
        desc.timeReferenceLow = 175728049
        desc.timeReferenceHigh = 0

        // validate and write the above def
        try BEXTDescription.write(bextDescription: desc, to: tmpfile)

        // read it back in
        let updated = try #require(BEXTDescription(url: tmpfile))
        #expect(updated.version == 2)
        #expect(updated.description == "A new description")
        #expect(updated.umid == "XXXXXX000000000000000000000000000000000000000000000000000000000")
        #expect(updated.originator == "Ryan Francesconi")
        #expect(updated.originatorReference == "ITRAIDA88396FG347125324098748726")
        #expect(updated.originationDate == "2011:01:10")
        #expect(updated.originationTime == "01:01:01")
        #expect(updated.codingHistory?.trimmed == "A=PCM,F=48000,W=16,M=mono,T=original")
        #expect(updated.timeReference == 175728049)
        #expect(updated.timeReferenceInSeconds == 3661.0010208333333)
        #expect(updated.loudnessValue == -20.12)
        #expect(updated.loudnessRange == -21)
        #expect(updated.maxTruePeakLevel == -22)
        #expect(updated.maxShortTermLoudness == -1)
        #expect(updated.maxMomentaryLoudness == -2)
    }

    @Test func parse_missing_BEXT() async throws {
        let desc = BEXTDescriptionC(path: "/Users/rf/Desktop/_av/Vocalizations/Element/Human/Sarcasm/12345678910_01.wav")
        #expect(desc == nil)
    }
}
