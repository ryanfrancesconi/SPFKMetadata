// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import AVFoundation
import Foundation
import SPFKMetadataC

/// Parse Chapters, works with a variety of file types.
/// AVFoundation is fine for parsing but not for writing
public enum ChapterParser {
    public static func parse(url: URL) async throws -> [ChapterMarker] {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw NSError(description: "failed to open \(url.path)")
        }

        let asset = AVURLAsset(url: url)

        return try await parseChapters(asset: asset)
    }

    private static func parseChapters(asset: AVAsset) async throws -> [ChapterMarker] {
        let languages = asset.availableChapterLocales.map { $0.identifier }
        let timedGroups = asset.chapterMetadataGroups(bestMatchingPreferredLanguages: languages)

        var chapters = [ChapterMarker]()

        for i in 0 ..< timedGroups.count {
            let group = timedGroups[i]
            let cmStart = group.timeRange.start
            let cmEnd = group.timeRange.end

            let name = (try? await title(from: group)) ?? "Chapter \(i + 1)"

            chapters.append(
                ChapterMarker(name: name, startTime: cmStart.seconds, endTime: cmEnd.seconds)
            )
        }

        return chapters
    }

    private static func title(from group: AVTimedMetadataGroup) async throws -> String? {
        for item in group.items where item.commonKey == .commonKeyTitle {
            if #available(macOS 12, iOS 15, *) {
                return try await item.load(.stringValue)

            } else {
                return item.stringValue
            }
        }

        return nil
    }
}
