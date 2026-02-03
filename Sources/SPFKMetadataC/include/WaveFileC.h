// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

#ifndef WAVEFILE_H
#define WAVEFILE_H

#import <Foundation/Foundation.h>

#include "BEXTDescriptionC.h"
#include "TagAudioPropertiesC.h"
#include "TagPicture.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaveFileC : NSObject

@property (nullable, nonatomic) TagAudioPropertiesC *audioPropertiesC;
@property (nonatomic) NSMutableDictionary *infoDictionary;
@property (nonatomic) NSMutableDictionary *id3Dictionary;
@property (nullable, nonatomic) BEXTDescriptionC *bextDescriptionC;
@property (nullable, nonatomic) NSString *iXML;
@property (nullable, nonatomic) TagPicture *tagPicture;
@property (nonatomic, strong, nonnull) NSArray *markers;

@property (nonatomic, strong, nonnull) NSString *path;

- (id)init;

/// Parse all objects from the passed in path
/// - Parameter path: the file to parse
- (id)initWithPath:(nonnull NSString *)path;
- (bool)load;
- (bool)save;

@end

NS_ASSUME_NONNULL_END

#endif /* WAVEFILE_H */
