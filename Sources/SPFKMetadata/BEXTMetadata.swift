import Foundation
import SPFKMetadataC

public struct BEXTMetadata {
    public private(set) var info: BroadcastExtensionDescription

    public init(url: URL) throws {
        guard let sfinfo = SFBroadcastInfo.parse(url.path) else {
            throw NSError(description: "Failed to parse \(url.path)")
        }

        info = BroadcastExtensionDescription(info: sfinfo.info)
    }
}
