//
//  Swift标准库的排序等算法.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/1.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//

import Foundation

//MARK: swift排序相关算法。
struct SortFunctionStruct{
    
    //MARK: sorted函数，返回新的数组，默认升序，即元素从小到大排序。
    static func testSorted(){
        let numbers = [5, 3, 8, 4, 2]
        let sortedNumbers = numbers.sorted() // 默认按升序排序
        print("默认sorted函数的结果：",sortedNumbers) // 输出: [2, 3, 4, 5, 8]
    }
    
    //MARK: sort函数，在原来数组原地排序，默认升序，即元素从小到大排序。
    static func testSort(){
        var numbers = [5, 3, 8, 4, 2]
        numbers.sort() // 默认按升序排序
        print("默认sort函数的结果：",numbers) // 输出: [2, 3, 4, 5, 8]
    }
    
    //MARK: sorted(by:)函数，自定义是降序还是升序排序，true是按照参数的左右顺序(升序)，false降序。
    static func testSortBy(){
        // 使用自定义排序逻辑
        let sortedStrings = ["banana", "apple", "cherry"].sorted(by: {
            (s1, s2) -> Bool in     //s1，s2是原数组中的任意两个元素。
            return s1 < s2  //是否按照s1,s2这样的顺序进行排列，false则按照s2,s1的顺序进行排列。
        })
        print("sorted的结果：",sortedStrings) // 输出: ["apple", "banana", "cherry"]
    }
    
}
