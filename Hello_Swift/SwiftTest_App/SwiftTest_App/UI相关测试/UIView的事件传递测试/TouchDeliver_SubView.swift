//
//  TouchDeliver_SubView.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/2.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试触摸事件传递的View，点击事件的传递

import UIKit

class TouchDeliver_SubView: UIView {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 向下寻找目标视图
    /// 告知UIKit响应者是否在自己的子孙后代中
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let isInside = super.point(inside: point, with: event)
        print("TouchDeliver_SubView 的 \(#function) 方法 -- \(isInside)")
        return isInside
    }
    
    /// 向下寻找点击的View，并且返回被点击的后代View（包括自身），该方法通过point(inside方法告知UIKit后代中是否包含了被点击的View， 有则返回被点击者，无则返回nil
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        print("TouchDeliver_SubView 的 \(#function) 方法 -- \(String(describing: hitView ?? nil))")
        if hitView == self {
            print("TouchDeliver_SubView 自身就是响应者")
        }
        return hitView
    }
    
    //MARK: 事件向上传递
    /// UIKit寻找到目标视图后，就会产生UITouch，然后就会调用目标视图的touchesBegan方法，把UITouch传递进来，而UITouch的View属性就是当前的目标视图。
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchDeliver_SubView 的 \(#function) 方法")
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchDeliver_SubView 的 \(#function) 方法")
        super.touchesEnded(touches, with: event)
    }
    
    
}

//MARK: -
extension TouchDeliver_SubView{
    
}

//MARK: -
extension TouchDeliver_SubView{
    
}

//MARK: -
extension TouchDeliver_SubView{
    
}

//MARK: -
extension TouchDeliver_SubView{
    
}
