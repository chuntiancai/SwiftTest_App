//
//  Quartz_Draw_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/18.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试利用quartz技术在实现画板功能。
/**
    1、核心思路是，context不记录上一个状态的路径，draw方法也不记录上一次的内容，所以每一次都是从新绘画，所以你要用数组保存path，每一次调用draw都是新的绘制。
    2、当系统提供的类不能满足你的需求时，你就需要自定义类去继承系统提供的类。
 */

class Quartz_Draw_View: UIView {
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
extension Quartz_Draw_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
    }
}

//MARK: -
extension Quartz_Draw_View{
    
}

//MARK: -
extension Quartz_Draw_View{
    
}

// MARK: - 笔记
/**
    1、
 */
