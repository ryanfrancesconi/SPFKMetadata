// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKMetadataC

extension WaveFileC {
    public subscript(key: InfoFrameKey) -> String? {
        get { infoDictionary?[key.value] as? String }
        set {
            infoDictionary?[key.value] = newValue
        }
    }
}
