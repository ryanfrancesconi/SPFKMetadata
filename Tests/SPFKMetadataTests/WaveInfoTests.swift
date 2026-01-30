// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKBase
@testable import SPFKMetadata
@testable import SPFKMetadataC
import SPFKTesting
import Testing

@Suite(.serialized)
class WaveInfoTests: BinTestCase {
    @Test func parseInfo() async throws {
        let url = TestBundleResources.shared.wav_bext_v2
        let file = try #require(WaveFileC(path: url.path))
        #expect(file.load())

        let dictionary = try #require(file.infoDictionary)
        Log.debug(dictionary)

        #expect(file[.product] == "This Is Spinal Tap")
        #expect(file[.artist] == "Spinal Tap")
        #expect(file[.comment] == "And oh how they danced. The little children of Stonehenge.Beneath the haunted moon.For fear that daybreak might come too soon.")
        #expect(file[.editedBy] == "SPFKMetadata")
        #expect(file[.title] == "Stonehenge")
        #expect(file[.bpm] == "666")
    }

    @Test func writeCustom() async throws {
        deleteBinOnExit = false
        let tmpfile = try copyToBin(url: TestBundleResources.shared.wav_bext_v2)

        let file = try #require(WaveFileC(path: tmpfile.path))
        #expect(file.load())
        file[.bpm] = "667"
        file.save()

        let newFile = try #require(WaveFileC(path: tmpfile.path))
        #expect(newFile.load())

        let newDict = try #require(newFile.infoDictionary)
        Log.debug(newDict)

        #expect(newFile[.bpm] == "667")
    }

    @Test func chunks() async throws {
        deleteBinOnExit = false

        let url = try copyToBin(url: TestBundleResources.shared.ixml_chunk)
        let file = try #require(WaveFileC(path: url.path))

        func dump() {
            #expect(file.load())
            Log.debug("ixmlString:", file.ixmlString)
            Log.debug("info:", file.infoDictionary)
            Log.debug("id3:", file.id3Dictionary)
            Log.debug("bext:", file.bextDescription?.sequenceDescription)
            Log.debug("markers:", file.markers.count, "marker(s)")
        }

        dump()

        file.infoDictionary?.setValue("an info title", forKey: InfoFrameKey.title.value)
        file.id3Dictionary?.setValue("an id3 title", forKey: TagKey.title.taglibKey)
        file.ixmlString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><BWFXML><IXML_VERSION>1.4</IXML_VERSION><PROJECT>a new project</PROJECT></BWFXML>"
        file.bextDescription?.sequenceDescription = "a new bext description"
        file.markers.append(
            AudioMarker(name: "new marker", time: 0, sampleRate: 44100, markerID: 0)
        )

        if let picture = TagPictureRef(url: TestBundleResources.shared.sharksandwich, pictureDescription: "new picture", pictureType: "jpeg") {
            file.tagPicture = TagPicture(picture: picture)
        }

        file.save()

        dump()
    }
}
