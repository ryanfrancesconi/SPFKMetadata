// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import AVFoundation
import CoreAudio
import Foundation
import SPFKMetadataC

// swiftformat:disable consecutiveSpaces

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
    case m4b
    case m4v
    case mov
    case mp3
    case mp4
    case opus
    case sd2
    case snd
    case ts
    case wav
    case w64

    /// File types that are commonly used for metadata storage
    public var metadataTypes: [AudioFileType] { [
        .aac,
        .aiff,
        .m4a,
        .m4b,
        .mp3,
        .mp4,
        .wav,
        .flac,
        .ogg,
        .opus,
    ] }

    public var tagType: TagFileTypeDef? {
        switch self {
        case .aac:
            return .aac
        case .aifc, .aiff:
            return .aiff
        case .flac:
            return .flac
        case .ogg:
            return .vorbis
        case .m4a:
            return .m4a
        case .mp3:
            return .mp3
        case .mp4:
            return .mp4
        case .opus:
            return .opus
        case .wav, .w64:
            return .wave

        default:
            return nil
        }
    }

    public var supportsMetadata: Bool {
        metadataTypes.contains(self)
    }

    public var stringValue: String {
        fileTypeName ?? rawValue
    }

    /// See getFileTypeName() for lookup version
    public var fileTypeName: String? {
        switch self {
        case .aac:  return "AAC"
        case .aiff: return "AIFF"
        case .caf:  return "CAF"
        case .flac: return "FLAC"
        case .m4a:  return "Apple MPEG-4 Audio"
        case .m4b:  return "Apple MPEG-4 AudioBooks"
        case .mp3:  return "MPEG Layer 3"
        case .mp4:  return "MPEG-4"
        case .m4v:  return "Apple MPEG-4 Video"
        case .mov:  return "Apple QuickTime"
        case .ogg:  return "Ogg Vorbis"
        case .opus: return "Ogg Opus"
        case .wav:  return "Waveform Audio"
        case .w64:  return "Wave (BW64 for length over 4 GB)"
        default:
            return nil
        }
    }

    public var pathExtension: String { rawValue }

    /// Create an `AudioFileType` from a URL pathExtension
    /// - Parameter pathExtension: pathExtension to parse.
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
            if let value = AudioFileType(parsing: url) {
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

    /// Open the file and determine its format via CoreAudio. Note that `TagFile.detectType()` is
    /// faster but only has the types that it supports.
    ///
    /// - Parameter url: URL to an audio file
    /// - Returns: A `MetaAudioFileFormat` or nil
    fileprivate init?(parsing url: URL) {
        // tag lib is faster than CoreAudio so run it first for primary types
        if let tagType = TagFileType.detect(url.path),
           let value = AudioFileType(tagType: tagType) {
            self = value
            return
        }

        // get possible extensions for this URL
        guard let extensions = try? AudioFileType.getExtensions(for: url) else { return nil }

        for ext in extensions {
            for item in Self.allCases where item.pathExtension == ext {
                self = item
                return
            }
        }

        return nil
    }

    public init?(tagType: TagFileTypeDef) {
        for item in Self.allCases where item.tagType == tagType {
            self = item
            return
        }

        return nil
    }

    // MARK: - Convenience mappings to CoreAudio and AVFoundation types when possible

    /// AVFoundation: File format UTIs
    public var avFileType: AVFileType? {
        switch self {
        case .aac:  return .mp4
        case .aiff: return .aiff
        case .aifc: return .aifc
        case .au:   return .au
        case .caf:  return .caf
        case .m4a:  return .m4a
        case .mov:  return .mov
        case .mp3:  return .mp3
        case .mp4:  return .mp4
        case .wav:  return .wav

        default:
            return nil
        }
    }

    public var utType: UTType? {
        UTType(filenameExtension: pathExtension)
    }

    public var isVideo: Bool {
        guard let utType else { return false }
        return utType.conforms(to: .video) || utType.conforms(to: .movie)
    }

    public var isAudio: Bool {
        guard let utType else { return false }

        return utType.conforms(to: .audio)
    }

    public var isPCM: Bool {
        audioFormatID == kAudioFormatLinearPCM
    }

    public var mimeType: String? {
        switch self {
        case .aac:  return "audio/aac"
        case .aiff: return "audio/aiff"
        case .caf:  return "audio/x-caf"
        case .m4a:  return "audio/x-m4a"
        case .mov:  return "video/mov"
        case .mp3:  return "audio/mpeg"
        case .mp4:  return "video/mp4"
        case .wav:  return "audio/wav"

        default:
            return utType?.preferredMIMEType
        }
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

    /// CoreAudio: Hardcoded CoreAudio identifier for an AudioFileType.
    public var audioFileTypeID: AudioFileTypeID? {
        switch self {
        case .aac:  return kAudioFileAAC_ADTSType
        case .aifc: return kAudioFileAIFCType
        case .aiff: return kAudioFileAIFFType
        case .caf:  return kAudioFileCAFType
        case .flac: return kAudioFileFLACType
        case .m4a:  return kAudioFileM4AType
        case .mp3:  return kAudioFileMP3Type
        case .mp4:  return kAudioFileMPEG4Type
        case .sd2:  return kAudioFileSoundDesigner2Type
        case .w64:  return kAudioFileWave64Type
        case .wav:  return kAudioFileWAVEType
        default:
            return nil
        }
    }
}

// swiftformat:enable consecutiveSpaces

extension TagFileType {
    public static var allCases: [TagFileTypeDef] { [
        .aac,
        .aiff,
        .flac,
        .m4a,
        .mp3,
        .mp4,
        .opus,
        .vorbis,
        .wave,
    ] }
}
