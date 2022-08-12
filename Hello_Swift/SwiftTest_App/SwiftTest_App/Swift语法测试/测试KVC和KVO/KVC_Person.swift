//
//  KVC_Person.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/13.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 用于测试KVC的Person类

//MARK: 笔记
/**
    1、非结构体使用KVC的，必须要在属性变量前加上@objc关键字，声明是@objc类型的属性，哪怕是在类名前加上@objc关键字都不行，必须是属性前。
    2、swift的扩展并不能扩展储存属性，但是可以扩展静态属性，所以可以通过关联静态属性的方式，添加“存储属性”。
 */


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
//MARK: swift关联对象，kvc
extension KVC_Person {
    
    static private var myWife:String?
    
    var wife:String{
        set{
            objc_setAssociatedObject(self, &Self.myWife, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            let retStr = objc_getAssociatedObject(self, &Self.myWife) as? String ?? ""
            return retStr
        }
    }
    
}
