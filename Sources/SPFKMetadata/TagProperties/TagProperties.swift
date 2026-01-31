// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKBase
import SPFKMetadataC

/// A Swift convenience wrapper to TagFile access
public struct TagProperties: Hashable, Codable, Sendable {
    public var url: URL?

    /// Use the various access methods in TagPropertiesContainerModel for mutation
    public var data = TagData()

    public var audioProperties: TagAudioProperties?

    private var tagLibPropertyMap: [String: String] {
        var dict: [String: String] = .init()

        for item in data.tags {
            dict[item.key.taglibKey] = item.value
        }

        for item in data.customTags {
            dict[item.key] = item.value
        }

        return dict
    }

    public init() {}

    /// Create a dictionary from an audio file url
    /// - Parameter url: the `URL` to parse for metadata
    public init(url: URL) throws {
        try load(url: url)
    }

    public mutating func load(url: URL) throws {
        self.url = url

        let tagFile = TagFile(path: url.path)
        tagFile.load()

        if let value = tagFile.audioProperties {
            audioProperties = TagAudioProperties(cObject: value)
        }

        guard let dict = tagFile.dictionary as? [String: String] else {
            throw NSError(description: "Failed to open file or no metadata for: \(url.path)")
        }

        for item in dict {
            data.set(taglibKey: item.key, value: item.value)
        }
    }

    /// Write the current tags dictionary back to the file
    public func save() throws {
        guard let url else {
            throw NSError(description: "URL is nil")
        }

        let tagFile = TagFile(path: url.path)
        tagFile.dictionary = tagLibPropertyMap

        guard tagFile.save() else {
            throw NSError(description: "Failed to update tags in \(url.path)")
        }
    }

    public mutating func removeAllAndSave() throws {
        guard let url else {
            throw NSError(description: "URL is nil")
        }

        try Self.removeAllTags(in: url)
        removeAll()
    }
}

extension TagProperties: TagPropertiesContainerModel {
    public var tags: TagKeyDictionary {
        get { data.tags }
        set { data.tags = newValue }
    }

    public var customTags: [String: String] {
        get { data.customTags }
        set { data.customTags = newValue }
    }
}

extension TagProperties {
    /// Read in tags and copy to the destination
    /// - Parameters:
    ///   - source: The file to read from
    ///   - destination: The file to write to
    public static func copyTags(from source: URL, to destination: URL) throws {
        TagLibBridge.copyTags(fromPath: source.path, toPath: destination.path)
    }

    public static func removeAllTags(in url: URL) throws {
        guard TagLibBridge.removeAllTags(url.path) else {
            throw NSError(description: "Failed to removeAll tags in \(url.path)")
        }
    }
}
