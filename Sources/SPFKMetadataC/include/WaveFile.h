// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>

#ifndef WAVEFILE_H
#define WAVEFILE_H

NS_ASSUME_NONNULL_BEGIN

@interface WaveFile : NSObject

@property (nullable, nonatomic) NSMutableDictionary *dictionary;

/// Convert the wave INFO chunks into a NSDictionary
/// - Parameter path: the file to parse
- (nullable id)initWithPath:(nonnull NSString *)path;

@end

NS_ASSUME_NONNULL_END

#endif /* WAVEFILE_H */
