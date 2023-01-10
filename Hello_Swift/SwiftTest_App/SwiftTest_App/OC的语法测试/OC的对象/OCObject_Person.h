//
//  OCObject_Person.h
//  SwiftTest_App
//
//  Created by mathew on 2023/1/10.
//  Copyright © 2023 com.mathew. All rights reserved.
//
//MARK: - 笔记
/**
    1、oc对象的自身大小 = 自身成员变量的大小 + 父类结构体自身的大小。
        注意，一个指针自身的大小是8个字节。
 
    2、如果没有太多的实现，直接把类的实现代码写在.h头文件好了，不用那么多文件，因为都是经过编译器编译，头文件只是一种书写规范，我不遵循了。
 
    3、实例对象的内存空间只存放成员变量空间，不存放方法。因为方法是多个实例对象可以共用的代码，而成员变量是不共用的。
        方法是存放在类对象的方法列表里。
 
 */

#import <Foundation/Foundation.h>


@interface OCObject_Person : NSObject
{
                //父类结构体的自身大小
    @public
    int _no;    //4字节
    int _age;   //4字节
}

@end

@implementation OCObject_Person

@end
