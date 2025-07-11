// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKAudio

import AVFoundation
@testable import SPFKMetadata
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

    @Test func checkMissingExtension() throws {
        deleteBinOnExit = false
        let url = try copyToBin(url: BundleResources.shared.tabla_mp4)
        let target = url.deletingPathExtension()
        try FileManager.default.moveItem(at: url, to: target)

        Log.debug(target)

        let type = AudioFileType(url: target)
        #expect(type == .m4a)
    }
}
