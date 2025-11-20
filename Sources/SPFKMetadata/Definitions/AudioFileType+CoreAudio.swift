// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import AudioToolbox
import AVFoundation
import SPFKBase

// MARK: - CoreAudio

extension AudioFileType {
    /// Get possible path extensions via CoreAudio for this URL
    /// - Parameter url: URL to parse
    /// - Returns: an Array of Strings containing the file extensions that are recognized for this file type or
    /// nil
    public static func getExtensions(for url: URL) throws -> [String] {
        var inSpecifier = try audioFilePropertyID(for: url)
        let inSpecifierSize = UInt32(MemoryLayout<OSType>.size)
        var ioDataSize = UInt32(MemoryLayout<CFString>.size)
        let outPropertyData = UnsafeMutablePointer<CFArray>.allocate(capacity: 1)

        let err: OSStatus = AudioFileGetGlobalInfo(
            kAudioFileGlobalInfo_ExtensionsForType,
            inSpecifierSize,
            &inSpecifier,
            &ioDataSize,
            outPropertyData
        )

        guard err == noErr else {
            throw NSError(description: "kAudioFileGlobalInfo_ExtensionsForType failed for \(url.lastPathComponent), error: \(err)")
        }

        defer { outPropertyData.deallocate() }

        // cast CFArray to NSArray
        let nsArray = outPropertyData.pointee as NSArray

        return nsArray as? [String] ?? []
    }

    /// Detect file format name via CoreAudio
    /// - Parameter url: URL to parse
    /// - Returns: The name of the file format such as "WAVE"
    public static func getFileTypeName(for url: URL) throws -> String {
        let inSpecifier = try audioFilePropertyID(for: url)

        return try getFileTypeName(propertyId: inSpecifier)
    }

    /// Detect file format name via CoreAudio
    /// - Parameter inSpecifier: Use this ID to lookup the name
    /// - Returns: The name of the file format such as "WAVE"
    public static func getFileTypeName(propertyId inSpecifier: AudioFilePropertyID) throws -> String {
        var inSpecifier = inSpecifier

        let inSpecifierSize = UInt32(MemoryLayout<AudioFilePropertyID>.size)
        var ioDataSize = UInt32(MemoryLayout<CFString>.size)
        let outPropertyData = UnsafeMutablePointer<CFString>.allocate(capacity: 1)

        guard noErr == AudioFileGetGlobalInfo(
            kAudioFileGlobalInfo_FileTypeName,
            inSpecifierSize,
            &inSpecifier,
            &ioDataSize,
            outPropertyData
        ) else {
            throw NSError(description: "kAudioFileGlobalInfo_FileTypeName failed for id \(inSpecifier)")
        }

        defer { outPropertyData.deallocate() }

        return outPropertyData.pointee as String
    }

    // MARK: - Helpers

    /// Get pointer to an `AudioFilePropertyID`
    private static func audioFilePropertyID(for url: URL) throws -> AudioFilePropertyID {
        guard let inAudioFile = openAudioFile(url: url) else {
            throw NSError(description: "Unable to open \(url.lastPathComponent)")
        }

        func closeFile() {
            AudioFileClose(inAudioFile)
        }

        var ioDataSize: UInt32 = 0
        var isWritable: UInt32 = 0

        guard noErr == AudioFileGetPropertyInfo(
            inAudioFile,
            kAudioFilePropertyFileFormat,
            &ioDataSize,
            &isWritable
        ) else {
            closeFile()
            throw NSError(description: "kAudioFilePropertyFileFormat failed to determine data size for \(url.lastPathComponent)")
        }

        let capacity = Int(ioDataSize) / MemoryLayout<AudioFilePropertyID>.size
        let format = UnsafeMutablePointer<AudioFilePropertyID>.allocate(capacity: capacity)

        defer {
            closeFile()
            format.deallocate()
        }

        guard noErr == AudioFileGetProperty(
            inAudioFile,
            kAudioFilePropertyFileFormat,
            &ioDataSize,
            format
        ) else {
            throw NSError(description: "kAudioFilePropertyFileFormat failed for \(url.lastPathComponent)")
        }

        return format.pointee
    }

    /// - Parameter url: URL to open
    /// - Returns: an AudioFileID for the open file or nil
    private static func openAudioFile(url: URL) -> AudioFileID? {
        var audioFileID: AudioFileID?

        AudioFileOpenURL(
            url as CFURL,
            .readPermission,
            0,
            &audioFileID
        )

        return audioFileID
    }
}
