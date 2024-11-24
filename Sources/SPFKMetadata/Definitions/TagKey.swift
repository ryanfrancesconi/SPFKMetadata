import Foundation

public enum TagKey: String, CaseIterable, Codable {
    case album
    case bpm
    case composer
    case genre
    case copyright
    case encodingTime
    case playlistDelay
    case originalDate
    case date
    case releaseDate
    case taggingDate
    case encodedBy
    case lyricist
    case filyType

    /// The 'Content group description' frame is used if the sound belongs to
    /// a larger category of sounds/music. For example, classical music is
    /// often sorted in different musical sections (e.g. "Piano Concerto",
    /// "Weather - Hurricane").
    case work

    /// The 'Title/Songname/Content description' frame is the actual name of
    /// the piece (e.g. "Adagio", "Hurricane Donna").
    case title

    /// The 'Subtitle/Description refinement' frame is used for information
    /// directly related to the contents title (e.g. "Op. 16" or "Performed
    /// live at Wembley").
    case subtitle

    case initialKey
    case instrumentation // non standard id3
    case keywords // non standard id3
    case language
    case length
    case lyrics
    case media
    case mood
    case originalAlbum
    case originalFilename
    case originalLyricist
    case originalArtist
    case owner
    case artist

    ///  id3's spec says 'PERFORMER', but most programs use 'ALBUMARTIST'
    case albumArtist
    case conductor

    /// Could also be ARRANGER
    case remixer
    case discNumber
    case producedNotice
    case label
    case trackNumber
    case radioStation
    case radioStationOwner
    case albumSort
    case composerSort
    case artistSort
    case titleSort

    /// non-standard, used by iTunes
    case albumArtistSort
    case isrc
    case encoding
    case discSubtitle

    // URL Frames
    case copyrightURL
    case fileWebpage
    case artistWebpage
    case audioSourceWebpage
    case radioStationWebpage
    case paymentWebpage
    case publisherWebpage

    // Other
    case comment

    // Apple Itunes proprietary frames
    case podcast
    case podcastCategory
    case podcastKeywords
    case podcastDesc
    case podcastID
    case podcastURL
    case movementName
    case movementNumber
    case grouping
    case compilation

    public var taglibKey: String {
        rawValue.uppercased()
    }

    public var id3Frame: String {
        switch self {
        case .album:
            return "TALB"
        case .bpm:
            return "TBPM"
        case .composer:
            return "TCOM"
        case .genre:
            return "TCON"
        case .copyright:
            return "TCOP"
        case .encodingTime:
            return "TDEN"
        case .playlistDelay:
            return "TDLY"
        case .originalDate:
            return "TDOR"
        case .date:
            return "TDRC"
        case .releaseDate:
            return "TDRL"
        case .taggingDate:
            return "TDTG"
        case .encodedBy:
            return "TENC"
        case .lyricist:
            return "TEXT"
        case .filyType:
            return "TFLT"
        case .work:
            return "TIT1"
        case .title:
            return "TIT2"
        case .subtitle:
            return "TIT3"
        case .initialKey:
            return "TKEY"
        case .instrumentation:
            return "TXXX" // non standard
        case .keywords, .podcastKeywords: // keywords isn't an official tag
            return "TKWD"
        case .language:
            return "TLAN"
        case .length:
            return "TLEN"
        case .lyrics:
            return "USLT"
        case .media:
            return "TMED"
        case .mood:
            return "TMOO"
        case .originalAlbum:
            return "TOAL"
        case .originalFilename:
            return "TOFN"
        case .originalLyricist:
            return "TOLY"
        case .originalArtist:
            return "TOPE"
        case .owner:
            return "TOWN"
        case .artist:
            return "TPE1"
        case .albumArtist:
            return "TPE2"
        case .conductor:
            return "TPE3"
        case .remixer:
            return "TPE4"
        case .discNumber:
            return "TPOS"
        case .producedNotice:
            return "TPRO"
        case .label:
            return "TPUB"
        case .trackNumber:
            return "TRCK"
        case .radioStation:
            return "TRSN"
        case .radioStationOwner:
            return "TRSO"
        case .albumSort:
            return "TSOA"
        case .composerSort:
            return "TSOC"
        case .artistSort:
            return "TSOP"
        case .titleSort:
            return "TSOT"
        case .albumArtistSort:
            return "TSO2"
        case .isrc:
            return "TSRC"
        case .encoding:
            return "TSSE"
        case .discSubtitle:
            return "TSST"
        case .copyrightURL:
            return "WCOP"
        case .fileWebpage:
            return "WOAF"
        case .artistWebpage:
            return "WOAR"
        case .audioSourceWebpage:
            return "WOAS"
        case .radioStationWebpage:
            return "WORS"
        case .paymentWebpage:
            return "WPAY"
        case .publisherWebpage:
            return "WPUB"
        case .comment:
            return "COMM"
        case .podcast:
            return "PCST"
        case .podcastCategory:
            return "TCAT"
        case .podcastDesc:
            return "TDES"
        case .podcastID:
            return "TGID"
        case .podcastURL:
            return "WFED"
        case .movementName:
            return "MVNM"
        case .movementNumber:
            return "MVIN"
        case .grouping:
            return "GRP1"
        case .compilation:
            return "TCMP"
        }
    }

    public init?(taglibKey: String) {
        for item in Self.allCases where item.taglibKey == taglibKey {
            self = item
            return
        }

        Swift.print("🚩 Found unknown taglibKey", taglibKey)

        return nil
    }

    public init?(id3Frame: String) {
        for item in Self.allCases where item.id3Frame == id3Frame {
            self = item
            return
        }

        Swift.print("🚩 Found unknown id3Frame", id3Frame)

        return nil
    }
}
