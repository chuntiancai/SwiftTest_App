//
//  KVO_Observer.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/16.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试KVO的观察者
//MARK: - 笔记
/**
    1、注意: override func observeValue(...)
            override class func observeValue(...)
        这两个方法是不一样的，如果复写 class func observeValue方法，但是接收的是成员变量的变化，则会报错，不要乱复写。
 
    2、必须在析构方法中释放掉观察者。
 */

class KVO_Observer:NSObject{
    
    override init() {
        super.init()
        print("KVO的观察者初始化了")
    }
    
    
    
}

//MARK: -
extension KVO_Observer{
    //MARK: 接受主题消息的方法
    ///还有一个observeValue是类方法，不要复写错了，类方法不是接收成员变量的变化消息的，应该是接收类成员变化的消息。
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("KVO_Observer接收到的主题者的属性是：\n\(String(describing: keyPath));\n--主题者object:\(String(describing: object));\n---变化的值change:\(String(describing: change));\n---context:\(String(describing: context))")
    }

    /// 接受类成员的值变化，但是如果也会接受成员变量的变化，如果接受到成员变量的变化，又不处理的话，就会报错，所以不要复写这个方法。
    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("KVO_Observer接收到的主题者的属性是：\n\(String(describing: keyPath));\n--主题者object:\(String(describing: object));\n---变化的值change:\(String(describing: change));\n---context:\(String(describing: context))")
    }
}

//MARK: -
extension KVO_Observer{
    
}

//MARK: -
extension KVO_Observer{
    
}

// MARK: - 笔记
/**
 
 */

