// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudio.h>
#import <Foundation/Foundation.h>

/// Core Audio based `AudioFileMarker` utility.
@interface RIFFMarker : NSObject

/// Get RIFF markers from file
/// @param url NSURL to file
+ (NSArray *)getMarkers:(NSURL *)url;

/// Set RIFF markers in the passed in URL
/// @param url NSURL to file
/// @param markerArray array of SimpleAudioFileMarker
+ (BOOL)update:(NSURL *)url
       markers:(NSArray *)markers;


/// Remove all RIFF markers in file
/// @param url NSURL to the file
+ (BOOL)removeAll:(NSURL *)url;

@end
