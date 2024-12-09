
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BEXTDescriptionC : NSObject

/// BWF Version 0, 1, or 2
@property (atomic) short version;

@property (atomic) NSString *bextDescription;

/// UMID (Unique Material Identifier) to standard SMPTE. (Note: Added in version 1.)
@property (atomic) NSString *umid;

/// A <CodingHistory> field is provided in the BWF format to allow the exchange of information on previous signal processing,
/// IE: A=PCM,F=48000,W=16,M=stereo|mono,T=original
///
/// A=<ANALOGUE, PCM, MPEG1L1, MPEG1L2, MPEG1L3, MPEG2L1, MPEG2L2, MPEG2L3>
/// F=<11000,22050,24000,32000,44100,48000>
/// B=<any bit-rate allowed in MPEG 2 (ISO/IEC 13818-3)>
/// W=<8, 12, 14, 16, 18, 20, 22, 24>
/// M=<mono, stereo, dual-mono, joint-stereo>
/// T=<a free ASCII-text string for in house use. This string should contain no commas (ASCII 2Chex).
/// Examples of the contents: ID-No; codec type; A/D type>
///
/// see: https://tech.ebu.ch/docs/r/r098.pdf
@property (atomic) NSString *codingHistory;

/// Integrated Loudness Value of the file in LUFS. (Note: Added in version 2.)
@property (atomic) float loudnessValue;

/// Loudness Range of the file in LU. (Note: Added in version 2.)
@property (atomic) float loudnessRange;

/// Maximum True Peak Value of the file in dBTP. (Note: Added in version 2.)
@property (atomic) float maxTruePeakLevel;

/// highest value of the Momentary Loudness Level of the file in LUFS. (Note: Added in version 2.)
@property (atomic) float maxMomentaryLoudness;

/// highest value of the Short-term Loudness Level of the file in LUFS. (Note: Added in version 2.)
@property (atomic) float maxShortTermLoudness;

/// The name of the originator / producer of the audio file
@property (atomic) NSString *originator;

/// Unambiguous reference allocated by the originating organization
@property (atomic) NSString *originatorReference;

/// yyyy:mm:dd
@property (atomic) NSString *originationDate;

/// hh:mm:ss
@property (atomic) NSString *originationTime;

/// Time reference in samples
/// These fields shall contain the time-code of the sequence. It is a 64-bit value which contains the first sample count since midnight.
/// First sample count since midnight, low word (UInt32)
@property (atomic) uint32_t timeReferenceLow;

/// Time reference in samples
/// First sample count since midnight, high word (UInt32)
@property (atomic) uint32_t timeReferenceHigh;

/// Combined 64bit time value of low and high words
@property (readonly) uint64_t timeReference;

/// Convenience property in seconds
@property (readonly) double timeReferenceInSeconds;

@property (readonly) double sampleRate;

- (id)init;
- (nullable id)initWithPath:(nonnull NSString *)path;

/// Set the Broadcast Extension Chunk for WAV (and related) files.
+ (bool)write:(BEXTDescriptionC *)info
         path:(nonnull NSString *)path;

@end

NS_ASSUME_NONNULL_END
