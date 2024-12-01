
import Foundation
import SPFKMetadataC

/// A wrapper to TagLib to ease compatibility with Swift
public struct TagProperties: TagPropertiesContainerModel {
    public var dictionary = TagKeyDictionary()

    private var tagLibCompatibleDictionary: [String: String] {
        var dict: [String: String] = .init()

        for item in dictionary {
            dict[item.key.taglibKey] = item.value
        }

        return dict
    }

    public private(set) var url: URL

    public init(url: URL) throws {
        guard let dict = TagLibBridge.getProperties(url.path) else {
            throw NSError(description: "Failed to open file or no metadata in: \(url.path)")
        }

        self.url = url

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

    public func save() throws {
        guard TagLibBridge.setProperties(url.path, dictionary: tagLibCompatibleDictionary) else {
            throw NSError(description: "Failed to update \(url.path)")
        }
    }
}
