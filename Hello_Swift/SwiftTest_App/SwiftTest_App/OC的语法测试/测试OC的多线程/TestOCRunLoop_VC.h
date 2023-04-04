//
//  TestOCRunLoop_VC.h
//  SwiftTest_App
//
//  Created by mathew on 2023/3/21.
//  Copyright © 2023 com.mathew. All rights reserved.
//

#import <UIKit/UIKit.h>

//MARK: - 笔记
/**
    1、RunLoop保存在一个全局的Dictionary里，线程作为key，RunLoop作为value。
        线程刚创建时并没有RunLoop对象，RunLoop会在第一次获取它时创建，RunLoop会在线程结束时销毁。
        主线程的RunLoop已经自动获取（创建），子线程默认没有开启RunLoop。
 
    2、获取Runloop，获取的是当前线程的runloop。
        OC封装的runloop：
        [NSRunLoop currentRunLoop]; // 获得当前线程的RunLoop对象
        [NSRunLoop mainRunLoop]; // 获得主线程的RunLoop对象

        C语言封装的runloop：
        CFRunLoopGetCurrent(); // 获得当前线程的RunLoop对象
        CFRunLoopGetMain(); // 获得主线程的RunLoop对象
 
    3、RunLoop的运行逻辑：
         1、通知Observers：进入Loop
         2、通知Observers：即将处理Timers
         3、通知Observers：即将处理Sources
         4、处理Blocks
         5、处理Source0（可能会再次处理Blocks）
         6、如果存在Source1，就跳转到第8步
         7、通知Observers：开始休眠（等待消息唤醒）
         8、通知Observers：结束休眠（被某个消息唤醒）
                > 处理Timer
                > 处理GCD Async To Main Queue
                > 处理Source1
         9、处理Blocks
         10、根据前面的执行结果，决定如何操作
                > 回到第02步
                > 退出Loop
         11、通知Observers：退出Loop

    4、runloop里的成员：
        Source0
            触摸事件处理
            performSelector:onThread:

        Source1
            基于Port的线程间通信
            系统事件捕捉

        Timers
            NSTimer
            performSelector:withObject:afterDelay:

        Observers
            用于监听RunLoop的状态
            UI刷新（BeforeWaiting）
            Autorelease pool（BeforeWaiting）

    5、runloop的作用：
        > 可以让线程保活，只需要创建runloop，而不需要新建线程，节省资源。
 */



NS_ASSUME_NONNULL_BEGIN

@interface TestOCRunLoop_VC : UIViewController

@end

NS_ASSUME_NONNULL_END
