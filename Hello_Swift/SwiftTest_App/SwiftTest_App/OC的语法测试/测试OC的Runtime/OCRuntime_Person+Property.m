//
//  OCRuntime_Person+Property.m
//  SwiftTest_App
//
//  Created by mathew on 2022/6/24.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import "OCRuntime_Person+Property.h"
#import <objc/message.h>

@implementation OCRuntime_Person (Property)


/// 动态给属性绑定一个对象。
- (void)setNickName:(NSString *)nickName{
    // 第一个参数object：给哪个对象添加关联
    // 第二个参数key：关联的key，通过这个key获取
    // 第三个参数value：关联的value
    // 第四个参数objc_AssociationPolicy: 关联的策略
    objc_setAssociatedObject(self, @"nickName", nickName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)nickName{
    return  objc_getAssociatedObject(self, @"nickName");
}

@end
