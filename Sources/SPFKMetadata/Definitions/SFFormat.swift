import Foundation
import SPFKMetadataC

public enum SFFormat: CaseIterable {
    /// Apple/SGI AIFF format (big endian).
    case aiff
    /// Sun/NeXT AU format (big endian).
    case au
    /// Audio Visual Research
    case avr
    /// Core Audio File format
    case caf
    /// FLAC lossless file format
    case flac
    /// HMM Tool Kit format
    case htk
    /// Berkeley/IRCAM/CARL
    case ircam
    /// Matlab (tm) V4.2 / GNU Octave 2.0
    case mat4
    /// Matlab (tm) V5.0 / GNU Octave 2.1\
    case mat5
    /// Akai MPC 2000 sampler
    case mpc2k
    /// MPEG-1/2 audio stream
    case mpeg
    /// Sphere NIST format.
    case nist
    /// Xiph OGG container
    case ogg
    /// Ensoniq PARIS file format.
    case paf
    /// Portable Voice Format
    case pvf
    /// RAW PCM data.
    case raw
    /// RF64 WAV file
    case rf64
    /// Sound Designer 2
    case sd2
    /// Midi Sample Dump Standard
    case sds
    /// Amiga IFF / SVX8 / SV16 format.
    case svx
    /// VOC files.
    case voc
    /// Sonic Foundry's 64 bit RIFF/WAV
    case w64
    /// Microsoft WAV format (little endian default).
    case wav
    /// MS WAVE with WAVEFORMATEX
    case wavex
    /// Psion WVE format
    case wve
    /// Fasttracker 2 Extended Instrument
    case xi

    /// major format value
    public var value: Int {
        switch self {
        case .aiff: return SF_FORMAT_AIFF
        case .au: return SF_FORMAT_AU
        case .avr: return SF_FORMAT_AVR
        case .caf: return SF_FORMAT_CAF
        case .flac: return SF_FORMAT_FLAC
        case .htk: return SF_FORMAT_HTK
        case .ircam: return SF_FORMAT_IRCAM
        case .mat4: return SF_FORMAT_MAT4
        case .mat5: return SF_FORMAT_MAT5
        case .mpc2k: return SF_FORMAT_MPC2K
        case .mpeg: return SF_FORMAT_MPEG
        case .nist: return SF_FORMAT_NIST
        case .ogg: return SF_FORMAT_OGG
        case .paf: return SF_FORMAT_PAF
        case .pvf: return SF_FORMAT_PVF
        case .raw: return SF_FORMAT_RAW
        case .rf64: return SF_FORMAT_RF64
        case .sd2: return SF_FORMAT_SD2
        case .sds: return SF_FORMAT_SDS
        case .svx: return SF_FORMAT_SVX
        case .voc: return SF_FORMAT_VOC
        case .w64: return SF_FORMAT_W64
        case .wav: return SF_FORMAT_WAV
        case .wavex: return SF_FORMAT_WAVEX
        case .wve: return SF_FORMAT_WVE
        case .xi: return SF_FORMAT_XI
        }
    }

    public init?(value: Int) {
        for item in Self.allCases where item.value == value {
            self = item
            return
        }

        Swift.print("🚩 Unhandled file type for majorFormat: \(value)")
        return nil
    }
}
