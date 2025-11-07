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
#import <tag/oggflacfile.h>
#import <tag/opusfile.h>
#import <tag/privateframe.h>
#import <tag/rifffile.h>
#import <tag/tag.h>
#import <tag/tfilestream.h>
#import <tag/tpropertymap.h>
#import <tag/vorbisfile.h>
#import <tag/wavfile.h>

#import "StringUtil.h"
#import "TagFile.h"

@implementation TagFile

using namespace std;
using namespace TagLib;

- (nullable id)initWithPath:(nonnull NSString *)path {
    self = [super init];

    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return NULL;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        return NULL;
    }

    _dictionary = [[NSMutableDictionary alloc] init];

    PropertyMap properties = tag->properties();

    if (properties.isEmpty()) {
        return self;
    }

    // Copy TagLib's PropertyMap into our dictionary using the same keys they use.
    // See TagKey for translations.

    for (const auto &property : properties) {
        const char *ckey = property.first.toCString();
        String cval = property.second.toString();

        // cout << ckey << " = " << cval << endl;

        NSString *key = @(ckey);
        NSString *object = @(cval.toCString()) ? : @"";

        if (key != nil && object != nil) {
            [_dictionary setValue:object forKey:key];
        }
    }

    return self;
}

# pragma mark - Helpers

NSString *const kTagFileTypeAAC = @"aac";
NSString *const kTagFileTypeAIFF = @"aif";
NSString *const kTagFileTypeM4A = @"m4a";
NSString *const kTagFileTypeMP3 = @"mp3";
NSString *const kTagFileTypeMP4 = @"mp4";
NSString *const kTagFileTypeWAVE = @"wav";
NSString *const kTagFileTypeOPUS = @"opus";
NSString *const kTagFileTypeFLAC = @"flac";
NSString *const kTagFileTypeVORBIS = @"ogg";

+ (NSString *)detectType:(NSString *)path
{
    NSString *pathExtension = [path.pathExtension lowercaseString];

    // no extension, open the file
    if ([pathExtension isEqualToString:@""]) {
        return [TagFile detectStreamType:path];
    }

    // ----

    if ([pathExtension isEqualToString:@"wave"] || [pathExtension isEqualToString:@"bwf"]) {
        return kTagFileTypeWAVE;
    } else if ([pathExtension containsString:@"aif"]) {
        return kTagFileTypeAIFF;
    } else {
        return pathExtension;
    }
}

+ (NSString *)detectStreamType:(NSString *)path
{
    FileStream *stream = new FileStream(path.UTF8String);

    if (!stream->isOpen()) {
        NSLog(@"__C TaglibWrapper.detectStreamType: Unable to open FileStream: %@", path);
        delete stream;
        return NULL;
    }

    NSString *value = NULL;

    if (RIFF::WAV::File::isSupported(stream)) {
        value = kTagFileTypeWAVE;
    } else if (MP4::File::isSupported(stream)) {
        value = kTagFileTypeM4A;
    } else if (RIFF::AIFF::File::isSupported(stream)) {
        value = kTagFileTypeAIFF;
    } else if (MPEG::File::isSupported(stream)) {
        value = kTagFileTypeMP3;
    } else if (Ogg::FLAC::File::isSupported(stream)) {
        value = kTagFileTypeFLAC;
    } else if (Ogg::Opus::File::isSupported(stream)) {
        value = kTagFileTypeOPUS;
    } else if (Ogg::Vorbis::File::isSupported(stream)) {
        value = kTagFileTypeVORBIS;
    }

    delete stream;
    return value;
}

@end
