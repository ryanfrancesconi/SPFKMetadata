// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKMetadataC

extension ID3File {
    public subscript(id3 key: ID3FrameKey) -> String? {
        get { dictionary?[key.value] as? String }
        set {
            dictionary?[key.value] = newValue
        }
    }
}
