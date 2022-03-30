//
//  TestCALayer_Layer.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/1.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 自定义的Layer

class TestCALayer_Layer: CALayer {
    
    override init() {
        super.init()
        print("TestCALayer_Layer 初始化啦～")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
