//
//  Quartz_Layer_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/17.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试利用quartz技术在layer上绘制图形

class Quartz_Layer_View: UIView {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension Quartz_Layer_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
    }
}

//MARK: -
extension Quartz_Layer_View{
    
}

//MARK: -
extension Quartz_Layer_View{
    
}

// MARK: - 笔记
/**
    1、
 */
