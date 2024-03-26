//
//  Runloop机制.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/19.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//
//MARK: - 笔记
/**
    1、什么是runloop?
        runloop是一个对象，是事件循环机制，使得线程能随时响应并处理事件的机制,里面的主要源码是do-while循环。
        runloop是swift和oc都有的机制，并不是某一个独有的。
        runloop管理了其需要处理的事件和消息，并提供了一个入口函数来执行上面 事件循环 的逻辑。
        线程进入runloop的入口函数后，就会一直处于这个函数内部 “接受消息->等待->处理” 的循环当中，除非runloop再没有事件和消息之后才会被销毁。
        runloop的模式是系统根据用户的行为触发的，而不是程序员自定义的，程序员只能添加事件到这些场景中，并不能修改场景。
 
    2、runloop的应用场景：
        App一启动就会开一个主线程，主线程一开起来就会跑一个主线程对应的RunLoop,RunLoop保证主线程不会被销毁，也就保证了程序的持续运行。
        定时器（Timer）、方法调用（PerformSelector）、GCD Async Main Queue、事件响应、手势识别、界面刷新、网络请求 AutoreleasePool。
        节省CPU资源，提高程序性能，程序运行起来时，当什么操作都没有做的时候，RunLoop就告诉CPU要去休眠，这时CPU就会将runloop的资源释放出来
        去做其他的事情，当有事情做的时候RunLoop就会立马起来去做事情。
        PerformSelecter方法其实是把事件添加到当前线程的runloop中。

    3、runloop的底层代码：
        NSRunLoop是基于CFRunLoopRef 的封装，提供了面向对象的 API，但是这些API 不是线程安全的，但是CFRunLoopRef 提供的是纯 C 函数的API，而所有这些 API 都是线程安全的。
 
        CFRunLoopRef是一个C语言的结构体，里面的成员记录了：
            RunLoop对应的线程、唤醒runloop的端口、mode字符串，mode的item、mode的运行模式等信息。
 
        在主线程创建主runloop的时候，会创建一个全局的字典，用于存放 线程-runloop 的键值对，维护线程与runloop的一一对应关系。
        子线程的runloop需要我们手动去获取runloop的时候才会被创建，否则不会被创建，线程就只是线程而已。
        RunLoop的销毁：系统在创建RunLoop的时候，会注册一个回调，确保线程在销毁的同时，也销毁掉其对应的RunLoop。
        RunLoop相关的类有5个：
            CFRunLoopRef:runloop本身
            CFRunLoopModeRef：代表runloop的运行模式。里面可以有多个mode item（就是事件、定时器、监听器这些）
            CFRunLoopSourceRef：代表runloop的输入事件。在mode里
            CFRunLoopTimerRef：定时器，也在mode里
            CFRunLoopObserverRef：监听runloop的运行状态。还是在mode 里。用于监听RunLoop的状态，UI刷新，自动释放池。

 
 
    4、runloop机制的设计：
        每次调用 RunLoop的主函数时，只能指定其中一个 Mode，如果需要切换 Mode，只能退出Loop，再重新指定一个Mode进入。
        这样做主要是为了分隔开不同组的 Source/Timer/Observer，让其互不影响。如果一个 mode中一个Source/Timer/Observer 都没有，则RunLoop会直接退出，不进入循环。
    
 */

import Foundation
