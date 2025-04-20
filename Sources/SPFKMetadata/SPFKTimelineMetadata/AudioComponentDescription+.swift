// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import AudioToolbox

extension AudioComponentDescription {
    /// Final Cut Pro creates a single id from these values for its Audio Units
    public var uid: String {
        let type = String(format: "%02x", componentType)
        let subType = String(format: "%02x", componentSubType)
        let manufacturer = String(format: "%02x", componentManufacturer)

        return type + subType + manufacturer
    }

    /// Create with a concatenated type+subType+manufacturer hex string. Used by Final Cut Pro XML
    /// - Parameter uid: The string to parse such as:
    /// `AudioUnit: 0x6175667864656c796170706c`,
    /// `0x6175667864656c796170706c`, or
    /// `6175667864656c796170706c`
    public init?(uid: String) {
        var uid = uid

        if uid.contains(" ") {
            let uidParts = uid.components(separatedBy: " ")

            if let value = uidParts.first(where: { item in
                item.hasPrefix("0x")
            }) {
                uid = value
            }
        }

        uid = uid.lowercased()

        if uid.hasPrefix("0x") {
            uid = String(uid.dropFirst(2))
        }

        guard uid.count == 24 else { return nil }

        let parts = uid.split(every: 8)

        let values = parts.compactMap {
            UInt32(String($0), radix: 16)
        }

        guard values.count == 3 else { return nil }

        self.init(componentType: values[0],
                  componentSubType: values[1],
                  componentManufacturer: values[2],
                  componentFlags: 0,
                  componentFlagsMask: 0)
    }
}
