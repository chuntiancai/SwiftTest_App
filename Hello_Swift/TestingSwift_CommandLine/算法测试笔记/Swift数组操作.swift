//
//  Swift操作数组.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/26.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//
// 对数组的相关操作

struct ArrayTestStruct{
    
    
    static func testArrFunc(){
        
        //TODO: - 找出数组中指定元素的个数
        let numArr = [1,0,0,1,1,1,0]
        ///统计数组中1的个数
        let oneCount = numArr.reduce(0) { (partialResult, element) in
            if element == 1 {
                return partialResult + 1
            }
            return partialResult
        }
        print("1的个数：\(oneCount)")
        
        
    }
    
}
