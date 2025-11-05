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
        return nil;
    }

    _dictionary = [[NSMutableDictionary alloc] init];

    TagLib::RIFF::Info::FieldListMap map = waveFile->InfoTag()->fieldListMap();

    if (map.isEmpty()) {
        return self;
    }

    for (const auto &[key, val] : map) {
        const char *bytes = key.data();
        const unsigned int length = key.size();

        NSString *nsKey = [[NSString alloc] initWithBytes:bytes
                                                   length:length
                                                 encoding:NSUTF8StringEncoding];

        NSString *nsValue = [[NSString alloc] initWithCString:val.toCString()
                                                     encoding:NSUTF8StringEncoding];

        // cout << key << " = " << val << endl;
        // NSLog(@"%@ = %@", nsKey, nsValue);

        [_dictionary setValue:nsValue ? : @"" forKey:nsKey];
    }

    return self;
}

@end
