// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation

/// This doesn't take custom frames into account but does handle most common non-standard
/// ones. TagLib uses an all caps dictionary key system.
/// TagsProperties has a customKeys dictionary for any keys found that aren't documented here.
public enum TagKey: String, CaseIterable, Codable, Comparable {
    public static func < (lhs: TagKey, rhs: TagKey) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case album
    case albumArtist //  id3's spec says 'PERFORMER', but most programs use 'ALBUMARTIST'
    case albumArtistSort // non-standard, used by iTunes
    case albumSort
    case arranger
    case artist
    case artistSort
    case artistWebpage // URL Frame
    case audioSourceWebpage // URL Frame
    case bpm
    case comment
    case compilation // Apple Itunes proprietary frame
    case composer
    case composerSort
    case conductor
    case copyright
    case copyrightURL // URL Frame
    case date
    case discNumber
    case discSubtitle
    case encodedBy
    case encoding
    case encodingTime
    case fileWebpage // URL Frame
    case fileType
    case genre
    case grouping // Apple Itunes proprietary frame
    case initialKey
    case instrumentation // non standard id3
    case isrc
    case keywords // non standard id3
    case label
    case language
    case length
    case lyricist
    case lyrics
    case media
    case mood
    case movementName // Apple Itunes proprietary frame
    case movementNumber // Apple Itunes proprietary frame
    case originalAlbum
    case originalArtist
    case originalDate
    case originalFilename
    case originalLyricist
    case owner
    case paymentWebpage // URL Frame
    case performer // wave INFO
    case playlistDelay
    case podcast // Apple Itunes proprietary frame
    case podcastCategory // Apple Itunes proprietary frame
    case podcastDesc // Apple Itunes proprietary frame
    case podcastID // Apple Itunes proprietary frame
    case podcastKeywords // Apple Itunes proprietary frame
    case podcastURL // Apple Itunes proprietary frame
    case producedNotice
    case publisherWebpage // URL Frame
    case radioStation
    case radioStationOwner
    case radioStationWebpage // URL Frame
    case releaseCountry // Wave INFO
    case releaseDate
    case remixer // Could also be ARRANGER
    case subtitle
    case taggingDate
    case title
    case titleSort
    case trackNumber
    case work
}

// MARK: - Init

extension TagKey {
    /// TagLib uses an all caps readable string for its keys.
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

    public init?(id3Frame: String) {
        for item in Self.allCases where item.id3Frame == id3Frame {
            self = item
            return
        }

        return nil
    }

    public init?(infoFrame: String) {
        for item in Self.allCases where item.infoFrame == infoFrame {
            self = item
            return
        }

        return nil
    }
}
