//
//  TestGesture_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试手势识别的View

class TestGesture_View: UIView {
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
//        print("TestGesture_View 的 \(#function) 方法")
        return super.point(inside: point, with: event)
    }
    
    /// 向下寻找点击的View，并且返回被点击的后代View（包括自身），该方法通过point(inside方法告知UIKit后代中是否包含了被点击的View， 有则返回被点击者，无则返回nil
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        print("TestGesture_View 的 \(#function) 方法")
        return super.hitTest(point, with: event)
    }
    
    //MARK: 事件向上传递
    /// UIKit寻找到目标视图后，就会产生UITouch，然后就会调用目标视图的touchesBegan方法，把UITouch传递进来，而UITouch的View属性就是当前的目标视图。
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TestGesture_View 的 \(#function) 方法")
        super.touchesBegan(touches, with: event)
    }
    
    /// 触摸移动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TestGesture_View 的 \(#function) 方法")
        super.touchesMoved(touches, with: event)
    }
    
    
    /// UIKit寻找到目标视图后，就会产生UITouch，然后就会调用目标视图的touchesBegan方法，把UITouch传递进来，而UITouch的View属性就是当前的目标视图。
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TestGesture_View 的 \(#function) 方法")
        super.touchesEnded(touches, with: event)
    }
    
    /// 取消触摸事件
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TestGesture_View 的 \(#function) 方法")
        super.touchesCancelled(touches, with: event)
    }
    
    
}

//MARK: -
extension TestGesture_View{
    
}


//MARK: - 笔记
/**
    1、UIGestureRecognizer的触摸事件 会插入 在 UIview的touchesBegan(_:with:) 方法 和 touchesCancelled(_:with:) 方法 之间。
 
    2、如果要实现UIScrollView这些内嵌的UIGestureRecognizerDelegate方法，那就要子类化UIScrollView，并实现UIGestureRecognizerDelegate方法，这样这些代理方法就会被调用。
       因为UIScrollView在初始化时就指定自己为UIGestureRecognizerDelegate。
 */

