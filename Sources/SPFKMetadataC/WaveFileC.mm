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
#import "ID3File.h"
#import "TagFile.h"
#import "TagUtil.h"
#import "WaveFileC.h"

@implementation WaveFileC

using namespace std;
using namespace TagLib;

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

    auto *waveFile = dynamic_cast<RIFF::WAV::File *>(fileRef.file());

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
        _infoDictionary = TagUtil::convertToDictionary(infoMap);
    }

    if (waveFile->hasID3v2Tag()) {
        ID3v2::Tag *tag = waveFile->ID3v2Tag();
        ID3v2::FrameList frameList = tag->frameList();
        _id3Dictionary = TagUtil::convertToDictionary(frameList);
    }

    _tagPicture = [[TagPicture alloc] initWithPath:_path];

    return true;
}

- (bool)save {
    [self saveExtras];

    FileRef fileRef(_path.UTF8String);

    if (fileRef.isNull()) {
        cout << "FileRef is nil" << endl;
        return false;
    }

    auto *waveFile = dynamic_cast<RIFF::WAV::File *>(fileRef.file());

    if (!waveFile) {
        cout << "Not a wave file" << endl;
        return false;
    }

    // write ixml
    if (_iXML) {
        waveFile->iXMLTag = String(_iXML.UTF8String);
    }

    // write id3
    PropertyMap properties = TagUtil::convertToPropertyMap(_id3Dictionary);
    waveFile->ID3v2Tag()->setProperties(properties);

    // write info values directly
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

@end
