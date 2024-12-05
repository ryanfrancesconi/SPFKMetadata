import Foundation

public typealias TagKeyDictionary = [TagKey: String]

public protocol TagPropertiesContainerModel: CustomStringConvertible {
    var dictionary: TagKeyDictionary { get set }
}

extension TagPropertiesContainerModel {
    public subscript(key: TagKey) -> String? {
        get { dictionary[key] }
        set {
            dictionary[key] = newValue
        }
    }

    public var description: String {
        let strings = dictionary.map {
            let key: TagKey = $0.key
            return "\(key.rawValue) (ID3: \(key.id3Frame ?? "????")) (INFO: \(key.infoFrame ?? "????")) = \($0.value)"
        }

        return strings.sorted().joined(separator: "\n")
    }
}
