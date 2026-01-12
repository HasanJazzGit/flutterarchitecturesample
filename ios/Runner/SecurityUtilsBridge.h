#import <Foundation/Foundation.h>

// Objective-C++ bridge to expose C++ function to Swift
@interface SecurityUtilsBridge : NSObject
+ (nonnull NSString *)getSecretKey;
@end
