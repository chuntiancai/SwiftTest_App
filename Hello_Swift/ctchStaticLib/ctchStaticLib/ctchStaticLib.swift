//
//  ctchStaticLib.swift
//  ctchStaticLib
//
//  Created by mathew on 2022/10/20.
//
// MARK: - 笔记

class CtchStaticLib {
    
    static func sayName(_ name:String = ""){
        print("测试.a文件的引入,静态方法name：\(name)")
    }

    func sayAge(_ age:Int = 18){
        print("测试.a文件的引入,实例方法age：\(age)")
    }
}
