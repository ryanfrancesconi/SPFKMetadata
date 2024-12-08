// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <CoreAudio/CoreAudio.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagLibBridge : NSObject

+ (nullable NSMutableDictionary *)getProperties:(NSString *)path;

+ (bool)setProperties:(NSString *)path
           dictionary:(NSDictionary *)dictionary;

+ (nullable NSString *)getTitle:(NSString *)path;

+ (bool)setTitle:(NSString *)path
           title:(NSString *)comment;

+ (nullable NSString *)getComment:(NSString *)path;

+ (bool)setComment:(NSString *)path
           comment:(NSString *)comment;

@end

NS_ASSUME_NONNULL_END
