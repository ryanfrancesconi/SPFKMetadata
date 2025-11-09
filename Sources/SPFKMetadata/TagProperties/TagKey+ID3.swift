// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation

extension TagKey {
    /// Return the associated ID3v2 label or TXXX if it is a non-standard frame
    public var id3Frame: ID3Frame {
        ID3Frame(rawValue: rawValue) ??
            .userDefined
    }
}
