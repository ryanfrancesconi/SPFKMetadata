// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

#ifndef WAVEFILE_H
#define WAVEFILE_H

#import <Foundation/Foundation.h>

#include "BEXTDescriptionC.h"
#include "TagPicture.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaveFileC : NSObject

@property (nullable, nonatomic) NSMutableDictionary *infoDictionary;
@property (nullable, nonatomic) NSMutableDictionary *id3Dictionary;
@property (nullable, nonatomic) BEXTDescriptionC *bextDescription;
@property (nullable, nonatomic) NSString *ixmlString;
@property (nullable, nonatomic) TagPicture *tagPicture;
@property (nonatomic, strong, nonnull) NSArray *markers;
@property (nonatomic, strong, nonnull) NSString *path;

/// Convert the frame list into a NSDictionary
/// - Parameter path: the file to parse
- (nullable id)initWithPath:(nonnull NSString *)path;
- (bool)load;
- (bool)save;

@end

NS_ASSUME_NONNULL_END

#endif /* WAVEFILE_H */
