//
//  Swift递归算法.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/5.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//
// MARK: - 笔记
/**
 
    1、具有以下特征的问题可考虑递归求解：
            当问题和子问题具有递推关系，比如杨辉三角、计算阶乘（后文讨论）。
            具有递归性质的数据结构，比如链表、树、图。
            反向性问题，比如取反。
       递归程序应该包含2个属性：
            基本情况（bottom cases），基本情况用于保证程序调用及时返回，不再继续递归，保证了程序可终止。
            递推关系（recurrentce relation），可将所有其他情况拆分到基本案例。可掐头去尾，在外部处理了头尾。
 
       注意：记得前头去尾去掉问题的不可重复性。
 
    2、递归最难理解的点是回溯(标志器的传递与复用)，回溯最难理解的点是：已标记过的足迹和已执行过的足迹搞混。
        已标记过的足迹：是指进行下一层递归之前，标记当前点已经浏览了。
        已执行过的足迹：是指当前层已经被上一层执行过了，但是当前层递归完下一层之后，又回溯当前层到未浏览状态，供上一层的右层引用，
                     但是已经不会再回退到上一层了，因为当前层就是上一层执行下来的。
 
        难点：已标志和已执行的足迹都是用同一个数组来标志，只是递归的层次是上下层。
             已标记的足迹是上一层未执行的足迹，需要释放。
 
        关于回溯：如果当前层会被右层使用，则需要在当前层的递归基的后面回溯标记当前层为未浏览。
                如果当前层不会被右层所使用，则不需要回溯状态。
                回溯状态不影响是因为，当前层不会再是上一层的同样路径来到这里，因为问题已经分而治之，或减而治之了，规模已经减少了，
                不会再回到之前还未治的规模，回到的规模是已经治的规模了，治了之后就不会重复这条路径了，因为是带着解答回到上一层的。
                体现为上一层for循环的下一个索引，for循环不会倒退。
 
        任何递归形式的算法都能通过栈、队列等数据结构转化为非递归的形式。但是我不能，我现在连理解递归都难。
 */

import Foundation

struct SwiftRecursionStruct{
    
    //MARK: 去掉头部特殊情况的递归，分月饼。
    static func testHeadTailRecursion(){
        /**
            1、问题规模为：人数，月饼个数。都可以减少，且都可以重复。
                递推条件：上一个人拿了多少个月饼 导致 月饼减少了， 人数也减少了。
                每一步是：有x个人，y个月饼，上一个人拿了z个，看是否可到达终点，记录能到达终点的个数即为求解。
                边界条件为：到达终点时，即最后人也轮完了，月饼也分完了。
         */
        var pNum = Int(readLine()!.trimmingCharacters(in: .whitespaces))!   //人数
        var cakeNum = Int(readLine()!.trimmingCharacters(in: .whitespaces))!    //月饼数

        var pArr = Array(repeating: false, count: pNum) //标志数组，已使用的条件，这里是第i个人是否分到了月饼
        var getArr = Array(repeating: 0, count: pNum)   //结果数组，每个人分的月饼个数，这里只是我想看一下
        getArr[0] = 1

        var validCount = 0  //有效分法的个数

        func getCake(curPNum:Int,cakes:Int,firstGet:Int) -> Int{ //有curPNum个人，分cakes个蛋糕，第一个人拿了firstGet个，有多少种分法。
            
            //边界条件，人刚好轮完，蛋糕也没有了。
            if curPNum == 0 && cakes == 0 {
                print("分配有效：",getArr)
                return 1
            }
            if cakes < 0 || curPNum < 0 {
                return 0  //没有合理的分配
            }
            
            let nextPum = curPNum - 1;  //下一个人
            var curCount = 0
            for index in 0 ... 3 {    //下一个人拿多少个。
                let nextGet = firstGet + index
                if (pNum - curPNum < getArr.count){
                    getArr[pNum - curPNum] = nextGet
                }
                
                let curValidCount = getCake(curPNum: nextPum, cakes: cakes - nextGet, firstGet: nextGet)   //是否能到终点
                curCount += curValidCount
                
            }
            return curCount
        }

        let maxGet = cakeNum - pNum + 1 //第一个人最多拿多少个
        for index in 1 ... maxGet { //第一个人拿 不算进递归基中，因为不可以重复，需要先行条件，需要第一个递推条件就是第一人拿了多少。
            getArr[0] = index
            let curCount = getCake(curPNum: pNum - 1, cakes: cakeNum - index, firstGet: index)
            validCount += curCount
            
        }
        print("总的分配方式：",validCount)
    }
    
    
}
