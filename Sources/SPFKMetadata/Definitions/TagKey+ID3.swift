// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation

extension TagKey {
    /// Return the associated ID3v2 frame label or TXXX if it is non-standard
    public var id3Frame: String? {
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
        case .keywords, .podcastKeywords: // non standard
            return "TXXX"
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
        case .remixer, .arranger:
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
        default:
            return nil
        }
    }
}
