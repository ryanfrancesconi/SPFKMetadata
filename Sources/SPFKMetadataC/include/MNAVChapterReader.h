//  MNAVChapters.h
//  MNAVChapters
//  Created by Michael Nisi on 02.08.13.
//  Copyright (c) 2013 Michael Nisi. All rights reserved.

// MARK: Delete me, replace with AppleMetadata

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CMTime.h>
#import <Foundation/Foundation.h>

@interface MNAVChapter : NSObject
@property (nonatomic, nullable, copy) NSString *identifier;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, nullable, copy) NSString *title;
@property (nonatomic, nullable, copy) NSString *url;
@property (nonatomic) CMTime time;
@property (nonatomic) CMTime duration;

//@property (nonatomic) NSImage *artwork;

- (BOOL)isEqualToChapter:(MNAVChapter *_Nullable)aChapter;
- (MNAVChapter *_Nullable)initWithTime:(CMTime)time duration:(CMTime)duration;
+ (MNAVChapter *_Nullable)chapterWithTime:(CMTime)time duration:(CMTime)duration;
@end

@interface MNAVChapterReader : NSObject
+ (NSArray *_Nullable)chaptersFromAsset:(AVAsset *_Nullable)asset;
@end

# pragma mark - Internal

@protocol MNAVChapterReader <NSObject>
- (NSArray *_Nullable)chaptersFromAsset:(AVAsset *_Nullable)asset;
@end

@interface MNAVChapterReaderMP3 : NSObject <MNAVChapterReader>
- (MNAVChapter *_Nullable)chapterFromFrame:(NSData *_Nullable)data;
@end

@interface MNAVChapterReaderMP4 : NSObject <MNAVChapterReader>
@end
