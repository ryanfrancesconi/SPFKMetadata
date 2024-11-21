
#import "sndfile.hh"
#import "SFBroadcastInfo.h"



@implementation SFBroadcastInfo

- (nullable id)initWithPath:(nonnull NSString *)path {
    const char *cpath = path.UTF8String;
    SndfileHandle file = SndfileHandle(cpath);
    SF_BROADCAST_INFO binfo;

    // SF_TRUE if the file contained a Broadcast Extension chunk or SF_FALSE otherwise.
    int err = file.command(
        SFC_GET_BROADCAST_INFO,
        &binfo,
        sizeof(binfo)
        );

    if (err == SF_FALSE) {
        return nil;
    }

    self = [super init];
    self.info = binfo;

    return self;
}

@end
