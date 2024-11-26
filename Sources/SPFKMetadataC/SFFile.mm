// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import "sndfile.hh"
#import "spfk_util.h"
#import "SFFile.h"
#import "SimpleMarker.h"

@implementation SFFile

+ (int)format:(nonnull NSString *)path {
    SndfileHandle file = SndfileHandle(path.UTF8String);

    return file.format(); //SF_CONTAINER(file.format());
}

+ (SF_BROADCAST_INFO)broadcastInfoWithPath:(nonnull NSString *)path {
    SndfileHandle file = SndfileHandle(path.UTF8String);

    SF_BROADCAST_INFO bext = {};

    // SF_TRUE if the file contained a Broadcast Extension chunk or SF_FALSE otherwise
    if (file.command(SFC_GET_BROADCAST_INFO, &bext,  sizeof(bext)) != SF_TRUE) {
        //return SF_NULL;
    }

    return bext;
}

+ (nullable NSArray *)markersWithPath:(nonnull NSString *)path {
    SndfileHandle file = SndfileHandle(path.UTF8String);

    double sampleRate = double(file.samplerate());

    SF_CUES cues = {};

    if (file.command(SFC_GET_CUE_COUNT, &cues.cue_count,  sizeof(cues.cue_count)) != SF_TRUE) {
        return nil;
    }

    file.command(SFC_GET_CUE, &cues,  sizeof(cues));

    return cuesToMarkers(cues, sampleRate);
}

NSArray *
cuesToMarkers(SF_CUES cues, double sampleRate) {
    NSMutableArray *markers = [[NSMutableArray alloc] initWithCapacity:cues.cue_count];

    for (int i = 0; i < cues.cue_count; i++) {
        SF_CUE_POINT marker = cues.cue_points[i];

        NSString *name = Util::utf8String(marker.name);
        uint32_t position = marker.position;
        double time = double(position) / sampleRate;

        SimpleMarker *simpleMarker = [SimpleMarker alloc];
        simpleMarker.name = name;
        simpleMarker.time = time;

        if (name.length > 0) {
            [markers addObject:simpleMarker];

            // std::cout << name.UTF8String << " @ time:" << time << std::endl;
        }
    }

    return markers;
}

SF_CUES
markersToCues(NSArray *markers, double sampleRate) {
    SF_CUES cues = {};

    cues.cue_count = uint32_t(markers.count);

    for (int i = 0; i < markers.count; i++) {
        SimpleMarker *smarker = [markers objectAtIndex:i];

        uint32_t position = uint32_t(smarker.time * sampleRate);

        strcpy(cues.cue_points[i].name, smarker.name.UTF8String);
        cues.cue_points[i].position = position;
        cues.cue_points[i].indx = i;
    }

    return cues;
}

+ (bool)updateMarkersWithPath:(nonnull NSString *)path markers:(nonnull NSArray *)markers {
    SndfileHandle file = SndfileHandle(path.UTF8String);
    double sampleRate = double(file.samplerate());

    SF_CUES cues;



    // erase all cues
//    if (file.command(SFC_SET_CUE, &cues, sizeof(cues)) != SF_TRUE) {
//        return false;
//    }

    cues = markersToCues(markers, sampleRate);

    if (file.command(SFC_SET_CUE, &cues, sizeof(cues)) != SF_TRUE) {
        return false;
    }

    return true;
}

@end
