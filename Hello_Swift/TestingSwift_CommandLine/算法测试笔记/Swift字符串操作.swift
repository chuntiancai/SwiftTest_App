//
//  Swift字符串操作.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/7.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//
// 测试字符串相关的操作

struct TestStringFuncStruct{
    
    //MARK: 测试字符串的常用方法
    static func testStrfunc(){
        
        //TODO: 访问string中的指定字符
        /**
            1、string不能直接通过int数字的下标来访问，string的下标有专属类型，String.Index
                String.Index 内部记录了字符在字符串中的确切位置，考虑到字符串可能包含变长的 Unicode 字符。因此，Swift 使用了一个特殊的内部结构来表示这些索引，以确保可以正确地遍历和访问字符串中的字符。
         */
        let str = "Hello, World!"
        let index = str.index(str.startIndex, offsetBy: 4) // 获取第5个字符（因为索引是从0开始的）
        let character = str[index]
        
        
        //TODO: 遍历寻找指定字符的索引
        var indices: [String.Index] = []    //字符串下标数组
        for (index, character) in str.enumerated() {
            if character == "o" {
                indices.append(str.index(str.startIndex, offsetBy: index))
            }
        }
        print(indices) // 输出包含所有 'o' 字符索引的数组
        
        
        //TODO: range字符串范围
        let startIndex = str.index(str.startIndex, offsetBy: 7) // 从字符串开始偏移7个字符的索引
        let endIndex = str.index(startIndex, offsetBy: 5) // 从startIndex开始再偏移5个字符的索引
        let customRange = startIndex..<endIndex // 创建一个范围对象
        let substring = str[customRange] // 使用范围来获取子字符串 "World"
        print(substring) // 输出: "World"
        
        
        //TODO: 字符串内部排序
        //此时会转换为String.Elemnt元素类型的数组，String.Element 实际上就是 Character 类型
        let sortedChars = str.map { $0 }.sorted()
        let sortedString = String(sortedChars)  //此时数组转换为字符串
        print(sortedString) // 输出: "ehllo"
        
        
        
    }
    
}
