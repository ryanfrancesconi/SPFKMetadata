// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import "RIFFMarker.h"
#import "SimpleAudioFileMarker.h"

@implementation RIFFMarker

#pragma mark GET

/// Get all markers in this file and return an array of `SimpleAudioFileMarker`
/// @param url URL to parse
+ (NSArray *)getMarkers:(NSURL *)url {
    AudioFileID fileID;
    CFURLRef cfurl = CFBridgingRetain(url);

    if (noErr != AudioFileOpenURL(cfurl, kAudioFileReadPermission, 0, &fileID)) {
        NSLog(@"Failed to open url %@", url);
        CFRelease(cfurl);
        return NULL;
    }

    CFRelease(cfurl);
    UInt32 propertySize;
    UInt32 writable;

    if (noErr != AudioFileGetPropertyInfo(fileID, kAudioFilePropertyMarkerList,  &propertySize, &writable)) {
        AudioFileClose(fileID);
        NSLog(@"Failed to get AudioFileID for %@", url);
        return NULL;
    }

    if (propertySize <= 0) {
        AudioFileClose(fileID);
        NSLog(@"kAudioFilePropertyMarkerList is invalid %@", url);
        return NULL;
    }

    AudioFileMarkerList *markerList = malloc(propertySize);

    if (noErr != AudioFileGetProperty(fileID,  kAudioFilePropertyMarkerList,  &propertySize, markerList) ) {
        AudioFileClose(fileID);
        NSLog(@"Failed to get kAudioFilePropertyMarkerList for %@", url);
        return NULL;
    }

    // NSLog(@"# of markers: %d\n", markerList->mNumberMarkers);

    size_t count = markerList->mNumberMarkers;

    if (count <= 0) {
        AudioFileClose(fileID);
        // NSLog(@"No markers in %@", url);
        free(markerList);
        return NULL;
    }

    AudioStreamBasicDescription format;
    UInt32 dataFormatSize = sizeof(format);

    if (noErr != AudioFileGetProperty(fileID, kAudioFilePropertyDataFormat, &dataFormatSize, &format)) {
        NSLog(@"Failed to get kAudioFilePropertyDataFormat for %@", url);
        return NULL;
    }

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    int i;

    for (i = 0; i < count; i++) {
        SimpleAudioFileMarker *safm = [[SimpleAudioFileMarker alloc] init];

        safm.markerID = markerList->mMarkers[i].mMarkerID;
        safm.type = markerList->mMarkers[i].mType;
        safm.time = markerList->mMarkers[i].mFramePosition / format.mSampleRate;
        safm.sampleRate = format.mSampleRate;

        if (markerList->mMarkers[i].mName != NULL) {
            safm.name = (__bridge NSString *)markerList->mMarkers[i].mName;
        } else {
            // create a default value in the case of missing names
            safm.name = [NSString stringWithFormat:@"Marker %d", i + 1];
        }

        // NSLog(@"%@ %lf", safm.name, safm.framePosition);

        [array addObject:safm];
    }

    free(markerList);
    AudioFileClose(fileID);

    // cast to an immutable one
    return [array copy];
}

#pragma mark SET

/// Set an array of RIFF markers in the file
/// @param url `URL` to set markers in
/// @param markerArray `[SimpleAudioFileMarker]`
+ (BOOL)update:(NSURL *)url
       markers:(NSArray *)markers {
    AudioFileID fileID;
    CFURLRef cfurl = CFBridgingRetain(url);

    if (noErr != AudioFileOpenURL(cfurl, kAudioFileReadWritePermission, 0, &fileID)) {
        NSLog(@"Failed to open url %@", url);
        CFRelease(cfurl);
        return NO;
    }

    CFRelease(cfurl);

    size_t count = markers.count;
    UInt32 propertySize = (UInt32)NumAudioFileMarkersToNumBytes(count);

    if (propertySize <= 0) {
        AudioFileClose(fileID);
        NSLog(@"NumAudioFileMarkersToNumBytes is invalid %@", url);
        return NO;
    }

    // NSLog(@"NumAudioFileMarkersToNumBytes %i", propertySize);

    AudioFileMarkerList *markerList = malloc(propertySize);

    for (int i = 0; i < count; i++) {
        SimpleAudioFileMarker *safm = (SimpleAudioFileMarker *)[markers objectAtIndex:i];

        AudioFileMarker afm = {};
        afm.mName = (__bridge CFStringRef)safm.name;
        afm.mFramePosition = safm.time * safm.sampleRate;
        afm.mMarkerID = i;
        afm.mType = safm.type;

        NSLog(@"Adding marker: %@ %f %d %d\n", afm.mName, afm.mFramePosition, afm.mMarkerID, afm.mType);

        markerList->mMarkers[i] = afm;
    }

    markerList->mNumberMarkers = (UInt32)count;

    // NSLog(@"markerList->mNumberMarkers %i", markerList->mNumberMarkers);

    if (noErr != AudioFileSetProperty(fileID,  kAudioFilePropertyMarkerList, propertySize, markerList)) {
        NSLog(@"Failed to set kAudioFilePropertyMarkerList for %@", url);
    }

    free(markerList);
    AudioFileClose(fileID);

    return YES;
}

#pragma mark REMOVE

+ (BOOL)removeAll:(NSURL *)url {
    AudioFileID fileID;
    CFURLRef cfurl = CFBridgingRetain(url);

    if (noErr != AudioFileOpenURL(cfurl, kAudioFileReadWritePermission,  0, &fileID)) {
        NSLog(@"Failed to open url %@", url);
        CFRelease(cfurl);
        return NO;
    }

    CFRelease(cfurl);

    UInt32 propertySize = (UInt32)NumAudioFileMarkersToNumBytes(0);
    AudioFileMarkerList *markerList = malloc(propertySize);
    markerList->mNumberMarkers = 0;

    if (noErr != AudioFileSetProperty(fileID,
                                      kAudioFilePropertyMarkerList,
                                      propertySize,
                                      markerList)) {
        NSLog(@"AudioFileStreamSetProperty kAudioFilePropertyMarkerList failed");
        AudioFileClose(fileID);
        return NO;
    }

    free(markerList);
    AudioFileClose(fileID);
    return YES;
}

@end
