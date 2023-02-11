//
//  NSMutableArray+Protection.h
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Protection)

//开启添加、修改、交换等操作崩溃防护
+ (void)xd_open;

@end

NS_ASSUME_NONNULL_END
