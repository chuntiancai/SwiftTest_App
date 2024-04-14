//
//  Swift高阶函数.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/1.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//
/**
    1、所谓高阶函数，就是参数是函数的函数，或者返回值是函数的函数。
 */

struct SwiftHighFunction{
    
    //MARK: map函数，映射，对数组中的每个元素进行操作，放到新的数组中。
    static func testMapFunc(){
        let numbers = [1, 2, 3, 4, 5]
        let doubled = numbers.map { $0 * 2 }
        print("map函数的结果：",doubled) // 输出: [2, 4, 6, 8, 10]
    }
    
    //MARK: flatMap函数，铺开多维数组映射，对多维数组中的每个元素进行操作，如果数组中的元素也是集合类型，平铺放到新的一维数组中。
    static func testflatMapFunc(){
        let scoresByName = ["Henk": [0, 5, 8], "John": [2, 5, 8]]
        let flatMapped = scoresByName.flatMap { $0.value }
        // [2, 5, 8, 0, 5, 8]
        print("flatmap函数的结果：",flatMapped)
        
    }
    
    //MARK: compactMap函数，紧凑解包映射，对数组中的每个元素进行操作，解包，不为nil，才放到新的数组中。
    static func testCompactMap(){
        let numbers: [Int] = [1, 2, 3, 4, 5]
        let evenNumbers: [Int?] = numbers.map { $0 % 2 == 0 ? $0 : nil }
        let unwrappedEvens = evenNumbers.compactMap { $0 }
        print("compactmap结果：",unwrappedEvens) // 输出: [2, 4]
    }
    
    //MARK: filter函数，查找，对数组中的每个元素进行操作，找出符合条件的元素，放到新的数组中。
    static func testFilter(){
        let numbers = [1, 2, 3, 4, 5, 6]
        let evens = numbers.filter { $0 % 2 == 0 }
        print("filter结果：",evens) // 输出: [2, 4, 6]
    }
    
    //MARK: reduce函数，归纳映射，对数组中的每个元素进行归纳操作，返回归纳的结果。
    static func testReduce(){
        let numbers = [1, 2, 3, 4, 5]
        let sum = numbers.reduce(0,{    //初始的归纳结果是0
            result,element -> Int in
            return result + element
        })
        print("reduce结果是：",sum) // 输出: 15
    }
    
}
