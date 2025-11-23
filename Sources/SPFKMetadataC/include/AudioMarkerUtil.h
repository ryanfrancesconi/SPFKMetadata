// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>

/// Core Audio based `AudioFileMarker` utility.
@interface AudioMarkerUtil : NSObject

/// Get RIFF markers from file
/// @param url NSURL to file
+ (NSArray *)getMarkers:(NSURL *)url;

/// Set RIFF markers in the passed in URL
/// @param url NSURL to file
/// @param markerArray array of AudioMarker
+ (BOOL)update:(NSURL *)url
       markers:(NSArray *)markers;

/// Remove all RIFF markers in file
/// @param url NSURL to the file
+ (BOOL)removeAllMarkers:(NSURL *)url;

@end
