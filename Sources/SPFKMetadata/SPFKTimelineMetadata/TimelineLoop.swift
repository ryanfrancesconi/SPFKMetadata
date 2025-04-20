// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

import Foundation

public typealias TimeChunk = TimelineLoop

public struct TimelineLoop {
    /// The loop start
    public var start: TimeInterval = 0 {
        didSet {
            update()
        }
    }

    /// The loop end
    public var end: TimeInterval = 0 {
        didSet {
            update()
        }
    }

    public var preroll: TimeInterval = 0 {
        didSet {
            update()
        }
    }

    /// Duration of the loop
    public private(set) var duration: TimeInterval = 0

    public private(set) var prerollStart: TimeInterval = 0

    public var editDescription: String {
        guard start > 0 && end != duration else { return "" }
        
        let start = start.truncated(decimalPlaces: 1)
        let end = end.truncated(decimalPlaces: 1)
        return "(\(start) to \(end))"
    }
    
    public init(start: TimeInterval = 0, end: TimeInterval = 0) {
        self.start = start
        self.end = end

        update()
    }

    private mutating func update() {
        prerollStart = start - preroll

        duration = end - prerollStart
    }

    /// Check to see if a time range overlaps with this loop
    /// - Parameters:
    ///   - startTime: start
    ///   - endTime: end
    /// - Returns: true if there is some overlap
    public func contains(startTime: TimeInterval, duration: TimeInterval) -> Bool {
        startTime < end && startTime + duration >= start
    }
}

extension TimelineLoop: CustomStringConvertible {
    public var description: String {
        "TimelineLoop(start: \(start), end: \(end), duration: \(duration))"
    }
}
