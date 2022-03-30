//
//  JFZResponseExpandButtton.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/13.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 扩大响应范围的按钮
import UIKit

class JFZResponseExpandButtton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// 扩大Button的点击范围
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        var bounds = self.bounds
        
            let x: CGFloat = -10
            let y: CGFloat = -10
            let width: CGFloat = bounds.width + 20
            let height: CGFloat = bounds.height + 20
            bounds = CGRect(x: x, y: y, width: width, height: height) //负值是方法响应范围
        
        return bounds.contains(point)
    }

}
