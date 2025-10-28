// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
@testable import SPFKTesting
import SPFKUtils
import Testing

@Suite(.serialized)
class BroadcastInfoTests: BinTestCase {
    @Test func parseBEXT_v2() async throws {
        let desc = try #require(BEXTDescription(url: BundleResources.shared.wav_bext_v2))

        Log.debug(desc)

        #expect(desc.version == 2)
        #expect(desc.umid == "")
        #expect(desc.sequenceDescription == """
            And oh how they danced
            The little children of Stonehenge
            Beneath the haunted moon
            For fear that daybreak might come too soon
            """
        )
        #expect(desc.codingHistory == "A=PCM,F=44100,W=16,M=stereo,T=original")
        #expect(desc.originator == "ITRAIDA88396FG347125324098748726")
        #expect(desc.originatorReference == "RF666SPONGEFORK66000100510720836")
        #expect(desc.originationDate == "1984:01:01")
        #expect(desc.originationTime == "00:01:00")
        #expect(desc.loudnessValue == -22.28)
        #expect(desc.loudnessRange == 0)
        #expect(desc.maxTruePeakLevel == -8.75)
        #expect(desc.maxMomentaryLoudness == -18.42)
        #expect(desc.maxShortTermLoudness == 327.67) // wrong?
        #expect(desc.timeReference == 158760000)
        #expect(desc.timeReferenceInSeconds == 3600.0)
    }

    @Test func writeBEXT() async throws {
        let tmpfile = try copyToBin(url: BundleResources.shared.wav_bext_v2)

        var desc = BEXTDescription()
        desc.sequenceDescription = "A new description"
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
        #expect(updated.sequenceDescription == "A new description")
        #expect(updated.umid == "XXXXXX000000000000000000000000000000000000000000000000000000000")
        #expect(updated.originator == "Ryan Francesconi")
        #expect(updated.originatorReference == "ITRAIDA88396FG347125324098748726")
        #expect(updated.originationDate == "2011:01:10")
        #expect(updated.originationTime == "01:01:01")
        #expect(updated.codingHistory?.trimmed == "A=PCM,F=48000,W=16,M=mono,T=original")
        #expect(updated.timeReference == 175728049)
        #expect(updated.timeReferenceInSeconds == 3984.763015873016)
        #expect(updated.loudnessValue == -20.12)
        #expect(updated.loudnessRange == -21)
        #expect(updated.maxTruePeakLevel == -22)
        #expect(updated.maxShortTermLoudness == -1)
        #expect(updated.maxMomentaryLoudness == -2)
    }
}
