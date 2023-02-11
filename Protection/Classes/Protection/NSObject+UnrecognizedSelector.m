//
//  NSObject+UnrecognizedSelector.m
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import "NSObject+UnrecognizedSelector.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>
#import "XDException.h"
#import "XDConstant.h"

@implementation NSObject (UnrecognizedSelector)

+ (void)openUnrecognizedSelectorProtection {
    [self swizzleInstanceMethodWithOriginalSEL:@selector(methodSignatureForSelector:) newSEL:@selector(xd_methodSignatureForSelector:)];
    [self swizzleInstanceMethodWithOriginalSEL:@selector(forwardInvocation:) newSEL:@selector(xd_forwardInvocation:)];
}

- (NSMethodSignature*)xd_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* methodSignature = [self xd_methodSignatureForSelector:aSelector];
    if (methodSignature) {
        return methodSignature;
    }
    IMP originIMP = class_getMethodImplementation([NSObject class], @selector(methodSignatureForSelector:));
    IMP currentClassIMP = class_getMethodImplementation(self.class, @selector(methodSignatureForSelector:));
    if (originIMP != currentClassIMP){
        return nil;
    }
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}

- (void)xd_forwardInvocation:(NSInvocation *)invocation {
    throwException(XDExcetionTypeUnrecognizedSelector, [NSString stringWithFormat:@"class:[%@] not found selector:(%@)",NSStringFromClass(self.class),NSStringFromSelector(invocation.selector)], @{});
}



@end
