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
//MARK: - 笔记
/*
    1、主要是编写spec文件，然后根据文件的描述，在classes文件夹下放swift文件，.framework文件即可，因为在spec文件中会描述这些文件的路径，与之对应即可。
    2、cocoapod给根据git仓库中的spec文件来查找spec文件中描述的文件和信息，来对swift这些文件进行编译。注意，不要把.framework文件放进spec编译的描述中，而是放到framwork的描述即可。
**/
