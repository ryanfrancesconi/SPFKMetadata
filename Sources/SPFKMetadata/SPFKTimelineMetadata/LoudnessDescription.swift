// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
internal import OTCore

public struct LoudnessDescription: Hashable, Comparable, Codable {
    public static func < (lhs: LoudnessDescription, rhs: LoudnessDescription) -> Bool {
        guard let lhs = lhs.lufs,
              let rhs = rhs.lufs else { return false }

        return lhs < rhs
    }

    public var lufs: Double?
    public var loudnessRange: Double?
    public var truePeak: Float?

    /// A summary suitable for displaying in a UI
    public var description: String {
        var out = ""

        let lufsString = lufs?.string(decimalPlaces: 1) ?? "N/A"
        out += "\(lufsString) LUFS, "

        let truePeakString = truePeak?.string(decimalPlaces: 1) ?? "N/A"
        out += "\(truePeakString) dBTP, "

        let loudnessRangeValue: Double? = loudnessRange == 0 ? nil : loudnessRange
        let loudnessRangeString = loudnessRangeValue?.string(decimalPlaces: 1) ?? "N/A"
        out += "\(loudnessRangeString) LRA"

        return out
    }

    public init(lufs: Double? = nil, loudnessRange: Double? = nil, truePeak: Float? = nil) {
        self.lufs = lufs
        self.loudnessRange = loudnessRange
        self.truePeak = truePeak
    }
}

extension LoudnessDescription {
    public static func averageLoudness(from array: [LoudnessDescription]) -> LoudnessDescription {
        var out = LoudnessDescription()

        guard array.isNotEmpty else {
            return out
        }

        let lufs = array.compactMap { $0.lufs }.filter { !$0.isInfinite }

        if lufs.count > 0 {
            out.lufs = lufs.reduce(0, +) / lufs.count.double
        }

        let loudnessRange = array.compactMap { $0.loudnessRange }

        if loudnessRange.count > 0 {
            out.loudnessRange = loudnessRange.reduce(0, +) / loudnessRange.count.double
        }

        let truePeak = array.compactMap { $0.truePeak }

        if truePeak.count > 0 {
            out.truePeak = truePeak.reduce(0, +) / truePeak.count.float
        }

        return out
    }
}
