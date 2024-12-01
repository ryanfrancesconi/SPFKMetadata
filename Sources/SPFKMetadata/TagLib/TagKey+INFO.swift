// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation

extension TagKey {
    /// Wave INFO chunk frame if it exists
    public var infoFrame: String? {
        switch self {
        case .album:
            return "IPRD"
        case .arranger:
            return "IENG"
        case .artist:
            return "IART"
        case .artistWebpage:
            return "IBSU"
        case .bpm:
            return "IBPM"
        case .comment:
            return "ICMT"
        case .composer:
            return "IMUS"
        case .copyright:
            return "ICOP"
        case .date:
            return "ICRD"
        case .discSubtitle:
            return "PRT1"
        case .encodedBy:
            return "ITCH"
        case .encoding:
            return "ISFT"
        case .encodingTime:
            return "IDIT"
        case .genre:
            return "IGNR"
        case .isrc:
            return "ISRC"
        case .label:
            return "IPUB"
        case .language:
            return "ILNG"
        case .lyricist:
            return "IWRI"
        case .media:
            return "IMED"
        case .performer:
            return "ISTR"
        case .releaseCountry:
            return "ICNT"
        case .remixer:
            return "IEDT"
        case .title:
            return "INAM"
        case .trackNumber:
            return "IPRT"

        default:
            return nil
        }
    }
}
