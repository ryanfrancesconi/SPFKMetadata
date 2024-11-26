// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#include <Foundation/Foundation.h>
#include "sndfile.h"
#import "BroadcastInfo.h"

// Macro for splitting the format file of SF_INFO into container type
#define SF_CONTAINER(x) ((x) & SF_FORMAT_TYPEMASK)

NS_ASSUME_NONNULL_BEGIN

///  Wrapper on the libsndfile for simpler interchange with Swift
@interface SFFile : NSObject

/// get RIFF markers
+ (nullable NSArray *)markersWithPath:(NSString *)path;

+ (bool)updateMarkersWithPath:(NSString *)path
                      markers:(NSArray *)markers;

@end


NS_ASSUME_NONNULL_END
