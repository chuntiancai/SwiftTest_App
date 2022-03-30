//
//  CocoapodFrameworkClass.swift
//  CocoaPodFrameworkTest
//
//  Created by mathew on 2021/8/30.
//
// 测试framework对外公开的类

import UIKit

open class CocoapodFrameworkClass: NSObject {
    
    /// 测试生成的framework的第一个方法
    open func testCocoaPodFramwork(name: String){
        print("     这是你在testCocoapodFramwork输入的名字：\(name)")
    }
    
    
    /// 测试不是open的方法
    public func addCocoaPodNmae(name:String){
        print("     这是CocoapodFrameworkClass不open的addCocoaPodNmae方法:\(name)")
    }
    
}

