// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

#ifndef TagUtil_H
#define TagUtil_H

#import <Foundation/Foundation.h>
#import <iostream>

#import <taglib/aifffile.h>
#import <taglib/fileref.h>
#import <taglib/flacfile.h>
#import <taglib/mpegfile.h>
#import <taglib/rifffile.h>
#import <taglib/wavfile.h>

#import <taglib/id3v2tag.h>
#import <taglib/privateframe.h>
#import <taglib/tpropertymap.h>

#include "TagFileType.h"

using namespace TagLib;
using namespace std;

namespace TagUtil {
    static NSMutableDictionary *
    convertToDictionary(ID3v2::FrameList frameList) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

        if (frameList.isEmpty()) {
            return dict;
        }

        for (auto it = frameList.begin(); it != frameList.end(); it++) {
            ByteVector frameID = (*it)->frameID();
            String value = (*it)->toString();

            // custom frame handling

            if (frameID == "TXXX") {
                ID3v2::UserTextIdentificationFrame *txxxFrame = dynamic_cast<ID3v2::UserTextIdentificationFrame *>(*it);

                // in taglib fashion, we'll call the the description the ID
                frameID = txxxFrame->description().data(String::UTF8);

                // the fieldList() has all text items, so the description() is first and the actual value is last
                value = txxxFrame->fieldList().back();

                // cout << txxxFrame->description() << " = " << txxxFrame->fieldList().back() << endl;
            } else if (frameID == "PRIV") {
                ID3v2::PrivateFrame *privFrame = dynamic_cast<ID3v2::PrivateFrame *>(*it);
                cout << "owner() = " << privFrame->owner() << endl;

                value = privFrame->data();
            }

            cout << frameID << " = " << value << endl;

            const char *bytes = frameID.data();
            const unsigned int length = frameID.size();

            NSString *nsKey = [[NSString alloc] initWithBytes:bytes
                                                       length:length
                                                     encoding:NSUTF8StringEncoding];

            NSString *nsValue = [[NSString alloc] initWithCString:value.toCString()
                                                         encoding:NSUTF8StringEncoding];

            [dict setValue:nsValue ? : @"" forKey:nsKey];
        }

        return dict;
    }

    static PropertyMap
    convertToPropertyMap(NSMutableDictionary *dict) {
        PropertyMap properties = PropertyMap();

        if (dict.count == 0) {
            return properties;
        }

        for (NSString *key in [dict allKeys]) {
            NSString *value = [dict objectForKey:key];

            // can be taglib key or 4 char id3 frameID
            String tagKey = String(key.UTF8String);
            StringList tagValue = StringList(value.UTF8String);

            properties.insert(tagKey, tagValue);
        }

        properties.removeEmpty();

        return properties;
    }

    static NSMutableDictionary *
    convertToDictionary(RIFF::Info::FieldListMap infoMap) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

        if (!infoMap.isEmpty()) {
            return dict;
        }

        for (const auto &[key, val] : infoMap) {
            const char *bytes = key.data();
            const unsigned int length = key.size();

            NSString *nsKey = [[NSString alloc] initWithBytes:bytes
                                                       length:length
                                                     encoding:NSUTF8StringEncoding];

            NSString *nsValue = [[NSString alloc] initWithCString:val.toCString()
                                                         encoding:NSUTF8StringEncoding];

            // NSLog(@"%@ = %@", nsKey, nsValue);

            [dict setValue:nsValue ? : @"" forKey:nsKey];
        }

        return dict;
    }

    static ID3v2::FrameList
    parseID3FrameList(NSString *path, NSString *fileType) {
        FileRef fileRef(path.UTF8String);

        if (fileRef.isNull()) {
            return ID3v2::FrameList();
        }

        ID3v2::Tag *tag = nullptr;

        if ([fileType isEqualToString:kTagFileTypeWave]) {
            auto *f = dynamic_cast<RIFF::WAV::File *>(fileRef.file());

            if (f->hasID3v2Tag()) {
                tag = f->ID3v2Tag();
            }
        } else if ([fileType isEqualToString:kTagFileTypeAiff]) {
            auto *f = dynamic_cast<RIFF::AIFF::File *>(fileRef.file());

            if (f->hasID3v2Tag()) {
                tag = f->tag();
            }
        } else if ([fileType isEqualToString:kTagFileTypeMp3]) {
            auto *f = dynamic_cast<MPEG::File *>(fileRef.file());

            if (f->hasID3v2Tag()) {
                tag = f->ID3v2Tag();
            }
        } else if ([fileType isEqualToString:kTagFileTypeFlac]) {
            auto *f = dynamic_cast<FLAC::File *>(fileRef.file());

            if (f->hasID3v2Tag()) {
                tag = f->ID3v2Tag();
            }
        }

        if (tag == nullptr) {
            cout << "Error: No ID3v2 tag found in" << path.UTF8String << endl;
            return ID3v2::FrameList();
        }

        return tag->frameList();
    }
}

#endif // !TagUtil_H
