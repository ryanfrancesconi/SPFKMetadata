// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import AVFoundation
import Foundation

/// AVFoundation is fine for parsing but not for writing
public struct TagPropertiesAV: TagPropertiesContainerModel {
    public var dictionary = TagKeyDictionary()

    public init(url: URL) async throws {
        let asset = AVURLAsset(url: url)

        let metadata = try await Self.loadID3(from: asset)

        for item in metadata {
            guard let key = item.key as? String,
                  var value = try await Self.loadValue(for: item) else { continue }

            guard let frame = TagKey(id3Frame: key) else {
                continue
            }

            value = value.removing(.controlCharacters).trimmed

            dictionary[frame] = value
        }
    }

    // remove when moving version to macOS 12+

    private static func loadID3(from asset: AVURLAsset) async throws -> [AVMetadataItem] {
        if #available(macOS 12, iOS 15, *) {
            return try await asset.loadMetadata(for: .id3Metadata)
        } else {
            return asset.metadata(forFormat: .id3Metadata)
        }
    }

    private static func loadValue(for item: AVMetadataItem) async throws -> String? {
        if #available(macOS 12, iOS 15, *) {
            return try await item.load(.value) as? String
        } else {
            return item.value as? String
        }
    }
}
