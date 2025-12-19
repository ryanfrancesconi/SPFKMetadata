// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation

public enum TagSet: String, CaseIterable, Sendable {
    case all
    case common
    case audio

    public var title: String {
        switch self {
        case .all: "All Tags"
        case .common: "Common Tags"
        case .audio: "Audio Tags"
        }
    }

    public var keys: [TagKey] {
        switch self {
        case .all:
            TagSet.allTags
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
    private static let allTags: [TagKey] = TagKey.allCases

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
