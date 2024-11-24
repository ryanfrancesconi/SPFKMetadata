//  TagLibBridge.mm
//  Created by Ryan Francesconi on 1/2/19.
//  Copyright © 2019 Ryan Francesconi. All rights reserved.

#include <iomanip>
#include <iostream>
#include <stdio.h>

#import <tag/aifffile.h>
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

#import "TagLibBridge.h"
#import "TagFile.h"

using namespace std;
using namespace TagLib;

@implementation TagLibBridge

NSString *const kFileTypeMP3 = @"mp3";
NSString *const kFileTypeM4A = @"m4a";
NSString *const kFileTypeAAC = @"aac";
NSString *const kFileTypeWAVE = @"wav";
NSString *const kFileTypeAIFF = @"aif";

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

    NSString *value = [NSString stringWithUTF8String:tag->title().toCString()];
    return value;
}

// convenience function to update the title tag in a file
+ (bool)setTitle:(NSString *)path
           title:(NSString *)title
{
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "__C Unable to write title" << endl;
        return false;
    }

    cout << "__C Updating title to: " << title.UTF8String << endl;
    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "__C Unable to write tag" << endl;
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
        cout << "__C FileRef is NULL " << path.UTF8String << endl;
        return nil;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "__C Tag is NULL" << endl;
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
        cout << "__C Unable to write comment" << endl;
        return false;
    }

    cout << "__C Updating comment to: " << comment.UTF8String << endl;
    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "__C Unable to write tag" << endl;
        return false;
    }

    tag->setComment(comment.UTF8String);
    bool result = fileRef.save();
    return result;
}

+ (nullable NSMutableDictionary *)parseMetadata:(NSString *)path
{
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "__C fileRef is NULL " << path.UTF8String << endl;
        return nil;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "__C Unable to create Tag " << path << endl;
        return nil;
    }

    NSString *title = wcharToString(tag->title().toCWString());
    NSString *artist = wcharToString(tag->artist().toCWString());
    NSString *album = wcharToString(tag->album().toCWString());
    NSString *comment = wcharToString(tag->comment().toCWString());
    NSString *genre = wcharToString(tag->genre().toCWString());
    NSString *year = [NSString stringWithFormat:@"%u", tag->year()];
    NSString *track = [NSString stringWithFormat:@"%u", tag->track()];

    // nil if not wave
    RIFF::WAV::File *waveFile = dynamic_cast<RIFF::WAV::File *>(fileRef.file());

    if (waveFile && waveFile->hasInfoTag()) {
        RIFF::Info::Tag *info = waveFile->InfoTag();

        if (title == nil || [title isEqualToString:@""]) {
            title = wcharToString(info->title().toCWString());
        }

        if ((artist == nil || [artist isEqualToString:@""])) {
            artist = wcharToString(info->artist().toCWString());
        }

        if ((album == nil || [album isEqualToString:@""])) {
            album = wcharToString(info->album().toCWString());
        }

        if ((comment == nil || [comment isEqualToString:@""])) {
            comment = wcharToString(info->comment().toCWString());
        }

        if ((genre == nil || [genre isEqualToString:@""])) {
            genre = wcharToString(info->genre().toCWString());
        }
    }

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    if (title != nil && [title isNotEqualTo:@""]) {
        [dictionary setValue:title forKey:@"TITLE"];
    }

    if (artist != nil && [artist isNotEqualTo:@""]) {
        [dictionary setValue:artist ? : @"" forKey:@"ARTIST"];
    }

    if (album != nil && [album isNotEqualTo:@""]) {
        [dictionary setValue:album ? : @"" forKey:@"ALBUM"];
    }

    if (year != nil && [year isNotEqualTo:@"0"]) {
        [dictionary setValue:year forKey:@"YEAR"];
    }

    if (comment != nil && [comment isNotEqualTo:@""]) {
        [dictionary setValue:comment ? : @"" forKey:@"COMMENT"];
    }

    if (track != nil && [track isNotEqualTo:@"0"]) {
        [dictionary setValue:track ? : @"" forKey:@"TRACK"];
    }

    if (genre != nil && [genre isNotEqualTo:@""]) {
        [dictionary setValue:genre ? : @"" forKey:@"GENRE"];
    }

    PropertyMap tags = fileRef.file()->properties();

    // debug, print all tags
    // printTags(tags);

    // ID3

    // scan through the tag properties where all the other id3 tags will be kept
    // add those as additional keys to the dictionary
    //cout << "-- TAG (properties) --" << endl;
    for (auto i = tags.begin(); i != tags.end(); ++i) {
        for (auto j = i->second.begin(); j != i->second.end(); ++j) {
            // cout << i->first << " - " << '"' << *j << '"' << endl;

            NSString *key = wcharToString(i->first.toCWString());
            NSString *object = wcharToString(j->toCWString());

            // overwrites values set in tag
            if (key != nil && object != nil) {
                [dictionary setValue:object ? : @"" forKey:key];
            }
        }
    }

    return dictionary;
}

