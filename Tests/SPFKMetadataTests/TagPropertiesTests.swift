// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
@testable import SPFKMetadata
@testable import SPFKMetadataC
@testable import SPFKTesting
import SPFKUtils
import Testing

@Suite(.serialized)
class TagPropertiesTests: BinTestCase {
    @Test func benchmarkTagLib() async throws {
        let tagLibElapsed = try ContinuousClock().measure {
            _ = try TagProperties(url: BundleResources.shared.mp3_id3)
        }

        let avElapsed = try await ContinuousClock().measure {
            _ = try await TagPropertiesAV(url: BundleResources.shared.mp3_id3)
        }

        Log.debug("TagLib took", tagLibElapsed)
        Log.debug("AV took", avElapsed)
    }

    @Test func parseID3MP3() async throws {
        let properties = try TagProperties(url: BundleResources.shared.mp3_id3)
        verify(properties: properties)
    }

    @Test func parseID3MP3_AV() async throws {
        let properties = try await TagPropertiesAV(url: BundleResources.shared.mp3_id3)
        // verify(properties: properties)
        
        Log.debug(properties)
    }

    @Test func parseID3Wave() async throws {
        Log.debug(BundleResources.shared.wav_bext_v2.path)

        let properties = try TagProperties(url: BundleResources.shared.wav_bext_v2)
        verify(properties: properties)
    }

    @Test func readWriteTagProperties() async throws {
        deleteBinOnExit = false

        let tmpfile = try copyToBin(url: BundleResources.shared.wav_bext_v2)

        // source
        let properties = try TagProperties(url: BundleResources.shared.mp3_id3)

        // target
        var output = try TagProperties(url: tmpfile)
        try output.removeAll()
        #expect(output.tags.isEmpty)

        // replace all tags
        output.tags = properties.tags
        try output.save()

        #expect(output.tags.count == 28)

        let random = Float.random(in: 0 ... 1)
        output[.title] = "New Title \(random)"
        try output.save()

        try output.reload()
        #expect(output[.title] == "New Title \(random)")
    }
}

extension TagPropertiesTests {
    private func verify(properties: TagPropertiesContainerModel) {
        Log.debug(properties.description)

        #expect(properties.contains(key: .album))
        #expect(properties.contains(key: .albumArtist))
        #expect(properties.contains(key: .remixer))
        #expect(properties.contains(key: .artist))
        #expect(properties.contains(key: .bpm))
        #expect(properties.contains(key: .comment))
        #expect(properties.contains(key: .composer))
        #expect(properties.contains(key: .copyright))
        #expect(properties.contains(key: .date))
        #expect(properties.contains(key: .genre))
        #expect(properties.contains(key: .initialKey))
        #expect(properties.contains(key: .isrc))
        #expect(properties.contains(key: .label))
        #expect(properties.contains(key: .language))
        #expect(properties.contains(key: .lyricist))
        #expect(properties.contains(key: .lyrics))
        #expect(properties.contains(key: .mood))
        #expect(properties.contains(key: .releaseCountry))
        #expect(properties.contains(key: .subtitle))
        #expect(properties.contains(key: .title))
        #expect(properties.contains(key: .trackNumber))

        let tags = properties.tags

        #expect(tags[.album] == "This Is Spinal Tap")
        #expect(tags[.albumArtist] == "Spinal Tap")
        #expect(tags[.remixer] == "SPFKMetadata")

        #expect(tags[.title] == "Stonehenge")
        #expect(tags[.bpm] == "666")
    }
}

/*
 album (ID3: TALB) (INFO: IPRD) = This Is Spinal Tap
 albumArtist (ID3: TPE2) (INFO: ????) = Spinal Tap
 artist (ID3: TPE1) (INFO: IART) = Spinal Tap
 bpm (ID3: TBPM) (INFO: IBPM) = 666
 comment (ID3: COMM) (INFO: ICMT) = And oh how they dancedThe little children of StonehengeBeneath the haunted moonFor fear that daybreak might come too soon
 composer (ID3: TCOM) (INFO: IMUS) = Nigel Tufnel
 conductor (ID3: TPE3) (INFO: ????) = Derek Smalls
 copyright (ID3: TCOP) (INFO: ICOP) = 1984 Universal Records, a Division of UMG Recordings, Inc.
 date (ID3: TDRC) (INFO: ICRD) = 1984
 discNumber (ID3: TPOS) (INFO: ????) = 1/1
 encodedBy (ID3: TENC) (INFO: ITCH) = SPFKMetadata
 genre (ID3: TCON) (INFO: IGNR) = Soundtracks
 initialKey (ID3: TKEY) (INFO: ????) = E
 isrc (ID3: TSRC) (INFO: ISRC) = AA6Q72000047
 label (ID3: TPUB) (INFO: IPUB) = Sony/ATV Music Publishing LLC
 language (ID3: TLAN) (INFO: ILNG) = en_uk
 lyricist (ID3: TEXT) (INFO: IWRI) = David St. Hubbins
 lyrics (ID3: USLT) (INFO: ????) = Stonehenge! Where the demons dwellWhere the banshees live and they do live wellStonehenge! Where a man's a manAnd the children dance to the Pipes of Pan
 originalAlbum (ID3: TOAL) (INFO: ????) = This is Spinal Tap
 originalArtist (ID3: TOPE) (INFO: ????) = Spinal Tap
 originalDate (ID3: TDOR) (INFO: ????) = 1884
 originalLyricist (ID3: TOLY) (INFO: ????) = Viv Savage
 releaseCountry (ID3: ????) (INFO: ICNT) = UK
 remixer (ID3: TPE4) (INFO: IEDT) = SPFKMetadata
 subtitle (ID3: TIT3) (INFO: ????) = And oh how they dancedThe little children of StonehengeBeneath the haunted moonFor fear that daybreak might come too soon
 title (ID3: TIT2) (INFO: INAM) = Stonehenge
 trackNumber (ID3: TRCK) (INFO: IPRT) = 9/13
 */
