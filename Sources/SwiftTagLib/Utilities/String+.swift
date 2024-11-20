import Foundation

extension String {
    public init?(mirroringCChar mirror: Mirror) {
        let charArray = mirror.children.compactMap { $0.value as? CChar }

        guard !charArray.isEmpty else {
            return nil
        }

        let nullterminated = charArray + [0]

        guard let value = String(cString: nullterminated, encoding: .utf8), value != "" else {
            let fallback = charArray.map { String(format: "%02hhx", $0) }.joined()
            self = fallback
            return
        }

        self = value
    }
}
