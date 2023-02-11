//
//  XDProtection.h
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import <Foundation/Foundation.h>
#import "XDException.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDProtection : NSObject

@property (nonatomic, assign, readonly) BOOL isOpen;

@property (nonatomic, copy, readonly) void(^exceptionCallHandler)(XDException *exception);

//开启崩溃防护
+ (void)openProtection:(XDExcetionType)type callHandler: (void(^)(XDException *exception))exceptionCallHandler;

@end

NS_ASSUME_NONNULL_END
