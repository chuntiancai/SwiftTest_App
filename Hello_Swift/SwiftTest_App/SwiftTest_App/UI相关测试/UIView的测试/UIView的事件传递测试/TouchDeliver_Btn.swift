//
//  TouchDeliver_Btn.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/2.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试UIButton对响应链传递的影响
// 1、button阻断了响应链的传递？取消了next responder？

import UIKit

class TouchDeliver_Btn: UIButton {

    //MARK: 复写的方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("初始化了TouchDeliver_Btn 按钮 ～")
        self.backgroundColor = .orange
        self.titleLabel?.text = "TouchDeliver_Btn 按钮"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        print("TouchDeliver_Btn 按钮的 \(#function)方法 ")
        return super.point(inside: point, with: event)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("TouchDeliver_Btn 按钮的 \(#function)方法  ")
        return super.hitTest(point, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchDeliver_Btn 按钮的 \(#function)方法  ")
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchDeliver_Btn 按钮的 \(#function)方法  ")
        super.touchesCancelled(touches, with: event)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchDeliver_Btn 按钮的 \(#function)方法 ")
        super.touchesEnded(touches, with: event)
    }
    

}
//MARK: - 笔记
/**
    1、button是先处理hitTest方法，然后才到Action方法。
    2、touchesBegan方法的默认处理方式是：如果当前响应者不出来，那么顺着响应者链，将事件交给上一个响应者处理。
        如果事件已经处理，例如Action动作方法已经接收，那么事件不会再顺着响应链传递，因为事件已经处理了啊，销毁了啊。
        如果你不想Btn处理Action事件，那么你可以在hitTest方法中返回nil。
 */
