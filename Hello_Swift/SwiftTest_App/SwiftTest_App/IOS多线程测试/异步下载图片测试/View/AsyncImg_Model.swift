//
//  AsyncImg_Model.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/29.
//  Copyright © 2022 com.mathew. All rights reserved.
//

//MARK:  异步下载图片的 tableview的cell 的model
struct AsyncImg_Model {
    
    var name:String!
    var icon:String!
    var url:URL?
    
    internal init(name: String, icon: String, url: String) {
        self.name = name
        self.icon = icon
        self.url = URL.init(string: url)
    }
    
}


