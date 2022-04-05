//
//  位移枚举.swift
//  SwiftTest_App
//
//  Created by chuntiancai on 2022/4/5.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试swift的位移枚举

/// 测试方向的位移枚举
struct directionType:OptionSet {
    var rawValue: Int   ///参考范型
    
    static let all = directionType.init(rawValue: 1)
    static let top = directionType.init(rawValue: 2)
    static let dowm = directionType.init(rawValue: 4)
    static let left = directionType.init(rawValue: 8)
    static let right = directionType.init(rawValue: 16)
}

