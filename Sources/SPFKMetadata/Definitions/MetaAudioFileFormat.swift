// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import AVFoundation
import SPFKMetadataC

/// A utility wrapper around file types that are commonly used for metadata storage.
/// CAF is included here but isn't compatible for all types of metadata
public enum MetaAudioFileFormat: String, CaseIterable {
    case wav
    case aiff
    case caf
    case m4a
    case mp3
    case mp4
    case mov
    case aac
}

extension MetaAudioFileFormat {
    public var description: String {
        Self.globalInfoFileTypeName(for: self)
    }

    public static func globalInfoFileTypeName(for format: MetaAudioFileFormat) -> String {
        switch format {
        case .wav: return "WAVE"
        case .aiff: return "AIFF"
        case .caf: return "CAF"
        case .m4a: return "Apple MPEG-4 Audio"
        case .mp3: return "MPEG Layer 3"
        case .mp4: return "MPEG-4 Audio"
        case .aac: return "AAC"
        case .mov: return "MOV"
        }
    }

    /// fromFileTypeName are the names defined by Apple in `kAudioFileGlobalInfo_FileTypeName`
    public static func format(fromGlobalInfoFileTypeName name: String) -> MetaAudioFileFormat? {
        switch name {
        case "WAVE": return .wav
        case "AIFF": return .aiff
        case "CAF": return .caf
        case "Apple MPEG-4 Audio": return .m4a
        case "MPEG Layer 3": return .mp3
        case "MPEG-4 Audio": return .mp4
        default: return nil
        }
    }

    /// Parse the MetaAudioFileFormat from the URL favoring the pathExtension if available
    /// - Parameters:
    ///   - url: URL to parse
    ///   - parseIfNoExtension: flag to allow deeper parsing. `true` by default.
    /// - Returns: a MetaAudioFileFormat or nil
    public static func format(fromURL url: URL, parseIfNoExtension: Bool = true) -> MetaAudioFileFormat? {
        let ext = url.pathExtension.lowercased()

        for item in MetaAudioFileFormat.allCases {
            if ext == item.rawValue { return item }
        }

        guard parseIfNoExtension else { return nil }

        // if the extension is missing, open the file
        return parseFormat(fromURL: url)
    }

    /// Open the file and determine its format via CoreAudio. Note that `TagFile.detectType()` is
    /// faster but only has the types that it supports.
    /// - Parameter url: URL to an audio file
    /// - Returns: A `MetaAudioFileFormat` or nil
    private static func parseFormat(fromURL url: URL) -> MetaAudioFileFormat? {
        guard let extensions = try? getExtensions(for: url) else { return nil }

        for ext in extensions {
            for item in Self.allCases where item.rawValue == ext {
                return item
            }
        }
        return nil
    }
}

extension MetaAudioFileFormat {
    /// Attempt to use the path extension and fall back on opening the file if it is missing
    public static func detectFileType(url: URL) -> MetaAudioFileFormat? {
        // Taglib is faster, so try that first
        guard let tagFormat = TagFile.detectType(url.path) else {
            // if it's an unsupported format, we'll try this
            return MetaAudioFileFormat.format(fromURL: url)
        }

        switch tagFormat {
        case kTagFileTypeWAVE:
            return .wav
        case kTagFileTypeAIFF:
            return .aiff
        case kTagFileTypeMP3:
            return .mp3
        case kTagFileTypeM4A:
            return .m4a

        case MetaAudioFileFormat.caf.rawValue:
            return .caf
        case MetaAudioFileFormat.aac.rawValue:
            return .aac
        case MetaAudioFileFormat.mp4.rawValue:
            return .mp4
        case MetaAudioFileFormat.mov.rawValue:
            return .mov
        default:
            return nil
        }
    }
}
