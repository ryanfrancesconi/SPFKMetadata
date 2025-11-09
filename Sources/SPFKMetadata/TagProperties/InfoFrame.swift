// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation

public enum InfoFrame: String, CaseIterable, Codable, Comparable {
    public static func < (lhs: InfoFrame, rhs: InfoFrame) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    case archivalLocation
    case artist
    case baseURL
    case bpm
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
    case vegasVersionMir
    case version
    case watermarkURL
    case writtenBy
    case year

    public var value: String {
        switch self {
        case .archivalLocation: return "IARL"
        case .artist: return "IART"
        case .bpm: return "IBPM"
        case .baseURL: return "IBSU"
        case .cinematographer: return "ICNM"
        case .comment: return "ICMT"
        case .commissioned: return "ICMS"
        case .copyright: return "ICOP"
        case .costumeDesigner: return "ICDS"
        case .country: return "ICNT"
        case .cropped: return "ICRP"
        case .dateCreated: return "ICRD"
        case .dateTimeOriginal: return "IDIT"
        case .defaultAudioStream: return "ICAS"
        case .dimensions: return "IDIM"
        case .distributedBy: return "IDST"
        case .dotsPerInch: return "IDPI"
        case .editedBy: return "IEDT"
        case .eighthLanguage: return "IAS8"
        case .encodedBy: return "IENC"
        case .endTimecode: return "TCDO"
        case .engineer: return "IENG" // TagKey.arranger
        case .fifthLanguage: return "IAS5"
        case .firstLanguage: return "IAS1"
        case .fourthLanguage: return "IAS4"
        case .genre: return "IGNR"
        case .keywords: return "IKEY"
        case .language: return "ILNG"
        case .language2: return "LANG"
        case .length: return "TLEN"
        case .lightness: return "ILGT"
        case .location: return "LOCA"
        case .logoURL: return "ILGU"
        case .medium: return "IMED"
        case .moreInfoBannerImage: return "IMBI"
        case .moreInfoBannerURL: return "IMBU"
        case .moreInfoText: return "IMIT"
        case .moreInfoURL: return "IMIU"
        case .musicBy: return "IMUS"
        case .ninthLanguage: return "IAS9"
        case .numberOfParts: return "PRT2"
        case .numColors: return "IPLT"
        case .organization: return "TORG"
        case .part: return "PRT1"
        case .publisher: return "IPUB"
        case .producedBy: return "IPRO"
        case .product: return "IPRD" // TagKey.album
        case .productionDesigner: return "IPDS"
        case .productionStudio: return "ISTD"
        case .rate: return "RATE"
        case .rating: return "IRTD"
        case .rippedBy: return "IRIP"
        case .secondaryGenre: return "ISGN"
        case .secondLanguage: return "IAS2"
        case .seventhLanguage: return "IAS7"
        case .sharpness: return "ISHP"
        case .sixthLanguage: return "IAS6"
        case .software: return "ISFT"
        case .source: return "ISRC"
        case .sourceForm: return "ISRF"
        case .starring: return "ISTR"
        case .starring2: return "STAR"
        case .startTimecode: return "TCOD"
        case .statistics: return "STAT" // (0: return Bad, 1: return OK)
        case .subject: return "ISBJ"
        case .tapeName: return "TAPE"
        case .technician: return "ITCH"
        case .thirdLanguage: return "IAS3"
        case .timeCode: return "ISMP"
        case .title: return "INAM"
        case .title2: return "TITL"
        case .trackNumber1: return "ITRK"
        case .trackNumber2: return "TRCK"
        case .trackNumber3: return "IPRT"
        case .url: return "TURL"
        case .vegasVersionMajor: return "VMAJ"
        case .vegasVersionMir: return "VMIN"
        case .version: return "TVER"
        case .watermarkURL: return "IWMU"
        case .writtenBy: return "IWRI"
        case .year: return "YEAR"
        }
    }
}
