//
//  TestMemory_Dog.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/21.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试内存泄漏，循环引用不释放，dog

class TestMemory_Dog: NSObject{
    
    var master:TestMemory_Person?
    var dogName:String = ""
    init(_ name:String = "") {
        super.init()
        dogName = name
        print("TestMemory_Dog 初始化了 ",String(format: "%p",self))
    }
    deinit{
        print("TestMemory_Dog 销毁了")
    }
}
