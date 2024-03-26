//
//  Swift单调栈的使用.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/2.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//

//MARK: - 笔记
/**
    1、单调栈的核心点就是：栈顶元素与遍历移动点保持一致。
                        栈顶元素 就是 遍历数组刚刚遍历过的元素。
                        将要入栈的元素 就是 数组中当前遍历的元素，正在处理的元素。
 
    2、单调栈的作用是：寻找右侧(或左侧)第一个比当前元素大(或小)的元素。
                    核心作用是，把单调栈作为一个遍历的窗口。不仅利用单调栈的将来(将要入栈的元素)，也利用了它的过去(栈里的元素)，做比较。
                    过去：即栈里的元素，即已经遍历过的数组的元素。
                         每一个过去都必须按照规律入栈。
                    将来：即将要入栈的元素，与过去做比较，看是否符合要求，然后决定要不要放到第三方标志器容器中(映射)。
 
    3、快速理解：
             如果是寻找右侧第一个比当前元素要大的元素，那么就是小的入栈。每一次过去与将来的比较(出栈)，都是第一次，且符合要求。
             如果是寻找右侧第一个比当前元素要小的元素，那么就是大的入栈。

 */


struct SingleStack{
    
    //MARK: 寻找右侧第一个更大的元素，并记录位置
    static func findNextMax(){
        //小朋友个数
        var nNum = Int(readLine()!.trimmingCharacters(in: .whitespaces))!

        var heightArr:[Int] = readLine()!.split(separator: " ").map { element in
            Int(element)!
        }


        var friendArr = Array(repeating: 0, count: heightArr.count) //记录好朋友位置的数组
        var heightStack = [(index:Int,height:Int)]()   //单调栈，记录比当前矮的身高，那么出栈的第一个必定是比栈顶高的数

        for (index,height) in heightArr.enumerated() {
            
            //比较将要入栈的元素，与栈顶元素的大小，看是否要入栈，不要入栈的话，那么将要入栈的元素就是第一个比栈顶元素大的元素。
            while !heightStack.isEmpty && height > heightStack.last!.height {
                let prePerson = heightStack.removeLast()
                friendArr[prePerson.index] = index  //记录好朋友的位置。
            }
            //如果将要入栈的元素比栈顶元素要小，那么将要入栈的元素直接入栈。
            heightStack.append((index,height))
            
            //如果单调栈最后不为空，那么栈里的小朋友都是没有好朋友的，因为没有人比他们高
        }

        for curPerson in heightStack {
            friendArr[curPerson.index] = 0  //没有好朋友
        }

        print("好朋友的位置是：",friendArr)
    }
    
}
