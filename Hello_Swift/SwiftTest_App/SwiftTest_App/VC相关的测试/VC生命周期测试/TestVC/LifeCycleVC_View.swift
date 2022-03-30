//
//  LifeCycleVC_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/1.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 替换VC的根View

class LifeCycleVC_View: UIView {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("LifeCycleVC_View 初始化啦～")
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension LifeCycleVC_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
    }
}

//MARK: -
extension LifeCycleVC_View{
    
}

//MARK: -
extension LifeCycleVC_View{
    
}

// MARK: - 笔记
/**
 
 */
