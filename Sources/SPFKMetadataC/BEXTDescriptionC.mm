// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>
#import "BEXTDescriptionC.h"
#import "sndfile.hh"
#import "StringUtil.h"

@implementation BEXTDescriptionC

using namespace std;

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

    _version = bext.version;
    _codingHistory = @(bext.coding_history);

    if (_version >= 2) {
        // A 16-bit signed integer, equal to round(100x the Integrated Loudness Value of the file in LUFS).
        _loudnessValue = ((float)bext.loudness_value) / 100;

        // A 16-bit signed integer, equal to round(100x the Loudness Range of the file in LU).
        _loudnessRange = ((float)bext.loudness_range) / 100;

        // A 16-bit signed integer, equal to round(100x the Maximum True Peak Value of the file in dBTP).
        _maxTruePeakLevel = ((float)bext.max_true_peak_level) / 100;

        // A 16-bit signed integer, equal to round(100x the highest value of the Momentary Loudness Level of the file in LUFS).
        _maxMomentaryLoudness = ((float)bext.max_momentary_loudness) / 100;

        // A 16-bit signed integer, equal to round(100x the highest value of the Short-term Loudness Level of the file in LUFS).
        _maxShortTermLoudness = ((float)bext.max_shortterm_loudness) / 100;
    }

    _sequenceDescription = StringUtil::asciiString(bext.description, sizeof(bext.description));
    _originator = StringUtil::asciiString(bext.originator, sizeof(bext.originator));
    _originationDate = StringUtil::asciiString(bext.origination_date, sizeof(bext.origination_date));
    _originationTime =  StringUtil::asciiString(bext.origination_time, sizeof(bext.origination_time));
    _originatorReference = StringUtil::asciiString(bext.originator_reference, sizeof(bext.originator_reference));

    _timeReferenceLow = (uint32_t)bext.time_reference_low;
    _timeReferenceHigh = (uint32_t)bext.time_reference_high;

    // read only properties
    _timeReference = (uint64_t(self.timeReferenceHigh) << 32) | self.timeReferenceLow;
    _sampleRate = double(file.samplerate());
    _timeReferenceInSeconds = double(self.timeReference) / self.sampleRate;

    if (_version >= 1) {
        char hexid[2] = {};

        // Calculate the actual size of the array [64]
        int length = MAX(64, sizeof(bext.umid) / sizeof(bext.umid[0]));

        std::string buffer;

        for (int i = 0; i < length; i++) {
            // Convert the char array to 2 digit hex
            buffer += StringUtil::charToHexString(bext.umid[i]);
        }

        _umid = StringUtil::utf8NSString(buffer);
    }

    return self;
}

+ (bool)write:(BEXTDescriptionC *)info
         path:(nonnull NSString *)path {
    //
    SndfileHandle file = SndfileHandle(path.UTF8String, SFM_RDWR);
    SF_BROADCAST_INFO bext = {};

    memset(&bext, 0, sizeof(bext));

    bext.version = info.version;

    const char *umid = StringUtil::asciiCString(info.umid);
    const char *codingHistory = StringUtil::asciiCString(info.codingHistory);
    const char *sequenceDescription = StringUtil::asciiCString(info.sequenceDescription);
    const char *originator = StringUtil::asciiCString(info.originator);
    const char *originatorReference = StringUtil::asciiCString(info.originatorReference);
    const char *originationDate = StringUtil::asciiCString(info.originationDate);
    const char *originationTime = StringUtil::asciiCString(info.originationTime);

    if (codingHistory) {
        size_t chsize = StringUtil::strncpy_validate(bext.coding_history, codingHistory, sizeof(bext.coding_history));
        bext.coding_history_size = (uint32_t)chsize;
    }

    if (info.version >= 1 && umid) {
        StringUtil::strncpy_pad0(bext.umid, umid, sizeof(bext.umid), true);
    }

    if (sequenceDescription) {
        StringUtil::strncpy_validate(bext.description, sequenceDescription, sizeof(bext.description));
    }

    if (originator) {
        StringUtil::strncpy_validate(bext.originator, originator, sizeof(bext.originator));
    }

    if (originatorReference) {
        StringUtil::strncpy_validate(bext.originator_reference, originatorReference, sizeof(bext.originator_reference));
    }

    if (originationDate) {
        StringUtil::strncpy_pad0(bext.origination_date, originationDate, sizeof(bext.origination_date), false);
    }

    if (originationTime) {
        StringUtil::strncpy_pad0(bext.origination_time, originationTime, sizeof(bext.origination_time), false);
    }

    if (bext.version >= 2) {
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
