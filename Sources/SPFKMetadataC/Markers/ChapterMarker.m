// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import "ChapterMarker.h"

@implementation ChapterMarker

- (nonnull id)initWithName:(nonnull NSString *)name
                 startTime:(NSTimeInterval)startTime
                   endTime:(NSTimeInterval)endTime {
    self = [super init];

    _name = name;
    _startTime = startTime;
    _endTime = endTime;

    return self;
}

@end
