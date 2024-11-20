import Foundation
@testable import SwiftTagLib
@testable import SwiftTagLibC
import Testing

/*
 swift test -Xswiftc -cxx-interoperability-mode=default
 */

class ParseFileTests: SwiftTagLibTestModel {
    @Test func parseMP3() async throws {
        let url = getResource(named: "id3.mp3")

        let metadata = try ID3Metadata(url: url)
        Swift.print(metadata)

        #expect(metadata[.title] == "Shine On (inst)")
    }

    @Test func parseBEXT() async throws {
        let url = getResource(named: "bext.wav")

        let metadata = try BEXTMetadata(url: url)

        Swift.print(metadata)
    }
}
