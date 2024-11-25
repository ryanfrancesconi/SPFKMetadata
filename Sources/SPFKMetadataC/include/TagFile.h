// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>

#ifndef TAGFILE_H
#define TAGFILE_H

NS_ASSUME_NONNULL_BEGIN

@interface TagFile : NSObject

@property (nullable, nonatomic) NSMutableDictionary *dictionary;

- (nullable id)initWithPath:(nonnull NSString *)path;

@end


NS_ASSUME_NONNULL_END

#endif /* TAGFILE_HH */
