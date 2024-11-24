
#import <CoreAudio/CoreAudio.h>
#import <Foundation/Foundation.h>

#import "sndfile.h"
#import "TagFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagLibBridge : NSObject

    extern NSString * const kFileTypeM4A;
extern NSString *const kFileTypeAAC;
extern NSString *const kFileTypeWAVE;
extern NSString *const kFileTypeAIFF;
extern NSString *const kFileTypeMP3;

+ (nullable NSString *)getTitle:(NSString *)path;

+ (bool)setTitle:(NSString *)path
           title:(NSString *)comment;

+ (nullable NSString *)getComment:(NSString *)path;

+ (bool)setComment:(NSString *)path
           comment:(NSString *)comment;

+ (nullable NSMutableDictionary *)parseMetadata:(NSString *)path;

+ (bool)setMetadata:(NSString *)path
         dictionary:(NSDictionary *)dictionary;

+ (nullable NSMutableDictionary *)parseProperties:(NSString *)path;

+ (nullable NSArray *)getMP3Chapters:(NSString *)path;

+ (bool)setMP3Chapters:(NSString *)path
                 array:(NSArray *)dictionary;

+ (nullable NSString *)detectFileType:(NSString *)path;
+ (nullable NSString *)detectStreamType:(NSString *)path;


@end

NS_ASSUME_NONNULL_END
