//
//  KVO_Person.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/16.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 用于测试KVO的Person类

class KVO_Person: NSObject {
    
    @objc dynamic var name:String = ""
    @objc dynamic var sex:String = "man"
    @objc private dynamic var age:Int = 0
    @objc private var money:Float = 2000
    @objc private var dog:KVO_Dog = KVO_Dog(PName: "wangcai", PAge: 2)

    convenience init(PName:String,PAge:Int,sex:String = "man",money:Float = 2000) {
        self.init()
        self.name = PName
        self.age = PAge
        self.sex = sex
        self.money = money
    }
    
    @objc func eat(_ food:String){
        print("吃东西：\(food)")
    }
    
    @objc func walk(){
        print("人行走")
    }

    func playBasketball(){
        print("人打篮球")
    }
    
    @objc private func playGame(){
        print("人玩游戏")
    }
    
    private func sleep(){
        print("人睡觉")
    }
    
    
    
    override var description: String {
        let backStr = """
                        {
                        name:\(self.name),
                        sex:\(self.sex),
                        age:\(self.age),
                        money:\(self.money),
                        dog:\(self.dog)
                        }
                        """
        return backStr
    }
    
    
}


class KVO_Dog: NSObject {
    
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

struct KVO_Student {
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
    1、swift中的@dynamic关键字：用于告诉编译器这个方法是可能被动态调用的，需要将其添加到查找表中。这个就是关键字 dynamic 的作用。因为Objective-C 的消息发送是完全动态的，Swift 中的函数可以是静态调用也可以是动态调用。
       以前@dynamic关键字是默认带有@objc前缀的，现在需要手工显式写了，后面还会不会加回来就不知道。

 
 */

