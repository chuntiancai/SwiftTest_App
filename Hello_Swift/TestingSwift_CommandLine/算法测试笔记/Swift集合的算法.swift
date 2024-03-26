//
//  Swift集合的算法.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/1.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//
// MARK: 注意set的特征是没有重复的元素。
import Foundation

struct SetStruct{
    
    //MARK: intersection(_:)函数，获取两个集合的交集，放在一个新的集合中。
    //MARK: isDisjoint(with:)函数，判断两个集合是否互斥，也就是是否没有交集。
    static func testIntersection(){
        let set1: Set<Int> = [1, 2, 3, 4, 5]
        let set2: Set<Int> = [4, 5, 6, 7, 8]
          
        let intersectionSet = set1.intersection(set2)
        print("两个集合的交集：",intersectionSet) // 输出：[4, 5]，因为 4 和 5 是 set1 和 set2 共有的元素
        
        if set1.isDisjoint(with: set2) {
            print("set1 和 set2 互斥，没有有交集")
        } else {
            print("set1 和 set2 不互斥，有交集")
        }
    }
}
