//
//  KVC_Person.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/13.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 用于测试KVC的Person类

@objc class KVC_Person: NSObject {
    
    @objc var name:String = ""
    @objc private var age:Int = 0
    @objc private var money:Float = 2000
    @objc private var dog:KVC_Dog = KVC_Dog(PName: "wangcai", PAge: 2)

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


class KVC_Dog: NSObject {
    
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

struct KVC_Student {
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

//MARK: 笔记
/**
    1、非结构体使用KVC的，必须要在属性变量前加上@objc关键字，声明是@objc类型的属性，哪怕是在类名前加上@objc关键字都不行，必须是属性前。
 
 */
