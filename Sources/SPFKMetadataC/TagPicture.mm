// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <iomanip>
#import <iostream>
#import <stdio.h>
#import <vector>

#import <CoreGraphics/CGImage.h>
#import <Foundation/Foundation.h>
#import <ImageIO/CGImageDestination.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

#import <tag/fileref.h>
#import <tag/tag.h>

#import "StringUtil.h"
#import "TagPicture.h"
#import "TagPictureRef.h"

using namespace std;
using namespace TagLib;

@implementation TagPicture

// MARK: TagLib string constants

const auto pictureKey = String("PICTURE");
const auto dataKey = String("data");
const auto mimeTypeKey = String("mimeType");
const auto descriptionKey = String("description");
const auto pictureTypeKey = String("pictureType");

- (nullable id)initWithPath:(nonnull NSString *)path {
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

    if (pictures.isEmpty()) {
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
    } else {
        NSLog(@"Image must be either JPEG or PNG");
        CFRelease(dataProvider);
        return NULL;
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

    String pictureDescription = picture.value(descriptionKey).value<String>();
    String pictureType = picture.value(pictureTypeKey).value<String>();

    NSString *desc = StringUtil::utf8NSString(pictureDescription);
    NSString *pict = StringUtil::utf8NSString(pictureType);

    _pictureRef = [[TagPictureRef alloc] initWithImage:imageRef
                                                utType:utType
                                    pictureDescription:desc
                                           pictureType:pict];

    return self;
}

+ (bool)write:(TagPictureRef *)picture
         path:(nonnull NSString *)path {
    //

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

    vector<char> vector = copyToVector(nsData);

    ByteVector data = ByteVector(vector.data(), int(vector.size()));
    map.insert(dataKey, data);

    tag->setComplexProperties(pictureKey, { map });
    fileRef.save();

    return true;
}

static vector<char> copyToVector(NSData *data) {
    const char *bytes = (const char *)[data bytes];
    NSUInteger length = [data length];

    vector<char> vec(length);
    copy(bytes, bytes + length, vec.begin());
    return vec;
}

@end
