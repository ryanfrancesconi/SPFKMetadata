// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import AVFoundation
import Foundation

/// AVFoundation is fine for parsing tags but they didn't implement usable ways to write them. (As of yet)
/// If all you need is reading tags, then this is an example without any further dependencies.
/// That said, the tradeoff of using AVFoundation is that it's less performant than TagLib.
/// Since AV is async, that would likely account for some of the performance hit.
///
/// You can measure yourself in the tests: parseID3MP3 vs parseID3MP3_AV
public struct TagPropertiesAV: TagPropertiesContainerModel {
    public var tags = TagKeyDictionary()
    public var customTags = [String: String]()

    public init(url: URL) async throws {
        let asset = AVURLAsset(url: url)

        let metadata = try await Self.loadMetadata(from: asset)

        for item in metadata {
            guard let id3Frame = item.key as? String,
                  let value = try? await Self.loadValue(for: item) else { continue }

            set(id3Frame: id3Frame, value: value)
        }
    }

    private static func loadMetadata(from asset: AVURLAsset) async throws -> [AVMetadataItem] {
        try await asset.loadMetadata(for: .id3Metadata)
    }

    private static func loadValue(for item: AVMetadataItem) async throws -> String? {
        try await item.load(.value) as? String
    }
}
