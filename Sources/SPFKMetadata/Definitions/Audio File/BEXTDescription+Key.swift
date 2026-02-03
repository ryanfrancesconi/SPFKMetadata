// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata
// swiftformat:disable consecutiveSpaces

import Foundation
import OrderedCollections
import SPFKAudioBase

extension BEXTDescription {
    public enum Key: Sendable, CaseIterable {
        case originator
        case originatorReference
        case originationDate
        case originationTime
        case timeReferenceSamples
        case timeReference
        case umid
        case description
        case loudnessIntegrated
        case loudnessRange
        case maxTruePeakLevel
        case maxMomentaryLoudness
        case maxShortTermLoudness
        case version
        case codingHistory

        public var isEditable: Bool {
            self != .version &&
                self != .codingHistory
        }

        public var displayName: String {
            switch self {
            case .originator:               "Originator"
            case .originatorReference:      "Originator Reference"
            case .originationDate:          "Origination Date"
            case .originationTime:          "Origination Time"
            case .timeReferenceSamples:     "Time Reference Samples"
            case .timeReference:            "Time Reference"
            case .umid:                     "UMID"
            case .description:              "Description"
            case .loudnessIntegrated:       TagKey.loudnessIntegrated.displayName
            case .loudnessRange:            TagKey.loudnessRange.displayName
            case .maxTruePeakLevel:         TagKey.loudnessTruePeak.displayName
            case .maxMomentaryLoudness:     TagKey.loudnessMaxMomentary.displayName
            case .maxShortTermLoudness:     TagKey.loudnessMaxShortTerm.displayName
            case .version:                  "Version"
            case .codingHistory:            "Coding History"
            }
        }

        public var description: String {
            switch self {
            case .originator:
                "Contains the name of the originator / producer of the audio file. (maximum 32 characters)"
            case .originatorReference:
                "Contains an unambiguous reference allocated by the originating organization."
            case .originationDate:
                "10 characters containing the date of creation of the audio sequence. The format shall be « ‘,year’,-,’month,’-‘,day,’» with 4 characters for the year and 2 characters per other item. Year is defined from 0000 to 9999 Month is defined from 1 to 12 Day is defined from 1 to 28, 29, 30 or 31 The separator between the items can be anything but it is recommended that one of the following characters be used: ‘-’  hyphen  ‘_’  underscore  ‘:’  colon  ‘ ’  space  ‘.’  stop."
            case .originationTime:
                "8 ASCII characters containing the time of creation of the audio sequence. The format shall be « ‘hour’-‘minute’-‘second’» with 2 characters per item. Hour is defined from 0 to 23. Minute and second are defined from 0 to 59. The separator between the items can be anything but it is recommended that one of the following characters be used: ‘-’  hyphen  ‘_’  underscore  ‘:’  colon  ‘ ’  space  ‘.’  stop."
            case .timeReferenceSamples:
                ""
            case .timeReference:
                "These fields shall contain the time-code of the sequence. It is a 64-bit value which contains the first sample count since midnight. The number of samples per second depends on the sample frequency which is defined in the field <nSamplesPerSec> from the <format chunk>."
            case .umid:
                "Unique Material Identifier"
            case .description:
                "ASCII string (maximum 256 characters) containing a free description of the sequence. To help applications which display only a short description, it is recommended that a resume of the description is contained in the first 64 characters and the last 192 characters are used for details."
            case .loudnessIntegrated:
                TagKey.loudnessIntegrated.readableDescription ?? ""
            case .loudnessRange:
                TagKey.loudnessRange.readableDescription ?? ""
            case .maxTruePeakLevel:
                TagKey.loudnessTruePeak.readableDescription ?? ""
            case .maxMomentaryLoudness:
                TagKey.loudnessMaxMomentary.readableDescription ?? ""
            case .maxShortTermLoudness:
                TagKey.loudnessMaxShortTerm.readableDescription ?? ""
            case .version:
                "Version of the BWF"
            case .codingHistory:
                ""
            }
        }

        public init?(displayName: String) {
            for item in Self.allCases where item.displayName == displayName {
                self = item
                return
            }

            return nil
        }
    }
}

extension BEXTDescription {
    public var timeReferenceString: String? {
        guard let timeReferenceInSeconds, !timeReferenceInSeconds.isNaN else { return nil }

        return RealTimeDomain.string(seconds: timeReferenceInSeconds, showHours: .enable)
    }

    public var dictionary: OrderedDictionary<Key, String?> { [
        .originator:            originator,
        .originatorReference:   originatorReference,
        .originationDate:       originationDate,
        .originationTime:       originationTime,
        .timeReferenceSamples:  timeReference?.string,
        .timeReference:         timeReferenceString,
        .umid:                  umid,
        .description:           sequenceDescription,
        .loudnessIntegrated:    loudnessDescription.loudnessIntegrated?.string,
        .loudnessRange:         loudnessDescription.loudnessRange?.string,
        .maxTruePeakLevel:      loudnessDescription.maxTruePeakLevel?.string,
        .maxMomentaryLoudness:  loudnessDescription.maxMomentaryLoudness?.string,
        .maxShortTermLoudness:  loudnessDescription.maxShortTermLoudness?.string,
        .version:               version > 0 ? version.string : "",
        .codingHistory:         codingHistory,
    ] }

    public mutating func update(key: Key, value: Any) {
        switch key {
        case .originator:
            originator = value as? String
        case .originatorReference:
            originatorReference = value as? String
        case .originationDate:
            originationDate = value as? String
        case .originationTime:
            originationTime = value as? String
        case .timeReferenceSamples:
            timeReferenceLow = value as? UInt64
        case .timeReference:
            // GET ONLY
            break
        case .umid:
            umid = value as? String ?? ""
        case .description:
            sequenceDescription = value as? String
        case .loudnessIntegrated:
            loudnessDescription.loudnessIntegrated = value as? Float64
        case .loudnessRange:
            loudnessDescription.loudnessRange = value as? Float64
        case .maxTruePeakLevel:
            loudnessDescription.maxTruePeakLevel = value as? Float32
        case .maxMomentaryLoudness:
            loudnessDescription.maxMomentaryLoudness = value as? Float64
        case .maxShortTermLoudness:
            loudnessDescription.maxShortTermLoudness = value as? Float64
        case .version:
            version = value as? Int16 ?? 2
        case .codingHistory:
            codingHistory = value as? String
        }
    }
}

// swiftformat:enable consecutiveSpaces
