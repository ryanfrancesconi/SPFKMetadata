// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>
#import <iostream>

namespace Util {
    /**
       If the length of the string is less than n characters, add null byte.
       returns the size written.
       - Parameters:
       - dest: destination
       - src: source
       - n: max length of field
     */
    static size_t
    strncpy_validate(char *dest, const char *src, size_t n) {
        // reserve space for null
        size_t length = strlen(src) + 1;

        if (length >= n) {
            // truncate to exactly n
            strncpy(dest, src, n);
            return n;
            //
        } else {
            strncpy(dest, src, length);

            // if less than n, add null termination
            dest [length - 1] = '\0';
            return length;
        }
    }

    /**
       If a string is < n, pad with character 0 -- for UMID bext spec.
     */
    static void
    strncpy_pad0(char *dest, const char *src, size_t n, bool terminate) {
        size_t length = strlen(src);

        if (length < n) {
            strncpy(dest, src, length);

            for (size_t i = length; i < n; i++) {
                dest[i] = '0'; // character 0, not termination
            }

            if (terminate) {
                dest [n - 1] = '\0';
                assert(strlen(dest) == n - 1);
            } else {
                assert(strlen(dest) == n);
            }
        } else {
            strncpy(dest, src, n);
        }
    }

    static NSString *
    asciiString(const char *s, size_t length) {
        return [
            [NSString alloc] initWithBytes:s
                                    length:length
                                  encoding:NSASCIIStringEncoding
        ];
    }
}
