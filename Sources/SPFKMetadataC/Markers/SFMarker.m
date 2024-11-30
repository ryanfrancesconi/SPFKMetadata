// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import "SFMarker.h"

@implementation SFMarker

- (nonnull id)initWithName:(nonnull NSString *)name time:(NSTimeInterval)time {
    self = [super init];

    _name = name;
    _time = time;
    
    return self;
}

@end
