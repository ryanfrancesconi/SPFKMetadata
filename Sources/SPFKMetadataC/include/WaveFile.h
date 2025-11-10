// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#ifndef WAVEFILE_H
#define WAVEFILE_H

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaveFile : NSObject

@property (nullable, nonatomic) NSMutableDictionary *dictionary;
@property (nonatomic, strong, nonnull) NSString *path;

/// Convert the frame list into a NSDictionary
/// - Parameter path: the file to parse
- (nullable id)initWithPath:(nonnull NSString *)path;
- (bool)load;
- (bool)save;

@end

NS_ASSUME_NONNULL_END

#endif /* WAVEFILE_H */
