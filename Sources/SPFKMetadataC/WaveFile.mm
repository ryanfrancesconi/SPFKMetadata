// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <tag/fileref.h>
#import <tag/wavfile.h>

#import "WaveFile.h"

@implementation WaveFile

using namespace std;
using namespace TagLib;

- (nullable id)initWithPath:(nonnull NSString *)path {
    self = [super init];
    
    _path = path;
    return self;
}

- (bool)update {
    FileRef fileRef(_path.UTF8String);

    if (fileRef.isNull()) {
        return false;
    }

    RIFF::WAV::File *waveFile = dynamic_cast<RIFF::WAV::File *>(fileRef.file());

    if (!waveFile) {
        // not a wave file
        return false;
    }

    _dictionary = [[NSMutableDictionary alloc] init];

    RIFF::Info::FieldListMap map = waveFile->InfoTag()->fieldListMap();

    if (map.isEmpty()) {
        return self;
    }

    for (const auto &[key, val] : map) {
        // cout << key << " = " << val << endl;

        const char *bytes = key.data();
        const unsigned int length = key.size();

        NSString *nsKey = [[NSString alloc] initWithBytes:bytes
                                                   length:length
                                                 encoding:NSUTF8StringEncoding];

        NSString *nsValue = [[NSString alloc] initWithCString:val.toCString()
                                                     encoding:NSUTF8StringEncoding];

        NSLog(@"%@ = %@", nsKey, nsValue);

        [_dictionary setValue:nsValue ? : @"" forKey:nsKey];
    }

    return true;
}

- (bool)save {
    FileRef fileRef(_path.UTF8String);

    if (fileRef.isNull()) {
        return false;
    }

    RIFF::WAV::File *waveFile = dynamic_cast<RIFF::WAV::File *>(fileRef.file());

    if (!waveFile) {
        // not a wave file
        return;
    }

    RIFF::Info::FieldListMap map = RIFF::Info::FieldListMap();

    for (NSString *key in [_dictionary allKeys]) {
        NSString *value = [_dictionary objectForKey:key];

        String tagKey = String(key.UTF8String);
        String tagValue = String(value.UTF8String);

        waveFile->InfoTag()->setFieldText(tagKey.data(String::UTF8), tagValue);
    }

    waveFile->save();
}

@end
