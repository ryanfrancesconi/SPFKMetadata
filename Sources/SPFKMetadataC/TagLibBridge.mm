// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <iomanip>
#import <iostream>
#import <stdio.h>

#import <tag/chapterframe.h>
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
/// ID3v2 only currently
+ (NSArray *)getMP3Chapters:(NSString *)path
{
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return nil;
    }

    MPEG::File *file = dynamic_cast<MPEG::File *>(fileRef.file());

    if (!file || !file->hasID3v2Tag()) {
        Util::log("getMP3Chapters: Not a MPEG File or no ID3v2 tag");
        return nil;
    }

    ID3v2::Tag *tag = file->ID3v2Tag();
    ID3v2::FrameList chapterList = tag->frameList("CHAP");

    NSMutableArray *array = [[NSMutableArray alloc] init];

    for (auto it = chapterList.begin(); it != chapterList.end(); ++it) {
        ID3v2::ChapterFrame *frame = dynamic_cast<ID3v2::ChapterFrame *>(*it);

        NSTimeInterval startTime = NSTimeInterval(frame->startTime()) / 1000;
        NSTimeInterval endTime = NSTimeInterval(frame->endTime()) / 1000;

        // placeholder for title
        String elementName = String(frame->elementID());

        cout << elementName << " " << startTime << " " << frame->endTime() << endl;

        const char *name = elementName.toCString();
        NSString *chapterName = Util::utf8String(name);

        const ID3v2::FrameList &embeddedFrames = frame->embeddedFrameList();

        if (!embeddedFrames.isEmpty()) {
            // Look for a title frame in the chapter, if found use that for the title
            for (auto it = frame->embeddedFrameList().begin(); it != frame->embeddedFrameList().end(); ++it) {
                auto tit2Frame = dynamic_cast<const ID3v2::TextIdentificationFrame *>(*it);

                // cout << tit2Frame->frameID() << endl;

                if (tit2Frame->frameID() == "TIT2") {
                    chapterName = Util::utf8String(tit2Frame->toString().toCString());
                }
            }
        }

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

    mpegFile->ID3v2Tag()->removeFrames("CHAP");

    // add new CHAP tags
    ID3v2::Header header;

    for (SimpleChapterFrame *object in array) {
        ID3v2::ChapterFrame *chapter = new ID3v2::ChapterFrame(&header, "CHAP");
        chapter->setStartTime(object.startTime * 1000);
        chapter->setEndTime(object.endTime * 1000);

        const char *cname = object.name.UTF8String;
        String string = String(cname);
        chapter->setElementID(string.data(String::Type::UTF8));

        // set the chapter title
        ID3v2::TextIdentificationFrame *titleFrame = new ID3v2::TextIdentificationFrame("TIT2");
        titleFrame->setText(cname);
        chapter->addEmbeddedFrame(titleFrame);
        mpegFile->ID3v2Tag()->addFrame(chapter);
    }

    return mpegFile->save();
}

+ (bool)removeMP3Chapters:(NSString *)path {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return false;
    }

    MPEG::File *mpegFile = dynamic_cast<MPEG::File *>(fileRef.file());

    if (!mpegFile) {
        Util::log("removeMP3Chapters: Not a MPEG File");
        return false;
    }

    mpegFile->ID3v2Tag()->removeFrames("CHAP");

    return mpegFile->save();
}

#pragma mark - experimental

+ (NSArray *)getMP4Chapters:(NSString *)path {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return nil;
    }

    MP4::File *file = dynamic_cast<MP4::File *>(fileRef.file());

    if (!file || !file->hasMP4Tag()) {
        Util::log("getMP4Chapters: Not a MP4 File or no MP4 tag");
        return nil;
    }

    MP4::Tag *tag = file->tag();
    PropertyMap tags = tag->properties();

//    for (auto i = tags.begin(); i != tags.end(); ++i) {
//        for (auto j = i->second.begin(); j != i->second.end(); ++j) {
//
//            cout << i->first.toCString() << "=" << j->toCString() << endl;
//        }
//    }
    

    MP4::ItemMap items = tag->itemMap();

    StringList list = tag->complexPropertyKeys();

    if (!list.isEmpty()) {
        for (auto it = list.begin(); it != list.end(); ++it) {
//            String key = (*it).first;
//            MP4::Item value = (*it).second;

            cout << (*it) << endl;
            
            // cout << key << "=" << value.toStringList() << endl;
        }
    }

    NSMutableArray *array = [[NSMutableArray alloc] init];

    return array;
}

@end
