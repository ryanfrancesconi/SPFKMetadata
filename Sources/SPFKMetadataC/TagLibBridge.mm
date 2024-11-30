// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <iomanip>
#import <iostream>
#import <stdio.h>

#import <tag/chapterframe.h>
#import <tag/fileref.h>
#import <tag/mpegfile.h>
#import <tag/rifffile.h>
#import <tag/tag.h>
#import <tag/textidentificationframe.h>
#import <tag/tfilestream.h>
#import <tag/tpropertymap.h>
#import <tag/tstring.h>
#import <tag/tstringlist.h>
#import <tag/wavfile.h>

#import "SimpleChapterFrame.h"
#import "TagFile.h"
#import "TagLibBridge.h"

#import "spfk_util.h"

using namespace std;
using namespace TagLib;

@implementation TagLibBridge

+ (nullable NSString *)getTitle:(NSString *)path
{
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return nil;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        return nil;
    }

    return [NSString stringWithUTF8String:tag->title().toCString()];
}

// convenience function to update the title tag in a file
+ (bool)setTitle:(NSString *)path
           title:(NSString *)title
{
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

    bool result = fileRef.save();
    return result;
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

    NSString *value = [NSString stringWithUTF8String:tag->comment().toCString()];

    return value;
}

// convenience function to update the comment tag in a file
+ (bool)setComment:(NSString *)path
           comment:(NSString *)comment
{
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
    bool result = fileRef.save();
    return result;
}

// MARK: -

+ (nullable NSMutableDictionary *)getProperties:(NSString *)path
{
    TagFile *tagFile = [[TagFile alloc] initWithPath:path];

    if (!tagFile) {
        return nil;
    }

    return tagFile.dictionary;
}

+ (bool)setProperties:(NSString *)path
           dictionary:(NSDictionary *)dictionary
{
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

    // these are the non standard tags
    PropertyMap tags = fileRef.file()->properties();

    for (NSString *key in [dictionary allKeys]) {
        NSString *value = [dictionary objectForKey:key];

        String tagKey = String(key.UTF8String);
        tags.replace(tagKey, StringList(value.UTF8String));
    }

    fileRef.setProperties(tags);

    return fileRef.save();
}

// MARK: -


/// Returns an array of SimpleChapterFrame
/// - Parameter path: file to open
+ (NSArray *)getMP3Chapters:(NSString *)path
{
    NSMutableArray *array = [[NSMutableArray alloc] init];

    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return nil;
    }

    MPEG::File *mpegFile = dynamic_cast<MPEG::File *>(fileRef.file());

    if (!mpegFile) {
        Util::log("getMP3Chapters: Not a MPEG File");
        return nil;
    }

    ID3v2::Tag *tag = mpegFile->ID3v2Tag();

    ID3v2::FrameList chapterList = tag->frameList("CHAP");

    for (auto it = chapterList.begin(); it != chapterList.end(); ++it) {
        ID3v2::ChapterFrame *frame = dynamic_cast<ID3v2::ChapterFrame *>(*it);

        NSTimeInterval startTime = NSTimeInterval(frame->startTime()) / 1000;
        NSTimeInterval endTime = NSTimeInterval(frame->endTime()) / 1000;

        String elementName = String(frame->elementID());

        cout << elementName << " " << startTime << " " << frame->endTime() << endl;

        const char *name = elementName.toCString();
        NSString *chapterName = Util::utf8String(name);

        SimpleChapterFrame *chapterFrame = [[SimpleChapterFrame alloc] initWithName:chapterName startTime:startTime endTime:endTime];

        [array addObject:chapterFrame];
    }

    return array;
}

// only works with mpeg files, TODO: support mp4
+ (bool)setMP3Chapters:(NSString *)path
                 array:(NSArray *)array
{
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return false;
    }

    MPEG::File *mpegFile = dynamic_cast<MPEG::File *>(fileRef.file());

    if (!mpegFile) {
        Util::log("setMP3Chapters: Not a MPEG File");
        return false;
    }

    // parse array

    // remove CHAPter tags
    mpegFile->ID3v2Tag()->removeFrames("CHAP");

    // add new CHAP tags
    ID3v2::Header header;

    for (SimpleChapterFrame *object in array) {
        ID3v2::ChapterFrame *chapter = new ID3v2::ChapterFrame(&header, "CHAP");
        chapter->setStartTime(object.startTime * 1000);
        chapter->setEndTime(object.endTime * 1000);

        String string = String(object.name.UTF8String);

        // chapter->setElementID(string.data());

        // set the chapter title
        ID3v2::TextIdentificationFrame *titleFrame = new ID3v2::TextIdentificationFrame("TIT2");
        titleFrame->setText(object.name.UTF8String);
        chapter->addEmbeddedFrame(titleFrame);
        mpegFile->ID3v2Tag()->addFrame(chapter);
    }

    bool result = mpegFile->save();
    return result;
}

@end
