//
//  TouchDeliver_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/28.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试触摸事件传递的View，点击事件的传递
// MARK: - 笔记
/**
    App外：用户点击->硬件响应->参数量化->数据转发->App接收。
    App内：子线程接收事件->主线程封装事件->UIWindow启动hitTest确定目标视图->UIApplication开始发送事件->touch事件开始回调。
    
    （确认目标视图：）
    1、UIWindow是UIView的子类，所以也有hitTest和point(inside 方法。
    2、从subview数组的末尾开始调用hitTest，subview数组下标越小，视图层级越低。
        a.如果pointInside方法返回NO，则证明UIWindow无法响应该事件，hitTest方法会马上返回nil；
        b.如果pointInside方法返回YES，则证明UIWindow可以响应该事件，hitTest方法会接着调用UIWindow子视图的hitTest方法。
    3、UITouch是由UIKit创建的。当UIKit确定目标视图之后，就会创建UITouch(封装在UIEvent里)，UITouch的window属性和view属性就是上面寻找过程中的UIWindow和目标视图。
    
    （事件产生与传递：）
    4、接着UIKit就会调用UIApplication的sendEvent:方法。（后面的UIWindow和view的 sendEvent方法 是传递给前面寻找过程中的window和view）
       再接着调用UIWindow的sendEvent:方法。在UIWindow的sendEvent:方法中会再调用UIWindow的sendTouchesForEvent:方法。
    5、而UIWindow的sendTouchesForEvent:方法调用的就是我们熟悉的touches四大方法：
        -touchesBegan:withEvent:
        -touchesMoved:withEvent:
        -touchesEnded:withEvent:
        -touchesCancelled:withEvent:
    6、从上一步寻找到的目标视图开始，目标视图会首先被调用touches方法，接着是目标视图的父视图，再是父视图的父视图，如果某个视图是ViewController的.view属性， 还会调用ViewController的方法，直到UIWindow、UIApplication、UIApplicationDelegate（我们创建的AppDelegate）。
 
    (手势识别器：)
    1、UIKit产生UITouch之后，回先寻找当前View的手势识别器，所以手势识别器优先于目标View接收事件。手势识别器是View的一个属性。当手势的touchesBegan:withEvent:处理完成之后，便会触发目标视图的touchesBegan方法。但是当手势识别成功之后，默认会cancel后续touch操作，也就是取消了View的touch方法，调用-touchesCancelled:withEvent:方法。自己接受事件并消化掉了。
    2、UIGestureRecognizer手势识别器里也有 -touchesBegan:withEvent:等方法，你也可以复写。
 
    （总结）
    寻找目标视图：UIApplication->UIWindow->ViewController->View->targetView
    手势识别：UIGestureEnvironment-> UIGestureRecognizer
    响应链回调：targetView->View->ViewController->UIWindow->UIApplication

    （第一响应者：）
    1、通过hitTest方法找到目标视图，此时的目标视图就是第一响应者。然后UIKit产生UITouch，传递给第一响应者在touchesBegan系列方法中消化处理事件。如果你不处理，则将UITouch事件传递给下一个响应者，下一个响应者在它的touchesBegan系列方法中处理消化事件，以此类推。会一直沿着响应链传递，一直出触发链上每一个响应者的touchesBegan系列方法，直到有一个响应者吧next responder置为nil，就会阻断事件的传递了。
 
    注意：
        1、很多笔记说的传递过程其实就是寻找目标视图的过程，只不过它也叫做传递罢了，然后后面的过程它就叫做响应过程，也就是响应链。所以容易造成歧议。
        2、当view的透明度为0～0.01事，UIKit不接收也不处理触摸事件。
            当view是隐藏的时候，它的子view也跟着隐藏。当view是透明的时候，它的子view也跟着透明。
        3、如果你想打断事件的传递，或者修改事件的传递，那么你可以在hitTest方法中返回自身或者返回你想接收事件的view。

 */


class TouchDeliver_View: UIView {
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
        print("TouchDeliver_View 的 \(#function) 方法 -- \(isInside)")
        return isInside
    }
    
    /// 向下寻找点击的View，并且返回被点击的后代View（包括自身），该方法通过point(inside方法告知UIKit后代中是否包含了被点击的View， 有则返回被点击者，无则返回nil
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        print("TouchDeliver_View 的 \(#function) 方法 -- \(hitView)")
        ///判断被点击的view是否在当前view内,参数传递进来的point是相对于自身坐标系的坐标点。
        /**
         //表示将当前视图的point 转换到目标视图（view）的point ，返回目标视图所对应的点
         open func convert(_ point: CGPoint, to view: UIView?) -> CGPoint、
         
         //表示将view 视图的某个point 转换到当前视图，返回当前视图所对应的point
         open func convert(_ point: CGPoint, from view: UIView?) -> CGPoint
         
         //表示将当前视图的rect 转换到目标视图（view）的rect ，返回目标视图所对应的rect
         open func convert(_ rect: CGRect, to view: UIView?) -> CGRect
         
         //表示将view 视图的某个rect 转换到当前视图，返回当前视图所对应的rect
         open func convert(_ rect: CGRect, from view: UIView?) -> CGRect
         */
        if let subView = self.viewWithTag(1213) {
            print("点击的点是：\(point)")
            let cPoint = self.convert(point, to: subView)
            print("转换后的点是：\(cPoint)")
            let isContain = subView.layer.contains(cPoint)
            print("子view是否包含转换后的点：\(isContain)")
        }
        return hitView
    }
    
    //MARK: 事件向上传递
    /// UIKit寻找到目标视图后，就会产生UITouch，然后就会调用目标视图的touchesBegan方法，把UITouch传递进来，而UITouch的View属性就是当前的目标视图。
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchDeliver_View 的 \(#function) 方法")
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: 事件向上传递
    /// UIKit寻找到目标视图后，就会产生UITouch，然后就会调用目标视图的touchesBegan方法，把UITouch传递进来，而UITouch的View属性就是当前的目标视图。
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchDeliver_View 的 \(#function) 方法")
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchDeliver_View 的 \(#function)方法～")
        super.touchesCancelled(touches, with: event)
    }
}

//MARK: -
extension TouchDeliver_View{
    
}

//MARK: -
extension TouchDeliver_View{
    
}


