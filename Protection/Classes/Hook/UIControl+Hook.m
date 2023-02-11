//
//  UIControl+EventHook.m
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import "UIControl+Hook.h"
#import "NSObject+Swizzle.h"

@implementation UIControl (Hook)

//+ (void)load {
//    //避免子类调用 [super load]  多次执行该函数
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self swizzleInstanceMethodWithOriginalSEL:@selector(sendActionsForControlEvents:) newSEL:@selector(xd_sendActionsForControlEvents:)];
//    });
//}
//
//- (void)xd_sendActionsForControlEvents:(UIControlEvents)controlEvents {
//    //在这里处理hook的事件
//    [self xd_sendActionsForControlEvents:controlEvents];
//}

@end
