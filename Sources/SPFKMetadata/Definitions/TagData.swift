import Foundation
import SPFKBase

public struct TagData: TagPropertiesContainerModel, Hashable, Codable {
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
