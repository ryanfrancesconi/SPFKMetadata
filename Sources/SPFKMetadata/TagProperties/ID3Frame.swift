// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation

public enum ID3Frame: String, CaseIterable, Codable, Comparable {
    public static func < (lhs: ID3Frame, rhs: ID3Frame) -> Bool {
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
    case copyrightUrl // URL Frame
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
    case isrc
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
    case playlistDelay
    case podcast // Apple proprietary frame
    case podcastCategory // Apple proprietary frame
    case podcastDescription // Apple proprietary frame
    case podcastId // Apple proprietary frame
    case podcastURL // Apple proprietary frame
    case producedNotice
    case publisherWebpage // URL Frame
    case radioStation
    case radioStationOwner
    case radioStationWebpage // URL Frame
    case releaseDate
    case remixer // Could also be ARRANGER
    case subtitle
    case taggingDate
    case title
    case titleSort
    case trackNumber
    case work

    // MARK: Custom Tags

    case userDefined

    /// Return the associated ID3v2 label or TXXX if it is a non-standard frame
    public var value: String {
        switch self {
        case .album: return "TALB"
        case .albumArtist: return "TPE2"
        case .albumArtistSort: return "TSO2"
        case .albumSort: return "TSOA"
        case .arranger, .remixer: return "TPE4" // TagLib uses remixer, AV uses arranger
        case .artist: return "TPE1"
        case .artistSort: return "TSOP"
        case .artistWebpage: return "WOAR"
        case .audioSourceWebpage: return "WOAS"
        case .bpm: return "TBPM"
        case .comment: return "COMM"
        case .compilation: return "TCMP"
        case .composer: return "TCOM"
        case .composerSort: return "TSOC"
        case .conductor: return "TPE3"
        case .copyright: return "TCOP"
        case .copyrightUrl: return "WCOP"
        case .date: return "TDRC"
        case .discNumber: return "TPOS"
        case .discSubtitle: return "TSST"
        case .encodedBy: return "TENC"
        case .encoding: return "TSSE"
        case .encodingTime: return "TDEN"
        case .fileWebpage: return "WOAF"
        case .fileType: return "TFLT"
        case .genre: return "TCON"
        case .grouping: return "GRP1"
        case .initialKey: return "TKEY"
        case .isrc: return "TSRC"
        case .label: return "TPUB"
        case .language: return "TLAN"
        case .length: return "TLEN"
        case .lyricist: return "TEXT"
        case .lyrics: return "USLT"
        case .media: return "TMED"
        case .mood: return "TMOO"
        case .movementName: return "MVNM"
        case .movementNumber: return "MVIN"
        case .originalAlbum: return "TOAL"
        case .originalArtist: return "TOPE"
        case .originalDate: return "TDOR"
        case .originalFilename: return "TOFN"
        case .originalLyricist: return "TOLY"
        case .owner: return "TOWN"
        case .paymentWebpage: return "WPAY"
        case .playlistDelay: return "TDLY"
        case .podcast: return "PCST"
        case .podcastCategory: return "TCAT"
        case .podcastDescription: return "TDES"
        case .podcastId: return "TGID"
        case .podcastURL: return "WFED"
        case .producedNotice: return "TPRO"
        case .publisherWebpage: return "WPUB"
        case .radioStation: return "TRSN"
        case .radioStationOwner: return "TRSO"
        case .radioStationWebpage: return "WORS"
        case .releaseDate: return "TDRL"
        case .subtitle: return "TIT3"
        case .taggingDate: return "TDTG"
        case .title: return "TIT2"
        case .titleSort: return "TSOT"
        case .trackNumber: return "TRCK"
        case .work: return "TIT1"

        case .userDefined: return "TXXX"
        }
    }
}
