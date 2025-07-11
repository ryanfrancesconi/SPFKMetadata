// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>

#ifndef TAGFILE_H
#define TAGFILE_H

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kTagFileTypeM4A;
extern NSString *const kTagFileTypeMP4;
extern NSString *const kTagFileTypeAAC;
extern NSString *const kTagFileTypeWAVE;
extern NSString *const kTagFileTypeAIFF;
extern NSString *const kTagFileTypeMP3;
extern NSString *const kTagFileTypeOGG;
extern NSString *const kTagFileTypeFLAC;

@interface TagFile : NSObject

@property (nullable, nonatomic) NSMutableDictionary *dictionary;

/// Convert TagLib's PropertyMap of tags into a NSDictionary
/// - Parameter path: the file to parse
- (nullable id)initWithPath:(nonnull NSString *)path;

+ (nullable NSString *)detectType:(NSString *)path;

@end

NS_ASSUME_NONNULL_END

#endif /* TAGFILE_HH */
