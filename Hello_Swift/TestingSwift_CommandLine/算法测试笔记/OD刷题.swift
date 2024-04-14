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
                    //判断是否已经到达终点，会有多次到达这里？
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
        /**
         1、用窗口模式，每一座山峰用个窗口来表现，窗口用队列实现。
         2、每更新一个窗口就输出当前窗口的最高峰和位置。
            所以需要处理窗口对应原数组的位置和值，用元组吧。
            正序遍历求出正向登山，和下山的路径和体力。反向遍历，遍历登山和下山的体力。找到该山峰最省力的登山路径和下山路径。
        */

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
    
    //MARK: 给定字符串，交换一个字母，让字符串在英语字典中排得更前面（字典排序的意思）
    static func testFindDictOrder(){
        /**
            1、给定字符串，交换一个字母，让字符串在英语字典中排得更前面（字典排序的意思）
            2、首先对字符进行排序，排序后第一个与原字符串不相同的字符交换即可。
         */

        let inStr = readLine()!

        var strArr = inStr.map{ $0}     //将字符串转换为字符数组
        let sortedStrArr = inStr.sorted()   //得到排序后的字符数组

        var targetIndex = strArr.count - 1

        for index in 0 ..< strArr.count {
            
            let oldChar = strArr[index]
            let curChar = sortedStrArr[index]
            if oldChar != curChar {
                targetIndex = index
                break
            }

        }

        print("第一个不同的字符串是",sortedStrArr[targetIndex])

        let preChar = strArr[targetIndex]   //得到需要交换的前面的字符
        let afterChar = sortedStrArr[targetIndex]   //得到需要交换的后面的字符

        let afterIndex = strArr.firstIndex(of: afterChar)

        //进行交换
        strArr[targetIndex] = afterChar
        strArr[afterIndex!] = preChar

        let targetStr = String(strArr)
        print("结果是",targetStr)
    }
 
    //MARK: 从数组前或后取N次，两端取值求最大的问题。猴子取香蕉问题
    static func testFindBanana(){
        let arrNum = Int(readLine()!)!   //先序遍历序列号
        let bananaArr = readLine()!.split(separator: " ").map { Int($0)!}    //输入的香蕉数组
        let getNum = Int(readLine()!)!   //获取的次数

        /**
            1、数组记录香蕉每串的条数，只需要比较数组首尾两端的数字大小，取其大者就可以了。
                这个不行，这个是贪心算法，不能找到最大的，应该是遍历每一种情况。
            2、两个位置标志器，表示指针的移动，记录每次比较的位置，也就是下一步是走哪里
                一个数组记录每次取香蕉的条数。
                左端取N次，右端取0次
                左端取N-1次，右端取1次
                如此反复，遍历所有取法。
         
         */

        //var leftPoint = 0
        //var rightPoint = arrNum - 1
        //var bananaSum = 0

        var sumArr = Array(repeating: 0, count: getNum) //记录每次获取的总数

        for i in 0 ..< getNum {
            
            let leftNum = bananaArr.prefix(i).reduce(0, +)  //首端的香蕉
            let rightNum = bananaArr.suffix(getNum - i).reduce(0, + )   //尾端的香蕉
            
            sumArr[i] = leftNum + rightNum

        }

        print("最多获取香蕉的条数：",sumArr.max()!)
    }
    
    //MARK: 买卖股票的最佳时机，前后两个数字之间的最大差值
    static func testMaxProfit(){
        /**
            1、找出股票的最佳买卖时机，也就是找出给定数组中两个数字之间的最大差值（即，最大利润），第二个数字（卖出价格）必须大于第一个数字（买入价格）。
            2、这个要利用差值这个特性，需要用到两个参考量，一个是当天的价格，一个是今天之前的历史的最低价格。然后得出的就是最新的差距利润了。
         */
        let numArr = readLine()!.split(separator: ",").map { Int($0)!}    //输入的数组

        var minNum = Int.max
        var dayNum = numArr.first   //每天的最新价格
        var maxProfit = 0   //最大利润

        for curNum in numArr {
            if curNum < minNum {
                minNum = curNum
            }
            let disNum = curNum - minNum    //每天的差值利润
            maxProfit = max(disNum, maxProfit)  //找出最大利润
        }
        print("最大的收益是：\(maxProfit)")
    }
    
    //MARK: 获取二进制相同的最小整数
    static func testFindeMinBinaryNum(){
        let inNum = Int(readLine()!)!    //输入的整数
        /**
            1、获取整数的二进制数组
            2、找出二进制数组的倒数第一个0，与后面的第一个1互换位置，但是要确保后面有1，
            3、如果后面没有1，则需要添加一个0了，因为已经没有更小的模了。因为必须要保证1的个数的，前面任意一个1往后移动这个数整体都变小了，不能变小。
            4、所以只能增加位数。
         */

        //找出数字的二进制数组
        var myNum = inNum
        var binaryArr = [Int]()
        while myNum > 0 {
            let leftNum = myNum % 2 //余数，记录位数，最后反转即可
            binaryArr.append(leftNum)   //这里添加的数组都是低位的1
            myNum = myNum / 2
        }

        //找出1后面的第一个0，与之交换位置
        var isHasOne = false
        var firstZeroIndex = -1
        for index in 0 ..< binaryArr.count {
            let i = binaryArr[index]
            if i == 1 {
                isHasOne = true //已经有第一个1了
            }
            //找到1后的第一个0的位置
            if i == 0 && isHasOne{
                firstZeroIndex = index
            }
        }

        //有第一个为0且符合的情况，firstZeroIndex不可能是数组的最后一个索引，因为是通过求模得到的二进制数组
        if firstZeroIndex > 0 {
            binaryArr[firstZeroIndex] = 1
            binaryArr[firstZeroIndex + 1] = 0
            let myNumArr = Array(binaryArr.reversed())
            var decimalNumber = 0   //二进制数组转换为数字
            for bit in myNumArr {
                decimalNumber = (decimalNumber << 1) | bit  //只需要每一个位与数组中的每个元素相与即可。
            }
            print("有0目标数字是：\(decimalNumber)")

        }else { //没有符合0的情况
            binaryArr.insert(0, at: 0)
            let myNumArr = Array(binaryArr.reversed())
            var decimalNumber = 0   //二进制数组转换为数字
            for bit in myNumArr {
                decimalNumber = (decimalNumber << 1) | bit  //只需要每一个位与数组中的每个元素相与即可。
            }
            print("目标数字是：\(decimalNumber)")
        }
    }
 
    //MARK: 火星文运算符
    static func testCaculateSignal(){
        /**
         1、已知火星人使用的运算符为#、$，其与地球人的等价公式如下：
            x#y = 2x+3y+4
            x$y = 3*x+y+2   //优先级高
         
         2、先将优先级低的运算符的数字找出来，然后再用高级运算符组合。
         */
        let inStr = readLine()!   //输入的字符串

        var strArr = inStr.split(separator: "#").map{ String($0)}


        //计算“$”符号的运算符
        func calculateCondition(_ paramStr:String) -> Int{
            
            let curStrArr = paramStr.split(separator: "$").map{ String($0)}
            var sum = Int(curStrArr.first!)!
            for numStr in curStrArr[1...] {
                if let curNum = Int(numStr) {
                    sum = sum * 3 + curNum + 2
                }
            }
            return sum
            
        }
        
        var tSum = 0
        //看第一个数是公式还是数字
        if let firstNum = Int(strArr.first!) {
            tSum = firstNum
        }else {
            tSum = calculateCondition(strArr.first!)
        }
        
        if strArr.count < 2{
            print("目标数组只有一个：\(tSum)")
        }else{
            //计算#运算符
            for curStr in strArr[1...] {
                //如果能转换为字符串
                if let curNum = Int(curStr) {
                    tSum = tSum * 2 + 3 * curNum + 4
                }else{
                    tSum = tSum * 2 + 3 * calculateCondition(curStr) + 4    //计算优先级更高的运算符
                }
            }
        }
        print("最后的结果：\(tSum)")
    }
    
    //MARK: 给定一个整数，计算该整数有几种连续自然数之和的表达式
    static func testContinueSum(){
        /**
            一个整数可以由连续的自然数之和来表示。给定一个整数，计算该整数有几种连续自然数之和的表达式
            1、利用等差公式推算，这个更加类似数学题。t=(m+n)(n−m+1)÷2。--》t=(2×m+i−1)×i÷2=(2×m+i−1)×i÷2
                首项 + 末项 的和 乘以 项数 再除以 2 。    //因为是连续的数，所以转换为i来计算，减少未知数
         
            2、推导出 m与i的关系，目的就是求i。再找出m与t之间的关系，然后不断得尝试m的值。m就是连续的开始值，i是连续的个数。
                m=(2×t÷i−i+1)÷2 //这个就可以通过求余来判断是不是整数了。
                2m
         
                m必须是整数，i的个数限制最少是一个，最多是从1开始一直数，那么此时的m=1，然后计算出i的最多值。
                    i的最多值： 1==(2×t÷i−i+1)÷2 --》 （i+1）i <= 2t
         
         */
        let inNum = Int(readLine()!)!   //输入的字符串

        if  inNum < 3 {
            print("结果只有自身：\(inNum)")
        }else{
            var totalCount = 1  //自身
            var i = 2
            let twoNum = 2 * inNum
            while (i+1) * i <= twoNum {
                //如果算式里，两个除法都能除尽，即取余为零，那么就证明是整数
                if twoNum % i == 0 && (twoNum / i - i + 1) % 2 == 0 {
                    totalCount += 1
                    print("开始数是：\((twoNum / i - i + 1) / 2)---连续数：\(i)")
                }
                
                i += 1
            }
            print("最后的结果：\(totalCount)")
        }
        
    }
    
    //MARK: 贪心算法，找出最合适的剩余内存
    static func testBestFixNum(){
        /**
            1、在一个100字节的内存空间，找到最适合，最排前的内存块大小
            2、用一个100空间的数组记录，使用过的记1，没使用的记0
                用 请求内存 与 剩余内存 相减 ，为零则是最合适，最小是最合适。
                用元组记录（开始位置，剩余大小），（开始位置，最合适差），从而求得最合适的差即为所求。
         */
        let askNum = Int(readLine()!)!   //输入的字符串,请求的内存大小
        var usedArr = Array(repeating: 0, count: 100)
        while true {
            
            let strArr = readLine()!.split(separator: " ")  //输入的字符数组
            if strArr.isEmpty {
                print("结束输入")
                break
            }else{
                let numArr = strArr.map{Int($0)!}
                for i in 0 ..< numArr[1] {
                    usedArr[numArr[0] + i] = 1  //设置已经使用的内存，使用了的内存都标1
                }
            }
        }
        //let minDis = Int.max    //求空余内存与请求内存的差距，找到最小的差距，则是最合适的，为零的时候就是最合适的。
        //var emptryCount = 0  //计算空余内存
        //var startIndex = 0  //开始的偏移
        var emptyTuple:(startIndex:Int,count:Int) = (-1,0)   //开始偏移，空余内存
        ///求空余内存与请求内存的差距，找到最小的差距，则是最合适的，为零的时候就是最合适的。
        var minDisTuple:(startIndex:Int,minCount:Int)  = (0,Int.max)    //最适合的空余内存

        for i in 0 ..< usedArr.count {
            let isUsed = usedArr[i]
            if isUsed == 0 {
                
                //记录空余内存的开始位置
                if emptyTuple.startIndex == -1 {
                    emptyTuple.startIndex = i
                }
                emptyTuple.count += 1
                
            }else{
                let curMinDis = emptyTuple.count - askNum
                if curMinDis >= 0 && curMinDis < minDisTuple.minCount { //不要用等于，不然就不是最排前的了
                    //记录最适合的空余内存，最后一次会没有记录到
                    minDisTuple.startIndex = emptyTuple.startIndex
                    minDisTuple.minCount = curMinDis
                }
                //重置状态
                emptyTuple.startIndex = -1
                emptyTuple.count = 0
            }
        }
        //记录末尾的状况
        if emptyTuple.startIndex != -1 && emptyTuple.count <= minDisTuple.minCount{
            minDisTuple.startIndex = emptyTuple.startIndex
            minDisTuple.minCount = emptyTuple.count
        }

        if minDisTuple.minCount > 100 {
            print("没有符合条件的")
        }else{
            print("符合条件的是：\(minDisTuple.startIndex)---\(minDisTuple.minCount)")
        }
    }
    
}
