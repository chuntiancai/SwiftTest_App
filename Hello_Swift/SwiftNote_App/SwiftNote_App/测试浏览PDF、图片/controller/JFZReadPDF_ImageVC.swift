//
//  JFZReadPDF_ImageVC.swift
//  SwiftNote_App
//
//  Created by 蔡天春 on 2021/6/27.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 线下浏览pdf和图片的VC

import UIKit
import WebKit

class JFZReadPDF_ImageVC: JFZBasicReadDocVC {
    //MARK: - 对外属性
    var pdfModelArr=[PDFResourceModel]()
    var imgModelArr=[ImgResModel]()
    
    //MARK: - 内部属性


    //MARK: - 复写方法
    override func viewDidLoad() {
        initData()
        super.viewDidLoad()
        self.title = "浏览PDF和图片的VC"
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = .bottom
        
    }
    
    
    

}

//MARK: - 设置UI
extension JFZReadPDF_ImageVC{
    
}

//MARK: - 动作方法
@objc extension JFZReadPDF_ImageVC{
    
}

//MARK: - 遵循代理协议
extension JFZReadPDF_ImageVC{
    
}

//MARK: - 内部工具方法
extension JFZReadPDF_ImageVC{
    
    /// 初始化数据，往父VC中设置数据源
    func initData(){
        
        for model in pdfModelArr {
            titleArr.append(model.fileName)
            let curView = WKWebView()
            let req = URLRequest.init(url: model.url)
            curView.load(req)
            viewArr.append(curView)
        }
        
        for imgModel in imgModelArr {
            titleArr.append(imgModel.fileName)
            let curTableView = JFZReadImageTableView()
            curTableView.imgModel = imgModel
            viewArr.append(curTableView)
        }
        
    }
    
    
}