+ (bool)setMetadata:(NSString *)path
         dictionary:(NSDictionary *)dictionary
{
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "__C Error: FileRef.isNull: Unable to open file:" << path.UTF8String << endl;
        return false;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "__C Unable to create tag" << endl;
        return false;
    }

    // also duplicate the data into the INFO tag if it's a wave file
    RIFF::WAV::File *waveFile = dynamic_cast<RIFF::WAV::File *>(fileRef.file());
    bool writeInfo = waveFile && waveFile->hasInfoTag();

    // these are the non standard tags
    PropertyMap tags = fileRef.file()->properties();

    for (NSString *key in [dictionary allKeys]) {
        NSString *value = [dictionary objectForKey:key];

        if ([key isEqualToString:@"TITLE"]) {
            tag->setTitle(value.UTF8String);             // ID3

            // also set InfoTag for wave
            if (writeInfo) {
                waveFile->InfoTag()->setTitle(value.UTF8String);
            }
        } else if ([key isEqualToString:@"ARTIST"]) {
            tag->setArtist(value.UTF8String);

            if (writeInfo) {
                waveFile->InfoTag()->setArtist(value.UTF8String);
            }
        } else if ([key isEqualToString:@"ALBUM"]) {
            tag->setAlbum(value.UTF8String);

            if (writeInfo) {
                waveFile->InfoTag()->setAlbum(value.UTF8String);
            }
        } else if ([key isEqualToString:@"YEAR"]) {
            tag->setYear(value.intValue);

            if (writeInfo) {
                waveFile->InfoTag()->setYear(value.intValue);
            }
        } else if ([key isEqualToString:@"TRACK"]) {
            tag->setTrack(value.intValue);

            if (writeInfo) {
                waveFile->InfoTag()->setTrack(value.intValue);
            }
        } else if ([key isEqualToString:@"COMMENT"]) {
            tag->setComment(value.UTF8String);

            if (writeInfo) {
                waveFile->InfoTag()->setComment(value.UTF8String);
            }
        } else if ([key isEqualToString:@"GENRE"]) {
            tag->setGenre(value.UTF8String);

            if (writeInfo) {
                waveFile->InfoTag()->setGenre(value.UTF8String);
            }
        } else {
            String tagKey = String(key.UTF8String);
            tags.replace(String(key.UTF8String), StringList(value.UTF8String));
        }
    }

    return fileRef.save();
}

+ (nullable NSMutableDictionary *)parseProperties:(NSString *)path
{
    TagFile *tagFile = [[TagFile alloc] initWithPath: path];
    
    if (!tagFile) {
        return nil;
    }
    
    return tagFile.dictionary;
}

/// markers as chapters in mp3 files
+ (NSArray *)getMP3Chapters:(NSString *)path
{
    NSMutableArray *array = [[NSMutableArray alloc] init];

    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return nil;
    }

    MPEG::File *mpegFile = dynamic_cast<MPEG::File *>(fileRef.file());

    if (!mpegFile) {
        return nil;
    }

    // cout << "Parsing MPEG File" << endl;

    ID3v2::FrameList chapterList = mpegFile->ID3v2Tag()->frameList("CHAP");

    for (ID3v2::FrameList::ConstIterator it = chapterList.begin();
         it != chapterList.end();
         ++it) {
        ID3v2::ChapterFrame *frame = dynamic_cast<ID3v2::ChapterFrame *>(*it);

        if (frame) {
            // cout << "FRAME " << frame->toString() << endl;

            if (!frame->embeddedFrameList().isEmpty()) {
                for (ID3v2::FrameList::ConstIterator it = frame->embeddedFrameList().begin(); it != frame->embeddedFrameList().end(); ++it) {
                    // the chapter title is a sub frame
                    if ((*it)->frameID() == "TIT2") {
                        // cout << (*it)->frameID() << " = " << (*it)->toString() << endl;
                        NSString *marker = wcharToString((*it)->toString().toCWString());

                        marker = [marker stringByAppendingString:[NSString stringWithFormat:@"@%d", frame->startTime() / 1000] ];
                        [array addObject:marker];
                    }
                }
            }
        }
    }

    return array;
}

