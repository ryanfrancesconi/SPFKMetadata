
import Foundation
import SPFKMetadataC

/// BEXT Wave Chunk - BroadcastExtension
public struct BroadcastExtensionDescription: Hashable, Codable {
    /// BWF Version 0, 1, or 2
    public var version: Int16 = 0

    ///  UMID (Unique Material Identifier) to standard SMPTE. (Note: Added in version 1.)
    public var umid: String?

    /// 100x the Integrated Loudness Value of the file in LUFS. (Note: Added in version 2.)
    /// IE, A value of -3255 = -32.5 LUFS (reference - 9.5 LU)
    public var loudnessValue: Int16?

    /// 100x the Loudness Range of the file in LU. (Note: Added in version 2.)
    /// 69 = +0.7 LU
    public var loudnessRange: Int16?

    /// 100x the Maximum True Peak Value of the file in dBTP. (Note: Added in version 2.)
    /// -1247 = -12.5 dB
    public var maxTruePeakLevel: Int16?

    /// 100x the highest value of the Momentary Loudness Level of the file in LUFS. (Note: Added in version 2.)
    /// -2625 = -26.3 LUFS (reference - 3.3 LU)
    public var maxMomentaryLoudness: Int16?

    /// 100x the highest value of the Short-term Loudness Level of the file in LUFS. (Note: Added in version 2.)
    /// -3212 = -32.1 LUFS (reference - 9.1 LU)
    public var maxShortTermLoudness: Int16?

    /// the name of the originator / producer of the audio file
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
        guard let timeReferenceLow,
              let timeReferenceHigh

        else {
            return nil
        }

        return UInt64(timeReferenceHigh << 32 | timeReferenceLow)
    }

    public init() {}

    /// Copy values from the C Struct `SF_BROADCAST_INFO` defined
    /// in sndfile.h
    ///
    /// - Parameter info: SF_BROADCAST_INFO
    public init(info: SF_BROADCAST_INFO) {
        originator = String(
            mirroringCChar: Mirror(reflecting: info.originator)
        )

        originatorReference = String(
            mirroringCChar: Mirror(reflecting: info.originator_reference)
        )

        originationDate = String(
            mirroringCChar: Mirror(reflecting: info.origination_date)
        )

        originationTime = String(
            mirroringCChar: Mirror(reflecting: info.origination_time)
        )

        timeReferenceLow = info.time_reference_low
        timeReferenceHigh = info.time_reference_high

        version = info.version

        if version >= 1 {
            umid = String(
                mirroringCChar: Mirror(reflecting: info.umid)
            )
        }

        if version >= 2 {
            loudnessValue = info.loudness_value
            loudnessRange = info.loudness_range
            maxTruePeakLevel = info.max_true_peak_level
            maxMomentaryLoudness = info.max_momentary_loudness
            maxShortTermLoudness = info.max_shortterm_loudness
        }
    }

    public func timeOrigin(at sampleRate: Double) -> TimeInterval {
        guard let timeReference else {
            return 0
        }

        return TimeInterval(timeReference) / sampleRate
    }
}