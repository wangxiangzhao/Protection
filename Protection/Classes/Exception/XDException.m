//
//  XDException.m
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import "XDException.h"
#import "XDConstant.h"

@implementation XDException

- (NSString *)description {
    return [NSString stringWithFormat:@"异常类型：%ld\n异常信息：%@\n扩展信息：%@\n程序地址：%@，镜像偏移量：%@\n堆栈信息：%@", _type, _message, _extendInfo, _loadAddress, _slideAddress, _callStackSymbols];
}

@end

//抛异常
void throwException(XDExcetionType type, NSString *message, NSDictionary *extendInfo) {
    XDException *exception = [[XDException alloc] init];
    exception.type = type;
    exception.message = message;
    exception.extendInfo = extendInfo;
    exception.loadAddress = [NSString stringWithFormat:@"%lu", get_load_address()];
    exception.slideAddress = [NSString stringWithFormat:@"%lu", get_slide_address()];
    exception.callStackSymbols = [NSThread callStackSymbols];
    [NSNotificationCenter.defaultCenter postNotificationName: XDNotifitionKey_throw_exception object: nil userInfo:@{
        @"exception" : exception
    }];
}
