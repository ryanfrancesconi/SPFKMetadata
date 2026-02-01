// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKMetadataC

extension WaveFileC {
    public var bext: BEXTDescription? {
        get {
            guard let bextDescription else { return nil }
            return BEXTDescription(info: bextDescription)
        }

        set {
            guard let newValue else {
                bextDescription = nil
                return
            }

            bextDescription = newValue.validateAndConvert()
        }
    }

    public subscript(info key: InfoFrameKey) -> String? {
        get { infoDictionary[key.value] as? String }
        set {
            infoDictionary[key.value] = newValue
        }
    }

    public subscript(id3 key: ID3FrameKey) -> String? {
        get { id3Dictionary[key.value] as? String }
        set {
            id3Dictionary[key.value] = newValue
        }
    }
}
