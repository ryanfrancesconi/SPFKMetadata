// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <tag/fileref.h>
#import <tag/wavfile.h>

#import "WaveFile.h"

@implementation WaveFile

using namespace std;
using namespace TagLib;

- (nullable id)initWithPath:(nonnull NSString *)path {
    self = [super init];

    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return nil;
    }

    RIFF::WAV::File *waveFile = dynamic_cast<RIFF::WAV::File *>(fileRef.file());

    if (!waveFile) {
        // not a wave file
        return nil;
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

    return self;
}

+ (bool)write:(nonnull NSDictionary *)dictionary path:(nonnull NSString *)path {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return;
    }

    RIFF::WAV::File *waveFile = dynamic_cast<RIFF::WAV::File *>(fileRef.file());

    if (!waveFile) {
        // not a wave file
        return;
    }

    RIFF::Info::FieldListMap map = RIFF::Info::FieldListMap();

    for (NSString *key in [dictionary allKeys]) {
        NSString *value = [dictionary objectForKey:key];

        String tagKey = String(key.UTF8String);
        String tagValue = String(value.UTF8String);

        waveFile->InfoTag()->setFieldText(tagKey.data(String::UTF8), tagValue);
    }

    waveFile->save();
}

@end
