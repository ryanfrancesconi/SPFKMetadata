// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation

public enum TagSet: CaseIterable, Hashable, Sendable {
    case common
    case music
    case loudness
    case replayGain
    case utility
    case other

    public var title: String {
        switch self {
        case .common: "Common Tags"
        case .music: "Music Tags"
        case .loudness: "Loudness"
        case .replayGain: "Replay Gain"
        case .utility: "Utility"
        case .other: "Other Tags"
        }
    }

    public var keys: [TagKey] {
        switch self {
        case .other:
            TagSet.otherTags

        case .common:
            TagSet.commonTags

        case .music:
            TagSet.musicTags

        case .loudness:
            TagSet.loudnessTags

        case .replayGain:
            TagSet.replayGainTags

        case .utility:
            TagSet.utilityTags
        }
    }

    public init?(title: String) {
        for item in Self.allCases where item.title == title {
            self = item
            return
        }

        return nil
    }
}

extension TagSet {
    private static let otherTags: [TagKey] = TagKey.allCases.filter {
        !commonTags.contains($0) &&
            !musicTags.contains($0) &&
            !loudnessTags.contains($0) &&
            !replayGainTags.contains($0) &&
            !utilityTags.contains($0)
    }

    private static let commonTags: [TagKey] = [
        .album,
        .artist,
        .comment,
        .date,
        .genre,
        .keywords,
        .mood,
        .title,
        .trackNumber,
    ]

    private static let musicTags: [TagKey] = [
        .arranger,
        .bpm,
        .composer,
        .conductor,
        .initialKey,
        .instrumentation,
        .label,
        .lyrics,
        .movementName,
        .movementNumber,
        .remixer,
        .work
    ]

    private static let loudnessTags: [TagKey] = [
        .loudnessRange,
        .loudnessIntegrated,
        .loudnessMaxMomentary,
        .loudnessMaxShortTerm,
        .loudnessTruePeak,
    ]

    private static let replayGainTags: [TagKey] = [
        .replayGainAlbumGain,
        .replayGainAlbumPeak,
        .replayGainAlbumRange,
        .replayGainReferenceLoudness,
        .replayGainTrackGain,
        .replayGainTrackPeak,
        .replayGainTrackRange,
    ]

    private static let utilityTags: [TagKey] = [
        .artistWebpage,
        .audioSourceWebpage,
        .date,
        .fileWebpage,
        .isrc,
        .paymentWebpage,
        .publisherWebpage,
        .radioStationWebpage,
        .releaseDate,
        .taggingDate,
    ]

    private static let sortTags: [TagKey] = [
        .albumArtistSort,
        .albumSort,
        .artistSort,
        .composerSort,
        .titleSort,
    ]
}
