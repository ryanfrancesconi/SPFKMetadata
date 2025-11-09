
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// For swift interop
typedef NSString *const TagFileTypeDef NS_TYPED_ENUM;

extern TagFileTypeDef kTagFileTypeAac;
extern TagFileTypeDef kTagFileTypeAiff;
extern TagFileTypeDef kTagFileTypeFlac;
extern TagFileTypeDef kTagFileTypeM4a;
extern TagFileTypeDef kTagFileTypeMp3;
extern TagFileTypeDef kTagFileTypeMp4;
extern TagFileTypeDef kTagFileTypeOpus;
extern TagFileTypeDef kTagFileTypeVorbis;
extern TagFileTypeDef kTagFileTypeWave;

@interface TagFileType : NSObject

/// Detect the file type based on the path. Will parse the header
/// if there is no file extension
+ (nullable TagFileTypeDef)detectType:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
