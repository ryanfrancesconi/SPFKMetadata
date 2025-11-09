// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation

/// TagKey is a predomiantly ID3 based label system which mostly follows TagLib's conventions.
///
/// TagsProperties has a customKeys dictionary for any keys found that aren't documented here.
public enum TagKey: String, CaseIterable, Codable, Comparable {
    public static func < (lhs: TagKey, rhs: TagKey) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    case album
    case albumArtist //  id3's spec says 'PERFORMER', but most programs use 'ALBUMARTIST'
    case albumArtistSort // Apple proprietary frame
    case albumSort
    case arranger
    case artist
    case artistSort
    case artistWebpage // URL Frame
    case audioSourceWebpage // URL Frame
    case bpm
    case comment
    case compilation // Apple proprietary frame
    case composer
    case composerSort
    case conductor
    case copyright
    case copyrightURL // URL Frame
    case date // or year
    case discNumber
    case discSubtitle
    case encodedBy
    case encoding
    case encodingTime
    case fileWebpage // URL Frame
    case fileType
    case genre
    case grouping // Apple proprietary frame
    case initialKey
    case instrumentation // TXXX non standard id3
    case isrc
    case keywords // TXXX RIFF INFO non standard id3
    case label
    case language
    case length
    case lyricist
    case lyrics
    case media
    case mood
    case movementName // Apple proprietary frame
    case movementNumber // Apple proprietary frame
    case originalAlbum
    case originalArtist
    case originalDate
    case originalFilename
    case originalLyricist
    case owner
    case paymentWebpage // URL Frame
    case performer // TXXX RIFF INFO
    case playlistDelay
    case podcast // Apple proprietary frame
    case podcastCategory // Apple proprietary frame
    case podcastDescription // Apple proprietary frame
    case podcastId // Apple proprietary frame
    case podcastKeywords // TXXX Apple proprietary frame
    case podcastURL // Apple proprietary frame
    case producedNotice
    case publisherWebpage // URL Frame
    case radioStation
    case radioStationOwner
    case radioStationWebpage // URL Frame
    case releaseCountry // RIFF INFO
    case releaseDate
    case remixer // Could also be ARRANGER
    case subtitle
    case taggingDate
    case title
    case titleSort
    case trackNumber
    case work

    // BEXT: TXXX Non-Standard Loudness Tags. Defined by this package.
    case loudnessValue
    case loudnessRange
    case maxTruePeakLevel
    case maxMomentaryLoudness
    case maxShortTermLoudness
}

// MARK: - Init

extension TagKey {
    public static var commonCases: [TagKey] {
        [.title, .artist, .album, .genre, .trackNumber, .comment, .date]
    }

    /// IE, .trackNumber = Track Number
    public var displayName: String {
        rawValue.titleCased
    }

    /// TagLib uses an all caps string for its properties.
    public var taglibKey: String {
        rawValue.uppercased()
    }

    public init?(taglibKey: String) {
        for item in Self.allCases where item.taglibKey == taglibKey {
            self = item
            return
        }
        return nil
    }

    public init?(id3Frame: ID3FrameKey) {
        for item in Self.allCases where item.id3Frame == id3Frame {
            self = item
            return
        }

        return nil
    }

    public init?(infoFrame: InfoFrameKey) {
        for item in Self.allCases where item.infoFrame == infoFrame {
            self = item
            return
        }

        return nil
    }

    public init?(displayName: String) {
        for item in Self.allCases where item.displayName == displayName {
            self = item
            return
        }

        return nil
    }
}
