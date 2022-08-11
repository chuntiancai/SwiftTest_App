//
//  Dict_Model.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/10.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 字典转换为model
//MARK: 笔记
/**
    1、首先是网络返回的json字符串，标准库提供json字符串转换为jsonObject，然后接送Object转换为字典，然后字典转换为model
        json字符串 ==> jsonObject(api提供) ==> 字典(api提供) ==> model (手写)
    2、注意，swift的optional类无法转换为OC。
 */

class Dict_CountryModel:NSObject {
    
    var key:String = ""  /// 关键字
    var cards:[Dict_CardModel] = [Dict_CardModel]()  //身份卡片
    var desc:String = ""  //描述
    var copyrights:String = ""  //版权
    
    //TODO: 字典转换为model
    convenience init( _ dict:Dictionary<String,Any>) {
        
        self.init() /// 必须调用指定构造器
        
        self.key = dict["key"] as? String ?? ""
        self.desc = dict["desc"] as? String ?? ""
        self.copyrights = dict["copyrights"] as? String ?? ""
        self.cards = Dict_CardModel.castToModelArray(dict["card"] as? [Dictionary<String,Any>] ?? [])
        
    }
    
    override var description: String{
        get{
            let retStr = """
            {
              key:\(key),\n
              desc:\(desc),\n
              copyrights:\(copyrights),\n
              cards:\(cards.count),\n
             }
            """
            return retStr
        }
    }
    
}

/// 国家卡片的model
class Dict_CardModel:NSObject {
    
    var format:[String] = [String]()
    var key:String = ""
    var name:String = ""
    var value:[String] = [String]()
    
    convenience init( _ dict:Dictionary<String,Any>) {
        
        self.init() /// 必须调用指定构造器
        
        self.format = dict["format"] as? [String] ?? [String]()
        self.key = dict["key"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.value = dict["value"] as? [String] ?? [String]()
        
    }
    
    //TODO: 将字典数组转换为model数组
    static func castToModelArray(_ dictArray: [Dictionary<String,Any>]) -> [Dict_CardModel] {
        var modelArr = [Dict_CardModel]()
        for dict in dictArray {
            let model = Dict_CardModel(dict)
            modelArr.append(model)
        }
        return modelArr
    }
    
    override var description: String{
        get{
            let retStr = """
            {
              format:\(format),\n
              key:\(key),\n
              name:\(name),\n
              value:\(value),\n
            }
            """
            return retStr
        }
    }
    
}


