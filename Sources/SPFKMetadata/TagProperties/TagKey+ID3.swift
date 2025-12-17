// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation

extension TagKey {
    /// The associated ID3v2 label or TXXX if it is a non-standard frame
    public var id3Frame: ID3FrameKey {
        // unlike the wave info keys which need custom mapping,
        // these names will match in our case as ID3 is the predominant structure
        ID3FrameKey(rawValue: rawValue) ??
            .userDefined
    }
}
