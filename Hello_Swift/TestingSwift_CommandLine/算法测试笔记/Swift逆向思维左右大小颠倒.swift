//
//  Swift逆向思维左右大小颠倒.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/5.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//
// MARK: - 笔记
/**
    1、逆向思维是：
            如果题目是比最大的，那么你就从从小的方向思考。
            如果题目是从小到大排列，那么你从从大到小方向去思考。
            如果题目是从左到右排列，那么你就从右到左方向思考。
 */

struct SwiftReverseMind{
    
    //MARK: 左右遍历数组，找出山峰与权重的问题。
    func testClimbMotain(){
        //1、用窗口模式，每一座山峰用个窗口来表现，窗口用队列实现。
        //2、每更新一个窗口就输出当前窗口的最高峰和位置。
        //   所以需要处理窗口对应原数组的位置和值，用元组吧。
        //   正序遍历求出正向登山，和下山的路径和体力。反向遍历，遍历登山和下山的体力。找到该山峰最省力的登山路径和下山路径。



        var mArr = readLine()!.split(separator: " ").map{Int($0)!}  //山峰数组
        var bodyValue = Int( readLine()!.trimmingCharacters(in: .whitespaces) )!     //体力值

        var windowArr = [Int]()   //窗口数组，记录当前一座山，可能有多个山峰
        var upPathValueArr = Array(repeating: -1, count: mArr.count)    //登山路径的最小体力消耗，下标为第i座山峰
        var dowmPathValueArr = Array(repeating: -1, count: mArr.count)    //下山路径的最小体力消耗，下标为第i座山峰


        var startIndex = 0  //山脚索引

        var mCount = 0  //可攀登山峰个数
        
        var isCouldClimb = mArr[0] < 1 ? true : false

        //正向遍历，找出正向登山路径与下山路径的消耗
        for index in 0 ..< mArr.count{
            
            
            let leftHeight = index - 1 < 0 ? mArr[0] : mArr[index-1]    //左边的高度
            let rightHeight = index + 1 > (mArr.count - 1) ? mArr[mArr.count - 1] : mArr[index + 1] //右边的高度
            
            let curHeight = mArr[index]
            
            if curHeight > 0 {
                if !isCouldClimb {continue} // 不可攀登
                
                windowArr.append(curHeight) //山峰入窗口记录
                
                if curHeight > leftHeight && curHeight > rightHeight {  //找到了第一个山峰
                    var upCast = 0  //上山体力
                    var downCast = 0    //下山体力
                    //计算这个山顶正向登陆，反向下山的体力消耗
                    for i in 0 ..< windowArr.count {
                        let curValue = windowArr[i]
                        let preValue = i == 0 ? 0 : windowArr[i - 1]
                        let diff = curValue - preValue  //高度差
                        upCast = upCast + diff * 2  //上山体力消耗
                        downCast = downCast + diff  //下山体力消耗
                    }
                    upPathValueArr[index] = upCast  //记录当前山峰的上山体力消耗
                    dowmPathValueArr[index] = downCast  //记录当前山峰的下山体力消耗

                    mCount += 1
                }
            }else{
                isCouldClimb = true //可以攀登
                windowArr.removeAll()   //重置窗口
            }

        }

        //反向遍历，找出反向登山路径与下山路径的消耗
        //stride(from: mArr.count - 1, through: 0, by: -1)
        isCouldClimb = mArr[mArr.count - 1] < 1 ? true : false
        for index in Array([0..<mArr.count]).indices.reversed(){
            
            
            let leftHeight = index - 1 < 0 ? mArr[0] : mArr[index-1]    //左边的高度
            let rightHeight = index + 1 > (mArr.count - 1) ? mArr[mArr.count - 1] : mArr[index + 1] //右边的高度
            
            let curHeight = mArr[index]
            
            if curHeight > 0 {
                if !isCouldClimb {continue}
                windowArr.append(curHeight) //山峰入窗口记录
                
                if curHeight > leftHeight && curHeight > rightHeight {  //找到了第一个山峰
                    var upCast = 0  //上山体力
                    var downCast = 0    //下山体力
                    //计算这个山顶正向登陆，反向下山的体力消耗
                    for i in 0 ..< windowArr.count {
                        let curValue = windowArr[i]
                        let preValue = i == 0 ? 0 : windowArr[i - 1]
                        let diff = curValue - preValue  //高度差
                        upCast = upCast + diff * 2  //上山体力消耗
                        downCast = downCast + diff  //下山体力消耗
                    }
                    upPathValueArr[index] = upPathValueArr[index] < 0 ? upCast : upPathValueArr[index]
                    if upCast < upPathValueArr[index] {
                        upPathValueArr[index] = upCast  //记录当前山峰的上山体力消耗
                    }
                    
                    dowmPathValueArr[index] = dowmPathValueArr[index] < 0 ? downCast : dowmPathValueArr[index]
                    if downCast < dowmPathValueArr[index] {
                        dowmPathValueArr[index] = downCast  //记录当前山峰的下山体力消耗
                    }
                    

                    
                }
            }else{
                isCouldClimb = true
                windowArr.removeAll()   //重置窗口
            }

        }

        print("上山体力：",upPathValueArr)
        print("下山体力：",dowmPathValueArr)

       

        //数组下标反向遍历
        for index in upPathValueArr.indices.reversed() {
        //    print("下标：",index)
            let uValue = upPathValueArr[index]
            let dValue = dowmPathValueArr[index]
            if uValue > 0 && dValue > 0 {
                let totalVal = uValue + dValue
                if totalVal < bodyValue {
                    mCount += 1
                }
            }

        }

        print("可以攀登的个数：",mCount)
        
        
    }
    
}


