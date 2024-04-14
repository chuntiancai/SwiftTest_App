//
//  main.swift
//  TestMain
//
//  Created by ctch on 2024/2/29.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
// 用于临时测试的main函数

import Foundation

print("Hello, TestMain!")

/**
 内存空间长度
 假设用区间 [start end) 表示一次内存初始化操作的范围，end 减去 start 表示初始化的内存长度。

 给定一组内存初始化操作，请计算最终初始化的内存空间的总长度。
 假设: 内存初始化操作都会成功；同一块内存允许重复初始化。

 首行一个整数 n，表示一组内存初始化操作的次数，取值范围 [1,100000]
 接下来 n 行，每行表示一次内存初始化，格式为start end，取值范围 0 <= start < end <= 10^9

 样例
 输入样例 1 复制

 3
 2 4
 3 7
 4 6
 输出样例 1

 5
 提示样例 1
 [2, 4) 和 [3, 7) 合并后为[2, 7)，[2, 7) 和 [4, 6) 合并后为[2, 7)，总长度为7 - 2 = 5 。

 */

/**
    1、找出数组中前一元素和后一个元素的交集，然后看是否可以合并，可以合并则添加到容器数组中。
 */

var nNum = 3
var dityTuple1:(start:Int,end:Int) = (2,4)
var dityTuple2:(start:Int,end:Int) = (3,7)
var dityTuple3:(start:Int,end:Int) = (4,6)


var dirtyArr = [dityTuple1,dityTuple2,dityTuple3]

var preTup = dirtyArr.first!
var resArr = [(start:Int,end:Int)]()    //结果数组
resArr.append(preTup)

for i in 0 ..< dirtyArr.count {
    let curT = dirtyArr[i]
    //判断后一个是否与前面一个有交集，
    if curT.start <= preTup.end  {
        //1、有交集
        if curT.end >= preTup.end {
            preTup.end =  curT.end
        }
        //2、前一个包含当前，不操作
    }else{
        //3、没有交集，在后面
        resArr.append(preTup)
        preTup = curT
    }
}

//处理最后一段内存空间,没有赋值preTup的情况
//if

var resSumArr = [Int]()
//输出结果
for tup in resArr {
    let curSum = tup.end - tup.start
    resSumArr.append(curSum)
}
var totalSum = 0
for curSum in resSumArr {
    totalSum += curSum
}

print("结果是:\(totalSum)")




