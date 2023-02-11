//
//  NSObject+CrashProtection.m
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

void swizzleMethod(Class cls, Method original, Method other) {
    if (!original || !other) {
        return;
    }
    //主要判断下在该类中是否存在原方法，还是存在于父类中；如果不存在该类中则添加实现再去替换，存在则直接交换
    BOOL addMethodResult = class_addMethod(cls, method_getName(original), method_getImplementation(original), method_getTypeEncoding(original));
    if (addMethodResult) {
        class_replaceMethod(cls, method_getName(other), method_getImplementation(original), method_getTypeEncoding(original));
    } else {
//        method_exchangeImplementations(original, other);
        class_replaceMethod(cls,
                            method_getName(other),
                            class_replaceMethod(cls,
                                                method_getName(original),
                                                method_getImplementation(other),
                                                method_getTypeEncoding(other)),
                            method_getTypeEncoding(original));
    }
}

void swizzleInstanceMethod(Class cls, SEL original, SEL other) {
    swizzleMethod(cls, class_getInstanceMethod(cls, original), class_getInstanceMethod(cls, other));
}

void swizzleClassMethod(Class cls, SEL original, SEL other) {
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    swizzleMethod(metacls, class_getClassMethod(cls, original), class_getClassMethod(cls, other));
}

@implementation NSObject (Swizzle)

#pragma mark - 替换方法
//替换实例方法
+ (void)swizzleInstanceMethodWithOriginalSEL:(SEL)originalSel newSEL:(SEL)newSel {
    Method original = class_getInstanceMethod(self, originalSel);
    Method other = class_getInstanceMethod(self, newSel);
    if (!original || !other) {
        return;
    }
    Class cls = self.class;
    //主要判断下在该类中是否存在原方法，还是存在于父类中；如果不存在该类中则添加实现再去替换，存在则直接交换
    BOOL addMethodResult = class_addMethod(cls, method_getName(original), method_getImplementation(original), method_getTypeEncoding(original));
    if (addMethodResult) {
        class_replaceMethod(cls, method_getName(other), method_getImplementation(original), method_getTypeEncoding(original));
    } else {
        method_exchangeImplementations(original, other);
    }
}

//替换类方法
+ (void)swizzleClassMethodWithOriginalSEL:(SEL)originalSel newSEL:(SEL)newSel {
    Method original = class_getClassMethod(self, originalSel);
    Method other = class_getClassMethod(self, newSel);
    if (!original || !other) {
        return;
    }
    Class metacls = objc_getMetaClass(NSStringFromClass(self.class).UTF8String);
    //主要判断下在该类中是否存在原方法，还是存在于父类中；如果不存在该类中则添加实现再去替换，存在则直接交换
    BOOL addMethodResult = class_addMethod(metacls, method_getName(original), method_getImplementation(original), method_getTypeEncoding(original));
    if (addMethodResult) {
        class_replaceMethod(metacls, method_getName(other), method_getImplementation(original), method_getTypeEncoding(original));
    } else {
        method_exchangeImplementations(original, other);
    }
}


@end
