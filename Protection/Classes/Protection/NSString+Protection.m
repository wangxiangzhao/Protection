//
//  NSString+Protection.m
//  Test
//
//  Created by wangxiangzhao on 2023/2/11.
//

#import "NSString+Protection.h"
#import "NSObject+Swizzle.h"
#import "XDException.h"

@implementation NSString (Protection)

+ (void)xd_open {
    [self swizzleClassMethodWithOriginalSEL:@selector(stringWithUTF8String:) newSEL:@selector(xd_stringWithUTF8String:)];
    [self swizzleClassMethodWithOriginalSEL:@selector(stringWithCString:encoding:) newSEL:@selector(xd_stringWithCString:encoding:)];
    
    //NSPlaceholderString
    Class cls = NSClassFromString(@"NSPlaceholderString");
    swizzleInstanceMethod(cls, @selector(initWithCString:encoding:), @selector(xd_initWithCString:encoding:));
    swizzleInstanceMethod(cls, @selector(initWithString:), @selector(xd_initWithString:));

    [self swizzleInstanceMethodWithOriginalSEL:@selector(substringFromIndex:) newSEL:@selector(xd_substringFromIndex:)];
    [self swizzleInstanceMethodWithOriginalSEL:@selector(substringToIndex:) newSEL:@selector(xd_substringToIndex:)];
    [self swizzleInstanceMethodWithOriginalSEL:@selector(rangeOfString:options:range:locale:) newSEL:@selector(xd_rangeOfString:options:range:locale:)];
    
    cls = NSClassFromString(@"__NSCFString");
    swizzleInstanceMethod(cls, @selector(substringWithRange:), @selector(xd_substringWithRange:));
//
//    //__NSCFConstantString
//    cls = NSClassFromString(@"__NSCFConstantString");
//    swizzleInstanceMethod(cls, @selector(substringFromIndex:), @selector(xd_substringFromIndex:));
//    swizzleInstanceMethod(cls, @selector(substringToIndex:), @selector(xd_substringToIndex:));
//    swizzleInstanceMethod(cls, @selector(rangeOfString:options:range:locale:), @selector(xd_rangeOfString:options:range:locale:));
//
//    //NSTaggedPointerString
//    swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(substringFromIndex:), @selector(xd_substringFromIndex:));
//    swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(substringToIndex:), @selector(xd_substringToIndex:));
////    swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(substringWithRange:), @selector(xd_substringWithRange:));
//    swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(rangeOfString:options:range:locale:), @selector(xd_rangeOfString:options:range:locale:));
}

+ (instancetype)xd_stringWithUTF8String:(const char *)nullTerminatedCString {
    if (nullTerminatedCString == NULL) {
        [self createThrowExceptionWithSEL:_cmd];
        return nil;
    }
    return [self xd_stringWithUTF8String:nullTerminatedCString];
}

+ (instancetype)xd_stringWithCString:(const char *)cString encoding:(NSStringEncoding)enc {
    if (cString == NULL) {
        [self createThrowExceptionWithSEL:_cmd];
        return nil;
    }
    return [self xd_stringWithCString:cString encoding:enc];
}

- (instancetype)xd_initWithCString:(const char *)nullTerminatedCString encoding:(NSStringEncoding)encoding {
    if (nullTerminatedCString == NULL) {
        [self createThrowExceptionWithSEL:_cmd];
        return nil;
    }
    return [self xd_initWithCString:nullTerminatedCString encoding:encoding];
}

- (instancetype)xd_initWithString:(NSString *)aString {
    if (!aString || ![aString isKindOfClass:NSString.class]) {
        [self createThrowExceptionWithSEL:_cmd];
        return nil;
    }
    return [self xd_initWithString:aString];
}

- (NSString *)xd_substringFromIndex:(NSUInteger)from {
    if (from > self.length) {
        throwException(XDExcetionTypeString, [NSString stringWithFormat:@"字符串处理异常，函数：%@；from：%lu；开始位置超出字符串的长度", NSStringFromSelector(_cmd), from], @{});
        return nil;
    }
    return [self xd_substringFromIndex:from];
}

- (NSString *)xd_substringToIndex:(NSUInteger)to {
    if (to > self.length) {
        throwException(XDExcetionTypeString, [NSString stringWithFormat:@"字符串处理异常，函数：%@；to：%lu；结束位置超出或等于字符串的长度", NSStringFromSelector(_cmd), to], @{});
        return nil;
    }
    return [self xd_substringToIndex:to];
}

- (NSString *)xd_substringWithRange:(NSRange)range {
    if (NSMaxRange(range) > self.length) {
        throwException(XDExcetionTypeString, [NSString stringWithFormat:@"字符串处理异常，函数：%@；range：%@；range最大值超出了字符串的长度", NSStringFromSelector(_cmd), NSStringFromRange(range)], @{});
        return nil;
    }
    return [self xd_substringWithRange:range];
}

- (NSRange)xd_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(NSLocale *)locale {
    if (!searchString || NSMaxRange(rangeOfReceiverToSearch) > self.length) {
        throwException(XDExcetionTypeString, [NSString stringWithFormat:@"字符串处理异常，函数：%@；查找的字符串：%@，range：%@；range最大值超出了字符串的长度或者查找的字符串为空", NSStringFromSelector(_cmd), searchString, NSStringFromRange(rangeOfReceiverToSearch)], @{});
        return NSMakeRange(NSNotFound, 0);
    }
    return [self xd_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}

+ (void)createThrowExceptionWithSEL:(SEL)aSelector {
    throwException(XDExcetionTypeString, [NSString stringWithFormat:@"字符串创建出现错误，函数：%@", NSStringFromSelector(aSelector)], @{});
}

- (void)createThrowExceptionWithSEL:(SEL)aSelector {
    [self.class createThrowExceptionWithSEL:aSelector];
}

@end

@implementation NSMutableString (Protection)

+ (void)xd_open {
    Class cls = NSClassFromString(@"__NSCFString");
    swizzleInstanceMethod(cls, @selector(appendString:), @selector(xd_appendString:));
    swizzleInstanceMethod(cls, @selector(insertString:atIndex:), @selector(xd_insertString:atIndex:));
    swizzleInstanceMethod(cls, @selector(deleteCharactersInRange:), @selector(xd_deleteCharactersInRange:));
}

- (void)xd_appendString:(NSString *)aString {
    if (!aString || ![aString isKindOfClass:NSString.class]) {
        return;
    }
    [self xd_appendString:aString];
}

- (void)xd_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    if (!aString || ![aString isKindOfClass:NSString.class]) {
        return;
    }
    if (loc > self.length) {
        return;
    }
    [self xd_insertString:aString atIndex:loc];
}

- (void)xd_deleteCharactersInRange:(NSRange)range {
    if (NSMaxRange(range) > self.length) {
        return;
    }
    [self xd_deleteCharactersInRange:range];
}

@end
