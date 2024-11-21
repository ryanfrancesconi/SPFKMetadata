import Foundation
import SPFKMetadataC

public struct BEXTMetadata {
    public private(set) var info: BEXTDescription

    public init(url: URL) throws {
        guard let sfinfo = SFBroadcastInfo(path: url.path) else {
            throw NSError(description: "Failed to parse \(url.path)")
        }

        info = BEXTDescription(info: sfinfo.info)
    }
}
