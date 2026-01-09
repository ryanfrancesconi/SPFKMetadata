// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKAudioBase
import SPFKBase
import SPFKMetadataC

public struct AudioMarkerDescriptionCollection: Hashable, Sendable {
    public var markerDescriptions: [AudioMarkerDescription] = []

    public var description: String {
        var out = ""

        for markerDescription in markerDescriptions {
            out += "\(markerDescription)\n"
        }

        return out
    }

    /// ChapterParser: m4a, mp4, flac, ogg
    /// MPEGChapterUtil: mp3
    /// AudioMarkerUtil: aif, wav
    public init(url: URL, fileType: AudioFileType? = nil) async throws {
        guard let fileType = fileType ?? AudioFileType(url: url) else {
            throw NSError(
                file: #file, function: #function,
                description: "Unable to determine file type from \(url.lastPathComponent)"
            )
        }

        switch fileType {
        case .m4a, .mp4, .ogg, .opus, .flac:
            try await parseChapters(url: url)

        case .aiff, .aifc, .wav, .w64:
            try await parseRIFF(url: url)

        case .mp3:
            try await parseMP3(url: url)

        default:
            throw NSError(
                file: #file, function: #function, description: "Unsupported file type: \(url.lastPathComponent)"
            )
        }
    }

    public init(markerDescriptions: [AudioMarkerDescription] = []) {
        update(markerDescriptions: markerDescriptions)
    }

    private mutating func parseChapters(url: URL) async throws {
        let value: [ChapterMarker] = try await ChapterParser.parse(url: url)

        update(markerDescriptions: value.map {
            AudioMarkerDescription(chapterMarker: $0)
        })
    }

    private mutating func parseMP3(url: URL) async throws {
        let value: [ChapterMarker] = MPEGChapterUtil.getChapters(url.path) as? [ChapterMarker] ?? []

        update(markerDescriptions: value.map {
            AudioMarkerDescription(chapterMarker: $0)
        })
    }

    private mutating func parseRIFF(url: URL) async throws {
        let value: [AudioMarker] = AudioMarkerUtil.getMarkers(url) as? [AudioMarker] ?? []

        update(markerDescriptions: value.map {
            AudioMarkerDescription(riffMarker: $0)
        })
    }
}

extension AudioMarkerDescriptionCollection {
    public mutating func append(marker markerDescription: AudioMarkerDescription) {
        markerDescriptions.append(markerDescription)
        sort()
    }

    public mutating func remove(marker markerDescription: AudioMarkerDescription) throws {
        guard let markerID = markerDescription.markerID else {
            throw NSError(description: "markerID is nil")
        }

        for i in 0 ..< markerDescriptions.count where markerDescriptions[i].markerID == markerID {
            markerDescriptions.remove(at: i)
            sort()
            return
        }

        throw NSError(description: "Failed to find markerID \(markerID)")
    }

    public mutating func update(markerDescriptions: [AudioMarkerDescription]) {
        self.markerDescriptions = markerDescriptions
        sort()
    }

    public mutating func replace(markerDescription: AudioMarkerDescription) throws {
        guard let markerID = markerDescription.markerID else {
            throw NSError(description: "markerID is nil")
        }

        for i in 0 ..< markerDescriptions.count where markerDescriptions[i].markerID == markerID {
            markerDescriptions[i] = markerDescription
            sort()
            return
        }

        throw NSError(description: "Failed to find markerID \(markerID), all ids are \(markerDescriptions.compactMap(\.markerID))")
    }

    public mutating func sort() {
        markerDescriptions = markerDescriptions.sorted()

        for i in 0 ..< markerDescriptions.count {
            markerDescriptions[i].markerID = i
        }
    }
}

extension AudioMarkerDescriptionCollection: Codable {
    enum CodingKeys: String, CodingKey {
        case markerDescriptions
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        markerDescriptions = try container.decode([AudioMarkerDescription].self, forKey: .markerDescriptions)
        sort()
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(markerDescriptions, forKey: .markerDescriptions)
    }
}
