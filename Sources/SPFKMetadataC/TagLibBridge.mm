// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <iomanip>
#import <iostream>
#import <stdio.h>
#import <vector>

#import <CoreGraphics/CGImage.h>
#import <ImageIO/CGImageDestination.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

#import <tag/aifffile.h>
#import <tag/fileref.h>
#import <tag/flacfile.h>
#import <tag/mp4file.h>
#import <tag/mpegfile.h>
#import <tag/oggfile.h>
#import <tag/rifffile.h>
#import <tag/tag.h>
#import <tag/textidentificationframe.h>
#import <tag/tfilestream.h>
#import <tag/tpropertymap.h>
#import <tag/tstring.h>
#import <tag/tstringlist.h>
#import <tag/wavfile.h>

#import "ChapterMarker.h"
#import "TagFile.h"
#import "TagLibBridge.h"
#import "TagPicture.h"

#import "StringUtil.h"

using namespace std;
using namespace TagLib;

@implementation TagLibBridge

+ (nullable NSMutableDictionary *)getProperties:(NSString *)path {
    TagFile *tagFile = [[TagFile alloc] initWithPath:path];

    if (!tagFile) {
        return NULL;
    }

    return tagFile.dictionary;
}

+ (bool)setProperties:(NSString *)path
           dictionary:(NSDictionary *)dictionary {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "Unable to read path:" << path.UTF8String << endl;
        return false;
    }

    PropertyMap tags = PropertyMap();

    for (NSString *key in [dictionary allKeys]) {
        NSString *value = [dictionary objectForKey:key];

        String tagKey = String(key.UTF8String);
        StringList tagValue = StringList(value.UTF8String);

        tags.insert(tagKey, tagValue);
    }

    tags.removeEmpty();

    fileRef.setProperties(tags);

    return fileRef.save();
}

+ (nullable NSString *)getTitle:(NSString *)path {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "fileRef.isNull. Unable to read path: " << path.UTF8String << endl;
        return NULL;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        return NULL;
    }

    return @(tag->title().toCString());
}

+ (bool)setTitle:(NSString *)path
           title:(NSString *)title {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "Unable to read path:" << path.UTF8String << endl;
        return false;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "Unable to create tag" << endl;
        return false;
    }

    tag->setTitle(title.UTF8String);

    // also duplicate the data into the INFO tag if it's a wave file
    RIFF::WAV::File *waveFile = dynamic_cast<RIFF::WAV::File *>(fileRef.file());

    // also set InfoTag for wave
    if (waveFile) {
        waveFile->InfoTag()->setTitle(title.UTF8String);
    }

    return fileRef.save();
}

+ (nullable NSString *)getComment:(NSString *)path
{
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "Unable to read path:" << path.UTF8String << endl;
        return NULL;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "Unable to create tag" << endl;
        return NULL;
    }

    return @(tag->comment().toCString());
}

+ (bool)setComment:(NSString *)path
           comment:(NSString *)comment {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "Unable to read path:" << path.UTF8String << endl;
        return false;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "Unable to create tag" << endl;
        return false;
    }

    tag->setComment(comment.UTF8String);

    return fileRef.save();
}

+ (bool)removeAllTags:(NSString *)path {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "Unable to read path: " << path.UTF8String << endl;
        return false;
    }

    NSString *fileType = [TagFile detectType:path];

    // implementation for strip() is specific to each type of file

    if ([fileType isEqualToString:kTagFileTypeWAVE]) {
        RIFF::WAV::File *f = dynamic_cast<RIFF::WAV::File *>(fileRef.file());
        f->strip();
        //
    } else if ([fileType isEqualToString:kTagFileTypeM4A] || [fileType isEqualToString:kTagFileTypeMP4]) {
        MP4::File *f = dynamic_cast<MP4::File *>(fileRef.file());
        f->strip();
        //
    } else if ([fileType isEqualToString:kTagFileTypeMP3]) {
        MPEG::File *f = dynamic_cast<MPEG::File *>(fileRef.file());
        f->strip();
        //
    } else if ([fileType isEqualToString:kTagFileTypeFLAC]) {
        FLAC::File *f = dynamic_cast<FLAC::File *>(fileRef.file());
        f->strip();
        //
    } else {
        cout << "Unable to strip tags in " << path.UTF8String << endl;

        fileRef.setProperties(PropertyMap());
    }

    return fileRef.save();
}

+ (bool)copyTagsFromPath:(NSString *)path
                  toPath:(NSString *)toPath {
    FileRef input(path.UTF8String);

    if (input.isNull()) {
        cout << "Unable to read" << path.UTF8String << endl;
        return false;
    }

    PropertyMap tags = input.file()->properties();

    if (tags.isEmpty()) {
        return true;
    }

    if (![self removeAllTags:toPath]) {
        cout << "Failed to remove tags in" << toPath.UTF8String << endl;
        return false;
    }

    FileRef output(toPath.UTF8String);

    if (output.isNull()) {
        cout << "Unable to read path: " << toPath.UTF8String << endl;
        return false;
    }

    output.tag()->setProperties(tags);

    return output.save();
}

