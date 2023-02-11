//
//  NSArray+Protection.h
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Protection)

//开启越界崩溃防护
+ (void)xd_open;

@end

NS_ASSUME_NONNULL_END
