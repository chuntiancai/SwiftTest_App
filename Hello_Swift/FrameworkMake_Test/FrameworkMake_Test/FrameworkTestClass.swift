//
//  FrameworkTestClass.swift
//  FrameworkMake_Test
//
//  Created by mathew on 2021/8/26.
//
// 测试framework对外公开的类

import UIKit

open class FrameworkTestClass: NSObject {
    
    /// 测试生成的framework的第一个方法
    open func testFramwork(name: String){
        print("     这是你在testFramwork输入的名字：\(name)")
    }
    
    
    /// 测试不是open的方法
    public func addNmae(name:String){
        print("     这是FrameworkTestClass不open的addName方法:\(name)")
    }
    
}

//MARK: - 笔记
/**
    1、open、public关键字暴露对外的接口即可，跟新建project差不多的流程。
 */
