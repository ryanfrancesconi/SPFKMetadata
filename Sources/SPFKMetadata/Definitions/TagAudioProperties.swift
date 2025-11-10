import Foundation
import SPFKMetadataC

/// Swift struct copy for Codable conformance. See `TagAudioPropertiesC`
/// which is am objc copy of the TagLib::AudioProperties C++ class
public struct TagAudioProperties: Codable, Hashable {
    public var sampleRate: Double
    public var duration: TimeInterval
    public var bitRate: Int32
    public var channelCount: Int32

    public var bitRateString: String {
        "\(bitRate) kbit/s"
    }

    public init(cObject: TagAudioPropertiesC) {
        self.sampleRate = cObject.sampleRate
        self.duration = cObject.duration
        self.bitRate = cObject.bitRate
        self.channelCount = cObject.channelCount
    }
}
