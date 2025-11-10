
// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>
#import <iostream>

#import <tag/aifffile.h>
#import <tag/fileref.h>
#import <tag/flacfile.h>
#import <tag/id3v2tag.h>
#import <tag/mpegfile.h>
#import <tag/privateframe.h>
#import <tag/rifffile.h>
#import <tag/wavfile.h>

#import "ID3File.h"
#import "TagFile.h"
#import "TagFileType.h"

@implementation ID3File

using namespace std;
using namespace TagLib;

- (id)initWithPath:(nonnull NSString *)path {
    self = [super init];

    _path = path;
    _fileType = [TagFileType detectType:path];
    _dictionary = [[NSMutableDictionary alloc] init];

    return self;
}

- (bool)update {
    ID3v2::FrameList frameList = [self parseTag];

    if (frameList.isEmpty()) {
        cout << "no frames were found" << endl;
        return false;
    }

    for (auto it = frameList.begin(); it != frameList.end(); it++) {
        ByteVector frameID = (*it)->frameID();
        String value = (*it)->toString();

        cout << frameID << " = " << value << endl;

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

    return true;
}

- (bool)save {
    return [TagFile write:_dictionary path:_path];
}

- (ID3v2::FrameList)parseTag {
    FileRef fileRef(_path.UTF8String);

    if (fileRef.isNull()) {
        return ID3v2::FrameList();
    }

    ID3v2::Tag *tag;

    if ([_fileType isEqualToString:kTagFileTypeWave]) {
        auto *f = dynamic_cast<RIFF::WAV::File *>(fileRef.file());

        if (f->hasID3v2Tag()) {
            tag = f->ID3v2Tag();
        }
    } else if ([_fileType isEqualToString:kTagFileTypeAiff]) {
        auto *f = dynamic_cast<RIFF::AIFF::File *>(fileRef.file());

        if (f->hasID3v2Tag()) {
            tag = f->tag();
        }
    } else if ([_fileType isEqualToString:kTagFileTypeMp3]) {
        auto *f = dynamic_cast<MPEG::File *>(fileRef.file());

        if (f->hasID3v2Tag()) {
            tag = f->ID3v2Tag();
        }
    } else if ([_fileType isEqualToString:kTagFileTypeFlac]) {
        auto *f = dynamic_cast<FLAC::File *>(fileRef.file());

        if (f->hasID3v2Tag()) {
            tag = f->ID3v2Tag();
        }
    }

    if (tag == NULL) {
        cout << "Error: No ID3v2 tag found" << endl;
        return ID3v2::FrameList();
    }

    return tag->frameList();
}

@end
