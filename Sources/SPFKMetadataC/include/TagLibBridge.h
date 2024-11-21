
#import <CoreAudio/CoreAudio.h>
#import <Foundation/Foundation.h>

#import "sndfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagLibBridge : NSObject

    extern NSString * const kTaglibWrapperFileTypeM4A;
extern NSString *const kTaglibWrapperFileTypeAAC;
extern NSString *const kTaglibWrapperFileTypeWAVE;
extern NSString *const kTaglibWrapperFileTypeAIFF;
extern NSString *const kTaglibWrapperFileTypeMP3;

+ (nullable NSString *)getTitle:(NSString *)path;

+ (bool)setTitle:(NSString *)path
           title:(NSString *)comment;

+ (nullable NSString *)getComment:(NSString *)path;

+ (bool)setComment:(NSString *)path
           comment:(NSString *)comment;

+ (nullable NSMutableDictionary *)parseMetadata:(NSString *)path;

+ (bool)setMetadata:(NSString *)path
         dictionary:(NSDictionary *)dictionary;


+ (nullable NSArray *)getMP3Chapters:(NSString *)path;

+ (bool)setMP3Chapters:(NSString *)path
                 array:(NSArray *)dictionary;

+ (nullable NSString *)detectFileType:(NSString *)path;

+ (nullable NSString *)detectStreamType:(NSString *)path;



@end

NS_ASSUME_NONNULL_END
