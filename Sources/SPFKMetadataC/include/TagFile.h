// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>
#import <tag/fileref.h>
#import <tag/tag.h>
#import <tag/tpropertymap.h>


NS_ASSUME_NONNULL_BEGIN

@interface TagFile : NSObject

@property (nullable, nonatomic) NSMutableDictionary *dictionary;

- (nullable id)initWithPath:(nonnull NSString *)path;

@end

static NSString *
wcharToString(const wchar_t *charText) {
    return [[NSString alloc] initWithBytes:charText
                                    length:wcslen(charText) * sizeof(*charText)
                                  encoding:NSUTF32LittleEndianStringEncoding];
}

NS_ASSUME_NONNULL_END
