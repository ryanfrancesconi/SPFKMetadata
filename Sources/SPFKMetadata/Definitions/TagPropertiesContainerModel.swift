// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
import OTCore

public typealias TagKeyDictionary = [TagKey: String]

public protocol TagPropertiesContainerModel: CustomStringConvertible {
    /// Official ID3 or conventional tags found in this file
    var tags: TagKeyDictionary { get set }

    /// Unoffical, uncommon tags found in this file
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
            return "\(key.rawValue) (ID3: \(key.id3Frame.value)) (INFO: \(key.infoFrame?.value ?? "????")) = \($0.value)"
        }

        return strings.sorted().joined(separator: "\n")
    }
}

extension TagPropertiesContainerModel {
    /// "TITLE": "Hello"
    internal mutating func set(taglibKey key: String, value: String) {
        let value = value.removing(.controlCharacters).trimmed

        guard let frame = TagKey(taglibKey: key) else {
            customTags[key] = value
            return
        }

        tags[frame] = value
    }

    /// TIT2 = Hello
    internal mutating func set(id3Frame key: ID3FrameKey, value: String) {
        let value = value.removing(.controlCharacters).trimmed

        guard let frame = TagKey(id3Frame: key) else {
            customTags[key.rawValue] = value
            return
        }

        tags[frame] = value
    }
}
