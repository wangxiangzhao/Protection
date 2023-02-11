//
//  NSObject+KVO.m
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import "NSObject+KVO.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>
#import "XDConstant.h"
#import "XDException.h"

@interface XDKVOItem : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, assign) NSKeyValueObservingOptions options;
@property (nonatomic, assign) void *context;

- (instancetype)initWithObserver:(NSObject *)observer keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end

@implementation XDKVOItem

- (instancetype)initWithObserver:(NSObject *)observer keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    self = [super init];
    if (self) {
        self.observer = observer;
        self.keyPath = keyPath;
        self.options = options;
        self.context = context;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self.observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (BOOL)isEqual:(XDKVOItem *)other {
    if (!_observer || !_keyPath) return NO;
    return [_observer isEqual:other.observer] && [_keyPath isEqualToString:other.keyPath];
}

- (NSUInteger)hash {
    return [_observer hash] ^ [_keyPath hash];
}

- (void)dealloc {
    
}

@end

@interface XDKVOContainer : NSObject

@property (nonatomic, strong) NSMutableSet<XDKVOItem *>* items;
@property (nonatomic, strong) NSLock *lock;

- (BOOL)addItem:(XDKVOItem *)item;
- (void)removeItem:(XDKVOItem *)item;
- (XDKVOItem *)findItemWithObserver:(NSObject *)observer keyPath:(NSString *)keyPath;

@end

@implementation XDKVOContainer

- (BOOL)addItem:(XDKVOItem *)item {
    [self.lock lock];
    if (!item) {
        [self.lock unlock];
        return NO;
    }
    BOOL exist = [self.items containsObject:item];
    if (!exist) {
        [self.items addObject:item];
        [self.lock unlock];
        return YES;
    }
    [self.lock unlock];
    return NO;
}

- (void)removeItem:(XDKVOItem *)item {
    [self.lock lock];
    if ([self.items containsObject:item]) {
        [self.items removeObject:item];
    }
    [self.lock unlock];
}

- (XDKVOItem *)findItemWithObserver:(NSObject *)observer keyPath:(NSString *)keyPath {
    if (!observer || !keyPath) return nil;
    [self.lock lock];
    XDKVOItem *temp;
    for (XDKVOItem *obj in self.items) {
        if ([obj.observer isEqual: observer] && [obj.keyPath isEqualToString:keyPath]) {
            temp = obj;
            break;
        }
    }
    if (temp) {
        [self.items removeObject:temp];
    }
    [self.lock unlock];
    return temp;
}

#pragma mark - getter

- (NSMutableSet<XDKVOItem *> *)items {
    if (_items) {
        return _items;
    }
    _items = [[NSMutableSet alloc] init];
    return _items;
}

- (NSLock *)lock {
    if (_lock) return _lock;
    _lock = [[NSLock alloc] init];
    return _lock;
}

- (void)dealloc {
    
}

@end

@interface NSObject (KVOProperty)

@property (nonatomic, strong) XDKVOContainer *kvo_container;

@end

@implementation NSObject (KVOProperty)

- (XDKVOContainer *)kvo_container {
    XDKVOContainer *container = objc_getAssociatedObject(self, _cmd);
    if (!container) {
        container = [[XDKVOContainer alloc] init];
        self.kvo_container = container;
    }
    return container;
}

- (void)setKvo_container:(XDKVOContainer *)kvo_container {
    objc_setAssociatedObject(self, @selector(kvo_container), kvo_container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation NSObject (KVO)

+ (void)openKVOProtection {
    [self swizzleInstanceMethodWithOriginalSEL:@selector(addObserver:forKeyPath:options:context:) newSEL:@selector(xd_addObserver:forKeyPath:options:context:)];
    [self swizzleInstanceMethodWithOriginalSEL:@selector(removeObserver:forKeyPath:) newSEL:@selector(xd_removeObserver:forKeyPath:)];
    [self swizzleInstanceMethodWithOriginalSEL:@selector(removeObserver:forKeyPath:context:) newSEL:@selector(xd_removeObserver:forKeyPath:context:)];
}

- (void)xd_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    if ([self ignoreKVODelegateForObserver:observer]) {
        [self xd_addObserver:observer forKeyPath:keyPath options:options context:context];
        return;
    }
    if (![self isValidKeyPath:keyPath] || !observer) {
        NSString *message = [NSString stringWithFormat:@"%@的对象添加监听者：%@时，keyPath = %@是无效的！！！", NSStringFromClass(self.class), NSStringFromClass(observer.class), keyPath];
        if (!observer) {
            message = [NSString stringWithFormat:@"%@的对象添加监听者时，监听者为nil", NSStringFromClass(self.class)];
        }
        throwException(XDExcetionTypeKVO, message, @{});
        return;
    }
    XDKVOItem *item = [[XDKVOItem alloc] initWithObserver:observer keyPath:keyPath options:options context:context];
    BOOL addResult = [self.kvo_container addItem:item];
    if (!addResult) return;
    [self xd_addObserver:item forKeyPath:keyPath options:options context:context];
}

- (void)xd_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if ([self ignoreKVODelegateForObserver:observer]) {
        [self xd_removeObserver:observer forKeyPath:keyPath];
        return;
    }
    if (![self isValidKeyPath:keyPath] || !observer) {
        NSString *message = [NSString stringWithFormat:@"%@的对象移除监听者：%@时，keyPath = %@是无效的！！！", NSStringFromClass(self.class), NSStringFromClass(observer.class), keyPath];
        if (!observer) {
            message = [NSString stringWithFormat:@"%@的对象移除监听者时,监听者已经释放", NSStringFromClass(self.class)];
        }
        throwException(XDExcetionTypeKVO, message, @{});
        return;
    }
    XDKVOItem *temp = [self.kvo_container findItemWithObserver:observer keyPath:keyPath];
    if (!temp) return;
    [self.kvo_container removeItem:temp];
    [self xd_removeObserver:temp forKeyPath:keyPath];
}

- (void)xd_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context {
    if ([self ignoreKVODelegateForObserver:observer]) {
        [self xd_removeObserver:observer forKeyPath:keyPath context:context];
        return;
    }
    [self removeObserver:observer forKeyPath:keyPath];
}

//是否是有效的keyPath
- (BOOL)isValidKeyPath:(NSString *)keyPath {
    if (!keyPath || ![keyPath isKindOfClass:NSString.class] || keyPath.length == 0) {
        return NO;
    }
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
    for (int idx = 0; idx < outCount; idx ++) {
        objc_property_t property = properties[idx];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if ([propertyName isEqualToString:keyPath]) return YES;
    }
    return NO;
}

//对一些特殊监听者忽略掉监听代理
- (BOOL)ignoreKVODelegateForObserver:(NSObject *)observer {
    if (!observer) {
        return NO;
    }
    //Ignore ReactiveCocoa
    if (object_getClass(observer) == objc_getClass("RACKVOProxy")) {
        return YES;
    }
    //Ignore AMAP
    NSString* className = NSStringFromClass(object_getClass(observer));
    if ([className hasPrefix:@"AMap"] || [className hasPrefix:@"_UI"] || [className hasPrefix:@"_NS"]) {
        return YES;
    }
    return NO;
}

@end
