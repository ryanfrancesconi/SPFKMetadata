
#import <Foundation/Foundation.h>
#import <iostream>

namespace Util {
    //
    static NSString *
    utf8String(const char *charText) {
        return [[NSString alloc] initWithCString:charText encoding:NSUTF8StringEncoding];
    }

    // quick placeholder
    static void
    log(const char *string) {
        std::cout << string << std::endl;
    }
}
