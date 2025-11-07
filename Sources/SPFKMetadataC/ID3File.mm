
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
#import <tag/privateframe.h>
#import <tag/rifffile.h>
#import <tag/tag.h>
#import <tag/tfilestream.h>
#import <tag/tpropertymap.h>
#import <tag/wavfile.h>

#import "ID3File.h"
#import "TagFile.h"

@implementation ID3File

using namespace std;
using namespace TagLib;

- (nullable id)initWithPath:(nonnull NSString *)path {
    self = [super init];

    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return nil;
    }

    _dictionary = [[NSMutableDictionary alloc] init];

    NSString *fileType = [TagFile detectType:path];
    ID3v2::Tag *id3v2;

    if ([fileType isEqualToString:kTagFileTypeWAVE]) {
        RIFF::WAV::File *f = dynamic_cast<RIFF::WAV::File *>(fileRef.file());

        if (f->hasID3v2Tag()) {
            id3v2 = f->ID3v2Tag();
        }
    } else if ([fileType isEqualToString:kTagFileTypeAIFF]) {
        RIFF::AIFF::File *f = dynamic_cast<RIFF::AIFF::File *>(fileRef.file());

        if (f->hasID3v2Tag()) {
            id3v2 = f->tag();
        }
    } else if ([fileType isEqualToString:kTagFileTypeMP3]) {
        MPEG::File *f = dynamic_cast<MPEG::File *>(fileRef.file());

        if (f->hasID3v2Tag()) {
            id3v2 = f->ID3v2Tag();
        }
    } else if ([fileType isEqualToString:kTagFileTypeFLAC]) {
        FLAC::File *f = dynamic_cast<FLAC::File *>(fileRef.file());

        if (f->hasID3v2Tag()) {
            id3v2 = f->ID3v2Tag();
        }
    }

    if (id3v2 == nil) {
        cout << "No ID3v2 tag found" << endl;
        return nil;
    }

    ID3v2::FrameList frameList = id3v2->frameList();

    for (auto it = frameList.begin(); it != frameList.end(); it++) {
        ByteVector frameID = (*it)->frameID();
        String value = (*it)->toString();

        cout << frameID << " == " << value << endl;

        // custom frame handling
        if (frameID == "PRIV") {
            ID3v2::PrivateFrame *privateFrame = dynamic_cast<ID3v2::PrivateFrame *>(*it);
            cout << "owner() = " << privateFrame->owner() << endl;

            value = privateFrame->data();
        }

        const char *bytes = frameID.data();
        const unsigned int length = frameID.size();

        NSString *nsKey = [[NSString alloc] initWithBytes:bytes
                                                   length:length
                                                 encoding:NSUTF8StringEncoding];

        NSString *nsValue = [[NSString alloc] initWithCString:value.toCString()
                                                     encoding:NSUTF8StringEncoding];

        [_dictionary setValue:nsValue ? : @"" forKey:nsKey];
    }

    return self;
}

@end
