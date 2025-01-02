// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

#import "TagPicture.h"

@implementation TagPicture
- (nonnull id)initWithImage:(CGImageRef)cgImage
                     utType:(UTType *)utType
         pictureDescription:(NSString *)pictureDescription
                pictureType:(NSString *)pictureType
{
    self = [super init];

    _cgImage = cgImage;
    _pictureDescription = pictureDescription;
    _utType = utType;
    _pictureType = pictureType;

    if (_pictureType == nil) {
        _pictureType = @"Front Cover";
    }

    return self;
}

- (nullable id)initWithURL:(NSURL *)url
                    utType:(UTType *)utType
        pictureDescription:(NSString *)pictureDescription
               pictureType:(NSString *)pictureType
{
    self = [super init];

    _pictureDescription = pictureDescription;
    _utType = utType;
    _pictureType = pictureType;

    if (_pictureType == nil) {
        _pictureType = @"Front Cover";
    }

    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((CFDataRef)[NSData dataWithContentsOfURL:url]);

    if (utType == UTTypeJPEG) {
        _cgImage = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, true, kCGRenderingIntentDefault);
    } else if (utType == UTTypePNG) {
        _cgImage = CGImageCreateWithPNGDataProvider(dataProvider, NULL, true, kCGRenderingIntentDefault);
    } else {
        NSLog(@"Image must be either JPEG or PNG");
        CFRelease(dataProvider);
        return nil;
    }

    CFRelease(dataProvider);

    return self;
}

@end
