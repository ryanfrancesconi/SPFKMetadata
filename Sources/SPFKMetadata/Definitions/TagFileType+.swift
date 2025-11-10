import Foundation
import SPFKMetadataC

extension TagFileTypeDef: @retroactive CaseIterable {
    // convenience
    public static var allCases: [TagFileTypeDef] { [
        .aac,
        .aiff,
        .flac,
        .m4a,
        .mp3,
        .mp4,
        .opus,
        .vorbis,
        .wave,
    ] }
}
