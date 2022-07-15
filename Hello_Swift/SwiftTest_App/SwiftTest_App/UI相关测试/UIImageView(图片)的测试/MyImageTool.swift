//
//  MyImageTool.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/7/13.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 图片工具，不用分类。

class MyImageTool {
    
    //TODO: 根据颜色来生成图片，颜色图片
    static func getColorImg(alpha:CGFloat,_ color:UIColor = .orange) -> UIImage {
        let alphaColor = color.withAlphaComponent(alpha).cgColor
        /// 描述图片的矩形
        let rect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)
        /// 开启位图的上下文
        UIGraphicsBeginImageContext(rect.size)
        /// 获取位图的上下文
        let context = UIGraphicsGetCurrentContext()
        
        /// 使用color填充上下文
        context?.setFillColor(alphaColor)
        
        /// 渲染上下文
        context?.fill(rect)
        /// 从上下文中获取图片
        let colorImg = UIGraphicsGetImageFromCurrentImageContext()
        
        ///结束上下文
        UIGraphicsEndImageContext()
        return colorImg!
    }
    
}
