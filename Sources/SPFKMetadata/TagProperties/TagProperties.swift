// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
import SPFKMetadataC
import SPFKUtils

/// A Swift convenience wrapper to TagLibBridge (C++)
public struct TagProperties: TagPropertiesContainerModel {
    public var tags = TagKeyDictionary()

    /// Any tags that weren't matched to a `TagKey` value
    public var customTags = [String: String]()

    private var tagLibPropertyMap: [String: String] {
        var dict: [String: String] = .init()

        for item in tags {
            dict[item.key.taglibKey] = item.value
        }

        return dict
    }

    public private(set) var url: URL

    /// Create a dictionary from an audio file url
    /// - Parameter url: the `URL` to parse for metadata
    public init(url: URL) throws {
        guard let dict = TagLibBridge.getProperties(url.path) as? [String: String] else {
            throw NSError(description: "Failed to open file or no metadata in: \(url.path)")
        }

        self.url = url

        dict.forEach {
            set(taglibKey: $0.key, value: $0.value)
        }
    }

    /// Write the current tags dictionary back to the file
    public func save() throws {
        guard TagLibBridge.setProperties(url.path, dictionary: tagLibPropertyMap) else {
            throw NSError(description: "Failed to update \(url.path)")
        }
    }
}
