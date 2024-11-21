
#include <Foundation/Foundation.h>
#include "sndfile.h"

// Macro for splitting the format file of SF_INFO into container type
#define SF_CONTAINER(x) ((x) & SF_FORMAT_TYPEMASK)

NS_ASSUME_NONNULL_BEGIN

///  Wrapper on the C struct for simpler interchange with Swift
@interface SFBroadcastInfo : NSObject

@property (nonatomic) SF_BROADCAST_INFO info;

- (nullable id)initWithPath:(NSString *)path;


@end

NS_ASSUME_NONNULL_END