// MARK: - Pictures

// NOTE: these are TagLib constants

const String pictureKey("PICTURE");
const String dataKey("data");
const String mimeTypeKey("mimeType");
const String descriptionKey("description");
const String pictureTypeKey("pictureType");

+ (TagPicture *)getPicture:(nonnull NSString *)path {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "fileRef.isNull. Unable to read path: " << path.UTF8String << endl;
        return NULL;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "Unable to read tag" << endl;
        return NULL;
    }

    auto pictures = tag->complexProperties(pictureKey);

    if (pictures.size() == 0) {
        return NULL;
    }

    // take the first picture only
    auto picture = pictures.front();

    String pictureMimeType = picture.value(mimeTypeKey).value<String>();
    NSString *mimeType = StringUtil::utf8NSString(pictureMimeType);
    UTType *utType = [UTType typeWithMIMEType:mimeType];

    if (!utType) {
        cout << "Failed to determine UTType" << endl;
        return NULL;
    }

    ByteVector pictureData = picture.value(dataKey).toByteVector();
    String pictureDescription = picture.value(descriptionKey).value<String>();
    String pictureType = picture.value(pictureTypeKey).value<String>();

    NSData *nsData = [[NSData alloc] initWithBytes:pictureData.data() length:pictureData.size()];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)nsData);

    CGImageRef imageRef = NULL;

    if (utType == UTTypeJPEG) {
        imageRef = CGImageCreateWithJPEGDataProvider(
            dataProvider,
            NULL,
            true,
            kCGRenderingIntentDefault
            );
    } else if (utType == UTTypePNG) {
        imageRef = CGImageCreateWithPNGDataProvider(
            dataProvider,
            NULL,
            true,
            kCGRenderingIntentDefault
            );
    }

    CFRelease(dataProvider);

    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);

    bool validSize = width > 0 && height > 0;

    if (!imageRef) {
        cout << "Failed to create CGImageRef" << endl;
        return NULL;
    }

    if (!validSize) {
        cout << "Invalid size returned for image" << endl;
        return NULL;
    }

    NSString *desc = StringUtil::utf8NSString(pictureDescription);
    NSString *pict = StringUtil::utf8NSString(pictureType);

    TagPicture *tagPicture = [[TagPicture alloc] initWithImage:imageRef
                                                        utType:utType
                                            pictureDescription:desc
                                                   pictureType:pict];

    return tagPicture;
}

+ (bool)setPicture:(nonnull NSString *)path picture:(nonnull TagPicture *)picture {
    FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "FileRef isNull" << endl;

        return false;
    }

    Tag *tag = fileRef.tag();

    if (!tag) {
        cout << "Unable to read tag" << endl;
        return false;
    }

    VariantMap map;

    if (picture.pictureDescription) {
        const char *value = StringUtil::utf8CString(picture.pictureDescription);
        map.insert(descriptionKey, String(value, String::Type::UTF8));
    }

    if (picture.pictureType) {
        const char *value = StringUtil::utf8CString(picture.pictureType);
        map.insert(pictureTypeKey, String(value, String::Type::UTF8));
    }

    NSString *mimeType = picture.utType.preferredMIMEType;
    const char *value = StringUtil::utf8CString(mimeType);
    map.insert(mimeTypeKey, String(value, String::Type::UTF8));

    CFMutableDataRef mutableData = CFDataCreateMutable(NULL, 0);
    CGImageDestinationRef destination = CGImageDestinationCreateWithData(
        mutableData,
        (__bridge CFStringRef)picture.utType.identifier,
        1,
        NULL
        );

    CGImageDestinationAddImage(destination, picture.cgImage, NULL);

    if (!CGImageDestinationFinalize(destination)) {
        cout << "CGImageDestinationFinalize failed" << endl;
        return false;
    }

    NSData *nsData = (__bridge NSData *)mutableData;

    if (!nsData) {
        cout << "data is NULL" << endl;
        return false;
    }

    vector<char> vector = copyToVector(nsData);

    ByteVector data = ByteVector(vector.data(), int(vector.size()));
    map.insert(dataKey, data);

    tag->setComplexProperties(pictureKey, { map });
    fileRef.save();

    return true;
}

vector<char> copyToVector(NSData *data) {
    const char *bytes = (const char *)[data bytes];
    NSUInteger length = [data length];

    vector<char> vec(length);
    copy(bytes, bytes + length, vec.begin());
    return vec;
}

@end
