// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKBase

extension TagKey {
    /// Short readable description of the tag
    public var readableDescription: String? {
        switch self {
        case .album:
            "The album that this track belongs to."

        case .compilation:
            "If this track is part of a compilation. (Apple proprietary frame)"

        case .grouping:
            "The grouping tag's purpose is unspecific and can be used for various purposes. (Apple proprietary frame)"

        case .isrc:
            "The ISRC tag is specifically used to store the 12-character alphanumeric code (e.g., CC-XXX-YY-NNNNN) that identifies a recording."

        case .label:
            "The record label or publisher."

        case .movementName:
            "Classical music movements or multi-part track. (Apple proprietary frame)"

        case .movementNumber:
            "Classical music movement number, (e.g.,F 1/3) (Apple proprietary frame)"

        case .performer:
            "Same as artist."

        case .playlistDelay:
            "Used to define a specific pause or silence duration (in milliseconds) before a track begins playing in a playlist."

        case .producedNotice:
            "Intended to hold a notice regarding the production of the audio file, such as licensing, recording, or production credits, often starting with a year. (e.g., 2026 Production Company Name)"

        case .loudnessIntegrated:
            "The average loudness over the entire duration of a track."

        case .loudnessRange:
            "Measures the dynamic variation in audio. A large LRA (e.g., 10-20 LU) means significant volume shifts, common in cinematic or classical music. A small LRA (e.g., under 4 LU) indicates a very consistent, compressed level, typical of podcasts or heavily processed pop."

        case .loudnessTruePeak:
            "Measures the absolute highest peak value, not perceived loudness."

        case .loudnessMaxMomentary:
            "Represents the highest average loudness value over a 400-millisecond window."

        case .loudnessMaxShortTerm:
            "Represents the highest average loudness value over a 3-second window"

        default:
            nil
        }
    }

    /// Text description of tag suitable for display in an UI
    public var description: String {
        var value = "\(displayName) (ID3: \(id3Frame.value)"

        if let infoFrame {
            value += ", INFO: \(infoFrame.value)"
        }

        value += ")"

        if let readableDescription {
            value += "\n\(readableDescription)"
        }

        return value
    }
}
