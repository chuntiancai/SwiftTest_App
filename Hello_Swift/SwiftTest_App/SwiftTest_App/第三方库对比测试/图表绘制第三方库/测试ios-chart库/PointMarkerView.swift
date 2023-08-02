//
//  PointMarkerView.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/9/18.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 图表每个点的标记，也就是弹窗

import Charts

/// 图表点击打点数据后的弹窗
class  PointMarkerView: MarkerView {
    
    var textLayer: CATextLayer = {
        let tempLayer = CATextLayer()
        tempLayer.backgroundColor = UIColor.clear.cgColor
        tempLayer.fontSize = 12
        tempLayer.isWrapped = true
        tempLayer.alignmentMode = .center
        tempLayer.foregroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1).cgColor
        tempLayer.contentsScale = UIScreen.main.scale
        return tempLayer
    }()
    
    var mOffset: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = [self.frame.size.width, self.frame.size.height].min()! / 2
        self.layer.masksToBounds = false
        
        self.layer.addSublayer(self.textLayer)
        self.textLayer.frame = CGRect(x: 0, y: (self.frame.size.height - 16)/2, width: self.frame.size.width, height: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
//        print("绘制的偏移：\(point)")
        return super.offsetForDrawing(atPoint: point)
        
    }
    
    /// 此方法使自定义IMarker可以在每次根据其指向的ChartDataEntry重绘IMarker时更新其内容。
     ///
     /// - 参数:
     ///   - entry: IMarker所属的ChartDataEntry。 这也可以是ChartDataEntry的任何子类，例如BarChartDataEntry或CandleChartDataEntry，只需在运行时将其强制转换即可。
     ///   - highlight: 高亮对象包含有关高亮值的信息，例如它的数据集索引，所选范围或堆栈索引（仅堆栈条形条目）。
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)
//        print("点击了图表:\(entry)")
        //设置弹窗偏移点（类似锚点）
        let valueStr = String(format: "%.2f", entry.y * 100 ) + "%"
        var dataStr = ""
        if let _ = entry.data as? Data {
            dataStr = String(data: entry.data as! Data, encoding: .utf8) ?? ""  //日期字符串
        }
        self.textLayer.string = valueStr + "\n" + dataStr
    }
    
    /// - 返回值: 以选中的坐标点为基准，希望IMarker的原点相对于基准点的偏移量。默认偏移(0,0)
    ///     返回值中的x: 如果为-(width / 2)，则将IMarker水平居中。
    ///     返回值中的y: 如果为-(height / 2)，则将IMarker垂直居中。
    override var offset: CGPoint {
        get {
            print("希望IMarker在x轴上具有的所需（通用）偏移量:\(super.offset)")
            return super.offset
            /**
             if(self.mOffset == nil) {
                // center the marker horizontally and vertically
                 self.mOffset = CGPoint(x: -(self.bounds.size.width / 2), y: -self.bounds.size.height)
             }
 //            print("希望IMarker在x轴上具有的所需（通用）偏移量offset:\(mOffset)")
             return self.mOffset!
             */
            
        }
        set {
            
        }
    }
}
