// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import "BroadcastInfo.h"
#import "../sndfile.hh"
#import "../spfk_util.h"
#import "SFFile.h"
#import "SFMarker.h"

/* calculate size of SF_CUES struct given number of cues */
#define SF_CUES_SIZE(count) (sizeof(uint32_t) + sizeof(SF_CUE_POINT) * (count))
#define    BUFFER_LEN 4096

@implementation SFFile

+ (nullable NSArray *)markersWithPath:(nonnull NSString *)path {
    SndfileHandle file = SndfileHandle(path.UTF8String, SFM_READ);

    double sampleRate = double(file.samplerate());

    SF_CUES cues = {};

    if (file.command(SFC_GET_CUE_COUNT, &cues.cue_count,  sizeof(cues.cue_count)) == SF_FALSE) {
        return nil;
    }

    if (file.command(SFC_GET_CUE, &cues, sizeof(cues)) == SF_FALSE) {
        return nil;
    }

    return cuesToMarkers(cues, sampleRate);
}

// not working
+ (BOOL)removeAllMarkersWithPath:(nonnull NSString *)path {
    const char *cpath = path.UTF8String;
    SndfileHandle file = SndfileHandle(cpath, SFM_RDWR);

    SF_CUES cues = {};

    if (file.command(SFC_SET_CUE, &cues, sizeof(cues)) != SF_TRUE) {
        return NO;
    }

    if (file.command(SFC_UPDATE_HEADER_NOW, NULL, 0) != SF_TRUE) {
        return NO;
    }
}

// not quite working
+ (BOOL)updateMarkersWithPath:(nonnull NSString *)path
//                       output:(nonnull NSString *)outputPath
                      markers:(nonnull NSArray *)markers {//
    SndfileHandle inputFile = SndfileHandle(path.UTF8String, SFM_READ);
    int samplerate = inputFile.samplerate();
    int format = inputFile.format();
    int channels = inputFile.channels();

    NSURL *inputURL = [[NSURL alloc] initFileURLWithPath:path];
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:path];

    outputURL = [outputURL URLByDeletingLastPathComponent];
    outputURL = [outputURL URLByAppendingPathComponent:@"temp.wav"];

    SndfileHandle outputFile = SndfileHandle(outputURL.path.UTF8String, SFM_WRITE, format, channels, samplerate);

    SF_CUES cues = markersToCues(markers, double(outputFile.samplerate()));

    if (outputFile.command(SFC_SET_CUE, &cues, sizeof(cues)) != SF_TRUE) {
        const char *errorString = sf_error_number(outputFile.error());
        printf("Line %d : sf_command (SFC_SET_CUE) failed setting %d cues, %s \n\n", __LINE__, cues.cue_count, errorString);
        return NO;
    }

    sfe_copy_data_int(outputFile.rawHandle(), inputFile.rawHandle(), channels);

    NSError *error;
    [NSFileManager.defaultManager removeItemAtURL:inputURL error:&error];

    [NSFileManager.defaultManager moveItemAtURL:outputURL toURL:inputURL error:&error];

    printf("Success: [%s] updated\n", path.UTF8String);

    return YES;
}

// MARK: - Helpers



NSArray *
cuesToMarkers(SF_CUES cues, double sampleRate) {
    NSMutableArray *markers = [[NSMutableArray alloc] initWithCapacity:cues.cue_count];

    for (int i = 0; i < cues.cue_count; i++) {
        SF_CUE_POINT cuePoint = cues.cue_points[i];

        NSString *name = Util::utf8String(cuePoint.name);
        uint32_t position = cuePoint.position;

        double time = double(position) / sampleRate;

        SFMarker *simpleMarker = [[SFMarker alloc] initWithName:name time:time];
        [markers addObject:simpleMarker];

        //if (name.length > 0) {
        // std::cout << name.UTF8String << " @ time:" << time << std::endl;
        //}
    }

    return markers;
}

SF_CUES
markersToCues(NSArray *markers, double sampleRate) {
    SF_CUES cues;

    memset(&cues, 0, sizeof(cues));

    uint32_t count = uint32_t(markers.count);

    cues.cue_count = MIN(100, count);

    for (int i = 0; i < cues.cue_count; i++) {
        SFMarker *smarker = [markers objectAtIndex:i];

        uint32_t position = uint32_t(smarker.time * sampleRate);
        const char *name = smarker.name.UTF8String;

        size_t maxlength = sizeof(cues.cue_points[i].name) - 1;

        cues.cue_points[i].indx = i;
        cues.cue_points[i].position = position;
        cues.cue_points[i].sample_offset = position;
        cues.cue_points[i].fcc_chunk = 0;
        psf_strlcpy(cues.cue_points[i].name, sizeof(cues.cue_points[i].name), name);
    }

    return cues;
}

void
psf_strlcpy(char *dest, size_t n, const char *src) {
    strncpy(dest, src, n - 1);
    dest [n - 1] = 0;
} /* psf_strlcpy */

static void
sfe_copy_data_int(SNDFILE *outfile, SNDFILE *infile, int channels) {
    static int data [BUFFER_LEN];
    int frames, readcount;

    frames = BUFFER_LEN / channels;
    readcount = frames;

    while (readcount > 0) {
        readcount = (int)sf_readf_int(infile, data, frames);
        sf_writef_int(outfile, data, readcount);
    }

    return;
}

@end
