// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>
#import <iostream>

#import <tag/aifffile.h>
#import <tag/fileref.h>
#import <tag/flacfile.h>
#import <tag/id3v2tag.h>
#import <tag/mp4file.h>
#import <tag/mpegfile.h>
#import <tag/oggfile.h>
#import <tag/oggflacfile.h>
#import <tag/opusfile.h>
#import <tag/privateframe.h>
#import <tag/rifffile.h>
#import <tag/tag.h>
#import <tag/tfilestream.h>
#import <tag/tpropertymap.h>
#import <tag/vorbisfile.h>
#import <tag/wavfile.h>

#import "StringUtil.h"
#import "TagFile.h"

@implementation TagFile

using namespace std;
using namespace TagLib;

- (nullable id)initWithPath:(nonnull NSString *)path {
    self = [super init];

    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return NULL;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        return NULL;
    }

    _dictionary = [[NSMutableDictionary alloc] init];

    PropertyMap properties = tag->properties();

    if (properties.isEmpty()) {
        return self;
    }

    // Copy TagLib's PropertyMap into our dictionary using the same keys they use.
    // See TagKey for translations.

    for (const auto &property : properties) {
        const char *ckey = property.first.toCString();
        String cval = property.second.toString();

        // cout << ckey << " = " << cval << endl;

        NSString *key = @(ckey);
        NSString *object = @(cval.toCString()) ? : @"";

        if (key != nil && object != nil) {
            [_dictionary setValue:object forKey:key];
        }
    }

    return self;
}

+ (bool)write:(nonnull NSDictionary *)dictionary path:(nonnull NSString *)path {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "Unable to read path:" << path.UTF8String << endl;
        return false;
    }

    PropertyMap tags = PropertyMap();

    for (NSString *key in [dictionary allKeys]) {
        NSString *value = [dictionary objectForKey:key];

        String tagKey = String(key.UTF8String);
        StringList tagValue = StringList(value.UTF8String);

        tags.insert(tagKey, tagValue);
    }

    tags.removeEmpty();
    fileRef.setProperties(tags);

    return fileRef.save();
}

@end
