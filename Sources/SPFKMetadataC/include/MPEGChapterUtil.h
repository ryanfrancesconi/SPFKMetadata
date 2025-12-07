// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPEGChapterUtil : NSObject

+ (nullable NSArray *)getChapters:(NSString *)path;

+ (bool)update:(NSString *)path
      chapters:(NSArray *)chapters;

+ (bool)removeAllChapters:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
