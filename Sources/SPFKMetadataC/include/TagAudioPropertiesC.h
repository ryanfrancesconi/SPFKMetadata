
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagAudioPropertiesC : NSObject
@property (nonatomic) double sampleRate;
@property (nonatomic) double duration;
@property (nonatomic) int bitRate;
@property (nonatomic) int channelCount;

- (nonnull id)init;
//- (nonnull id)initWithProperties:(nonnull TagLib::AudioProperties *)audioProperties;

@end

NS_ASSUME_NONNULL_END
