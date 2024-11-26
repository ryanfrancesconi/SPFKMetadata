// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <CoreAudio/CoreAudio.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TagLibBridge : NSObject

+ (bool)setProperties:(NSString *)path
           dictionary:(NSDictionary *)dictionary;

+ (nullable NSMutableDictionary *)getProperties:(NSString *)path;

+ (nullable NSString *)getTitle:(NSString *)path;

+ (bool)setTitle:(NSString *)path
           title:(NSString *)comment;

+ (nullable NSString *)getComment:(NSString *)path;

+ (bool)setComment:(NSString *)path
           comment:(NSString *)comment;

// -

+ (nullable NSArray *)getMP3Chapters:(NSString *)path;

+ (bool)setMP3Chapters:(NSString *)path
                 array:(NSArray *)dictionary;


@end

NS_ASSUME_NONNULL_END
