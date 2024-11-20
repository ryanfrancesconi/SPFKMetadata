
import Foundation
import SwiftTagLibC

public typealias ID3FrameDictionary = [ID3v2Frame: String]

public struct ID3Metadata {
    private var dictionary = ID3FrameDictionary()

    public subscript(key: ID3v2Frame) -> String? {
        get { dictionary[key] }
        set {
            dictionary[key] = newValue
        }
    }

    public init(url: URL) throws {
        guard let dict = TagLibBridge.parseMetadata(url.path) else {
            throw NSError(description: "Failed to parse \(url.path)")
        }

        for item in dict {
            guard let key = item.key as? String else { continue }

            guard let frame = ID3v2Frame(taglibKey: key) else {
                continue
            }

            dictionary[frame] = String(describing: item.value)
        }
    }
}

extension ID3Metadata: CustomStringConvertible {
    public var description: String {
        let strings = dictionary.map {
            let key: ID3v2Frame = $0.key
            return "\(key.rawValue) (\(key.id3Frame)) = \($0.value)"
        }

        return strings.sorted().joined(separator: ", ")
    }
}
