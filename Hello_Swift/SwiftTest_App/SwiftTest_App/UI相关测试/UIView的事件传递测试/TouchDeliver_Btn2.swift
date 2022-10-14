//
//  TouchDeliver_Btn2.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/2.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试UIButton对响应链传递的影响
// 1、button阻断了响应链的传递？取消了next responder？

import UIKit

class TouchDeliver_Btn2: UIButton {

    
    //MARK: 复写的方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("初始化了TouchDeliver_Btn2 按钮 ～")
        self.backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        print("TouchDeliver_Btn2 按钮的 \(#function) 方法 ")
        return super.point(inside: point, with: event)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("TouchDeliver_Btn2 按钮的 \(#function) 方法 ")
        return super.hitTest(point, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchDeliver_Btn2 按钮的 \(#function) 方法 ")
        self.resignFirstResponder()
        super.touchesBegan(touches, with: event)
    }
    

}
