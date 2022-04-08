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

//MARK: - 位移枚举第二种写法
struct OptionEnum:OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public static var caseOne:OptionEnum{ return OptionEnum(rawValue: 0)}
    public static var caseTwo:OptionEnum{ return OptionEnum(rawValue: 1)}
    public static var caseThree:OptionEnum{ return OptionEnum(rawValue: 2)}
    public static var caseFour:OptionEnum{ return OptionEnum(rawValue: 4)}
    public static var caseFive:OptionEnum{ return OptionEnum(rawValue: 8)}
}

