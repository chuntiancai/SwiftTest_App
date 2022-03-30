//
//  Singleton_Person.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/29.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 单例对象

class Singleton_Person{
    
    static let shared = Singleton_Person()  //用静态方法去实现单例，只执行一次，let 表明不能修改
    
    var name:String = "张单例"
    var age:Int = 15
    private init() {
        
    }
    
}

class Singleton_NSObject: NSObject {
    
    static let shared:Singleton_NSObject = Singleton_NSObject() //用静态方法去实现单例，只执行一次，let 表明不能修改
    
    var name:String = "李单例"
    var age:Int = 16
    
    private override init() {   //将初始化方法私有化
        
    }
    
}
