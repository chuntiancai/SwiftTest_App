//
//  OC中枚举的写法.m
//  SwiftTest_App
//
//  Created by mathew on 2022/4/21.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import <Foundation/Foundation.h>
//MARK: 第一种枚举的写法，没有办法定义枚举的绑定类型
typedef enum {
    MyEnumTop,
    MyEnumBottom
} MyEnum;   //MyEnum是枚举名称

//MARK: 枚举的第二种写法,OC写法，NSInteger是枚举绑定类型，MyEnumTwo是枚举的名称
typedef NS_ENUM(NSInteger,MyEnumTwo){
    MyEnumTwoTop,
    MyEnumTwoBottom
};

//MARK: 枚举的第三种写法,位移枚举，
/// 如果位移枚举值没有0值，那么传入0作为枚举参数，那么所有有关于枚举的判断都不会执行，这样的效率最高。
typedef NS_OPTIONS(NSInteger, MyEnumOption) {
    MyEnumOptionTop = 1 << 0,   //左移0位，1
    MyEnumOptionBottom = 1 << 1,    //左移1位，2
    MyEnumOptionLeft = 1 << 2,       //左移2位，4
    MyEnumOptionRight = 1 << 3,     //左移3位，8
    MyEnumOptionMiddle = 1 << 4,     //左移4位，16
};

//MARK: - 枚举的使用
@interface OCEnumTest : NSObject
@end
@implementation OCEnumTest

-(void)testEnum:(MyEnumOption)enumType {
    if (enumType  & MyEnumOptionTop){
        NSLog(@"向上---%zd",enumType  & MyEnumOptionTop);
    }
}

-(void)test{
    [self testEnum:MyEnumOptionTop | MyEnumOptionLeft];
}

@end
