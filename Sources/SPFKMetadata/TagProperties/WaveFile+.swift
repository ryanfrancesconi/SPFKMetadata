// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKMetadataC

extension WaveFile {
    public subscript(key: InfoFrameKey) -> String? {
        get { dictionary?[key.value] as? String }
        set {
            dictionary?[key.value] = newValue
        }
    }
}
