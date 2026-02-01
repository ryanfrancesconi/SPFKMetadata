import AVFoundation
import SPFKBase
import SPFKTesting
import Testing

@testable import SPFKMetadata

@Suite(.tags(.file))
struct AudioFormatPropertiesTests {
    @Test func printFormats() async throws {
        for url in TestBundleResources.shared.formats {
            let audioFile = try AVAudioFile(forReading: url)

            let properties = AudioFormatProperties(audioFile: audioFile)

            Log.debug(url.lastPathComponent, properties.durationDescription, properties.formatDescription)
        }
    }
}
