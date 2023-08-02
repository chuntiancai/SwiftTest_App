//
//  IOSChart_ZeroXAxisRenderer.swift
//  SwiftTest_App
//
//  Created by mathew on 2023/6/29.
//  Copyright © 2023 com.mathew. All rights reserved.
//
// 测试自定义绘制IOSChart的横轴

import Charts

class IOSChart_ZeroXAxisRenderer: XAxisRenderer {
    
    
    override func renderAxisLine(context: CGContext) {
        super.renderAxisLine(context: context)
        
        context.beginPath()
        //顶部绘制箭头
        let startX = viewPortHandler.contentRight - 5
        let startY = viewPortHandler.contentBottom - 3.0
        context.move(to: CGPoint.init(x: startX, y: startY))
        // 画出两条线
        context.addLine(to: CGPoint.init(x: startX + 12 , y: startY + 3.0 ))
        context.addLine(to: CGPoint.init(x: startX, y: startY + 6.0))

        context.closePath()
        // 填充颜色
        context.setFillColor(axis.axisLineColor.cgColor)
        context.fillPath()
        
        context.strokePath()
    }
    
}
