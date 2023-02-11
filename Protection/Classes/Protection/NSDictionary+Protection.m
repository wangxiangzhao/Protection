//
//  NSDictionary+Protection.m
//  Test
//
//  Created by wangxiangzhao on 2023/2/11.
//

#import "NSDictionary+Protection.h"
#import "NSObject+Swizzle.h"
#import "XDException.h"
#import <objc/runtime.h>

@implementation NSDictionary (Protection)

+ (void)xd_open {
    [self swizzleClassMethodWithOriginalSEL:@selector(dictionaryWithObject:forKey:) newSEL:@selector(xd_dictionaryWithObject:forKey:)];
    [self swizzleClassMethodWithOriginalSEL:@selector(dictionaryWithObjects:forKeys:) newSEL:@selector(xd_dictionaryWithObjects:forKeys:)];
}

+ (instancetype)xd_dictionaryWithObject:(id)object forKey:(id<NSCopying>)key {
    if (!object || !key) {
        throwException(XDExcetionTypeDictionary, [NSString stringWithFormat:@"创建字典：dictionaryWithObject：%@ forKey：%@；key或者object有空值", object, key], @{});
        return nil;
    }
    return [self xd_dictionaryWithObject:object forKey:key];
}

+ (instancetype)xd_dictionaryWithObjects:(NSArray *)objects forKeys:(NSArray<id<NSCopying>> *)keys {
    if (!objects || !keys) {
        throwException(XDExcetionTypeDictionary, [NSString stringWithFormat:@"创建字典：dictionaryWithObjects：%@ forKeys：%@；keys或者objects有空值", objects, keys], @{});
        return nil;
    }
    if (objects.count != keys.count) {
        throwException(XDExcetionTypeDictionary, [NSString stringWithFormat:@"创建字典：dictionaryWithObjects：forKeys：其中objects的count：%lu，keys的count：%lu；两个值不相等", objects.count, keys.count], @{});
        return nil;
    }
    return [self xd_dictionaryWithObjects:objects forKeys:keys];
}


@end

@implementation NSMutableDictionary (Protection)

+ (void)xd_open {
    Class cls = objc_getClass("__NSDictionaryM");
    swizzleInstanceMethod(cls, @selector(setObject:forKey:), @selector(xd_setObject:forKey:));
    swizzleInstanceMethod(cls, @selector(setObject:forKeyedSubscript:), @selector(xd_setObject:forKeyedSubscript:));
    swizzleClassMethod(cls, @selector(removeObjectForKey:), @selector(xd_removeObjectForKey:));
    swizzleClassMethod(cls, @selector(removeObjectsForKeys:), @selector(xd_removeObjectsForKeys:));
}

- (void)xd_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject || !aKey) {
        throwException(XDExcetionTypeDictionary, [NSString stringWithFormat:@"字典赋值：object：setObject：%@ forKey：%@；key或者object有空值", anObject, aKey], @{});
        return;
    }
    [self xd_setObject:anObject forKey:aKey];
}

- (void)xd_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!obj || !key) {
        throwException(XDExcetionTypeDictionary, [NSString stringWithFormat:@"字典字面量赋值：setObject：%@ forKeyedSubscript：%@；key或者object有空值", obj, key], @{});
        return;
    }
    [self xd_setObject:obj forKeyedSubscript:key];
}

- (void)xd_removeObjectForKey:(id)aKey {
    if (!aKey) {
        throwException(XDExcetionTypeDictionary, [NSString stringWithFormat:@"字典移除内容：removeObjectForKey：%@ ，key不能为空值", aKey], @{});
        return;
    }
    [self xd_removeObjectForKey:aKey];
}

- (void)xd_removeObjectsForKeys:(NSArray *)keyArray {
    if (!keyArray || keyArray.count == 0) {
        throwException(XDExcetionTypeDictionary, [NSString stringWithFormat:@"字典移除内容：removeObjectsForKeys：%@ ，keyArray不能为空值", keyArray], @{});
        return;
    }
    [self xd_removeObjectsForKeys:keyArray];
}

@end
