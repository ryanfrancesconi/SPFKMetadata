
#import <Foundation/Foundation.h>
#import "BEXTDescriptionC.h"
#import "sndfile.hh"
#import "spfk_util.h"

@implementation BEXTDescriptionC

- (id)init {
    self = [super init];
    return self;
}

- (nullable id)initWithPath:(nonnull NSString *)path {
    SndfileHandle file = SndfileHandle(path.UTF8String);
    SF_BROADCAST_INFO bext = {};

    memset(&bext, 0, sizeof(bext));

    // SF_TRUE if the file contained a Broadcast Extension chunk or SF_FALSE otherwise
    if (file.command(SFC_GET_BROADCAST_INFO, &bext, sizeof(bext)) == SF_FALSE) {
        const char *errorString = sf_error_number(file.error());
        printf("Line %d : sf_command (SFC_GET_BROADCAST_INFO) failed, %s \n\n", __LINE__, errorString);
        return nil;
    }

    self = [super init];

    self.version = bext.version;

    self.codingHistory = @(bext.coding_history);

    if (self.version >= 1 && strlen(bext.umid) > 0) {
        self.umid = @(bext.umid); // Util::asciiString(bext.umid, 64); //@(bext.umid);
    }

    if (self.version >= 2) {
        self.loudnessValue = bext.loudness_value / 100;
        self.loudnessRange = bext.loudness_range / 100;
        self.maxTruePeakLevel = bext.max_true_peak_level / 100;
        self.maxMomentaryLoudness = bext.max_momentary_loudness / 100;
        self.maxShortTermLoudness = bext.max_shortterm_loudness / 100;
    }

    self.bextDescription = @(bext.description);
    self.originator = @(bext.originator);

    self.originationDate = Util::asciiString(bext.origination_date, 10);
    self.originationTime =  Util::asciiString(bext.origination_time, 8);
    self.originatorReference = Util::asciiString(bext.originator_reference, 32);

    self.timeReferenceLow = bext.time_reference_low;
    self.timeReferenceHigh = bext.time_reference_high;

    // read only properties
    _timeReference = (uint64_t(self.timeReferenceHigh) << 32) | self.timeReferenceLow;
    _sampleRate = double(file.samplerate());
    _timeReferenceInSeconds = double(self.timeReference) / self.sampleRate;

    return self;
}

+ (bool)write:(BEXTDescriptionC *)info
         path:(nonnull NSString *)path {
    //
    SndfileHandle file = SndfileHandle(path.UTF8String, SFM_RDWR);
    SF_BROADCAST_INFO bext = {};

    bext.version = info.version;

    const char *umid = [info.umid cStringUsingEncoding:NSASCIIStringEncoding];
    const char *codingHistory = [info.codingHistory cStringUsingEncoding:NSASCIIStringEncoding];
    const char *description = [info.bextDescription cStringUsingEncoding:NSASCIIStringEncoding];
    const char *originator = [info.originator cStringUsingEncoding:NSASCIIStringEncoding];
    const char *originatorReference = [info.originatorReference cStringUsingEncoding:NSASCIIStringEncoding];
    const char *originationDate = [info.originationDate cStringUsingEncoding:NSASCIIStringEncoding];
    const char *originationTime = [info.originationTime cStringUsingEncoding:NSASCIIStringEncoding];

    if (codingHistory) {
        bext.coding_history_size = sizeof(bext.coding_history); //(uint32_t)strlen(bext.coding_history);
        Util::strncpy_0(bext.coding_history, codingHistory, strlen(bext.coding_history));
    }

    if (info.version >= 1 && umid) {
        Util::strncpy_0(bext.umid, umid, strlen(bext.umid));
    }

    if (description) {
        Util::strncpy_0(bext.description, description, sizeof(bext.description) + 1);
    }

    if (originator) {
        Util::strncpy_0(bext.originator, originator, sizeof(bext.originator) + 1);
    }

    if (originatorReference) {
        Util::strncpy_0(bext.originator_reference, originatorReference, sizeof(bext.originator_reference) + 1);
    }

    if (originationDate) {
        Util::strncpy_0(bext.origination_date, originationDate, sizeof(bext.origination_date) + 1);
    }

    if (originationTime) {
        Util::strncpy_0(bext.origination_time, originationTime, sizeof(bext.origination_time) + 1);
    }

    if (info.version >= 2) {
        bext.loudness_value = (int16_t)(info.loudnessValue * 100);
        bext.loudness_range = (int16_t)(info.loudnessRange * 100);
        bext.max_true_peak_level = (int16_t)(info.maxTruePeakLevel * 100);
        bext.max_momentary_loudness = (int16_t)(info.maxMomentaryLoudness * 100);
        bext.max_shortterm_loudness = (int16_t)(info.maxShortTermLoudness * 100);
    }

    bext.time_reference_low = info.timeReferenceLow;
    bext.time_reference_high = info.timeReferenceHigh;

    if (file.command(SFC_SET_BROADCAST_INFO, &bext, sizeof(bext)) == SF_FALSE) {
        const char *errorString = sf_error_number(file.error());
        printf("Line %d : sf_command (SFC_SET_BROADCAST_INFO) failed, %s \n\n", __LINE__, errorString);
        return false;
    }

    return true;
}

@end
