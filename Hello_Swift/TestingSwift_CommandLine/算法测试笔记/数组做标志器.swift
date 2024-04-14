//
//  数组做标志器.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/26.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//

import Foundation


struct ArrayMarkStruct{
    
    //TODO: 寻找宽度最小的矩阵
    static func testFindMinXMartrix(){
        /**
            1、在一个数字矩阵中，给出一个一维数组的数字，找出包含该一维数组所有数字的最小矩阵，只要求举证宽度最小，不要求高度。
            2、还是利用数学特性好了：
                其实可以利用列的特性，遍历每一列，看有没有k数组里面的数组，有的话，就移除k数组的一个元素，看什么时候把k数组全部移除，那么就是结果了。
                这样就只需要记录开始和结束的就可以了
         */


        let nmArr1 = readLine()!.split(separator: " ").map { Int($0)!}  //n*m
        let nNum = nmArr1[0]    //有n行
        let mNum = nmArr1[1]    //有m列


        //struct Point{
        //    let x:Int
        //    let y:Int
        //    let value:Int   //坐标上的物件， -1 障碍，-2宝宝，-3妈妈，>=0 糖果。
        //}

        //坐标图
        var gridMap = [[Int]]()   //输入数字的矩阵

        for i in 0 ..< nNum {
            gridMap.append([Int]())
            let inputArr1 = readLine()!.split(separator: " ").map { Int($0)!}
            for val in inputArr1 {
        //        let curPoint = Point(x: index, y: j, value: inputArr1[j])
                gridMap[i].append(val)
            }
        }


        var kNum = Int(readLine()!)!    //k数组的个数
        var kArr = readLine()!.split(separator: " ").map { Int($0)!}    //k数组


        //在第一行找到kArr的第一个数字，作为起始点，看有多少个数字则有多少个起始点
        let startVal = kArr.first!  //如果第一个行没有，则说明要到下一行，一直有为止



        //找出最小间距,开始的列，结束的列
        func findMinDistance(startX:Int,startY:Int) -> (Int,Int){
            var mystartX = -1 //开始列
            var myendX = -1   //结束列
            
            var curKArr = Array(kArr[0...]) //标志器数组
            if startX >= mNum || startY >= nNum {
                return (mystartX,myendX)
            }
            for j in startX ..< mNum {   //遍历列
                
                let disX = mNum - j
                if disX * nNum < curKArr.count {    //如果剩余个数少于标志，则不需要遍历了，肯定不符合要求了
                    return (mystartX,myendX)
                }
                for i in startY ..< nNum {   //遍历行
                    let curValue = gridMap[i][j]
                    if let firsIndex = curKArr.firstIndex(of: curValue) {
                        
                        curKArr.remove(at: firsIndex)
                        if mystartX < 0 { //记录下开始列
                            mystartX = j
                        }
                        if curKArr.isEmpty {   //记录下结束列
                            myendX = j
                            return (mystartX,myendX)
                        }
                    }
                    
                }
            }
            return (mystartX,myendX)
        }

        var ansArr = [(Int,Int)]()  //最小间距数组
        for i in 0 ..< nNum {   //行
            for j in 0 ..< mNum {   //列
                let disX = mNum - j
                let disY = nNum - i
                if disX * disY < kNum {  //如果个数不足了，则不需要再继续扫描了
                    break
                }
                let curTup = findMinDistance(startX: j,startY: i)
                ansArr.append(curTup)
            }
        }
        var minDis = mNum + 1
        for (sX,eX) in ansArr {
            if sX > -1 && eX > -1 {
                let curDis = eX - sX + 1
                minDis = min(minDis, curDis)    //找出最小值
            }
        }


        if minDis < mNum + 1 {
            print(minDis)
        }else {
            print(-1)
        }
    }
    
    //TODO: 找偶数最长字符串，数组+吊坠 作为标志器
    static func testFindEvenStr(){
        /**
            1、环形字符串，找出包含i、o、x都出现偶数次的最长子字符串。
            2、利用数学的奇偶性：偶-偶 = 偶 ， 奇-奇 = 偶，奇-偶 = 奇
                记录每个字母在当前位置的前面是奇数个还是偶数个，只需要记录奇偶性和位置即可，位置用于找出子字符串，奇偶性为了满足题目条件。
         
                如何记录？用什么数据结构？ 一维数组+吊坠 的数据结构。
                    三珠吊坠，三珠就是i、o、x三个字母的标志器，可以用链表表示。这里可以直接用二进制整数来表示，因为只用到了奇偶性，所以更简单。
                    一维数组就是原来环形字符串的位置标志器。
         
                难点：数学特性，因为出现两个相同吊坠的时候，就是满足题意了，因为奇偶相同了，所以问题就变成了记录两个相同吊坠最长距离了。
                     把距离作为最终目的，那么吊坠就又成了一个参考器，如何记录重复的吊坠呢，可以用一维数组的下标作为吊坠，
                     因为吊坠也是二进制数，可以理解为整数，于是一维数组的所有下标就对应了吊坠的所有可能性，值就记录吊坠出现的位置或者长度即可。(这里用位置)
                     但是我觉得不是很好，不如用字典+吊坠的形式。key为吊坠，value为（吊坠出现的位置，长度）
         */

        let inStr = readLine()!  //输入的字符串
        let sStr = inStr + inStr
        var indexMarkArr = Array(repeating: UInt8(0), count: sStr.count)    //记录每个位置的吊坠，奇偶性状态,i为最末尾那个，其次到o，再到x

        var statusInt:UInt8 = 0    //最开始的奇偶性状态，当前位为0表示出现了偶数次。
        var statusDict:[UInt8:(idnex:Int,lenght:Int)]  = [UInt8:(Int,Int)]()  //字典记录当前状态所在的索引

        for (index,value) in sStr.enumerated() {
            
            let char = value
            var markInt:UInt8 = 0
            //记录当前的吊坠，要与前面的吊坠进行异或
            switch char {
            case "l":
                //与1异或，相同为0，不同为1，不改变其他位置的数值，只改变目标位的数值。因为其他为全为0
                markInt = 1 << 0
            case "o":
                markInt = 1 << 1
            case "x":
                markInt = 1 << 2
            
            default:
                break
            }
            
            statusInt = statusInt ^ markInt
            
            indexMarkArr[index] = statusInt //记录当前位置的奇偶性状态
            
            if let tuple = statusDict[statusInt] {   //当前位置有该状态
                let distance = index - tuple.idnex  //不能包含第一次出现该状态的位置，因为我是这个位置的状态的奇偶性，是需要减去上一个状态的。
                if distance <=  inStr.count {
                    statusDict[statusInt] = (tuple.idnex,distance) //记录最大长度
                }
            }else{
                statusDict[statusInt] = (index,1)   //记录第一次出现该状态的位置
            }
            
        }

        var maxDis = 0
        for tuple in statusDict.values {
            maxDis = max(maxDis, tuple.lenght)
        }
        let charStatusArr  = indexMarkArr.map{ String($0,radix: 2,uppercase: true)}
        print(charStatusArr)


        print("最长的字符串长度是：",maxDis)
    }
}
