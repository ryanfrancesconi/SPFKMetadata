// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChapterMarker : NSObject

@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval endTime;

- (nonnull id)initWithName:(nonnull NSString *)name
                 startTime:(NSTimeInterval)startTime
                   endTime:(NSTimeInterval)endTime;

@end

NS_ASSUME_NONNULL_END
