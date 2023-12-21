//
//  TestODAlgorithm.swift
//  SwiftTest_CommandLine
//
//  Created by mathew on 2023/8/4.
//  Copyright © 2023 com.fendaTeamIOS. All rights reserved.
//
// OD考试的刷题

import Darwin

struct TestODAlgorithm {
    
    //测试补种的课数
    static func testTreeCount(){
        
        struct TreeAliveStruct{

            var firstIndex:Int = 0  //第一课树的索引
            var lastIndex:Int = 0   //最后一棵树的索引
            var aliveCount:Int = 0  //存活的个数
            var preTreeIndex:Int = 0    //前一树堆的最后一棵树的索引
            var nextTreeIndex:Int = 0   //下一个树堆的第一个索引
            var andNextAliveCount = 0 //和下一堆树之间的活树的个数
            var andNextDieCount = 0  //和下一堆树之间死树的个数
            var andNextTotalCount = 0   //和下一堆树之间总的死树和活树的数量
        }
        
        // 1、找得到每一堆连续存活的树，记录下存活连续树的数组，找到最多的连续存活的树
        // 2、找到相邻三堆树之间，死树的个数，总数的个数，类似归并排序。(递归)
        //      找到相邻两堆活树之间，个数最多，间隔最短的。
        // 3、
        
        let totalTreeCout = 100
        let aliveTree = 50
        let dieTreeArr = [12,23,34,45]
        let applyTreeCount = 3
        
        //模拟已经死了的树
        var totalTreeArr:[Int] = Array(repeating: 1, count: 100)
        for dieIndex in dieTreeArr {
            totalTreeArr[dieIndex] = 0
        }
        var allTreeStructArr = [TreeAliveStruct]()
        var preStruct = &allTreeStructArr
        var isCounting = false  //是否正在数活着的树
        
        for index in 0 ..< totalTreeArr.count {
            let num = totalTreeArr[index]
            if num == 1 {
                if !isCounting {
                    isCounting = true
                    preStruct.nextTreeIndex = index //下一个树堆
                    //新建树堆
                    var curStruct = TreeAliveStruct()
                    curStruct.firstIndex = index
                    curStruct.aliveCount = 1
                    curStruct.preTreeIndex = preStruct.lastIndex    //前一个树堆
                    preStruct = curStruct
                    allTreeStructArr.append(curStruct)
                }else{
                    preStruct.aliveCount += 1
                }
            }else{
                //遇到的第一课死树
                if isCounting {
                    isCounting = false
                    //处理前一堆树
                    preStruct.lastIndex = index - 1
                }
            }
        }
        
        print("打印的树：\(totalTreeArr)")
        print("打印添加的树堆：\(allTreeStructArr)")

        //
        
        
    }
    
    
    //            var isAlive = true //是否存活
    //            var dieCount:Int = 0    //死掉的树
    
    
    //        if totalTreeArr.first == 0 {
    //            preStruct.isAlive = false
    //            preStruct.dieCount = 1
    //            isCounting = false
    //        }
    //        allTreeArr.append(preStruct)
    
    
    //测试车的最近距离
    static func testCarDistance(){
        let myNumArr = [0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,1,0,0,0,]
        //1、找到数组中所有的0，记录0的个数,记录1前面有多少个0
        //2、找到相邻两个1之间的最大差距
        //  那其实还不如记录0的个数更加好一些，记录0最大的个数，第一个0的下标
        //  用字典记录第一个0的下标和个数，对字典进行排序。
        //  第一个1前面是0的情况
        
        var numDict:[Int:Int] = [Int:Int]()
        var zeroCount = 0
        
        for index in 0 ..< myNumArr.count {
            let curNum = myNumArr[index]
            if curNum == 0 {
                zeroCount += 1
            }else if curNum == 1 {
                numDict[index] = zeroCount
                zeroCount = 0
            }
            if index == myNumArr.count - 1 && curNum == 0{
                numDict[index] = zeroCount   //记录最后一排0
            }
        }
       
        
        //处理两端情况
        if let firstIndex = myNumArr.firstIndex(of: 1) {
            numDict[firstIndex] = (numDict[firstIndex] ?? 0) * 2
        }
        if myNumArr.last == 0 {
            numDict[myNumArr.count - 1] = (numDict[myNumArr.count - 1] ?? 0)  * 2
        }
        
        print("当前的字典是：\(numDict)")
        let newDict = numDict.sorted(by: {$0.1 > $1.1})
//       let newDict = numDict.values.sorted()
        print("之后的字典是：\(newDict) -- \(String(describing: newDict.first))")
        let maxIndex = newDict.first?.key ?? 1
        let maxCount = numDict[maxIndex] ?? 0
        var curMaxIndex = maxIndex - Int(Float(maxCount) * 0.5)
        if maxIndex == myNumArr.count - 1 {
            curMaxIndex = myNumArr.count - 1
        }
        print("当前的车位是：\(curMaxIndex) -- \(myNumArr.count)")
        
        
       
        
    }
    
    
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
