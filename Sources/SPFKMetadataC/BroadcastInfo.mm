
#import <Foundation/Foundation.h>
#import "BroadcastInfo.h"
#import "sndfile.hh"
#import "spfk_util.h"

@implementation BroadcastInfo

- (id)init {}

- (nullable id)initWithPath:(nonnull NSString *)path {
    SndfileHandle file = SndfileHandle(path.UTF8String);
    SF_BROADCAST_INFO bext = {};

    // SF_TRUE if the file contained a Broadcast Extension chunk or SF_FALSE otherwise
    if (file.command(SFC_GET_BROADCAST_INFO, &bext,  sizeof(bext)) != SF_TRUE) {
        return nil;
    }

    self = [super init];

    _version = bext.version;
    _codingHistory = Util::utf8String(bext.coding_history);

    if (_version >= 1) {
        _umid = Util::utf8String(bext.umid);
    }

    if (_version >= 2) {
        _loudnessValue = bext.loudness_value / 100;
        _loudnessRange = bext.loudness_range / 100;
        _maxTruePeakLevel = bext.max_true_peak_level / 100;
        _maxMomentaryLoudness = bext.max_momentary_loudness / 100;
        _maxShortTermLoudness = bext.max_shortterm_loudness / 100;
    }

    _originator = Util::utf8String(bext.originator);
    _originationDate = Util::utf8String(bext.origination_date);
    _originationTime = Util::utf8String(bext.origination_time);
    _originatorReference = Util::utf8String(bext.originator_reference);

    _timeReferenceLow = bext.time_reference_low;
    _timeReferenceHigh = bext.time_reference_high;

    _timeReference = (uint64_t(_timeReferenceHigh) << 32) | _timeReferenceLow;

    _sampleRate = double(file.samplerate());
    _timeReferenceInSeconds = double(_timeReference) / _sampleRate;

    return self;
}

@end
