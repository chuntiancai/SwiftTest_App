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
    
}
