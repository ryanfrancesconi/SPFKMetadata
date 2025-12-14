// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKAudioBase
import SPFKMetadataC

/// A format agnostic audio marker to be used to store either
/// RIFF marker data or Chapter markers
public struct AudioMarkerDescription: Codable, Hashable, Sendable {
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
