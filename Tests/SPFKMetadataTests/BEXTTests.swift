// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKBase
import SPFKMetadata
import SPFKMetadataC
import SPFKTesting
import Testing

@Suite(.serialized)
class BEXTTests: BinTestCase {
    @Test func initBEXTDescriptionC() async throws {
        let bextc = BEXTDescriptionC(path: TestBundleResources.shared.tabla_wav.path())
        
        Log.debug(bextc?.maxTruePeakLevel)
    }
    
    @Test func parseBEXT_v1() async throws {
        let desc = try #require(BEXTDescription(url: TestBundleResources.shared.wav_bext_v1))
        Log.debug(desc)

        // <bext:version>1</bext:version>
        #expect(desc.version == 1)

        // XMP: <bext:umid>00000000F05E776B01000000000000000000000000000000000000006058776B010000003058776B01000000C8D3B6080100000000000000000000006058776B</bext:umid>
        #expect(desc.umid == "00000000F05E776B01000000000000000000000000000000000000006058776B010000003058776B01000000C8D3B6080100000000000000000000006058776B")

        // <bext:originator>Logic Pro</bext:originator>
        #expect(desc.originator == "Logic Pro")

        // <bext:originationDate>2025-10-18</bext:originationDate>
        #expect(desc.originationDate == "2025-10-18")

        // <bext:originationTime>17:51:21</bext:originationTime>
        #expect(desc.originationTime == "17:51:21")

        // <bext:timeReference>172800000</bext:timeReference>
        #expect(desc.timeReference == 172_800_000)
    }

    @Test func parseBEXT_v2b() async throws {
        deleteBinOnExit = false

        let url = TestBundleResources.shared.wav_bext_v2b

        let desc = try #require(BEXTDescription(url: url))
        Log.debug(desc)

        #expect(desc.version == 2)
        #expect(desc.umid == "53504F4E4745464F524B303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303000")
        #expect(desc.sequenceDescription == "And oh how they danced The little children of Stonehenge Beneath the haunted moon For fear that daybreak might come too soonr fear that daybreak might come too soon")
        #expect(desc.codingHistory?.trimmed == "A=PCM,F=44100,W=16,M=stereo,T=original")
        #expect(desc.originator == "ITRAIDA88396FG347125324098748726")
        #expect(desc.originatorReference == "RF666SPONGEFORK66000100510720836")
        #expect(desc.originationDate == "1984:01:01")
        #expect(desc.originationTime == "00:01:00")
        #expect(desc.loudnessValue == -22.28)
        #expect(desc.loudnessRange == -14)
        #expect(desc.maxTruePeakLevel == -8.75)
        #expect(desc.maxMomentaryLoudness == -18.42)
        #expect(desc.maxShortTermLoudness == -16)
        #expect(desc.timeReference == 158_760_000)
        #expect(desc.timeReferenceInSeconds == 3600.0)
    }

    @Test func writeBEXT1() async throws {
        deleteBinOnExit = false
        let tmpfile = try copyToBin(url: TestBundleResources.shared.wav_bext_v2)

        var desc = BEXTDescription()

        desc.version = 2
        desc.umid = "SPONGEFORK"
        desc.sequenceDescription = "And oh how they danced The little children of Stonehenge Beneath the haunted moon For fear that daybreak might come too soonr fear that daybreak might come too soon"

        desc.codingHistory = "A=PCM,F=44100,W=16,M=stereo,T=original"
        desc.originator = "ITRAIDA88396FG347125324098748726"
        desc.originatorReference = "RF666SPONGEFORK66000100510720836"
        desc.originationDate = "1984:01:01"
        desc.originationTime = "00:01:00"
        desc.loudnessValue = -22.28
        desc.loudnessRange = -14
        desc.maxTruePeakLevel = -8.75
        desc.maxMomentaryLoudness = -18.42
        desc.maxShortTermLoudness = -16
        desc.timeReferenceLow = 158_760_000
        desc.timeReferenceHigh = 0

        // validate and write the above def
        try BEXTDescription.write(bextDescription: desc, to: tmpfile)
    }

    @Test func writeBEXT2() async throws {
        deleteBinOnExit = false
        let tmpfile = try copyToBin(url: TestBundleResources.shared.wav_bext_v1)

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
        desc.timeReferenceLow = 175_728_049
        desc.timeReferenceHigh = 0
        desc.sampleRate = 48000

        // validate and write the above def
        try BEXTDescription.write(bextDescription: desc, to: tmpfile)

        // read it back in
        let updated = try #require(BEXTDescription(url: tmpfile))
        #expect(updated.version == 2)
        #expect(updated.sequenceDescription == desc.sequenceDescription)
        #expect(updated.umid == "58585858585830303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303000")
        #expect(updated.originator == desc.originator)
        #expect(updated.originatorReference == desc.originatorReference)
        #expect(updated.originationDate == "2011:01:10")
        #expect(updated.originationTime == "01:01:01")

        if let codingHistory = updated.codingHistory?.trimmed {
            #expect(codingHistory.hasPrefix("A=PCM,F=48000,W=16,M=mono,T=original"))
        }

        #expect(updated.timeReference == 175_728_049)
        #expect(updated.timeReferenceInSeconds == 3661.0010208333333)
        #expect(updated.loudnessValue == -20.12)
        #expect(updated.loudnessRange == -21)
        #expect(updated.maxTruePeakLevel == -22)
        #expect(updated.maxShortTermLoudness == -1)
        #expect(updated.maxMomentaryLoudness == -2)
    }

    @Test func writeBEXT3() async throws {
        deleteBinOnExit = false
        let tmpfile = try copyToBin(url: TestBundleResources.shared.wav_bext_v1)

        var desc1 = BEXTDescription()
        desc1.sequenceDescription = "Description 1"

        var desc2 = BEXTDescription()
        desc2.sequenceDescription = "Description 2"

        try BEXTDescription.write(bextDescription: desc1, to: tmpfile)
        try BEXTDescription.write(bextDescription: desc2, to: tmpfile)

        let updated = try #require(BEXTDescription(url: tmpfile))

        Log.debug(updated)
    }
}
