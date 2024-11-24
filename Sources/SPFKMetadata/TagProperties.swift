
import Foundation
import SPFKMetadataC

public typealias TagKeyDictionary = [TagKey: String]

public struct TagProperties {
    public private(set) var dictionary = TagKeyDictionary()

    public subscript(key: TagKey) -> String? {
        get { dictionary[key] }
        set {
            dictionary[key] = newValue
        }
    }

    public init(url: URL) throws {
//        guard let file = TagFile(path: url.path), let dict = file.dictionary else {
//            throw NSError(description: "Failed to parse \(url.path)")
//        }

        guard let dict = TagLibBridge.parseProperties(url.path) else {
            throw NSError(description: "Failed to parse \(url.path)")
        }

        for item in dict {
            guard let key = item.key as? String else { continue }

            guard let frame = TagKey(taglibKey: key) else {
                continue
            }

            dictionary[frame] = String(describing: item.value)
        }
    }
}

extension TagProperties: CustomStringConvertible {
    public var description: String {
        let strings = dictionary.map {
            let key: TagKey = $0.key
            return "\(key.rawValue) (\(key.id3Frame)) = \($0.value)"
        }

        return strings.sorted().joined(separator: "\n")
    }
}
