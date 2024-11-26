// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import AudioToolbox
import Foundation
import SPFKMetadataC

// TBD: if there needs to be a Swift struct representation copy
// Maintaining this copy for Hashable/Codable conformance

/// BEXT Wave Chunk - BroadcastExtension
public struct BEXTDescription: Hashable, Codable {
    /// BWF Version 0, 1, or 2
    public var version: Int16 = 0

    /// UMID (Unique Material Identifier) to standard SMPTE. (Note: Added in version 1.)
    public var umid: String?

    /// A <CodingHistory> field is provided in the BWF format to allow the exchange of information on previous signal processing,
    /// IE: A=PCM,F=48000,W=16,M=stereo|mono,T=original
    ///
    /// A=<ANALOGUE, PCM, MPEG1L1, MPEG1L2, MPEG1L3, MPEG2L1, MPEG2L2, MPEG2L3>
    /// F=<11000,22050,24000,32000,44100,48000>
    /// B=<any bit-rate allowed in MPEG 2 (ISO/IEC 13818-3)>
    /// W=<8, 12, 14, 16, 18, 20, 22, 24>
    /// M=<mono, stereo, dual-mono, joint-stereo>
    /// T=<a free ASCII-text string for in house use. This string should contain no commas (ASCII 2Chex).
    /// Examples of the contents: ID-No; codec type; A/D type>
    ///
    /// see: https://tech.ebu.ch/docs/r/r098.pdf
    public var codingHistory: String?

    /// Integrated Loudness Value of the file in LUFS. (Note: Added in version 2.)
    public var loudnessValue: AUValue?

    /// Loudness Range of the file in LU. (Note: Added in version 2.)
    public var loudnessRange: AUValue?

    /// Maximum True Peak Value of the file in dBTP. (Note: Added in version 2.)
    public var maxTruePeakLevel: AUValue?

    /// highest value of the Momentary Loudness Level of the file in LUFS. (Note: Added in version 2.)
    public var maxMomentaryLoudness: AUValue?

    /// highest value of the Short-term Loudness Level of the file in LUFS. (Note: Added in version 2.)
    public var maxShortTermLoudness: AUValue?

    /// The name of the originator / producer of the audio file
    public var originator: String?

    /// Unambiguous reference allocated by the originating organization
    public var originatorReference: String?

    /// yyyy:mm:dd
    public var originationDate: String?

    /// hh:mm:ss
    public var originationTime: String?

    /// Time reference in samples
    /// These fields shall contain the time-code of the sequence. It is a 64-bit value which contains the first sample count since midnight.
    /// First sample count since midnight, low word (UInt32)
    public var timeReferenceLow: UInt32?

    /// Time reference in samples
    /// First sample count since midnight, high word (UInt32)
    public var timeReferenceHigh: UInt32?

    /// Combined 64bit time value of low and high words
    public var timeReference: UInt64? {
        guard let timeReferenceLow, let timeReferenceHigh else {
            return nil
        }

        return (UInt64(timeReferenceHigh) << 32) | UInt64(timeReferenceLow)
    }

    public var timeReferenceInSeconds: TimeInterval? {
        guard let timeReference, let sampleRate else { return nil }
        return TimeInterval(timeReference) / sampleRate
    }

    public var sampleRate: Double?

    public init() {}

    public init?(url: URL) {
        guard let info = BroadcastInfo(path: url.path) else {
            return nil
        }

        self = BEXTDescription(info: info)
    }

    public init(info: BroadcastInfo) {
        version = info.version
        sampleRate = info.sampleRate

        if version > 1 {
            umid = info.umid
        }

        if version >= 2 {
            loudnessValue = info.loudnessValue
            loudnessRange = info.loudnessRange
            maxTruePeakLevel = info.maxTruePeakLevel
            maxMomentaryLoudness = info.maxMomentaryLoudness
            maxShortTermLoudness = info.maxShortTermLoudness
        }

        originator = info.originator
        originationDate = info.originationDate
        originationTime = info.originationTime
        originatorReference = info.originatorReference

        timeReferenceLow = info.timeReferenceLow
        timeReferenceHigh = info.timeReferenceHigh
    }
}
