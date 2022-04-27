//
//  TestFSCalendar_Cell.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/19.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 自定义FSCalendar显示日期的Cell

import FSCalendar

class TestFSCalendar_Cell: FSCalendarCell {
    
    weak var selectionLayer: CAShapeLayer!
    var isShowCircleShape:Bool = false {
        didSet{
            self.selectionLayer.isHidden = !isShowCircleShape
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.white.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        self.shapeLayer.isHidden = true     ///关闭默认的圆形
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
        
        /// 绘制白色圆背景
        let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
        self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        
        
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        print("TestFSCalendar_Cell的 \(#function) 方法")
        isShowCircleShape = false
        // Override the build-in appearance configuration
//        if self.isPlaceholder {
//            self.eventIndicator.isHidden = true
//        }
    }
    
}

