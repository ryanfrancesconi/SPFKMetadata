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

#import "TagFileType.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TagFileType

using namespace std;
using namespace TagLib;

# pragma mark - Helpers

TagFileTypeDef kTagFileTypeAac = @"aac";
TagFileTypeDef kTagFileTypeAiff = @"aif";
TagFileTypeDef kTagFileTypeFlac = @"flac";
TagFileTypeDef kTagFileTypeM4a = @"m4a";
TagFileTypeDef kTagFileTypeMp3 = @"mp3";
TagFileTypeDef kTagFileTypeMp4 = @"mp4";
TagFileTypeDef kTagFileTypeOpus = @"opus";
TagFileTypeDef kTagFileTypeVorbis = @"ogg";
TagFileTypeDef kTagFileTypeWave = @"wav";

+ (nullable TagFileTypeDef)detectType:(NSString *)path {
    NSString *pathExtension = [path.pathExtension lowercaseString];

    // no extension, open the file
    if ([pathExtension isEqualToString:@""]) {
        return [TagFileType detectStreamType:path];
    }

    // ----

    if ([pathExtension isEqualToString:@"wave"] || [pathExtension isEqualToString:@"bwf"]) {
        return kTagFileTypeWave;
    } else if ([pathExtension containsString:@"aif"]) {
        return kTagFileTypeAiff;
    } else {
        return pathExtension;
    }
}

+ (nullable TagFileTypeDef)detectStreamType:(NSString *)path {
    FileStream *stream = new FileStream(path.UTF8String);

    if (!stream->isOpen()) {
        NSLog(@"__C TaglibWrapper.detectStreamType: Unable to open FileStream: %@", path);
        delete stream;
        return NULL;
    }

    NSString *value = NULL;

    if (RIFF::WAV::File::isSupported(stream)) {
        value = kTagFileTypeWave;
    } else if (MP4::File::isSupported(stream)) {
        value = kTagFileTypeM4a;
    } else if (RIFF::AIFF::File::isSupported(stream)) {
        value = kTagFileTypeAiff;
    } else if (MPEG::File::isSupported(stream)) {
        value = kTagFileTypeMp3;
    } else if (Ogg::FLAC::File::isSupported(stream)) {
        value = kTagFileTypeFlac;
    } else if (Ogg::Opus::File::isSupported(stream)) {
        value = kTagFileTypeOpus;
    } else if (Ogg::Vorbis::File::isSupported(stream)) {
        value = kTagFileTypeVorbis;
    }

    delete stream;
    return value;
}

@end

NS_ASSUME_NONNULL_END
