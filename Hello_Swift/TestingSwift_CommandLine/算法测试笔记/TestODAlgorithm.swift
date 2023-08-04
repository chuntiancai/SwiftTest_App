//
//  TestODAlgorithm.swift
//  SwiftTest_CommandLine
//
//  Created by mathew on 2023/8/4.
//  Copyright © 2023 com.fendaTeamIOS. All rights reserved.
//
// OD考试的刷题

struct TestODAlgorithm {
    
    //找出前三个冠军
    //其实直接排序，然后找出前三就可以了
    static func findFrontThreeChampion(){
        
        let myNumArr = [454,446,164,496,49,69,694,6946,4,4,49,4,496,4469,8,797,98,56,11,6498]
        /**
            用递归查找
            1、退出条件：只剩下三个id的数组
            2、递归基：传入数组；对数组拆分为A、B数组； 比较；合并胜利了数组；分而治之。
            3、这个空间复杂度太大了。
        
         
         */
        
        print("数组是：")
        for index in 0 ..< myNumArr.count {
            print("\(index)--\(myNumArr[index])",separator: " ")
        }
        print("\n")
        var scriptArr:[Int] = [Int]()
        for index in 0 ..< myNumArr.count {
            scriptArr.append(index)
        }
//        var nextArr = [Int]()
        
        // 传入的是数组的下标；返回的是 原数组的下标
        func recursionFind(numArr:[Int]) -> [Int]{
            
            //退出条件
            if numArr.count == 3 {
                var targetArr = [Int]()
                
                let numA = myNumArr[numArr[0]]
                let numB = myNumArr[numArr[1]]
                let numC = myNumArr[numArr[2]]
                var curIndex = numArr[0]
                if numB > numA {
                    targetArr.append(numArr[1])
                    if numC > numA {
                        targetArr.append(numArr[2])
                        targetArr.append(numArr[0])
                    }else{
                        targetArr.append(numArr[0])
                        targetArr.append(numArr[2])
                    }
                }else{
                    targetArr.append(numArr[0])
                    if numC > numB {
                        targetArr.append(numArr[2])
                        targetArr.append(numArr[1])
                    }else{
                        targetArr.append(numArr[1])
                        targetArr.append(numArr[2])
                    }
                }
                    
                

                return targetArr
            }
            
            print("传入的数组是：")
            for index in numArr {
                print("\(index)-\(myNumArr[index])",terminator: ",")
            }
            print("\n")
            
            var nextArr = [Int]()
            
            //比较
            for index in stride(from: 0, through: numArr.count - 1, by: 2){
                let numA = myNumArr[numArr[index]]
                var numB = -1
                if index + 1 < numArr.count {
                    numB = myNumArr[numArr[index + 1]]
                }
                //添加胜利者进数组
                if numB > numA {
                    nextArr.append(numArr[index + 1])
                }else{
                    nextArr.append(numArr[index])
                }
                
            }
            //递归
            return recursionFind(numArr:nextArr)
        }
        
        let targetArr = recursionFind(numArr: scriptArr)
        for index in targetArr {
            print("胜利者是：index:\(index)-- value：\(myNumArr[index])",separator: " ")
        }
        
        
    }
    
    
}
