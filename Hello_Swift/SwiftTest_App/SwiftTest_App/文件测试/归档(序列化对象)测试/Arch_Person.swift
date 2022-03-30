//
//  Arch_Persion.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/10.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试归档化的自定义对象。

class Arch_Person: NSObject,NSCoding,NSSecureCoding {
    
    var name:String = "小明"
    var age:Int = 5
    var money:Double = 12530.62
    var dog:Arch_Dog = Arch_Dog.init(name: "小旺", age: 1)
    
    /// 编码成存储的对象,在该方法，告诉系统，编码成存储对象时，要存储哪些属性。
    func encode(with coder: NSCoder) {
        print("Arch_Person的\(#function)方法")
        coder.encode(self.name, forKey: "name")
        coder.encode(self.age, forKey: "age")
        coder.encode(self.money, forKey: "money")
        coder.encode(self.dog, forKey: "dog")
    }
    
    /// 从 存储的对象 解码成 程序可使用的对象，在这里告诉系统，你要解析哪一些属性。
    required init?(coder: NSCoder) {
        print("Arch_Person的\(#function)方法")
        self.name = coder.decodeObject(forKey: "name") as? String ?? ""
        self.age = coder.decodeInteger(forKey: "age")
        self.money = coder.decodeDouble(forKey: "money")
        self.dog = coder.decodeObject(forKey: "dog") as? Arch_Dog ?? Arch_Dog(name: "小狗", age: 0)
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    private override init() {
        super.init()
    }
    
    convenience init(name:String,age:Int,money:Double = 100){
        self.init()
        self.name = name
        self.age = age
    }
    
    override var description: String {
        let rStr = """
            ===Arch_Person===
            {
             name : \(name),
             age : \(age),
             dog : \(dog)
            }
            """
        return rStr
    }
    
}


//MARK: - 小狗
class Arch_Dog: NSObject,NSCoding,NSSecureCoding {
    
    var name:String = "小狗"
    var age:Int = 0
    
    /// 编码成存储的对象,在该方法，告诉系统，编码成存储对象时，要存储哪些属性。
    func encode(with coder: NSCoder) {
        print("Arch_Dog的\(#function)方法")
        coder.encode(self.name, forKey: "name")
        coder.encode(self.age, forKey: "age")
    }
    
    /// 从 存储的对象 解码成 程序可使用的对象，在这里告诉系统，你要解析哪一些属性。
    required init?(coder: NSCoder) {
        print("Arch_Dog的\(#function)方法")
        self.name = coder.decodeObject(forKey: "name") as? String ?? ""
        self.age = coder.decodeInteger(forKey: "age")
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    private override init() {
        super.init()
    }
    
    convenience init(name:String,age:Int ){
        self.init()
        self.name = name
        self.age = age
    }
    
    override var description: String {
        let rStr = """
            ===Arch_Dog===
            {
             name : \(name),
             age : \(age)
            }
            """
        return rStr
    }
    
}


//MARK: - 笔记
/**
    
    模型类（被归档的类）
    1、其实本质也是通过key-value来编码解码。
        1.1. 模型类必须继承NSObject 、NSCoding, 在swift5.0 之后还要继承NSSecureCoding 协议
        1.2. 继承NSSecureCoding 需要实现supportsSecureCoding 方法, 并且必须要返回true(目前Xcode会点击fix 自动完成).
        1.3. 必须实现encode、decode方法

 */
