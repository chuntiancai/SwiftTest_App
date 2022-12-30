//
//  TestMemory_Person.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/21.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试内存泄漏，循环引用不释放，Person

class TestMemory_Person: NSObject {
    var dog:TestMemory_Dog?
    var name:String = ""
    init(_ name:String = "") {
        super.init()
        self.name = name
        print("TestMemory_Person 初始化了",String(format: "%p", self))
    }
    deinit{
        print("TestMemory_Person 销毁了")
    }
}
