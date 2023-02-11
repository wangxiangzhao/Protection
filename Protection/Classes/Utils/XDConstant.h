//
//  XDConstant.h
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 获取程序运行地址
uintptr_t get_load_address(void);
uintptr_t get_slide_address(void);


#pragma mark - 添加weak的关联对象
typedef id weakid;
typedef weakid _Nullable (^WeakReference)(void);
WeakReference packWeakReference(id ref);
weakid unpackWeakReference(WeakReference closure);


@interface XDConstant : NSObject


@end

//抛出异常
extern NSString * const XDNotifitionKey_throw_exception;

NS_ASSUME_NONNULL_END
