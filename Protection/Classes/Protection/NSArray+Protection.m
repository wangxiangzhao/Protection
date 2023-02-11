//
//  NSArray+Protection.m
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import "NSArray+Protection.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>
#import "XDException.h"

@implementation NSArray (Protection)

+ (void)xd_open {
#pragma mark - 数组下标越界
        //字面量数组
        swizzleInstanceMethod(objc_getClass("NSConstantArray"), @selector(objectAtIndex:), @selector(xd_objectAtIndex:));
        //空数组
        swizzleInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:), @selector(xd_objectAtIndex:));
        //多个元素数组
        swizzleInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:), @selector(xd_objectAtIndex:));
        //单个元素数组  iOS10之后
        swizzleInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndex:), @selector(xd_objectAtIndex:));
        //可变数组
        swizzleInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:), @selector(xd_objectAtIndex:));
        //老版本存在这样的问题  iOS16测试没有这样的问题
        swizzleInstanceMethod(objc_getClass("__NSFrozenArrayM"), @selector(objectAtIndex:), @selector(xd_objectAtIndex:));
        swizzleInstanceMethod(objc_getClass("__NSArrayI_Transfer"), @selector(objectAtIndex:), @selector(xd_objectAtIndex:));
        swizzleInstanceMethod(objc_getClass("__NSArrayReversed"), @selector(objectAtIndex:), @selector(xd_objectAtIndex:));
        
#pragma mark - 数组字面量获取下标越界
        //字面量数组
        swizzleInstanceMethod(objc_getClass("NSConstantArray"), @selector(objectAtIndexedSubscript:), @selector(xd_objectAtIndexedSubscript:));
        //空数组
        swizzleInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndexedSubscript:), @selector(xd_objectAtIndexedSubscript:));
        //多个元素数组
        swizzleInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndexedSubscript:), @selector(xd_objectAtIndexedSubscript:));
        //单个元素数组  iOS10之后
        swizzleInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndexedSubscript:), @selector(xd_objectAtIndexedSubscript:));
        //可变数组
        swizzleInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndexedSubscript:), @selector(xd_objectAtIndexedSubscript:));
        //老版本存在这样的问题  iOS16测试没有这样的问题
        swizzleInstanceMethod(objc_getClass("__NSFrozenArrayM"), @selector(objectAtIndexedSubscript:), @selector(xd_objectAtIndexedSubscript:));
        swizzleInstanceMethod(objc_getClass("__NSArrayI_Transfer"), @selector(objectAtIndexedSubscript:), @selector(xd_objectAtIndexedSubscript:));
        swizzleInstanceMethod(objc_getClass("__NSArrayReversed"), @selector(objectAtIndexedSubscript:), @selector(xd_objectAtIndexedSubscript:));
}

//防止下标越界
- (id)xd_objectAtIndex:(NSUInteger)index {
    if ([self isProtectionAtIndex:index]) {
        throwException(XDExcetionTypeArray, [NSString stringWithFormat:@"数组超出边界，下标objectAtIndex为：%lu，数组count：%lu", index, self.count], @{});
        return nil;
    }
    return [self xd_objectAtIndex:index];
}

//防止字面量下标获取越界
- (id)xd_objectAtIndexedSubscript:(NSUInteger)idx {
    if ([self isProtectionAtIndex:idx]) {
        throwException(XDExcetionTypeArray, [NSString stringWithFormat:@"数组字面值超下标，下标为：%lu，数组count：%lu", idx, self.count], @{});
        return nil;
    }
    return [self xd_objectAtIndexedSubscript:idx];
}

//是否越界  YES：越界  NO：未越界
- (BOOL)isProtectionAtIndex:(NSUInteger)idx {
    if (self.count == 0) {
        return YES;
    }
    if (idx > self.count - 1) {
        return YES;
    }
    return NO;
}

@end
