// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <CoreAudio/CoreAudio.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagLibBridge : NSObject

/// get all tags as a dictionary translation of TagLib's Property Map
+ (nullable NSMutableDictionary *)getProperties:(NSString *)path;

+ (bool)setProperties:(NSString *)path
           dictionary:(NSDictionary *)dictionary;

+ (nullable NSString *)getTitle:(NSString *)path;

/// convenience to update the title tag
+ (bool)setTitle:(NSString *)path
           title:(NSString *)comment;

+ (nullable NSString *)getComment:(NSString *)path;

/// convenience to update the comment tag
+ (bool)setComment:(NSString *)path
           comment:(NSString *)comment;

+ (bool)removeAllTags:(NSString *)path;

+ (bool)copyTagsFromPath:(NSString *)path
                  toPath:(NSString *)toPath;

@end

NS_ASSUME_NONNULL_END
