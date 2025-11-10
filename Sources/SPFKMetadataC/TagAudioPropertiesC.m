
#import "TagAudioPropertiesC.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TagAudioPropertiesC

- (nonnull id)init {
    self = [super init];
    return self;
}

//- (nonnull id)initWithProperties:(nonnull TagLib::AudioProperties *)audioProperties {
//    self = [super init];
//
//    _sampleRate = audioProperties->sampleRate();
//    _duration = (double)audioProperties->lengthInMilliseconds() / 1000;
//    _bitRate = audioProperties->bitrate();
//    _channelCount = audioProperties->channels();
//
//    return self;
//}

@end

NS_ASSUME_NONNULL_END
