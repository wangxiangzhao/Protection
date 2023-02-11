//
//  XDConstant.m
//  Test
//
//  Created by wangxiangzhao on 2023/2/10.
//

#import "XDConstant.h"

#pragma mark - 获取程序运行地址
//应用基础地址
uintptr_t get_load_address(void) {
    const struct mach_header *exe_header = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) {
            exe_header = header;
            break;
        }
    }
    return (uintptr_t)exe_header;
}

//镜像虚拟地址偏移量
uintptr_t get_slide_address(void) {
    uintptr_t vmaddr_slide = 0;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) {
            vmaddr_slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    
    return (uintptr_t)vmaddr_slide;
}

#pragma mark - 添加weak的关联对象
WeakReference packWeakReference(id ref) {
    __weak weakid weakRef = ref;
    return ^{
        return weakRef;
    };
}

weakid unpackWeakReference(WeakReference closure) {
    return closure ? closure() : nil;
}

@implementation XDConstant


@end

//抛出异常
NSString * const XDNotifitionKey_throw_exception = @"XDNotifitionKey_throw_exception";
