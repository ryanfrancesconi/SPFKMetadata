// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#ifndef TAGFILE_H
#define TAGFILE_H

#import <Foundation/Foundation.h>
#import "TagAudioPropertiesC.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagFile : NSObject

@property (nullable, nonatomic) NSDictionary *dictionary;
@property (nonatomic, strong, nonnull) NSString *path;
@property (nullable, nonatomic) TagAudioPropertiesC *audioProperties;

/// Convert the frame list into a NSDictionary
/// - Parameter path: the file to parse
- (id)initWithPath:(nonnull NSString *)path;

- (bool)load;
- (bool)save;

+ (bool)write:(nonnull NSDictionary *)dictionary path:(nonnull NSString *)path;

@end

NS_ASSUME_NONNULL_END

#endif /* TAGFILE_H */
