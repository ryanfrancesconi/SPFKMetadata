
import Foundation
import SPFKMetadataC

public typealias TagKeyDictionary = [TagKey: String]

/// A wrapper to TagLib to ease compatibility with Swift
public struct TagProperties {
    public private(set) var dictionary = TagKeyDictionary()

    public subscript(key: TagKey) -> String? {
        get { dictionary[key] }
        set {
            dictionary[key] = newValue
        }
    }

    public init(url: URL) throws {
        guard let dict = TagLibBridge.getProperties(url.path) else {
            throw NSError(description: "Failed to open file or no metadata in: \(url.path)")
        }

        for item in dict {
            guard let key = item.key as? String,
                  var value = item.value as? String else { continue }

            guard let frame = TagKey(taglibKey: key) else {
                continue
            }

            value = value.removing(.controlCharacters).trimmed

            dictionary[frame] = value
        }
    }
}

extension TagProperties: CustomStringConvertible {
    public var description: String {
        let strings = dictionary.map {
            let key: TagKey = $0.key
            return "\(key.rawValue) (ID3: \(key.id3Frame ?? "????") (INFO: \(key.infoFrame ?? "????")) = \($0.value)"
        }

        return strings.sorted().joined(separator: "\n")
    }
}
