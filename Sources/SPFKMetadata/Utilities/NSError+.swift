import Foundation

extension NSError {
    internal convenience init(
        description: String,
        code: Int = 1,
        domain: String = "SPFKMetadata"
    ) {
        let userInfo: [String: Any] = [NSLocalizedDescriptionKey: description]

        self.init(domain: domain, code: code, userInfo: userInfo)
    }
}
