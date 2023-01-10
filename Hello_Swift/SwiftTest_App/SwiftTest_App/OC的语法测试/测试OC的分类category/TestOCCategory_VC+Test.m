//
//  TestOCCategory_VC+Test.m
//  SwiftTest_App
//
//  Created by mathew on 2023/1/9.
//  Copyright © 2023 com.mathew. All rights reserved.
//
// 测试OC Category的Category。

#import "TestOCCategory_VC+Test.h"
//MARK: - 笔记
/**
    1、在代码文件层面，实例对象的代码存储的是成员变量，类对象代码存储的是属性、对象方法、协议、成员变量。实例对象代码的isa指针指向类对象代码、类对象代码的isa指针指向父类。
        元类对象的代码空间，存储的是类方法。
    2、分类对象的代码空间，是追加到类对象代码的方法链表里(前插)，是链表结构，在运行时追加。分类可以添加方法、协议、属性、但是不可以添加成员变量。因为成员变量是连续内存空间。
        分类写的 @property属性并不会生成对应的下划线成员变量，也就是不会在原来的对象空间扩展内存，而是分类对象自身代码文件会给属性分配空间。
    3、oc的initialize方法，是当 类 第一次接收到用户消息 的时候就调用。(也就是(全局)第一次使用这个类的时候，先父类再子类，第二次就不调用了)
        消息机制是通过isa指针逐层去查找方法。
        load方法，首次加载的时候，是直接调用load的方法地址，执行方法体，没有通过消息机制。手动调用的话，是通过消息机制。
 */

@implementation TestOCCategory_VC (Test)

- (void)testCategory{
    NSLog(@"测试OC Category的 testCategory 方法");
}

@end
