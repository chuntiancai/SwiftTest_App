//
//  tempView.swift
//  SwiftTest_App
//
//  Created by chuntiancai on 2021/7/18.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试

class tempView: UIView {
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
}

//MARK: - 设置UI
extension tempView{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
    }
}

//MARK: - 动作方法
@objc extension tempView{
    
}

//MARK: -
extension tempView{
    
}

// MARK: - 笔记
/**
 
 */
