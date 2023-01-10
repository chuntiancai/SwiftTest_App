//
//  OCRuntime_Person+Property.h
//  SwiftTest_App
//
//  Created by mathew on 2022/6/24.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCRuntime_Person.h"
//MARK: - 笔记
/**
    通过分类，动态添加属性。 
    1、@property 分类： 只会产生get、set方法的声明，不会发生实现，也不会生成下划线成员属性。
 */

@interface OCRuntime_Person (Property)

@property NSString * nickName;

@end

