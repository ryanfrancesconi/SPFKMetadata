// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation

public enum TagSet: CaseIterable, Hashable, Sendable {
    case common
    case audio
    case other

    public var title: String {
        switch self {
        case .common: "Common Tags"
        case .audio: "Audio Tags"
        case .other: "Other Tags"
        }
    }

    public var keys: [TagKey] {
        switch self {
        case .other:
            TagSet.otherTags

        case .common:
            TagSet.commonTags

        case .audio:
            TagSet.audioTags
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
            !audioTags.contains($0)
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

    private static let audioTags: [TagKey] = [
        .bpm,
        .initialKey,
        .instrumentation,
        .length,
        .loudnessRange,
        .loudnessValue,
        .maxMomentaryLoudness,
        .maxShortTermLoudness,
        .maxTruePeakLevel,
        .replayGainAlbumGain,
        .replayGainAlbumPeak,
        .replayGainAlbumRange,
        .replayGainReferenceLoudness,
        .replayGainTrackGain,
        .replayGainTrackPeak,
        .replayGainTrackRange,
    ]
}
