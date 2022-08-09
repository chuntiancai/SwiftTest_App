//
//  MyNaviTool.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/3.
//  Copyright © 2022 com.mathew. All rights reserved.
//

class MyNaviTool:NSObject {
    
    //MARK: 0、获取UIBarButtonItem，点击高亮
    static func getUIBarButtonItem(img:UIImage, highImg:UIImage, target:NSObject ,action:Selector) -> UIBarButtonItem{
        
        let btn  = UIButton()
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.setImage(img, for: .normal)
        btn.setImage(highImg, for: .highlighted)
        let barItem = UIBarButtonItem(customView: btn)
        return barItem
    }
    
    //MARK: 1、获取UIBarButtonItem，选中状态
    static func getUIBarButtonItem(img:UIImage, selectedImg:UIImage, target:NSObject ,action:Selector) -> UIBarButtonItem{
        
        let btn  = UIButton(type: .custom)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.setImage(img, for: .normal)
        btn.setImage(selectedImg, for: .selected)
        btn.sizeToFit()
        let containView = UIView(frame: btn.bounds)
        containView.addSubview(btn)
        let barItem = UIBarButtonItem(customView: containView)
        return barItem
    }
    
}
