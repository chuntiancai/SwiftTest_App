//
//  TestCALayer_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/1.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试更换view的根layer

class TestCALayer_View: UIView {
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
    
    //MARK: - 更换view的根layer
    override class var layerClass: AnyClass{
        return TestCALayer_Layer.self
    }
    
}

//MARK: - 设置UI
extension TestCALayer_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
    }
}

//MARK: -
extension TestCALayer_View{
    
}

//MARK: -
extension TestCALayer_View{
    
}

// MARK: - 笔记
/**
 
 */
