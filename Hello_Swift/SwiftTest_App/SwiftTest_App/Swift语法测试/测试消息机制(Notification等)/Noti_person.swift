//
//  Noti_person.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/24.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试通知的接收者，其实就是观察者模式
//MARK: - 笔记
/**
    1、接收通知的方法的参数必须是Notification类型。
 */


class Noti_person: NSObject {
    
    @objc var name:String = ""
    @objc private var age:Int = 0
    @objc private var money:Float = 2000

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
                        }
                        """
        return backStr
    }
    
    /// 接收新闻
    @objc func acceptNews(note:Notification){
        print("接收到通知：\(self.name)--\(#function) --- 接收到的新闻是：\n\(note)\n")
    }
    
}
