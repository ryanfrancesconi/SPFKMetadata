// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///  Objective C wrapper on the AudioFileMarker C struct for simpler interchange with Swift
@interface SimpleAudioFileMarker : NSObject

@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic) NSTimeInterval time;
@property (nonatomic) Float64 sampleRate;
@property (nonatomic) SInt32 markerID;
@property (nonatomic) UInt32 type;

- (nonnull id)initWithName:(nonnull NSString *)name
                      time:(NSTimeInterval)time
                sampleRate:(Float64)sampleRate
                  markerID:(SInt32)markerID;

- (Float64)framePosition;

@end

NS_ASSUME_NONNULL_END
