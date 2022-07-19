//
//  Noti_Subject.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/24.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 通知的发布者，主题者

class Noti_Subject: NSObject {
    
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
    
    
}
//MARK: - 笔记
/**
 
 */
