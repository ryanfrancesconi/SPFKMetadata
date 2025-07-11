// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
import SPFKMetadataC
import SPFKUtils

/// A Swift convenience wrapper to TagLibBridge (C++)
public struct TagProperties: TagPropertiesContainerModel, Hashable, Codable {
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
        self.url = url

        try reload()
    }

    public mutating func reload() throws {
        guard let dict = TagLibBridge.getProperties(url.path) as? [String: String] else {
            throw NSError(description: "Failed to open file or no metadata for: \(url.path)")
        }

        dict.forEach {
            set(taglibKey: $0.key, value: $0.value)
        }
    }

    /// Write the current tags dictionary back to the file
    public func save() throws {
        guard TagLibBridge.setProperties(
            url.path,
            dictionary: tagLibPropertyMap
        ) else {
            throw NSError(description: "Failed to update \(url.path)")
        }
    }

    public mutating func removeAll() throws {
        try Self.removeAll(in: url)
        tags = [:]
    }
}

extension TagProperties {
    /// Read in tags and copy to the destination
    /// - Parameters:
    ///   - source: The file to read from
    ///   - destination: The file to write to
    public static func copy(from source: URL, to destination: URL) throws {
        TagLibBridge.copyTags(fromPath: source.path, toPath: destination.path)
    }

    public static func removeAll(in url: URL) throws {
        guard TagLibBridge.removeAllTags(url.path) else {
            throw NSError(description: "Failed to update \(url.path)")
        }
    }
}
