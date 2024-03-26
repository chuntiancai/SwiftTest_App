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
    
    //MARK:BFS宽度搜索算法，妈妈找儿子问题
    static func testMomBaby(){
        
        struct Point{
            let x:Int
            let y:Int
            let value:Int   //坐标上的物件， -1 障碍，-2宝宝，-3妈妈，>=0 糖果。
        }
        
        //坐标图
        var gridMap = [[Point]]()
        
        //描绘整个地图。
        var mom = Point(x: -1, y: -1, value: -3)
        var baby = Point(x: -1, y: -1, value: -2)
        let direction = [(0,1),(0,-1),(-1,0),(1,0)]  //运动的方向,上下左右
        
        let nNum = Int(readLine()!)!//输入地图矩阵的大小
        
        //描绘地图矩阵
        for i in 0 ..< nNum{
            let rowNumArr = (readLine()!).split(separator: " ").map{Int($0)!}   //读取每一行
            gridMap.append(Array(repeating: Point(x: 0, y: 0, value: 0), count: rowNumArr.count))
            for j in 0 ..< rowNumArr.count {
                let curValue = rowNumArr[j]
                let curPoint  = Point(x: i, y: j, value: curValue)
                if curPoint.value == -3{
                    mom = curPoint
                }else if curPoint.value == -2 {
                    baby = curPoint
                }
                gridMap[i][j] = curPoint
            }
            
        }
        //设置BFS算法。
        
        //起始点mom，终点baby，迭代器queue，浏览点记录器visited
        var queue = [mom]
        var visited = Array(repeating: Array(repeating: false, count: nNum), count: nNum)
        
        
        var isFindBaby = false //能否找到baby
        var time = 0 //经过多少步才能找到baby
        var maxCandy = 0    //最大糖果数
        
        //运行迭代器
        while !queue.isEmpty {
            let qSize = queue.count
            //扩散一圈
            for _ in 0 ..< qSize{
                let curPoint = queue.removeFirst()  //pop出当前点进行浏览。
                visited[curPoint.x][curPoint.y] = true  //记录已经浏览的点
                //判断是否已经到达终点
                if curPoint.value == baby.value{
                    print("已经找到baby，推出当前循环")
                    //            time = time + 1 //步数+1
                    isFindBaby = true
                    break   //这个是break for
                }
                //入队列周围的点
                for (xStep,yStep) in direction{
                    var nextPoint = Point(x: curPoint.x + xStep, y: curPoint.y + yStep, value: 0)
                    
                    //找出下一点是否越界，不越界就放到迭代器队列中。
                    if nextPoint.x >= 0 && nextPoint.x < nNum && nextPoint.y >= 0 && nextPoint.y < nNum {
                        //未浏览过,且不是阻碍物
                        if visited[nextPoint.x][nextPoint.y] == false && gridMap[nextPoint.x][nextPoint.y].value != -1 {
                            print("入队列下一步要浏览的点 (\(nextPoint.x)-\(nextPoint.y))")
                            nextPoint = gridMap[nextPoint.x][nextPoint.y]
                            queue.append(nextPoint)
                        }
                        
                    }
                    
                }
            }
            
            
            if isFindBaby {
                //这个是break while
                print("找到了，不要再扩散了")
                break
            } //找到了，就不要再扩散了
            print("步数+1")
            time = time + 1 //每扩散一层才算前进了一步，如果是要记录下最短路径，则需要回溯
            
        }
        if isFindBaby {
            print("最短路径的步数是：",time)
            
            //找到最短路径上的最大权重。
            var recordMatrix = Array(repeating: Array(repeating: 0, count: nNum), count: nNum)
            visited = Array(repeating: Array(repeating: false, count: nNum), count: nNum)
            queue = [mom]
            
            var maxCandy = 0
            while time >= 0 {
                
                let qSize = queue.count
                for _ in 0 ..< qSize{
                    let curPoint = queue.removeFirst()  //pop出当前点进行浏览。
                    visited[curPoint.x][curPoint.y] = true  //记录已经浏览的点
                    //判断是否已经到达终点
                    if curPoint.value == baby.value{
                        let maxCandy = recordMatrix[curPoint.x][curPoint.y]
                        print("已经找到baby，推出当前循环，此时baby的最大权重是：\(maxCandy)")
                        
                        isFindBaby = true
                        break   //这个是break for
                    }
                    //入队列周围的点
                    for (xStep,yStep) in direction{
                        var nextPoint = Point(x: curPoint.x + xStep, y: curPoint.y + yStep, value: 0)
                        
                        //找出下一点是否越界，不越界就放到迭代器队列中。
                        if nextPoint.x >= 0 && nextPoint.x < nNum && nextPoint.y >= 0 && nextPoint.y < nNum {
                            //未浏览过,且不是阻碍物
                            if visited[nextPoint.x][nextPoint.y] == false && gridMap[nextPoint.x][nextPoint.y].value != -1 {
                                
                                nextPoint = gridMap[nextPoint.x][nextPoint.y]
                                print("入队列下一步要浏览的点 (\(nextPoint.x)-\(nextPoint.y)-v:\(nextPoint.value)")
                                
                                //记录下一点的权重，因为浏览过的就不再浏览，所以不必考虑重复记录的问题,可能会有多点预计到达这里，但是这里不会被重复浏览。
                                if nextPoint.value >= 0 {
                                    if recordMatrix[curPoint.x][curPoint.y] + nextPoint.value > recordMatrix[nextPoint.x][nextPoint.y]
                                    {
                                        recordMatrix[nextPoint.x][nextPoint.y] = recordMatrix[curPoint.x][curPoint.y] + nextPoint.value  //记录到达该点的最大权重。
                                    }
                                    
                                }else if nextPoint.value ==  baby.value{
                                    if recordMatrix[curPoint.x][curPoint.y] > recordMatrix[nextPoint.x][nextPoint.y]
                                    {
                                        recordMatrix[nextPoint.x][nextPoint.y] = recordMatrix[curPoint.x][curPoint.y]  //记录到达该点的最大权重。
                                    }
                                }
                                queue.append(nextPoint)
                            }
                            
                        }
                        
                    }
                }
                
                //已经使用了一步
                time = time - 1
                
            }
            
            print("权重数组：",recordMatrix)
        }else{
            print("路径不可达",-1)
        }
        
        
    }
    
    
    //MARK: 排序找前后N个数和的问题
    static func testArrNSum(){
        var lineStr = readLine()!.trimmingCharacters(in: .whitespaces)
        let mNum = Int(lineStr)!

        if mNum < 0 {
            print("输入错误，小于0")
            exit(10086)
        }

        var valueArr = readLine()!.split(separator: " ").map({ numStr in
            return Int(numStr)!
        })

        //选择要计算的N值
        var nNum = Int(readLine()!.trimmingCharacters(in: .whitespaces))!

        print("输入的数组是：",valueArr)


        print("输入的前后值是：",nNum)

        if nNum > Int(Double(mNum) * 0.5) {
            print("计算的N值超过可选范围")
        }

        var sortArr = valueArr.sorted() //排序后的数组
        var preArr = Array(sortArr.prefix(nNum))
        var suffixArr = Array(sortArr.suffix(nNum))

        var preSet = Set(preArr)  //去重
        var suffixSet = Set(suffixArr)

        //判断是否没有交集
        if !preSet.isDisjoint(with: suffixSet) {
            print("前后有重复，输出-1")
        }else{
            //高阶函数，计算结果
            let sum = preArr.reduce(0, +) + suffixArr.reduce(0, +)
            print("前后相加的结果是",sum)
        }
    }
    
    //MARK: 寻找有多少个山和山峰的问题。
    static func testFindMoutain(){
        //1、用窗口模式，每一座山峰用个窗口来表现，窗口用队列实现。
        //2、每更新一个窗口就输出当前窗口的最高峰和位置。
        //   所以需要处理窗口对应原数组的位置和值，用元组吧。

        var mArr = readLine()!.split(separator: " ").map{Int($0)!}  //山峰数组

        var windowArr = [(index:Int,value:Int)]()   //窗口数组。
        var mCount = 0  //山峰个数

        for index in 0 ..< mArr.count{
            
            let leftHeight = index - 1 < 0 ? mArr[0] : mArr[index-1]    //左边的高度
            let rightHeight = index + 1 > (mArr.count - 1) ? mArr[mArr.count - 1] : mArr[index + 1] //右边的高度
            
            let curHeight = mArr[index]
            if curHeight > leftHeight && curHeight > rightHeight {
                mCount += 1
            }

        }

        print("山峰的个数：",mCount)
    }
    
    
}
