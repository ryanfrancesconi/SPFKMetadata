import Foundation

extension BEXTDescription: Codable {
    enum CodingKeys: String, CodingKey {
        case codingHistory
        case loudnessRange
        case loudnessValue
        case maxMomentaryLoudness
        case maxShortTermLoudness
        case maxTruePeakLevel
        case originationDate
        case originationTime
        case originator
        case originatorReference
        case sampleRate
        case sequenceDescription
        case timeReferenceHigh
        case timeReferenceLow
        case umid
        case version
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        version = try container.decodeIfPresent(Int16.self, forKey: .version) ?? 0

        sequenceDescription = try? container.decodeIfPresent(String.self, forKey: .sequenceDescription)
        codingHistory = try? container.decodeIfPresent(String.self, forKey: .codingHistory)
        originator = try? container.decodeIfPresent(String.self, forKey: .originator)
        originationDate = try? container.decodeIfPresent(String.self, forKey: .originationDate)
        originationTime = try? container.decodeIfPresent(String.self, forKey: .originationTime)
        originatorReference = try? container.decodeIfPresent(String.self, forKey: .originatorReference)
        originator = try? container.decodeIfPresent(String.self, forKey: .originator)
        originationDate = try? container.decodeIfPresent(String.self, forKey: .originationDate)
        timeReferenceLow = try? container.decodeIfPresent(UInt64.self, forKey: .timeReferenceLow)
        timeReferenceHigh = try? container.decodeIfPresent(UInt64.self, forKey: .timeReferenceHigh)
        sampleRate = try? container.decodeIfPresent(Double.self, forKey: .sampleRate)

        if version >= 1 {
            umid = try? container.decodeIfPresent(String.self, forKey: .umid)
        }

        if version >= 2 {
            loudnessValue = try? container.decodeIfPresent(Float.self, forKey: .loudnessValue)
            loudnessRange = try? container.decodeIfPresent(Float.self, forKey: .loudnessRange)
            maxTruePeakLevel = try? container.decodeIfPresent(Float.self, forKey: .maxTruePeakLevel)
            maxMomentaryLoudness = try? container.decodeIfPresent(Float.self, forKey: .maxMomentaryLoudness)
            maxShortTermLoudness = try? container.decodeIfPresent(Float.self, forKey: .maxShortTermLoudness)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(version, forKey: .version)
        try? container.encodeIfPresent(sequenceDescription, forKey: .sequenceDescription)
        try? container.encodeIfPresent(codingHistory, forKey: .codingHistory)
        try? container.encodeIfPresent(originator, forKey: .originator)
        try? container.encodeIfPresent(originationDate, forKey: .originationDate)
        try? container.encodeIfPresent(originationTime, forKey: .originationTime)
        try? container.encodeIfPresent(originatorReference, forKey: .originatorReference)
        try? container.encodeIfPresent(originator, forKey: .originator)
        try? container.encodeIfPresent(originationDate, forKey: .originationDate)
        try? container.encodeIfPresent(timeReferenceLow, forKey: .timeReferenceLow)
        try? container.encodeIfPresent(timeReferenceHigh, forKey: .timeReferenceHigh)
        try? container.encodeIfPresent(sampleRate, forKey: .sampleRate)

        if version >= 1 {
            try? container.encodeIfPresent(umid, forKey: .umid)
        }

        if version >= 2 {
            try? container.encodeIfPresent(loudnessValue, forKey: .loudnessValue)
            try? container.encodeIfPresent(loudnessRange, forKey: .loudnessRange)
            try? container.encodeIfPresent(maxTruePeakLevel, forKey: .maxTruePeakLevel)
            try? container.encodeIfPresent(maxMomentaryLoudness, forKey: .maxMomentaryLoudness)
            try? container.encodeIfPresent(maxShortTermLoudness, forKey: .maxShortTermLoudness)
        }
    }
}
