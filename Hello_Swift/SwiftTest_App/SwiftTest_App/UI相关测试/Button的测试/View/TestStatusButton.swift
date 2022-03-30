//
//  TestStatusButton.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/10.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试按钮的状态的按钮View

class TestStatusButton: UIButton {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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

//MARK: - 设置UI
extension TestStatusButton{
    
    //MARK: 初始化默认的UI
    func initDefaultUI(){
        self.addTarget(self, action: #selector(tapBtnAction(sender:)), for: .touchUpInside)
    }
    
}

//MARK: - 测试的方法
extension TestStatusButton{
    
    //MARK: 设置上图下文
    
}

//MARK: - 动作方法
@objc extension TestStatusButton{
    /// 点击了按钮的动作方法
    func tapBtnAction(sender:UIButton){
        print("点击了TestStatusButton按钮的动作方法")
    }
}

//MARK: -
extension TestStatusButton{
    
}

// MARK: - 笔记
/**
 
 */

