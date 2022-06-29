//
//  Point_Person.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/6/28.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 用于测试指针的Person类

//MARK: 笔记
/**
    1、
 
 */


class Point_Person: NSObject {
    
   var name:String = ""
   private var age:Int = 0
   private var money:Float = 2000
   private var dog:Point_Dog = Point_Dog(PName: "wangcai", PAge: 2)

    convenience init(PName:String,PAge:Int,money:Float = 2000) {
        self.init()
        self.name = PName
        self.age = PAge
    }
    
    override var description: String {
        let backStr = """
                        {
                        name:\(self.name),
                        age:\(self.age),
                        money:\(self.money),
                        dog:\(self.dog)
                        }
                        """
        return backStr
    }
    
}


class Point_Dog: NSObject {
    
    @objc private var name:String = ""
    @objc private var age:Int = 0
    
    convenience init(PName:String,PAge:Int) {
        self.init()
        self.name = PName
        self.age = PAge
    }
    override var description:String{
        get{
            let info = "{name:\(name) , age:\(age)}"
            return info
        }
    }
}

struct Point_Student {
    var name:String = ""
    var age:Int = 0

    init(PName:String,PAge:Int) {
        self.name = PName
        self.age = PAge
    }
    
    var description: String {
        let backStr = """
                        {
                        name:\(self.name),
                        age:\(self.age),
                        }
                        """
        return backStr
    }
    
}

