
#import <Foundation/Foundation.h>
#import <iostream>

namespace Util {
    // quick placeholder
    static void
    log(const char *s) {
        std::cout << s << std::endl;
    }

    static void
    strncpy_0(char *dest, const char *src, size_t n) {
        strncpy(dest, src, n - 1);
        dest [n - 1] = 0; //'\0';
    }

    static NSString *
    asciiString(const char *s, size_t length) {
        return [[NSString alloc] initWithBytes:s length:length encoding:NSASCIIStringEncoding];
    }
}
