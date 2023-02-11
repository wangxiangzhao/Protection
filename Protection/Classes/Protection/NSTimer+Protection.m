//
//  NSTimer+Protection.m
//  Test
//
//  Created by wangxiangzhao on 2023/2/11.
//

#import "NSTimer+Protection.h"
#import "NSObject+Swizzle.h"

@interface XDTimerProxy : NSObject

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) id userInfo;
@property (nonatomic, assign) BOOL repeats;

- (void)fireTimer:(NSTimer *)timer;

@end

@implementation XDTimerProxy

- (void)fireTimer:(NSTimer *)timer {
    if (!self.target) {
        [timer invalidate];
        return;
    }
    
    if ([self.target respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:timer];
#pragma clang diagnostic pop
    }
}

- (void)dealloc {
    
}

@end

@implementation NSTimer (Protection)

+ (void)xd_open {
    [self swizzleClassMethodWithOriginalSEL:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:) newSEL:@selector(xd_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];
}

+ (NSTimer *)xd_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    if (!yesOrNo) {
        return [self xd_scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    }
    XDTimerProxy *proxy = [[XDTimerProxy alloc] init];
    proxy.target = aTarget;
    proxy.selector = aSelector;
    proxy.timeInterval = ti;
    proxy.userInfo = userInfo;
    proxy.repeats = yesOrNo;
    return [self xd_scheduledTimerWithTimeInterval:ti target:proxy selector:@selector(fireTimer:) userInfo:userInfo repeats:yesOrNo];
}

@end
