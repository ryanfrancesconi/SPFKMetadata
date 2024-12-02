// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <tag/aifffile.h>
#import <tag/fileref.h>
#import <tag/mp4file.h>
#import <tag/mpegfile.h>
#import <tag/rifffile.h>
#import <tag/tag.h>
#import <tag/tfilestream.h>
#import <tag/tpropertymap.h>
#import <tag/wavfile.h>

#import "spfk_util.h"
#import "TagFile.h"

@implementation TagFile

using namespace TagLib;

- (nullable id)initWithPath:(nonnull NSString *)path {
    self = [super init];

    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        return nil;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        return nil;
    }

    PropertyMap tags = fileRef.file()->properties();

    if (tags.isEmpty()) {
        return nil;
    }

    _dictionary = [[NSMutableDictionary alloc] init];

    // Copy TagLib's PropertyMap into our dictionary using the same keys
    for (auto i = tags.begin(); i != tags.end(); ++i) {
        for (auto j = i->second.begin(); j != i->second.end(); ++j) {
            //
            NSString *key = Util::utf8String(i->first.toCString());
            NSString *object = Util::utf8String(j->toCString());

            if (key != nil && object != nil) {
                [_dictionary setValue:object ? : @"" forKey:key];
            }
        }
    }

    return self;
}

# pragma mark - Util

NSString *const kTagFileTypeMP3 = @"mp3";
NSString *const kTagFileTypeM4A = @"m4a";
NSString *const kTagFileTypeAAC = @"aac";
NSString *const kTagFileTypeWAVE = @"wav";
NSString *const kTagFileTypeAIFF = @"aif";

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
    } else if ([pathExtension isEqualToString:@"aiff"]) {
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
        return nil;
    }

    NSString *value = nil;

    if (RIFF::WAV::File::isSupported(stream)) {
        value = kTagFileTypeWAVE;
    } else if (MP4::File::isSupported(stream)) {
        value = kTagFileTypeM4A;
    } else if (RIFF::AIFF::File::isSupported(stream)) {
        value = kTagFileTypeAIFF;
    } else if (MPEG::File::isSupported(stream)) {
        value = kTagFileTypeMP3;
    }

    delete stream;
    return value;
}

@end
