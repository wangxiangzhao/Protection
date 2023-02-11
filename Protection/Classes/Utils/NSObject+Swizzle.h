//
//  NSObject+Swizzle.h
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

void swizzleInstanceMethod(Class cls, SEL original, SEL other);
void swizzleClassMethod(Class cls, SEL original, SEL other);

@interface NSObject (Swizzle)

#pragma mark - 替换方法
//替换实例方法
+ (void)swizzleInstanceMethodWithOriginalSEL:(SEL)originalSel newSEL:(SEL)newSel;
//替换类方法
+ (void)swizzleClassMethodWithOriginalSEL:(SEL)originalSel newSEL:(SEL)newSel;

@end

NS_ASSUME_NONNULL_END
