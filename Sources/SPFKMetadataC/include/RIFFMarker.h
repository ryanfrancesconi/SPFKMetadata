// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudio.h>
#import <Foundation/Foundation.h>

@interface RIFFMarker : NSObject

/// Get RIFF markers from file
/// @param url NSURL to file
+ (NSArray *)getAudioFileMarkers:(NSURL *)url;

/// Set RIFF markers in the passed in URL
/// @param url NSURL to file
/// @param markerArray array of SimpleAudioFileMarker
+ (BOOL)setAudioFileMarkers:(NSURL *)url
                    markers:(NSArray *)markers;


/// Remove all RIFF markers in file
/// @param url NSURL to the file
+ (BOOL)removeAllAudioFileMarkers:(NSURL *)url;

@end
