
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SFMarker : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSTimeInterval time;

- (id)initWithName:(nonnull NSString *)name
              time:(NSTimeInterval)time;
@end

NS_ASSUME_NONNULL_END
