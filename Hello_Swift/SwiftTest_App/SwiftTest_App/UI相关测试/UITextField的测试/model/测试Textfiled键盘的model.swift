//
//  测试Textfiled键盘的model.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/22.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 读取plist文件

struct FlagItem {
    
    var name:String = ""
    var icon:String = ""
    
    init() {
        
    }
    
    ///自定义字典参数构造器来初始化结构体，通过字典转换成结构体struct
    init(dict: Dictionary<String, Any>) {
        self.name = dict["name"] as? String ?? ""
        self.icon = dict["icon"] as? String ?? ""
    }
    
    
    /// 将json的Dict数组，转换为model的数组
    static func castToModelArray(withJsonDictArr itemArr: [[String: Any]]) -> [FlagItem]{
        var modelArr = [FlagItem]()
        for itemDict in itemArr {
            let curModel = FlagItem.init(dict: itemDict)
            modelArr.append(curModel)
        }
        return modelArr
    }
}

