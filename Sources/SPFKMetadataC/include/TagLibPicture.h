// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>

#import "TagPictureRef.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagLibPicture : NSObject

+ (nullable TagPictureRef *)getPicture:(NSString *)path;

+ (bool)setPicture:(TagPictureRef *)picture
              path:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
