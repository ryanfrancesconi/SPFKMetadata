// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <CoreGraphics/CGImage.h>
#import <Foundation/Foundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagPictureRef : NSObject

@property (nonatomic) CGImageRef cgImage;
@property (nonatomic, strong, nullable) NSString *pictureDescription;
@property (nonatomic, strong, nullable) NSString *pictureType;
@property (nonatomic, strong, nonnull) UTType *utType;

/// Creates a `TagPicture` from a `CGImage`
- (nonnull id)initWithImage:(CGImageRef)cgImage
                     utType:(UTType *)utType
         pictureDescription:(NSString *)pictureDescription
                pictureType:(NSString *)pictureType;

/// Creates a `TagPicture` from either a JPEG or PNG `URL`.
/// No other file types are supported.
- (nullable id)initWithURL:(NSURL *)url
        pictureDescription:(NSString *)pictureDescription
               pictureType:(NSString *)pictureType;

@end

NS_ASSUME_NONNULL_END
