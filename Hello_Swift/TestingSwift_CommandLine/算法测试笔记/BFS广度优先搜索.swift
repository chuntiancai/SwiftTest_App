//
//  BFS广度优先搜索.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/2/29.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//
//MARK: - 笔记
/**
    1、BFS从根节点（或其他任意节点）开始，首先访问所有相邻的节点，然后再访问这些节点的相邻节点，依此类推，直到访问完所有可达的节点。
    2、BFS通常使用队列来实现，首先将根节点入队，然后不断从队列中取出节点进行访问，并将其相邻节点入队，直到队列为空。
        也就是队列作为参考容器，为了实现BFS有可能用到多个参考容器，例如二维数组。
 */

 //MARK: - 妈妈找宝宝问题，最短路径，与最短路径上的最大权重。
 /**
     解题思路：用BFS找出最短时间，即最短路径，再遍历每条最短路径上的最大糖果数。
     需要的标志器：
            起点，终点，
            BFS运行的迭代器(队列)，每一次迭代只迭代周围的点，所以迭代器要设计好大小范围，用大小范围(size)作为一圈的断点标志。
                            是像涟漪一样，一圈一圈地扩散去搜索。像花瓣一样扩散开来。
            记录已经浏览过的点（可以用矩阵二维数组来记录，如果原始的数据不需要保留，那么也可以直接修改原数据）
            最短时间，最大糖果数，
  
     找最短路径上的最大权重：
        知道了最短路径步数之后，就再一次BFS，从起点到终点，规定在最短路径(步数)内，用多一个矩阵标志器，标志每到达该点的最大权重是多少。
        因为BFS在规定的最短路径(步数)到达该点的路径都是最短路径，所以也就不用纠结会不会绕路了，因为已经浏览过的都不能再浏览了，
        也就不存在重复记录问题，记录的都是预计下一步要走的点，而且浏览过的点，都表明了到达该点的最大权重了，到时候(最短路径步数内)该点的最大权重就好了。
  
                         
     
  先想一想BFS是怎么运行的，
    1、设置起始点，起始点默认为未遍历的点，入队列
    2、起始点出队列，作为当前点，记录当前点为已浏览，当前点进入已经浏览过的容器中，把当前点的周围点入队列，作为下一批要遍历的点。
        2.1、判断当前点的周围点是否已经浏览过，如果浏览过，计入浏览的标志容器中，则不进入队列中。
                如果未浏览过，则进入迭代队列中。
        2.2、如果是单纯找最短时间，则不需要每一个点都存储数据标志，只需要每一次遍历作为路径+1，什么时候遍历到终点了，结束路径+1就可以了。
        2.3、这样做可以知道最短时间，但是并不知道最短路径的整条路径，如果需要知道整条路径，则需要更多的数据结构来记录。
                那就需要为开始遍历的每一个点设置一个数组，遇到分叉，就新建一条路径，作为路径的记录，好多工程。
                但是最常用的就是直接reverse，记录数组反转？
  */


 //描述问题的数据结构：
 //坐标的点。
func testMomBaby(){
    
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

    //运行迭代器，找出最少步数
    while !queue.isEmpty {
        let qSize = queue.count
        //扩散一圈
        for _ in 0 ..< qSize{
            let curPoint = queue.removeFirst()  //pop出当前点进行浏览。
            visited[curPoint.x][curPoint.y] = true  //记录已经浏览的点
            //判断是否已经到达终点
            if curPoint.value == baby.value{
                print("已经找到baby，推出当前循环")    //最先到达的肯定是最少步数的
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
 
 

struct TestBFS_Struct {
    //MARK：题目1:在一个N*N矩阵中，找到最短路径，并且找出权重最大的那个最短路径。
    /**
        解题的关键：
            1.BFS的核心参考容器就是队列，用一个队列来记录所有走过的点，因为按照先后顺序存入队列，刚好就是对应BFS的遍历相邻点存入队列。
            2.
     */
    func testNN(){
        
    }
    
    //MARK: BFS找出最少时间
    static func testLestTime() {
        
    }
    
    //MARK: BFS找出最短路径
    static func testShortPath() {
        
    }
    
}
