
#import "sndfile.hh"
#import "SFBroadcastInfo.h"

@implementation SFBroadcastInfo

+ (SFBroadcastInfo *)parse:(nonnull NSString *)path {
    const char *fname = path.UTF8String;
    SF_BROADCAST_INFO binfo;
    SndfileHandle file = SndfileHandle(fname);

    // SF_TRUE if the file contained a Broadcast Extension chunk or SF_FALSE otherwise.
    int err = file.command(
        SFC_GET_BROADCAST_INFO,
        &binfo,
        sizeof(binfo)
        );

    if (err == SF_FALSE) {
        return nil;
    }

    SFBroadcastInfo *info = [[SFBroadcastInfo alloc] init];
    info.info = binfo;

    return info;
}

@end
