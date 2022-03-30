//
//  SubThread.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/30.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 自定义Thread线程，子类化子线程

class SubThread: Thread {
    
    /// 重写main方法，默认任务是在main方法里执行的。main方法里面的代码就相当于任务了。
    override func main() {
        print(" Thread \(#function) -- 执行Thread 里 的main方法里的代码")
        print("当前线程：\(Thread.current)")
        print(" Thread \(#function) -- Thread main方法 -- end")
    }
    
    /// 重写Start方法
    override func start() {
        print("SubThread -- \(#function)")
        super.start()
    }
}

//MARK: - 笔记
/**
    1、重写main方法，默认任务是在main方法里执行的。main方法里面的代码就相当于任务了。
 */
