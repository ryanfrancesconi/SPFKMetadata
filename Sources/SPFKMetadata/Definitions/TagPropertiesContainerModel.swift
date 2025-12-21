// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SwiftExtensions

public typealias TagKeyDictionary = [TagKey: String]

public protocol TagPropertiesContainerModel: CustomStringConvertible {
    /// Official ID3 or conventional tags found in this file
    var tags: TagKeyDictionary { get set }

    /// Unoffical, other custom tags found in this file
    var customTags: [String: String] { get set }
}

extension TagPropertiesContainerModel {
    public subscript(key: TagKey) -> String? {
        get { tags[key] }
        set {
            tags[key] = newValue
        }
    }

    public func contains(key: TagKey) -> Bool {
        tags.contains { $0.key.id3Frame == key.id3Frame }
    }

    public func contains(keys: [TagKey]) -> Bool {
        for key in keys {
            guard contains(key: key) else { return false }
        }

        return true
    }

    public var description: String {
        let strings = tags.map {
            let key: TagKey = $0.key
            return "\(key.description) = \($0.value)"
        }

        return strings.sorted().joined(separator: "\n")
    }
}

extension TagPropertiesContainerModel {
    public func tag(for tagKey: TagKey) -> String? {
        tags[tagKey]
    }

    public func customTag(for key: String) -> String? {
        customTags[key]
    }

    public mutating func set(tag key: TagKey, value: String) {
        tags[key] = value
    }

    public mutating func set(customTag key: String, value: String) {
        customTags[key] = value
    }

    public mutating func remove(tag key: TagKey) {
        tags.removeValue(forKey: key)
    }

    public mutating func remove(customTag key: String) {
        customTags.removeValue(forKey: key)
    }

    public mutating func removeAll() {
        tags.removeAll()
        customTags.removeAll()
    }
}

extension TagPropertiesContainerModel {
    /// "TITLE": "Hello"
    mutating func set(taglibKey key: String, value: String) {
        let value = value.removing(.controlCharacters).trimmed

        guard let frame = TagKey(taglibKey: key) else {
            customTags[key] = value
            return
        }

        tags[frame] = value
    }

    /// .title = Hello
    mutating func set(id3Frame key: ID3FrameKey, value: String) {
        let value = value.removing(.controlCharacters).trimmed

        guard let frame = TagKey(id3Frame: key) else {
            customTags[key.rawValue] = value
            return
        }

        tags[frame] = value
    }
}
