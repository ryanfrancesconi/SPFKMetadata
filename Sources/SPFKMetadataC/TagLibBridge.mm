// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <iomanip>
#import <iostream>
#import <stdio.h>

#import <tag/fileref.h>
#import <tag/mp4file.h>
#import <tag/mpegfile.h>
#import <tag/rifffile.h>
#import <tag/tag.h>
#import <tag/textidentificationframe.h>
#import <tag/tfilestream.h>
#import <tag/tpropertymap.h>
#import <tag/tstring.h>
#import <tag/tstringlist.h>
#import <tag/wavfile.h>

#import "ChapterMarker.h"
#import "TagFile.h"
#import "TagLibBridge.h"

#import "spfk_util.h"

using namespace std;
using namespace TagLib;

@implementation TagLibBridge

+ (nullable NSMutableDictionary *)getProperties:(NSString *)path {
    TagFile *tagFile = [[TagFile alloc] initWithPath:path];

    if (!tagFile) {
        return nil;
    }

    return tagFile.dictionary;
}

+ (bool)setProperties:(NSString *)path
           dictionary:(NSDictionary *)dictionary {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        Util::log("__C Error: FileRef.isNull: Unable to open file");
        return false;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        Util::log("__C Unable to create tag");
        return false;
    }

    PropertyMap tags = fileRef.file()->properties();

    for (NSString *key in [dictionary allKeys]) {
        NSString *value = [dictionary objectForKey:key];

        String tagKey = String(key.UTF8String);

        tags.replace(tagKey, StringList(value.UTF8String));
    }

    fileRef.setProperties(tags);

    return fileRef.save();
}

+ (nullable NSString *)getTitle:(NSString *)path {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return nil;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        return nil;
    }

    return @(tag->title().toCString());
}

+ (bool)setTitle:(NSString *)path
           title:(NSString *)title {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        Util::log("__C Unable to write title");
        return false;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        Util::log("__C Unable to write tag");
        return false;
    }

    tag->setTitle(title.UTF8String);

    // also duplicate the data into the INFO tag if it's a wave file
    RIFF::WAV::File *waveFile = dynamic_cast<RIFF::WAV::File *>(fileRef.file());

    // also set InfoTag for wave
    if (waveFile) {
        waveFile->InfoTag()->setTitle(title.UTF8String);
    }

    return fileRef.save();
}

+ (nullable NSString *)getComment:(NSString *)path
{
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        Util::log("__C FileRef is NULL");
        return nil;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        Util::log("__C Tag is NULL");
        return nil;
    }

    return @(tag->comment().toCString());
}

// convenience function to update the comment tag in a file
+ (bool)setComment:(NSString *)path
           comment:(NSString *)comment {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        Util::log("__C Unable to write comment");
        return false;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        Util::log("__C Unable to write tag");
        return false;
    }

    tag->setComment(comment.UTF8String);

    return fileRef.save();
}

@end
