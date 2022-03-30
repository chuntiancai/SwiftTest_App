//
//  测试view的阴影.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/4.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试view的阴影

import UIKit

class TestShadowView: UIView {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    //TODO: 测试cell里面的白色背景的阴影
    private let whiteBgView = UIView()  //白色背景

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension TestShadowView{
    /// 设置默认的UI
    func setDefaultUI(){
        
        self.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1)
        
        whiteBgView.layer.shadowRadius = 5
        whiteBgView.layer.shadowOffset = CGSize.init(width: 4, height: 5)
        whiteBgView.layer.shadowColor =  UIColor.black.cgColor
        whiteBgView.layer.shadowOpacity = 0.5
        
        /// 白色背景图
        whiteBgView.backgroundColor = .white
        whiteBgView.layer.cornerRadius = 12
        self.addSubview(whiteBgView)
        whiteBgView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(280)
            make.height.equalTo(250)
        }
    }
    
}

//MARK: -
extension TestShadowView{
    
}

//MARK: -
extension TestShadowView{
    
}

//MARK: -
extension TestShadowView{
    
}

// MARK: - 笔记
/**
 
 */
