#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "XDException.h"
#import "UIControl+Hook.h"
#import "NSArray+Protection.h"
#import "NSDictionary+Protection.h"
#import "NSMutableArray+Protection.h"
#import "NSObject+KVO.h"
#import "NSObject+UnrecognizedSelector.h"
#import "NSString+Protection.h"
#import "NSTimer+Protection.h"
#import "NSObject+Swizzle.h"
#import "XDConstant.h"
#import "XDProtection.h"

FOUNDATION_EXPORT double ProtectionVersionNumber;
FOUNDATION_EXPORT const unsigned char ProtectionVersionString[];

