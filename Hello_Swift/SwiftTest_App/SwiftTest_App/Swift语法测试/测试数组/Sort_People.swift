//
//  Sort_People.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/5/25.
//  Copyright © 2022 com.mathew. All rights reserved.
//

class Sort_People: NSObject {
    
    @objc dynamic var name:String = ""
    @objc dynamic var sex:String = "man"
    @objc dynamic var age:Int = 0
    @objc private var money:Float = 2000

    convenience init(PName:String,PAge:Int,sex:String = "man",money:Float = 2000) {
        self.init()
        self.name = PName
        self.age = PAge
        self.sex = sex
        self.money = money
    }
    
    override var description: String {
        let backStr = """
                        {
                        name:\(self.name),
                        sex:\(self.sex),
                        age:\(self.age),
                        money:\(self.money),
                        }
                        """
        return backStr
    }
    
}
