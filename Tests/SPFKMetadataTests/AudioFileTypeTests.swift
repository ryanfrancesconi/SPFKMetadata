// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKAudio

import AVFoundation
@testable import SPFKMetadata
import SPFKMetadataC
import SPFKTesting
import SPFKUtils
import Testing

@Suite(.serialized, .tags(.file))
class AudioFileTypeTests: BinTestCase {
    @Test func checkPathExtension() throws {
        var extensions = AudioFileType.allCases.map { $0.pathExtension }

        extensions += ["AIF", "bwf", "wave"]

        for aft in extensions {
            let instance = try #require(
                AudioFileType(pathExtension: aft)
            )

            #expect(instance.utType != nil)
        }
    }

    @Test func tagFileType() throws {
        for item in TagFileType.allCases {
            #expect(AudioFileType(tagType: item) != nil)
        }
    }

    @Test func checkMissingExtension() throws {
        deleteBinOnExit = false
        let url = try copyToBin(url: TestBundleResources.shared.tabla_mp4)
        let target = url.deletingPathExtension()
        try FileManager.default.moveItem(at: url, to: target)

        Log.debug(target)

        let type = AudioFileType(url: target)
        #expect(type == .m4a)
    }

    @Test func getFileTypeName() throws {
        let ids = [
            kAudioFile3GP2Type,
            kAudioFile3GPType,
            kAudioFileAAC_ADTSType,
            kAudioFileAC3Type,
            kAudioFileAIFCType,
            kAudioFileAIFFType,
            kAudioFileAMRType,
            kAudioFileBW64Type,
            kAudioFileCAFType,
            kAudioFileFLACType,
            kAudioFileM4AType,
            kAudioFileM4BType,
            kAudioFileMP1Type,
            kAudioFileMP2Type,
            kAudioFileMP3Type,
            kAudioFileMPEG4Type,
            kAudioFileNextType,
            kAudioFileRF64Type,
            kAudioFileSoundDesigner2Type,
            kAudioFileWave64Type,
            kAudioFileWAVEType,
        ]

        let names = ids.compactMap {
            try? AudioFileType.getFileTypeName(propertyId: $0)
        }

        #expect(names.count == ids.count)

        Log.debug(names)
    }

    @Test func utType() throws {
        let formats = TestBundleResources.shared.formats

        let audioFileTypes = formats.compactMap {
            AudioFileType(url: $0)
        }

        Log.debug(audioFileTypes)

        #expect(audioFileTypes.count == formats.count)

        let utTypes = audioFileTypes.compactMap { $0.utType }
        #expect(audioFileTypes.count == utTypes.count)

        Log.debug(utTypes)
    }

    @Test func videoTypes() throws {
        #expect(AudioFileType.mov.isVideo)
        #expect(AudioFileType.m4v.isVideo)
        #expect(AudioFileType.mp4.isVideo)

        #expect(!AudioFileType.wav.isVideo)
        #expect(AudioFileType.wav.isAudio)
        #expect(AudioFileType.wav.isPCM)

        // it could be but this returns false
        // #expect(AudioFileType.mp4.isPCM)
    }
}
