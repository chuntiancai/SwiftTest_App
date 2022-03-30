//
//  测试OC与Swift的performSelector方法.swift
//  SwiftTest_CommandLine
//
//  Created by mathew on 2021/10/18.
//  Copyright © 2021 com.fendaTeamIOS. All rights reserved.
//

import Foundation

class Person:NSObject{
    var sex:String
    
    init(sex:String) {
        self.sex = sex
        super.init()
    }
    
    @objc func sayYourSex() -> String { //运行时绑定方法，必须是OC的方法，所以必须加上@objc关键字。
        print("我的性别是：\(sex)")
        return self.sex
    }
}


class Student: Person {
    var name:String
    init(name:String,sex:String) {
        self.name = name
        super.init(sex: sex)
    }
    
    func sayYourName() -> String {
        print("我的名字是：\(name)")
        return name
    }
}




// MARK: - 测试代码
/**
 
 */





// MARK: - 笔记
/**
 
1、运行时绑定方法，必须是OC的方法，所以必须加上@objc关键字。
2、let returnValue = person.perform(selector, with: nil).takeRetainedValue() 需要调用takeRetainedValue()对方法的返回值解包，否则返回的是Unmanaged<AnyObject>!类型。
3、let workName = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String 这个是ios的app的plist目录，mac app没有这个目录，通过字符串来获取类，必须传入类的完整类名，也就是必须带上plist目录名字的前缀，也就是：
        let workName = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
        let class_VC = NSClassFromString("\(workName).\(className)") as! BaseController.Type    //具体类信息
        let vc = class_VC.init()
 */
