//
//  TestCocoPodClass.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/30.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 作为一个swift文件，提供给cocoapod使用，参与编译的swift文件。

import Foundation

open class TestCocoPodClass: NSObject {
    
    /// 测试生成的framework的第一个方法
    open func testCocoaPod(name: String){
        print("     这是你在testCocoaPod输入的名字：\(name)")
    }
    
    
    /// 测试不是open的方法
    public func addNmae(name:String){
        print("     这是TestCocoPodClass不open的addName方法:\(name)")
    }
    
}
