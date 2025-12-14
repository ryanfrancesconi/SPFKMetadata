// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKAudioBase
import SPFKMetadataC

/// A format agnostic audio marker to be used to store either
/// RIFF marker data or Chapter markers
public struct AudioMarkerDescription: Hashable, Sendable {
    public var name: String?
    public var startTime: TimeInterval
    public var endTime: TimeInterval?
    public var sampleRate: Double?
    public var markerID: Int?

    public init(
        name: String?,
        startTime: TimeInterval,
        endTime: TimeInterval? = nil,
        sampleRate: Double? = nil,
        markerID: Int? = nil
    ) {
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.sampleRate = sampleRate
        self.markerID = markerID
    }

    public init(riffMarker marker: AudioMarker) {
        name = marker.name
        startTime = marker.time
        endTime = marker.time
        sampleRate = marker.sampleRate
        markerID = Int(marker.markerID)
    }

    public init(chapterMarker marker: ChapterMarker) {
        name = marker.name
        startTime = marker.startTime
        endTime = marker.endTime
        sampleRate = nil
        markerID = nil
    }
}

extension AudioMarkerDescription: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case startTime
        case endTime
        case sampleRate
        case markerID
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startTime = try container.decode(TimeInterval.self, forKey: .startTime)

        name = try? container.decodeIfPresent(String.self, forKey: .name)
        endTime = try? container.decodeIfPresent(TimeInterval.self, forKey: .endTime)
        sampleRate = try? container.decodeIfPresent(Double.self, forKey: .sampleRate)
        markerID = try? container.decodeIfPresent(Int.self, forKey: .markerID)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(startTime, forKey: .startTime)

        try? container.encodeIfPresent(name, forKey: .name)
        try? container.encodeIfPresent(endTime, forKey: .endTime)
        try? container.encodeIfPresent(sampleRate, forKey: .sampleRate)
        try? container.encodeIfPresent(markerID, forKey: .markerID)
    }
}
