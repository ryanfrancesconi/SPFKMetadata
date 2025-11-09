// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation

// swiftformat:disable consecutiveSpaces

extension TagKey {
    /// Wave INFO frames as mapped by TagLib.
    /// TagLib defines this mapping in its infotag.cpp and
    /// these are the primary INFO tags it will write.
    public var infoFrame: InfoFrameKey? {
        switch self {
        case .album:            return .product
        case .arranger:         return .engineer
        case .artist:           return .artist
        case .artistWebpage:    return .baseURL
        case .bpm:              return .bpm
        case .comment:          return .comment
        case .composer:         return .musicBy
        case .copyright:        return .copyright
        case .date:             return .dateCreated
        case .discSubtitle:     return .part
        case .encodedBy:        return .technician
        case .encoding:         return .software
        case .encodingTime:     return .dateTimeOriginal
        case .genre:            return .genre
        case .isrc:             return .source
        case .label:            return .publisher
        case .language:         return .language
        case .lyricist:         return .writtenBy
        case .media:            return .medium
        case .performer:        return .starring
        case .releaseCountry:   return .country
        case .remixer:          return .editedBy
        case .title:            return .title
        case .trackNumber:      return .trackNumber3

        default:
            return nil
        }
    }
}

// swiftformat:enable consecutiveSpaces
