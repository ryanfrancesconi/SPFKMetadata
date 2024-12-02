// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <AudioToolbox/AudioFile.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///  Objective C wrapper on the AudioFileMarker C struct for simpler interchange with Swift
@interface AudioMarker : NSObject // RIFFMarker impl

@property (nonatomic, nullable) NSString *name;
@property (nonatomic) NSTimeInterval time;
@property (nonatomic) Float64 sampleRate;
@property (nonatomic) SInt32 markerID;
@property (nonatomic) UInt32 type;
@property (nonatomic) AudioFile_SMPTE_Time timecode;

- (nonnull id)initWithName:(nonnull NSString *)name
                      time:(NSTimeInterval)time
                sampleRate:(Float64)sampleRate
                  markerID:(SInt32)markerID;

- (Float64)framePosition;

@end

NS_ASSUME_NONNULL_END
