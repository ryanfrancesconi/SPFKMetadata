// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

import Foundation

public protocol TagFrameKey: CaseIterable, RawRepresentable where RawValue == String {
    var value: String { get }
}

extension TagFrameKey {
    public var taglibKey: String {
        rawValue.uppercased()
    }

    public var displayName: String {
        rawValue.spacedTitleCased
    }

    public init?(value: String) {
        for item in Self.allCases where item.value == value {
            self = item
            return
        }

        return nil
    }

    public init?(displayName: String) {
        for item in Self.allCases where item.displayName == displayName {
            self = item
            return
        }

        return nil
    }

    public init?(taglibKey: String) {
        for item in Self.allCases where item.taglibKey == taglibKey {
            self = item
            return
        }
        return nil
    }
}
