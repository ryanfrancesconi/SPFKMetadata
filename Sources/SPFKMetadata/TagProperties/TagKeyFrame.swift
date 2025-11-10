// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation
import SPFKMetadataC

public struct TagKeyFrame: Codable,Hashable {
    var key: TagKey
    var value: String
}
