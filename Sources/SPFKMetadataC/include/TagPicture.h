// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

#import <Foundation/Foundation.h>

#import "TagPictureRef.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagPicture : NSObject

@property (nullable, nonatomic) TagPictureRef *pictureRef;

- (nullable id)initWithPath:(nonnull NSString *)path;

/// Set the Broadcast Extension Chunk for WAV (and related) files.
+ (bool)write:(TagPictureRef *)picture
         path:(nonnull NSString *)path;

@end

NS_ASSUME_NONNULL_END
