// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation

// swiftformat:disable consecutiveSpaces

extension TagKey {
    /// Wave INFO frames as mapped to TagKey.
    ///
    /// Partial mapping of most common tags.
    public var infoFrame: InfoFrameKey? {
        switch self {
        case .album:            .product
        case .arranger:         .engineer
        case .artist:           .artist
        case .artistWebpage:    .baseURL
        case .bpm:              .bpm
        case .comment:          .comment
        case .composer:         .musicBy
        case .copyright:        .copyright
        case .date:             .dateCreated
        case .discSubtitle:     .part
        case .encodedBy:        .technician
        case .encoding:         .software
        case .encodingTime:     .dateTimeOriginal
        case .genre:            .genre
        case .isrc:             .source
        case .keywords:         .keywords
        case .label:            .publisher
        case .language:         .language
        case .length:           .length
        case .lyricist:         .writtenBy
        case .media:            .medium
        case .performer:        .starring
        case .releaseCountry:   .country
        case .remixer:          .editedBy
        case .startTimecode:    .startTimecode
        case .endTimecode:      .endTimecode
        case .title:            .title
        case .trackNumber:      .trackNumber1
        default:
            nil
        }
    }
}

// swiftformat:enable consecutiveSpaces
