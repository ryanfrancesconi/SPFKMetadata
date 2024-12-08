import Foundation

public typealias TagKeyDictionary = [TagKey: String]

public protocol TagPropertiesContainerModel: CustomStringConvertible {
    /// official ID3 or conventional tags found in this file
    var tags: TagKeyDictionary { get set }

    /// unoffical, uncommon tags found in this file
    var customTags: [String: String] { get set }
}

extension TagPropertiesContainerModel {
    public subscript(key: TagKey) -> String? {
        get { tags[key] }
        set {
            tags[key] = newValue
        }
    }

    /// TITLE: Hello
    public mutating func set(taglibKey key: String, value: String) {
        let value = value.removing(.controlCharacters).trimmed

        guard let frame = TagKey(taglibKey: key) else {
            customTags[key] = value
            return
        }

        tags[frame] = value
    }

    /// TIT2 = Hello
    public mutating func set(id3Frame key: String, value: String) {
        let value = value.removing(.controlCharacters).trimmed

        guard let frame = TagKey(id3Frame: key) else {
            customTags[key] = value
            return
        }

        tags[frame] = value
    }

    public var description: String {
        let strings = tags.map {
            let key: TagKey = $0.key
            return "\(key.rawValue) (ID3: \(key.id3Frame ?? "????")) (INFO: \(key.infoFrame ?? "????")) = \($0.value)"
        }

        return strings.sorted().joined(separator: "\n")
    }
}
