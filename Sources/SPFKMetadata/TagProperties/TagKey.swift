// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata
// swiftformat:disable consecutiveSpaces

import Foundation
import SPFKBase

/// TagKey is a predomiantly ID3 based label system which mostly follows TagLib's conventions.
///
/// TagsProperties has a customKeys dictionary for any keys found that aren't documented here.
public enum TagKey: String, CaseIterable, Codable, Comparable, Sendable {
    public static func < (lhs: TagKey, rhs: TagKey) -> Bool {
        lhs.rawValue.standardCompare(with: rhs.rawValue)
    }

    case album
    case albumArtist            //  id3's spec says 'PERFORMER', but most programs use 'ALBUMARTIST'
    case albumArtistSort        // Apple proprietary frame
    case albumSort
    case arranger
    case artist
    case artistSort
    case artistWebpage          // URL Frame
    case audioSourceWebpage     // URL Frame
    case bpm
    case comment
    case compilation            // Apple proprietary frame
    case composer
    case composerSort
    case conductor
    case copyright
    case copyrightURL           // URL Frame
    case date                   // or year
    case discNumber
    case discSubtitle
    case encodedBy
    case encoding
    case encodingTime
    case fileWebpage            // URL Frame
    case fileType
    case genre
    case grouping               // Apple proprietary frame
    case initialKey
    case instrumentation        // TXXX non standard id3
    case isrc
    case keywords               // TXXX RIFF INFO non standard id3
    case label
    case language
    case length
    case lyricist
    case lyrics
    case media
    case mood
    case movementName           // Apple proprietary frame
    case movementNumber         // Apple proprietary frame
    case originalAlbum
    case originalArtist
    case originalDate
    case originalFilename
    case originalLyricist
    case owner
    case paymentWebpage         // URL Frame
    case performer              // TXXX RIFF INFO
    case playlistDelay
    case podcast                // Apple proprietary frame
    case podcastCategory        // Apple proprietary frame
    case podcastDescription     // Apple proprietary frame
    case podcastId              // Apple proprietary frame
    case podcastKeywords        // TXXX Apple proprietary frame
    case podcastURL             // Apple proprietary frame
    case producedNotice
    case publisherWebpage       // URL Frame
    case radioStation
    case radioStationOwner
    case radioStationWebpage    // URL Frame
    case releaseCountry         // RIFF INFO
    case releaseDate
    case remixer                // Could also be ARRANGER
    case subtitle
    case taggingDate
    case title
    case titleSort
    case trackNumber
    case work

    // MARK: TXXX Non-Standard frames

    // BEXT: Loudness Tags. Defined by this package.

    case loudnessValue
    case loudnessRange
    case maxTruePeakLevel
    case maxMomentaryLoudness
    case maxShortTermLoudness

    // Replay Gain. Proposed ID3 addition. Some adoptance.

    case replayGainTrackGain
    case replayGainTrackPeak
    case replayGainTrackRange
    case replayGainAlbumGain
    case replayGainAlbumPeak
    case replayGainAlbumRange
    case replayGainReferenceLoudness
}

// MARK: - Init

extension TagKey {
    public var description: String {
        var value = "\(displayName) (ID3: \(id3Frame.value)"

        if let infoFrame {
            value += ", INFO: \(infoFrame.value)"
        }

        value += ")"

        return value
    }

    /// IE, .trackNumber = Track Number
    public var displayName: String {
        switch self {
        case .copyrightURL: "Copyright URL"
        case .podcastURL:   "Podcast URL"
        case .isrc:         "ISRC"
        case .bpm:          "BPM"
        default:
            // This works for any standard camelCase rawValue
            rawValue.spacedTitleCased
        }
    }

    /// TagLib uses an all caps string for its properties.
    public var taglibKey: String {
        switch self {
        case .replayGainTrackGain:          "REPLAYGAIN_TRACK_GAIN"
        case .replayGainTrackPeak:          "REPLAYGAIN_TRACK_PEAK"
        case .replayGainTrackRange:         "REPLAYGAIN_TRACK_RANGE"
        case .replayGainAlbumGain:          "REPLAYGAIN_ALBUM_GAIN"
        case .replayGainAlbumPeak:          "REPLAYGAIN_ALBUM_PEAK"
        case .replayGainAlbumRange:         "REPLAYGAIN_ALBUM_RANGE"
        case .replayGainReferenceLoudness:  "REPLAYGAIN_REFERENCE_LOUDNESS"
        default:
            // This works for most of the keys as it was planned that way
            rawValue.uppercased()
        }
    }
}

// swiftformat:enable consecutiveSpaces
