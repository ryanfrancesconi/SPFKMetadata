import Foundation
import SwiftTagLibC

public struct BEXTMetadata {
    public private(set) var info: BroadcastExtensionDescription

    public init(url: URL) throws {
        guard let sfinfo = TagLibBridge.parseBroadcastInfo(url.path) else {
            throw NSError(description: "Failed to parse \(url.path)")
        }

        info = BroadcastExtensionDescription(info: sfinfo.info)
    }
}
