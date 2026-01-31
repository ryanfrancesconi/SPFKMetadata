// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/spfk-metadata

#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#import <taglib/fileref.h>
#import <taglib/privateframe.h>
#import <taglib/textidentificationframe.h>
#import <taglib/tpropertymap.h>
#import <taglib/wavfile.h>

#import "AudioMarkerUtil.h"
#import "TagFile.h"
#import "WaveFileC.h"

@implementation WaveFileC

using namespace std;
using namespace TagLib;
using namespace RIFF;

- (id)init {
    self = [super init];
    _id3Dictionary = [[NSMutableDictionary alloc] init];
    _infoDictionary = [[NSMutableDictionary alloc] init];
    return self;
}

- (id)initWithPath:(nonnull NSString *)path {
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

    [_id3Dictionary removeAllObjects];
    [_infoDictionary removeAllObjects];

    auto audioProperties = fileRef.audioProperties();

    if (audioProperties != nullptr) {
        _audioProperties = [[TagAudioPropertiesC alloc] init];
        _audioProperties.sampleRate = (double)audioProperties->sampleRate();
        _audioProperties.duration = (double)audioProperties->lengthInMilliseconds() / 1000;
        _audioProperties.bitRate = audioProperties->bitrate();
        _audioProperties.channelCount = audioProperties->channels();
    }

    NSURL *url = [NSURL URLWithString:_path];
    _markers = [AudioMarkerUtil getMarkers:url];

    if (waveFile->hasBEXTTag()) {
        _bextDescription = [[BEXTDescriptionC alloc] initWithPath:_path];
    } else {
        _bextDescription = [[BEXTDescriptionC alloc] init];
    }

    if (waveFile->hasiXMLTag()) {
        _iXML = [[NSString alloc] initWithCString:waveFile->iXMLTag.data(String::UTF8).data()
                                         encoding:NSUTF8StringEncoding];
    }

    if (waveFile->hasInfoTag()) {
        auto infoMap = waveFile->InfoTag()->fieldListMap();

        if (!infoMap.isEmpty()) {
            for (const auto &[key, val] : infoMap) {
                const char *bytes = key.data();
                const unsigned int length = key.size();

                NSString *nsKey = [[NSString alloc] initWithBytes:bytes
                                                           length:length
                                                         encoding:NSUTF8StringEncoding];

                NSString *nsValue = [[NSString alloc] initWithCString:val.toCString()
                                                             encoding:NSUTF8StringEncoding];

                // NSLog(@"%@ = %@", nsKey, nsValue);

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

            [_id3Dictionary setValue:nsValue ? : @"" forKey:nsKey];
        }
    }

    _tagPicture = [[TagPicture alloc] initWithPath:_path];

    return true;
}

- (void)saveExtras {
    // write bext first as it will only write the bext chunk and audio data
    if (![BEXTDescriptionC write:_bextDescription path:_path]) {
        cout << "BEXTDescriptionC write failed" << endl;
    }

    // write image data
    if (_tagPicture) {
        [TagPicture write:_tagPicture.pictureRef path:_path];
    }

    // write markers
    if (_markers.count > 0) {
        NSURL *url = [NSURL URLWithString:_path];
        [AudioMarkerUtil update:url markers:_markers];
    }
}

- (bool)save {
    [self saveExtras];

    FileRef fileRef(_path.UTF8String);

    if (fileRef.isNull()) {
        cout << "FileRef is nil" << endl;
        return false;
    }

    auto *waveFile = dynamic_cast<WAV::File *>(fileRef.file());

    if (!waveFile) {
        cout << "Not a wave file" << endl;
        return false;
    }

    // write ixml
    if (_iXML) {
        waveFile->iXMLTag = String(_iXML.UTF8String);
    }

    // write id3
    if (_id3Dictionary.count > 0) {
        PropertyMap properties = PropertyMap();

        for (NSString *key in [_id3Dictionary allKeys]) {
            NSString *value = [_id3Dictionary objectForKey:key];

            // can be taglib key or 4 char id3 frameID
            String tagKey = String(key.UTF8String);
            StringList tagValue = StringList(value.UTF8String);

            properties.insert(tagKey, tagValue);
        }

        properties.removeEmpty();
        waveFile->ID3v2Tag()->setProperties(properties);
    }

    // write info
    if (_infoDictionary.count > 0) {
        for (NSString *key in [_infoDictionary allKeys]) {
            NSString *value = [_infoDictionary objectForKey:key];

            ByteVector tagKey = String(key.UTF8String).data(String::UTF8);
            String tagValue = String(value.UTF8String);

            waveFile->InfoTag()->setFieldText(tagKey, tagValue);
        }
    }

    return waveFile->save();
}

@end
