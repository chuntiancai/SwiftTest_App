//
//  DragTouch_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试拖曳事件的View

class DragTouch_View: UIView {
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
        print("DragTouch_View 的 \(#function) 方法")
        return super.point(inside: point, with: event)
    }
    
    /// 向下寻找点击的View，并且返回被点击的后代View（包括自身），该方法通过point(inside方法告知UIKit后代中是否包含了被点击的View， 有则返回被点击者，无则返回nil
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("DragTouch_View 的 \(#function) 方法")
        return super.hitTest(point, with: event)
    }
    
    //MARK: 事件向上传递
    /// UIKit寻找到目标视图后，就会产生UITouch，然后就会调用目标视图的touchesBegan方法，把UITouch传递进来，而UITouch的View属性就是当前的目标视图。
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("DragTouch_View 的 \(#function) 方法")
        super.touchesBegan(touches, with: event)
    }
    
    /// 触摸移动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("DragTouch_View 的 \(#function) 方法")
        // 实现view的拖曳，一个手指对应一个UITouch对象。
        
        /// 1、先找出 手指上一个点、手指当前点 的坐标。 找出两个点的偏移量，用偏移量来计算位移。
        
        let touch = touches.first   //单点击情况下，touches集合里面只有一个对象。
        let preP = touch?.previousLocation(in: self)    //在当前view里的前一个触摸的点的位置。
        let curP = touch?.location(in: self)    //在当前view里的当前触摸的点的位置。
        print("前一个触摸点位置：\(String(describing: preP))")
        print("当前触摸点位置：\(String(describing: curP))")
        
        /// 2、计算出手指当前点和上一个点之间的偏移量，x，y的偏移。
        let offsetX:CGFloat = (curP?.x ?? 0) - (preP?.x ?? 0)
        let offsetY:CGFloat = (curP?.y ?? 0) - (preP?.y ?? 0)
        
        /// 3、通过transform来实现拖拽。在拖拽之前，view的位置还没发生变化啊，因为还没调用这个形变属性，所以偏移的计算还是准确的。
        self.transform = self.transform.translatedBy(x: offsetX, y: offsetY)

        
        
    }
    
    
    /// UIKit寻找到目标视图后，就会产生UITouch，然后就会调用目标视图的touchesBegan方法，把UITouch传递进来，而UITouch的View属性就是当前的目标视图。
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("DragTouch_View 的 \(#function) 方法")
        super.touchesEnded(touches, with: event)
    }
    
    /// 取消触摸事件
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("DragTouch_View 的 \(#function) 方法")
        super.touchesCancelled(touches, with: event)
    }
    
    
}

//MARK: -
extension DragTouch_View{
    
}


//MARK: - 笔记
/**
    1、一个手指对应一个UITouch对象。UITouch对象用于保存手指的相关信息，当手指移动时，系统会更新同一个UITouch对象，使该UITouch对象始终对应着该手指的触摸信息。
        UITouch对象包含的信息有：位置、事件、阶段。。。
        当手指离开屏幕时，系统会销毁对应的UITouch对象。
        UITouch的属性：touch所在的window、view、tapCount(点击次数)、timestamp(产生时间或更新时间)
        UITouch的方法：location(in view: UIView?)当前触摸的点位置，previousLocation(in view: UIView?)上一个触摸的点的位置。
    
    2、UITouch只关心触摸点的位置，并不关心所在view的位置，它与所在view是独立管理的各自的。
        因为UITouch对象的参考点位置是参考手机硬件的，只是UIKit提供了方法，可以把触摸点的位置转化为相关的view或者window中的坐标系。

 */

