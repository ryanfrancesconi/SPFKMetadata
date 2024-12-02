// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import AVFoundation
import Foundation
import SPFKMetadataC

/// Parse Chapters, works with a variety of file types.
/// AVFoundation is fine for parsing but not for writing
public enum ChapterParser {
    public static func parse(url: URL) async throws -> [SimpleChapterFrame] {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw NSError(description: "failed to open \(url.path)")
        }

        let asset = AVURLAsset(url: url)

        return try await parseChapters(asset: asset)
    }

    private static func parseChapters(asset: AVAsset) async throws -> [SimpleChapterFrame] {
        let languages = asset.availableChapterLocales.map { $0.identifier }
        let timedGroups = asset.chapterMetadataGroups(bestMatchingPreferredLanguages: languages)

        var chapters = [SimpleChapterFrame]()

        for i in 0 ..< timedGroups.count {
            let group = timedGroups[i]
            let cmStart = group.timeRange.start
            let cmEnd = group.timeRange.end

            let name = (try? await title(from: group)) ?? "Chapter \(i + 1)"

            chapters.append(
                SimpleChapterFrame(name: name, startTime: cmStart.seconds, endTime: cmEnd.seconds)
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

@available(macOS 10.11, *)
public enum ChapterWriter {
    public static func write(url: URL, to output: URL, chapters: [SimpleChapterFrame]) async throws {
        let asset = AVMutableMovie(url: url)
//
//        let languages = asset.availableChapterLocales.map { $0.identifier }
//        var timedGroups = asset.chapterMetadataGroups(bestMatchingPreferredLanguages: languages)
//
//        var newMetadata = [AVMetadataItem]()
//
//        for i in 0 ..< timedGroups.count {
//            let items = timedGroups[i].items
//
//            for var item in items where item.commonKey == .commonKeyTitle {
//                item.value = NSString("HELLLLLO")
//            }
//        }

        let item = AVMutableMetadataItem()
        item.identifier = .id3MetadataComments
        item.locale = Locale.current
        item.key = AVMetadataKey.id3MetadataKeyComments.rawValue as NSString
        item.keySpace = .id3
        item.value = NSString("RFRFRFRF")

        asset.metadata = [item]

        // assert(movie.isModified)

        if #available(macOS 15, *) {
            guard let exportSession = AVAssetExportSession(
                asset: asset,
                presetName: AVAssetExportPresetPassthrough
            ) else {
                throw NSError(description: "failed to create export session")
            }

            exportSession.metadata = [item]
            try await exportSession.export(to: output, as: .mp4)

            // try asset.writeHeader(to: output, fileType: .mp4, options: [.addMovieHeaderToDestination])
        }
    }
}
