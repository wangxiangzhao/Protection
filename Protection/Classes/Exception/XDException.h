//
//  XDException.h
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    XDExcetionTypeUnrecognizedSelector = 1 << 0,                         //未识别方法
    XDExcetionTypeArray = 1 << 1,                                        //数组相关的错误
    XDExcetionTypeDictionary = 1 << 2,                                   //字典相关的错误
    XDExcetionTypeString = 1 << 3,                                       //字符串处理相关的错误
    XDExcetionTypeKVO = 1 << 4,                                          //监听相关的错误
    XDExcetionTypeTimer = 1 << 5,                                        //计时器相关的错误
    XDExcetionTypeAll = XDExcetionTypeUnrecognizedSelector | XDExcetionTypeArray | XDExcetionTypeDictionary | XDExcetionTypeString | XDExcetionTypeKVO | XDExcetionTypeTimer
} XDExcetionType;

@interface XDException : NSObject

@property (nonatomic, assign) XDExcetionType type;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSDictionary *extendInfo;
//线程堆栈信息
@property (nonatomic, strong) NSArray *callStackSymbols;
@property (nonatomic, copy) NSString *loadAddress;
@property (nonatomic, copy) NSString *slideAddress;

@end

//抛异常
void throwException(XDExcetionType type, NSString *message, NSDictionary *extendInfo);

NS_ASSUME_NONNULL_END
