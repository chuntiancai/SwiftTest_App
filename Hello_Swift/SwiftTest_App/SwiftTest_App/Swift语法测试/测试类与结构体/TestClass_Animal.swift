//
//  TestClass_Animal.swift
//  SwiftTest_App
//
//  Created by mathew on 2023/6/9.
//  Copyright © 2023 com.mathew. All rights reserved.
//

class TestClass_Animal:NSObject {
    var name = "动物"
    required override init(){
        super.init()
    }
}

class TestClass_Dog:TestClass_Animal {
    required init() {
        super.init()
        self.name = "小狗"
    }
    
}

class TestClass_Cat:TestClass_Animal {
    required init() {
        super.init()
        self.name = "小猫"
    }
}