//    MP4::File *mp4File = dynamic_cast<MP4::File *>(fileRef.file());

// only works with mpeg files, takes an array of strings
// title@1.04
// TODO, change to array of marker objects
+ (bool)setMP3Chapters:(NSString *)path
                 array:(NSArray *)array
{
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return false;
    }

    MPEG::File *mpegFile = dynamic_cast<MPEG::File *>(fileRef.file());

    if (!mpegFile) {
        cout << "__C TaglibWrapper.setChapters: Not a MPEG File" << endl;
        return false;
    }

    // parse array

    // remove CHAPter tags
    mpegFile->ID3v2Tag()->removeFrames("CHAP");

    // add new CHAP tags
    ID3v2::Header header;

    // expecting NAME@TIME right now
    for (NSString *object in array) {
        NSArray *items = [object componentsSeparatedByString:@"@"];
        NSString *name = [items objectAtIndex:0];         //shows Description
        int time = [[items objectAtIndex:1] intValue];

        ID3v2::ChapterFrame *chapter = new ID3v2::ChapterFrame(&header, "CHAP");
        chapter->setStartTime(time);
        chapter->setEndTime(time);

        // set the chapter title
        ID3v2::TextIdentificationFrame *eF = new ID3v2::TextIdentificationFrame("TIT2");
        eF->setText(name.UTF8String);
        chapter->addEmbeddedFrame(eF);
        mpegFile->ID3v2Tag()->addFrame(chapter);
    }

    bool result = mpegFile->save();
    return result;
}

+ (NSString *)detectFileType:(NSString *)path
{
    NSString *pathExtension = [path.pathExtension lowercaseString];

    // no extension, open the file
    if ([pathExtension isEqualToString:@""]) {
        return [TagLibBridge detectStreamType:path];
    }

    if ([pathExtension isEqualToString:@"wave"] || [pathExtension isEqualToString:@"bwf"]) {
        return kFileTypeWAVE;
    } else if ([pathExtension isEqualToString:@"aiff"]) {
        return kFileTypeAIFF;
    } else {
        return pathExtension;
    }
}

+ (NSString *)detectStreamType:(NSString *)path
{
    const char *filepath = path.UTF8String;
    FileStream *stream = new FileStream(filepath);

    if (!stream->isOpen()) {
        NSLog(@"__C TaglibWrapper.detectStreamType: Unable to open FileStream: %@", path);
        delete stream;
        return nil;
    }

    NSString *value = nil;

    if (RIFF::WAV::File::isSupported(stream)) {
        value = kFileTypeWAVE;
    } else if (MP4::File::isSupported(stream)) {
        value = kFileTypeM4A;
    } else if (RIFF::AIFF::File::isSupported(stream)) {
        value = kFileTypeAIFF;
    } else if (MPEG::File::isSupported(stream)) {
        value = kFileTypeMP3;
    }

    delete stream;

    return value;
}

// MARK: Utilities

void printTags(const PropertyMap &tags) {
    unsigned int longest = 0;

    for (PropertyMap::ConstIterator i = tags.begin(); i != tags.end(); ++i) {
        if (i->first.size() > longest) {
            longest = i->first.size();
        }
    }

    cout << "__C -- TAG (properties) --" << endl;

    for (PropertyMap::ConstIterator i = tags.begin(); i != tags.end(); ++i) {
        for (StringList::ConstIterator j = i->second.begin(); j != i->second.end(); ++j) {
            cout << left << std::setw(longest) << i->first << " - " << '"' << *j << '"' << endl;
        }
    }
}

@end
