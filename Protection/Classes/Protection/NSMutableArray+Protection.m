//
//  NSMutableArray+Protection.m
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import "NSMutableArray+Protection.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>
#import "XDException.h"

@implementation NSMutableArray (Protection)

+ (void)xd_open {
    Class NSArrayMcls = objc_getClass("__NSArrayM");
    swizzleInstanceMethod(NSArrayMcls, @selector(addObject:), @selector(xd_addObject:));
    swizzleInstanceMethod(NSArrayMcls, @selector(insertObject:atIndex:), @selector(xd_insertObject:atIndex:));
    swizzleInstanceMethod(NSArrayMcls, @selector(removeObjectAtIndex:), @selector(xd_removeObjectAtIndex:));
    swizzleInstanceMethod(NSArrayMcls, @selector(replaceObjectAtIndex:withObject:), @selector(xd_replaceObjectAtIndex:withObject:));
    
    Class NSCFArraycls = objc_getClass("__NSCFArray");
    swizzleInstanceMethod(NSCFArraycls, @selector(addObject:), @selector(xd_addObject:));
    swizzleInstanceMethod(NSCFArraycls, @selector(insertObject:atIndex:), @selector(xd_insertObject:atIndex:));
    swizzleInstanceMethod(NSCFArraycls, @selector(removeObjectAtIndex:), @selector(xd_removeObjectAtIndex:));
    swizzleInstanceMethod(NSCFArraycls, @selector(replaceObjectAtIndex:withObject:), @selector(xd_replaceObjectAtIndex:withObject:));
}

- (void)xd_addObject:(id)anObject {
    if (!anObject || self.class != objc_getClass("__NSArrayM")) {
        throwException(XDExcetionTypeArray, [NSString stringWithFormat:@"数组添加addObject：%@抛异常", anObject], @{});
        return;
    }
    [self xd_addObject:anObject];
}

- (void)xd_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count || !anObject || self.class != objc_getClass("__NSArrayM")) {
        throwException(XDExcetionTypeArray, [NSString stringWithFormat:@"数组添加insertObject：%@抛异常；atIndex：%lu", anObject, index], @{});
        return;
    }
    [self xd_insertObject:anObject atIndex:index];
}

- (void)xd_removeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count || self.class != objc_getClass("__NSArrayM")) {
        throwException(XDExcetionTypeArray, [NSString stringWithFormat:@"数组添加removeObjectAtIndex：%lu", index], @{});
        return;
    }
    [self xd_removeObjectAtIndex:index];
}

- (void)xd_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= self.count || anObject == nil || self.class != objc_getClass("__NSArrayM")) {
        throwException(XDExcetionTypeArray, [NSString stringWithFormat:@"数组添加replaceObjectAtIndex：%lu；withObject：%@", index, anObject], @{});
        return;
    }
    [self xd_replaceObjectAtIndex:index withObject:anObject];
}

@end
