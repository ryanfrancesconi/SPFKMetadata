import Foundation
@testable import SPFKMetadata
import SPFKUtils
import Testing

struct TagKeyTests {
    @Test func displayNames() throws {
        for item in TagKey.allCases {
            let displayName = item.displayName
            
            Log.debug(displayName)
            
            let new = TagKey(displayName: displayName)
            
            #expect(item == new)
        }
    }
}
