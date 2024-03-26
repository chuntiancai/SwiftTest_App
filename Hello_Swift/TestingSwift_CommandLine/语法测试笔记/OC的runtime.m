//
//  OC的runtime.m
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/13.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//
//MARK: - 笔记
/**
    1、objc_object定义，在OC中每一个对象在底层C++都是一个结构体，结构体中都包含一个isa的成员变量，其位于成员变量的第一位。
        isa_t是一个结构体，作用就是用来存储类的信息，isa_t里面有个Class cls这个变量，这也是个结构体。
        cls就我们口中的类objc_class，类其实也是一个对象,cls里有三个成员变量，也是结构体：
            第一个变量： superclass:指向他的父类
            第二个变量cache: 这里面存储的方法缓存。
            第三个变量bits： 存储对象的方法、属性、协议等信息。

        OC中每一个对象底层都是通过objc_object结构体来维护 -> objc_object有个成员isa指向自己的子类 -> objc_class结构体 ->
        objc_class记录了初始化实例对象所需要的信息，和继承链关系 -> objc_class的super_class成员指向自己的父类（也是继承objc_object）
        ->
 
 */

#import <Foundation/Foundation.h>
