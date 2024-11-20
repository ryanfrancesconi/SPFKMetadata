
import Foundation
import SwiftTagLibC

/// BEXT Wave Chunk - BroadcastExtension
public struct BroadcastExtensionDescription: Hashable, Codable {
    /// BWF Version 0, 1, or 2
    public var version: Int16?

    /// 100x the Integrated Loudness Value of the file in LUFS. (Note: Added in version 2.)
    public var loudnessValue: Int16?

    /// 100x the Loudness Range of the file in LU. (Note: Added in version 2.)
    public var loudnessRange: Int16?

    /// 100x the Maximum True Peak Value of the file in dBTP. (Note: Added in version 2.)
    public var maxTruePeakLevel: Int16?

    /// 100x the highest value of the Momentary Loudness Level of the file in LUFS. (Note: Added in version 2.)
    public var maxMomentaryLoudness: Int16?

    /// 100x the highest value of the Short-term Loudness Level of the file in LUFS. (Note: Added in version 2.)
    public var maxShortTermLoudness: Int16?

    ///  UMID (Unique Material Identifier) to standard SMPTE. (Note: Added in version 1.)
    public var umid: String?

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
        umid = String(mirroringCChar: Mirror(reflecting: info.umid))
        originator = String(mirroringCChar: Mirror(reflecting: info.originator))
        originatorReference = String(mirroringCChar: Mirror(reflecting: info.originator_reference))
        originationDate = String(mirroringCChar: Mirror(reflecting: info.origination_date))
        originationTime = String(mirroringCChar: Mirror(reflecting: info.origination_time))

        timeReferenceLow = info.time_reference_low
        timeReferenceHigh = info.time_reference_high
        version = info.version
    }

    public func timeOrigin(at sampleRate: Double) -> TimeInterval {
        guard let value = timeReference else {
            return 0
        }

        return TimeInterval(value) / sampleRate
    }
}
