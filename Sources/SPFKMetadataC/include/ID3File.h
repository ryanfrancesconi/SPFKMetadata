// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

#import <Foundation/Foundation.h>

#ifndef ID3FILE_H
#define ID3FILE_H

NS_ASSUME_NONNULL_BEGIN

/// To be used when you need to parse all frames from an ID3 tag,
/// not just the standard Tag ones that TagLib returns in its properties
@interface ID3File : NSObject

@property (nullable, nonatomic) NSMutableDictionary *dictionary;
@property (nonatomic, strong, nonnull) NSString *path;
@property (nonatomic, strong, nullable) NSString *fileType;

/// Convert the frame list into a NSDictionary
/// - Parameter path: the file to parse
- (id)initWithPath:(nonnull NSString *)path;
- (bool)load;
- (bool)save;

@end

NS_ASSUME_NONNULL_END

#endif /* ID3FILE_H */
