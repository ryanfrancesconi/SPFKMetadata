// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <iomanip>
#import <iostream>
#import <stdio.h>

#import <tag/aifffile.h>
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
        cout << "Unable to read path:" << path << endl;
        return false;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "Unable to create tag" << endl;
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
        cout << "Unable to read path:" << path << endl;
        return false;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "Unable to write tag" << endl;
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
        cout << "FileRef is NULL" << endl;
        return nil;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "Tag is NULL" << endl;
        return nil;
    }

    return @(tag->comment().toCString());
}

+ (bool)setComment:(NSString *)path
           comment:(NSString *)comment {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "Unable to read path:" << path << endl;
        return false;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "Unable to write tag" << endl;
        return false;
    }

    tag->setComment(comment.UTF8String);

    return fileRef.save();
}

+ (bool)removeAllTags:(NSString *)path {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "Unable to read path:" << path << endl;
        return false;
    }

    RIFF::WAV::File *waveFile = dynamic_cast<RIFF::WAV::File *>(fileRef.file());
    MPEG::File *mpegFile = dynamic_cast<MPEG::File *>(fileRef.file());
    MP4::File *mp4File = dynamic_cast<MP4::File *>(fileRef.file());

    // implementation for strip() is specific to each type of file

    if (waveFile) {
        waveFile->strip();
        return fileRef.save();
    } else if (mp4File) {
        return mp4File->strip();
    } else if (mpegFile) {
        return mpegFile->strip();
    }

    // unsupported file
    return false;
}

+ (bool)copyTagsFromPath:(NSString *)path
                  toPath:(NSString *)toPath {
    FileRef input(path.UTF8String);

    if (input.isNull()) {
        cout << "Unable to write comment" << endl;
        return false;
    }

    PropertyMap tags = input.file()->properties();

    if (tags.isEmpty()) {
        return true;
    }

    if (![self removeAllTags:toPath]) {
        cout << "Failed to remove tags in" << toPath << endl;
        return false;
    }

    FileRef output(toPath.UTF8String);

    if (output.isNull()) {
        cout << "Unable to read path:" << toPath << endl;
        return false;
    }

    output.tag()->setProperties(tags);

    return output.save();
}

@end
