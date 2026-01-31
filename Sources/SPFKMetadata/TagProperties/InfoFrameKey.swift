// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKMetadataC

// swiftformat:disable consecutiveSpaces

/// A fairly complete list of Wave INFO tags. Not all are currently written.
public enum InfoFrameKey: String, TagFrameKey, Codable, Comparable {
    public static func < (lhs: InfoFrameKey, rhs: InfoFrameKey) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    case archivalLocation
    case artist
    case baseURL
    case bpm // non standard frame
    case cinematographer
    case comment
    case commissioned
    case copyright
    case costumeDesigner
    case country
    case cropped
    case dateCreated
    case dateTimeOriginal
    case defaultAudioStream
    case dimensions
    case distributedBy
    case dotsPerInch
    case editedBy
    case eighthLanguage
    case encodedBy
    case endTimecode
    case engineer
    case fifthLanguage
    case firstLanguage
    case fourthLanguage
    case genre
    case keywords
    case language
    case language2
    case length
    case lightness
    case location
    case logoURL
    case medium
    case moreInfoBannerImage
    case moreInfoBannerURL
    case moreInfoText
    case moreInfoURL
    case musicBy
    case ninthLanguage
    case numberOfParts
    case numColors
    case organization
    case part
    case publisher // non standard
    case producedBy
    case product
    case productionDesigner
    case productionStudio
    case rate
    case rating
    case rippedBy
    case secondaryGenre
    case secondLanguage
    case seventhLanguage
    case sharpness
    case sixthLanguage
    case software
    case source
    case sourceForm
    case starring
    case starring2
    case startTimecode
    case statistics
    case subject
    case tapeName
    case technician
    case thirdLanguage
    case timeCode
    case title
    case title2
    case trackNumber1
    case trackNumber2
    case trackNumber3
    case url
    case vegasVersionMajor
    case vegasVersionMinor
    case version
    case watermarkURL
    case writtenBy
    case year

    public var value: String {
        switch self {
        case .archivalLocation:     "IARL"
        case .artist:               "IART"
        case .bpm:                  "IBPM"
        case .baseURL:              "IBSU"
        case .cinematographer:      "ICNM"
        case .comment:              "ICMT"
        case .commissioned:         "ICMS"
        case .copyright:            "ICOP"
        case .costumeDesigner:      "ICDS"
        case .country:              "ICNT"
        case .cropped:              "ICRP"
        case .dateCreated:          "ICRD"
        case .dateTimeOriginal:     "IDIT"
        case .defaultAudioStream:   "ICAS"
        case .dimensions:           "IDIM"
        case .distributedBy:        "IDST"
        case .dotsPerInch:          "IDPI"
        case .editedBy:             "IEDT"
        case .eighthLanguage:       "IAS8"
        case .encodedBy:            "IENC"
        case .endTimecode:          "TCDO"
        case .engineer:             "IENG" // TagKey.arranger
        case .fifthLanguage:        "IAS5"
        case .firstLanguage:        "IAS1"
        case .fourthLanguage:       "IAS4"
        case .genre:                "IGNR"
        case .keywords:             "IKEY"
        case .language:             "ILNG"
        case .language2:            "LANG"
        case .length:               "TLEN"
        case .lightness:            "ILGT"
        case .location:             "LOCA"
        case .logoURL:              "ILGU"
        case .medium:               "IMED"
        case .moreInfoBannerImage:  "IMBI"
        case .moreInfoBannerURL:    "IMBU"
        case .moreInfoText:         "IMIT"
        case .moreInfoURL:          "IMIU"
        case .musicBy:              "IMUS"
        case .ninthLanguage:        "IAS9"
        case .numberOfParts:        "PRT2"
        case .numColors:            "IPLT"
        case .organization:         "TORG"
        case .part:                 "PRT1"
        case .publisher:            "IPUB"
        case .producedBy:           "IPRO"
        case .product:              "IPRD" // TagKey.album
        case .productionDesigner:   "IPDS"
        case .productionStudio:     "ISTD"
        case .rate:                 "RATE"
        case .rating:               "IRTD"
        case .rippedBy:             "IRIP"
        case .secondaryGenre:       "ISGN"
        case .secondLanguage:       "IAS2"
        case .seventhLanguage:      "IAS7"
        case .sharpness:            "ISHP"
        case .sixthLanguage:        "IAS6"
        case .software:             "ISFT"
        case .source:               "ISRC"
        case .sourceForm:           "ISRF"
        case .starring:             "ISTR"
        case .starring2:            "STAR"
        case .startTimecode:        "TCOD"
        case .statistics:           "STAT" // (0: return Bad, 1: return OK)
        case .subject:              "ISBJ"
        case .tapeName:             "TAPE"
        case .technician:           "ITCH"
        case .thirdLanguage:        "IAS3"
        case .timeCode:             "ISMP"
        case .title:                "INAM"
        case .title2:               "TITL"
        case .trackNumber1:         "ITRK"
        case .trackNumber2:         "TRCK"
        case .trackNumber3:         "IPRT"
        case .url:                  "TURL"
        case .vegasVersionMajor:    "VMAJ"
        case .vegasVersionMinor:    "VMIN"
        case .version:              "TVER"
        case .watermarkURL:         "IWMU"
        case .writtenBy:            "IWRI"
        case .year:                 "YEAR"
        }
    }
}

// swiftformat:enable consecutiveSpaces
