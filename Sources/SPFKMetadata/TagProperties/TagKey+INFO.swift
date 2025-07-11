// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation

extension TagKey {
    /// Wave INFO frames. TagLib defines this mapping in its infotag.cpp and these are the INFO tags it will write.
    public var infoFrame: String? {
        switch self {
        case .album: return "IPRD"
        case .arranger: return "IENG" // TagLib is calling this Engineer which isn't correct
        case .artist: return "IART"
        case .artistWebpage: return "IBSU"
        case .bpm: return "IBPM"
        case .comment: return "ICMT"
        case .composer: return "IMUS"
        case .copyright: return "ICOP"
        case .date: return "ICRD"
        case .discSubtitle: return "PRT1"
        case .encodedBy: return "ITCH"
        case .encoding: return "ISFT"
        case .encodingTime: return "IDIT"
        case .genre: return "IGNR"
        case .isrc: return "ISRC"
        case .label: return "IPUB"
        case .language: return "ILNG"
        case .lyricist: return "IWRI"
        case .media: return "IMED"
        case .performer: return "ISTR"
        case .releaseCountry: return "ICNT"
        case .remixer: return "IEDT"
        case .title: return "INAM"
        case .trackNumber: return "IPRT"

        default: return nil
        }
    }
}

/**
For reference all possible INFO tags are:

 'IARL'    ArchivalLocation
 'IART'    Artist
 'IAS1'    FirstLanguage
 'IAS2'    SecondLanguage
 'IAS3'    ThirdLanguage
 'IAS4'    FourthLanguage
 'IAS5'    FifthLanguage
 'IAS6'    SixthLanguage
 'IAS7'    SeventhLanguage
 'IAS8'    EighthLanguage
 'IAS9'    NinthLanguage
 'IBSU'    BaseURL
 'ICAS'    DefaultAudioStream
 'ICDS'    CostumeDesigner
 'ICMS'    Commissioned
 'ICMT'    Comment
 'ICNM'    Cinematographer
 'ICNT'    Country
 'ICOP'    Copyright
 'ICRD'    DateCreated
 'ICRP'    Cropped
 'IDIM'    Dimensions
 'IDIT'    DateTimeOriginal
 'IDPI'    DotsPerInch
 'IDST'    DistributedBy
 'IEDT'    EditedBy
 'IENC'    EncodedBy
 'IENG'    Engineer
 'IGNR'    Genre
 'IKEY'    Keywords
 'ILGT'    Lightness
 'ILGU'    LogoURL
 'ILIU'    LogoIconURL
 'ILNG'    Language
 'IMBI'    MoreInfoBannerImage
 'IMBU'    MoreInfoBannerURL
 'IMED'    Medium
 'IMIT'    MoreInfoText
 'IMIU'    MoreInfoURL
 'IMUS'    MusicBy
 'INAM'    Title
 'IPDS'    ProductionDesigner
 'IPLT'    NumColors
 'IPRD'    Product
 'IPRO'    ProducedBy
 'IRIP'    RippedBy
 'IRTD'    Rating
 'ISBJ'    Subject
 'ISFT'    Software
 'ISGN'    SecondaryGenre
 'ISHP'    Sharpness
 'ISMP'    TimeCode
 'ISRC'    Source
 'ISRF'    SourceForm
 'ISTD'    ProductionStudio
 'ISTR'    Starring
 'ITCH'    Technician
 'ITRK'    TrackNumber
 'IWMU'    WatermarkURL
 'IWRI'    WrittenBy
 'LANG'    Language
 'LOCA'    Location
 'PRT1'    Part
 'PRT2'    NumberOfParts
 'RATE'    Rate
 'STAR'    Starring
 'STAT'    Statistics (0 = Bad, 1 = OK)
 'TAPE'    TapeName
 'TCDO'    EndTimecode
 'TCOD'    StartTimecode
 'TITL'    Title
 'TLEN'    Length
 'TORG'    Organization
 'TRCK'    TrackNumber
 'TURL'    URL
 'TVER'    Version
 'VMAJ'    VegasVersionMajor
 'VMIN'    VegasVersionMir
 'YEAR'    Year
 */
