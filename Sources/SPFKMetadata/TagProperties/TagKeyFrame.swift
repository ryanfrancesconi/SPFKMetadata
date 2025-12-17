// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation
import SPFKMetadataC

public struct TagKeyFrame: Codable, Hashable {
    var key: TagKey
    var value: String
}
