import Foundation
import SPFKBase

public struct TagData: TagPropertiesContainerModel, Hashable, Codable, Sendable {
    public var isEmpty: Bool {
        tags.isEmpty && customTags.isEmpty
    }

    /// Known ID3 tags
    public var tags: TagKeyDictionary

    /// TXXX, Unoffical, uncommon tags found in this file
    /// Any tags that didn't match to a `TagKey` value
    public var customTags: [String: String]

    public init(tags: TagKeyDictionary = .init(), customTags: [String: String] = .init()) {
        self.tags = tags
        self.customTags = customTags
    }

    public mutating func removeAll() {
        tags.removeAll()
        customTags.removeAll()
    }
}

extension [TagData] {
    public func merge() async -> TagData {
        let allTags = compactMap(\.tags)
        let allCustomTags = compactMap(\.customTags)

        var mergedTags: TagKeyDictionary = .init()
        var mergedCustomTags: [String: String] = .init()

        for item in allTags {
            // keep old value if duplicate key
            mergedTags = mergedTags.merging(item, uniquingKeysWith: { old, _ in old })
        }

        for item in allCustomTags {
            mergedCustomTags = mergedCustomTags.merging(item, uniquingKeysWith: { old, _ in old })
        }

        return TagData(tags: mergedTags, customTags: mergedCustomTags)
    }
}
