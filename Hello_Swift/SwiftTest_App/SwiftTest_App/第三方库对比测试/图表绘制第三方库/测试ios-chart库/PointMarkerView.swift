//
//  PointMarkerView.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/9/18.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 图表每个点的标记，也就是弹窗

import Charts

class PointMarkerView: MarkerView {
    var textLayer: CATextLayer = {
        let tempLayer = CATextLayer()
        tempLayer.backgroundColor = UIColor.clear.cgColor
        tempLayer.fontSize = 12
        tempLayer.alignmentMode = .center
        tempLayer.foregroundColor = UIColor.black.cgColor
        return tempLayer
    }()
    
    var mOffset: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = [self.frame.size.width, self.frame.size.height].min()! / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor(white: 150.0/255.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 1
        
        self.layer.addSublayer(self.textLayer)
        self.textLayer.frame = CGRect(x: 0, y: (self.frame.size.height - 16)/2, width: self.frame.size.width, height: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)
        
        self.textLayer.string = String(entry.y)
    }
    
    override var offset: CGPoint {
        get {
            if(self.mOffset == nil) {
                // center the marker horizontally and vertically
                self.mOffset = CGPoint(x: -(self.bounds.size.width / 2), y: -self.bounds.size.height)
            }
            
            return self.mOffset!
        }
        set {
            
        }
    }
}
