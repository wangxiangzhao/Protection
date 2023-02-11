//
//  NSDictionary+Protection.h
//  Test
//
//  Created by wangxiangzhao on 2023/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Protection)

+ (void)xd_open;

@end

@interface NSMutableDictionary (Protection)

+ (void)xd_open;

@end

NS_ASSUME_NONNULL_END
