#import <Foundation/Foundation.h>
#import "SecurityUtils.h"

// Objective-C++ bridge to expose C++ function to Swift
@interface SecurityUtilsBridge : NSObject
+ (NSString *)getSecretKey;
@end

@implementation SecurityUtilsBridge
+ (NSString *)getSecretKey {
    const char* key = getSecretKey();
    return [NSString stringWithUTF8String:key];
}
@end
