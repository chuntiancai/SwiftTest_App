//
//  IOSChart_LeftYAxisRenderer.swift
//  SwiftTest_App
//
//  Created by mathew on 2023/6/29.
//  Copyright © 2023 com.mathew. All rights reserved.
//
// 测试自定义绘制IOSChart的左边纵轴
import Charts

class IOSChart_LeftYAxisRenderer: YAxisRenderer{
    
    override init(viewPortHandler: ViewPortHandler, axis: YAxis, transformer: Transformer?) {
        super.init(viewPortHandler: viewPortHandler, axis: axis, transformer: transformer)
        print("IOSChart_LeftYAxisRenderer 初始化了")
    }
    
    // 重新绘制y轴
    override func renderAxisLine(context: CGContext) {
        guard
            axis.isEnabled,
            axis.drawAxisLineEnabled
            else { return }

        context.saveGState()
        defer { context.restoreGState() }

        context.setStrokeColor(axis.axisLineColor.cgColor)
        context.setLineWidth(axis.axisLineWidth)
        if axis.axisLineDashLengths != nil
        {
            context.setLineDash(phase: axis.axisLineDashPhase, lengths: axis.axisLineDashLengths)
        }
        else
        {
            context.setLineDash(phase: 0.0, lengths: [])
        }
        
        if axis.axisDependency == .left
        {
            context.beginPath()
            //顶部绘制箭头
            let startX = viewPortHandler.contentLeft - 3
            let startY = viewPortHandler.contentTop + 3.0
            context.move(to: CGPoint.init(x: startX, y: startY))
            // 画出两条线
            context.addLine(to: CGPoint.init(x: startX + 6.0 , y: startY ))
            context.addLine(to: CGPoint.init(x: startX + 3.0, y: startY - 8))

            context.closePath()
            // 填充颜色
            context.setFillColor(axis.axisLineColor.cgColor)
            context.fillPath()
            
            
            context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: viewPortHandler.contentTop))
            context.addLine(to: CGPoint(x: viewPortHandler.contentLeft, y: viewPortHandler.contentBottom))
            context.strokePath()
        }
        else
        {
            context.beginPath()
            context.move(to: CGPoint(x: viewPortHandler.contentRight, y: viewPortHandler.contentTop))
            context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: viewPortHandler.contentBottom))
            context.strokePath()
        }
    }
}
