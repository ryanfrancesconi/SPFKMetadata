// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKAudio

import AVFoundation
import CoreAudio
import Foundation
import SPFKMetadataC

/// Common audio formats used by the SPFK system
public enum AudioFileType: String, Hashable, Codable, CaseIterable {
    case aac
    case aifc
    case aiff
    case au
    case caf
    case flac
    case ogg
    case m4a
    case m4v
    case mov
    case mp3
    case mp4
    case sd2
    case snd
    case ts
    case wav

    /// File types that are commonly used for metadata storage
    public var metadataTypes: [AudioFileType] {
        [.aac, .aiff, .caf, .m4a, .mp3, .mp4, .wav]
    }

    public var supportsMetadata: Bool {
        metadataTypes.contains(self)
    }

    public var description: String {
        fileTypeName ?? rawValue
    }

    public var fileTypeName: String? {
        switch self {
        case .aac: return "AAC"
        case .aiff: return "AIFF"
        case .caf: return "CAF"
        case .m4a: return "Apple MPEG-4 Audio"
        case .mp3: return "MPEG Layer 3"
        case .mp4: return "MPEG-4 Audio"
        case .mov: return "Apple MOV"
        case .wav: return "WAVE"
        default:
            return nil
        }
    }

    public var pathExtension: String { rawValue }

    public init?(pathExtension: String) {
        let rawValue = pathExtension.lowercased()

        if rawValue == "aif" {
            self = .aiff
            return

        } else if rawValue == "wave" || rawValue == "bwf" {
            self = .wav
            return
        }

        guard let value = AudioFileType(rawValue: rawValue) else {
            return nil
        }

        self = value
    }

    /// Attempt to use the path extension and fall back on opening the file if it is missing
    public init?(url: URL) {
        let ext = url.pathExtension.lowercased()

        // when the file has no extension
        guard ext != "" else {
            if let value = Self.parseFormat(fromURL: url) {
                self = value
                return
            }
            return nil
        }

        if let value = AudioFileType(pathExtension: ext) {
            self = value
            return
        }

        return nil
    }

    // MARK: - Convenience onversions mappings to CoreAudio and AVFoundation types where possible

    /// AVFoundation: File format UTIs
    public var avFileType: AVFileType? {
        switch self {
        case .aac: return .mp4
        case .aiff: return .aiff
        case .caf: return .caf
        case .m4a: return .m4a
        case .mp3: return .mp3
        case .mp4: return .mp4
        case .wav: return .wav
        case .mov: return .mov
        case .au: return .au
        default:
            return nil
        }
    }

    public var utType: UTType? {
        UTType(filenameExtension: pathExtension)
    }

    public var mimeType: String? {
        switch self {
        case .aac: return "audio/aac"
        case .aiff: return "audio/aiff"
        case .caf: return "audio/x-caf"
        case .m4a: return "audio/x-m4a"
        case .mp3: return "audio/mpeg"
        case .mp4: return "video/mp4"
        case .wav: return "audio/wav"
        case .mov: return "video/mov"
        default:
            return utType?.preferredMIMEType
        }
    }

    public var isPCM: Bool {
        audioFormatID == kAudioFormatLinearPCM
    }

    /// CoreAudio: A four char code indicating the general kind of data in the stream.
    public var audioFormatID: AudioFormatID? {
        switch self {
        case .wav, .aiff, .caf:
            return kAudioFormatLinearPCM
        case .m4a, .mp4:
            return kAudioFormatMPEG4AAC
        case .mp3:
            return kAudioFormatMPEGLayer3
        case .aac:
            return kAudioFormatMPEG4AAC
        default:
            return nil
        }
    }

    /// CoreAudio: Identifier for an audio file type.
    public var audioFileTypeID: AudioFileTypeID? {
        switch self {
        case .aac: return kAudioFileAAC_ADTSType
        case .aiff: return kAudioFileAIFFType
        case .caf: return kAudioFileCAFType
        case .m4a: return kAudioFileM4AType
        case .mp3: return kAudioFileMP3Type
        case .mp4: return kAudioFileMPEG4Type
        case .wav: return kAudioFileWAVEType
        default:
            return nil
        }
    }
}

extension AudioFileType {
    /// Open the file and determine its format via CoreAudio. Note that `TagFile.detectType()` is
    /// faster but only has the types that it supports.
    /// - Parameter url: URL to an audio file
    /// - Returns: A `MetaAudioFileFormat` or nil
    fileprivate static func parseFormat(fromURL url: URL) -> AudioFileType? {
        // tag lib is fastest to checkif it supports this type
        if let tagFormat = TagFile.detectType(url.path) {
            return AudioFileType(pathExtension: tagFormat)
        }

        guard let extensions = try? AudioFileType.getExtensions(for: url) else { return nil }

        for ext in extensions {
            for item in Self.allCases where item.rawValue == ext {
                return item
            }
        }
        return nil
    }
}
