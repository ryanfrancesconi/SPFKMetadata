// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#import <taglib/fileref.h>
#import <taglib/privateframe.h>
#import <taglib/tpropertymap.h>
#import <taglib/wavfile.h>

#import "AudioMarkerUtil.h"
#import "WaveFileC.h"

@implementation WaveFileC

using namespace std;
using namespace TagLib;
using namespace RIFF;

- (nullable id)initWithPath:(nonnull NSString *)path {
    self = [super init];

    _path = path;
    _id3Dictionary = [[NSMutableDictionary alloc] init];
    _infoDictionary = [[NSMutableDictionary alloc] init];

    return self;
}

- (bool)load {
    FileRef fileRef(_path.UTF8String);

    if (fileRef.isNull()) {
        return false;
    }

    auto *waveFile = dynamic_cast<WAV::File *>(fileRef.file());

    if (!waveFile) {
        // not a wave file
        return false;
    }

    NSURL *url = [NSURL URLWithString:_path];
    _markers = [AudioMarkerUtil getMarkers:url];

    if (waveFile->hasBEXTTag()) {
        _bextDescription = [[BEXTDescriptionC alloc] initWithPath:_path];
    } else {
        _bextDescription = [[BEXTDescriptionC alloc] init];
    }

    if (waveFile->hasiXMLTag()) {
        _ixmlString = [[NSString alloc] initWithCString:waveFile->iXMLTag.data(String::UTF8).data()
                                               encoding:NSUTF8StringEncoding];
    }

    if (waveFile->hasInfoTag()) {
        auto infoMap = waveFile->InfoTag()->fieldListMap();

        if (!infoMap.isEmpty()) {
            for (const auto &[key, val] : infoMap) {
                // cout << key << " = " << val << endl;

                const char *bytes = key.data();
                const unsigned int length = key.size();

                NSString *nsKey = [[NSString alloc] initWithBytes:bytes
                                                           length:length
                                                         encoding:NSUTF8StringEncoding];

                NSString *nsValue = [[NSString alloc] initWithCString:val.toCString()
                                                             encoding:NSUTF8StringEncoding];

                NSLog(@"%@ = %@", nsKey, nsValue);

                [_infoDictionary setValue:nsValue ? : @"" forKey:nsKey];
            }
        }
    }

    if (waveFile->hasID3v2Tag()) {
        ID3v2::Tag *tag = waveFile->ID3v2Tag();
        ID3v2::FrameList frameList = tag->frameList();

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

            [_id3Dictionary setValue:nsValue ? : @"" forKey:nsKey];
        }
    }

    _tagPicture = [[TagPicture alloc] initWithPath:_path];

    return true;
}

- (bool)save {
    FileRef fileRef(_path.UTF8String);

    if (fileRef.isNull()) {
        return false;
    }

    auto *waveFile = dynamic_cast<WAV::File *>(fileRef.file());

    if (!waveFile) {
        // not a wave file
        return false;
    }

    // write bext first as it will only write the bext chunk and audio data
    if (![BEXTDescriptionC write:_bextDescription path:_path]) {
        return false;
    }

    // write image data
    if (_tagPicture) {
        [TagPicture write:_tagPicture.pictureRef path:_path];
    }

    // write markers
    NSURL *url = [NSURL URLWithString:_path];
    [AudioMarkerUtil update:url markers:_markers];

    // write ixml
    if (_ixmlString) {
        waveFile->iXMLTag = String(_ixmlString.UTF8String);
    }

    // write id3
    if (_id3Dictionary.count > 0) {
        PropertyMap properties;

        for (NSString *key in [_id3Dictionary allKeys]) {
            NSString *value = [_id3Dictionary objectForKey:key];

            String tagKey = String(key.UTF8String);
            String tagValue = String(value.UTF8String);

            properties.insert(tagKey, tagValue);
        }

        waveFile->ID3v2Tag()->setProperties(properties);
    }

    // write info
    if (_infoDictionary.count > 0) {
        for (NSString *key in [_infoDictionary allKeys]) {
            NSString *value = [_infoDictionary objectForKey:key];

            String tagKey = String(key.UTF8String);
            String tagValue = String(value.UTF8String);

            waveFile->InfoTag()->setFieldText(tagKey.data(String::UTF8), tagValue);
        }
    }

    waveFile->save();
}

@end
