// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import "TagFile.h"

#import <tag/fileref.h>
#import <tag/tag.h>
#import <tag/tpropertymap.h>

@implementation TagFile

using namespace TagLib;

- (nullable id)initWithPath:(nonnull NSString *)path {
    self = [super init];

    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return nil;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        return nil;
    }

    PropertyMap tags = fileRef.file()->properties();

    if (tags.isEmpty()) {
        return nil;
    }

    _dictionary = [[NSMutableDictionary alloc] init];

    // Copy TagLib's properties() into our NSMutableDictionary using the same key
    for (auto i = tags.begin(); i != tags.end(); ++i) {
        for (auto j = i->second.begin(); j != i->second.end(); ++j) {
            //
            const char *ckey = i->first.toCString();
            const char *cobject = j->toCString();

            NSString *key = [[NSString alloc] initWithCString:ckey encoding:NSUTF8StringEncoding];
            NSString *object = [[NSString alloc] initWithCString:cobject encoding:NSUTF8StringEncoding];

            if (key != nil && object != nil) {
                [_dictionary setValue:object ? : @"" forKey:key];
            }
        }
    }

    return self;
}

@end
