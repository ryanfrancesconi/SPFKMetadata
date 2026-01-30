// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

#import <Foundation/Foundation.h>

#import "TagPictureRef.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagPicture : NSObject

@property (nullable, nonatomic) TagPictureRef *pictureRef;

- (nullable id)initWithPath:(nonnull NSString *)path;
- (nullable id)initWithPicture:(nonnull TagPictureRef *)pictureRef;

/// Set the picture data
+ (bool)write:(TagPictureRef *)picture
         path:(nonnull NSString *)path;

@end

NS_ASSUME_NONNULL_END
