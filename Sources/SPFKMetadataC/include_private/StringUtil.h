// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKMetadata

#import <Foundation/Foundation.h>
#import <iostream>
#import <tag/tstring.h>

namespace StringUtil {
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
       If a string is < n, pad with character 0 -- for UMID bext spec which
       says to fill the remaining size with 0s.
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

    /**
       A string is null terminated in the bext chunk if it is less than the full size,
       otherwise it isn't. This will clamp to maxLength to make sure it doesn't keep
       reading towards the next null byte which would overflow into a subsequent
       field in the bext data.
     */
    static NSString *
    asciiString(const char *s, size_t maxLength) {
        size_t len = MIN(maxLength, strlen(s));

        return [
            [NSString alloc] initWithBytes:s
                                    length:len
                                  encoding:NSASCIIStringEncoding
        ];
    }

    static NSString *
    utf8NSString(TagLib::String string) {
        return [[NSString alloc] initWithCString:string.toCString() encoding:NSUTF8StringEncoding];
    }

    static const char *
    asciiCString(NSString *string) {
        return [string cStringUsingEncoding:NSASCIIStringEncoding];
    }

    static const char *
    utf8CString(NSString *string) {
        return [string cStringUsingEncoding:NSUTF8StringEncoding];
    }
}
