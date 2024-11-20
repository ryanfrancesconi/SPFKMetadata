
#include <Foundation/Foundation.h>
#include "sndfile.h"

NS_ASSUME_NONNULL_BEGIN

///  Wrapper on the C struct for simpler interchange with Swift
@interface SFBroadcastInfo : NSObject

@property (nonatomic) SF_BROADCAST_INFO info;

@end

NS_ASSUME_NONNULL_END
