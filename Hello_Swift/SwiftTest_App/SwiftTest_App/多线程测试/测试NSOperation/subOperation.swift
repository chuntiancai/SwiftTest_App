//
//  SubOperation.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/9.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 子类化Operation，重写main方法，即时编写任务

import UIKit

class SubOperation: Operation {
    
    override func main() {
        print("子类：这是子类 SubOperation 的 main 方法")
        if self.isCancelled {   //当前已经被取消，所以就直接返回
            return
        }
        print(" ----- end -------")
    }
    
    /// 重写开启任务的方法
    override func start() {
        print("\(#function) Thread : \(Thread.current)")
        super.start()
    }
    
}

//MARK: - 笔记
/**
    1、Operation添加到队列中就会被队列管理，由队列默认开启。
    2、Operation也可以调用start()自己启动自己，相当于自己添加到一条自己创建的队列中，然后在自己创建的队列中启动自己
 */
