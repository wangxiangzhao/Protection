//
//  XDProtectionManager.m
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import "XDProtection.h"
#import "NSObject+UnrecognizedSelector.h"
#import "NSArray+Protection.h"
#import "NSDictionary+Protection.h"
#import "NSMutableArray+Protection.h"
#import "NSString+Protection.h"
#import "NSTimer+Protection.h"
#import "NSObject+KVO.h"
#import "XDConstant.h"

@interface XDProtection ()

@property (nonatomic, copy) void(^exceptionCallHandler)(XDException *exception);

@end

@implementation XDProtection

//+ (void)load {
//    [XDProtection openProtection:XDExcetionTypeAll callHandler:^(XDException * _Nonnull exception) {
//        NSLog(@"%@", exception.description);
//    }];
//}

+ (instancetype)shared {
    static XDProtection *protection;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        protection = [[XDProtection alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:protection selector:@selector(exceptionNotification:) name:XDNotifitionKey_throw_exception object:nil];
    });
    return protection;
}

//开启崩溃防护
+ (void)openProtection:(XDExcetionType)type callHandler: (void(^)(XDException *exception))exceptionCallHandler {
    XDProtection *protection = [XDProtection shared];
    protection.exceptionCallHandler = exceptionCallHandler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (type & XDExcetionTypeArray) {
            [NSArray xd_open];
            [NSMutableArray xd_open];
        }
        if (type & XDExcetionTypeKVO) {
            [NSObject openKVOProtection];
        }
        if (type & XDExcetionTypeUnrecognizedSelector) {
            [NSObject openUnrecognizedSelectorProtection];
        }
        if (type & XDExcetionTypeTimer) {
            [NSTimer xd_open];
        }
        if (type & XDExcetionTypeDictionary) {
            [NSDictionary xd_open];
            [NSMutableDictionary xd_open];
        }
        if (type & XDExcetionTypeString) {
            [NSString xd_open];
            [NSMutableString xd_open];
        }
    });
}

- (void)exceptionNotification:(NSNotification *)notification {
    XDException *exception = notification.userInfo[@"exception"];
    if (!exception) return;
    if (self.exceptionCallHandler) {
        self.exceptionCallHandler(exception);
    }
}

@end
