//
//  Swift窗口的使用.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/2.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//
//MARK: - 笔记
/**
    作用：寻找一个字符串中符合条件的连续子字符串。
    滑动窗口的使用：
                原始数组，窗口数组(队列)，存储最长字符串的标志器数组，最长整数标志器。
    理解：窗口数组起队列的作用，
        1.遍历原始数组，当前元素(将要入队的元素)，与队列的最后一个元素做比较，符合要求的元素就进去窗口队列中。
        2.如果当前元素不符合要求，当前窗口队列 与 标志器数组 做比较，如果符合要求，则替换标志器数组，清空当前队列，入队新元素。
                             如果不比标志数组的个数多，那直接清空窗口队列，入队新元素。
 
 */


struct WindowStruct {
    
    //MARK: 测试窗口的使用
    static func testWindowStruct(){
        /**
         1、找最长的一个字母和若干数字的子字符串
         */
        var myStr = readLine()!
        print("输入的字符串是：" ,myStr)

        var windowArr = "\(myStr.first!)"
        var maxCharArr = ""

        for char in myStr {
            //比较窗口队列和当前元素。
            
            //如果当前元素是字母
            if char.isLetter {
                
                //与窗口的最后个做比较。
                guard let last = windowArr.last else {
                    print("窗口最后一个不存在")
                    break
                }
                
                //窗口最后一个是字母，当前也是字母
                if last.isLetter {
                    //如果标志数组比窗口小，则替换
                    if maxCharArr.count < windowArr.count {
                        maxCharArr = windowArr
                    }
                    
                    //清空窗口队列
                    windowArr = ""
                    windowArr.append(char)
                    
                }else if last.isNumber {    //窗口最后一个是数字
                    
                    if let first = windowArr.first  {   //当前元素是数字，则清空窗口
                        
                        //窗口第一个是数字，最后也是数字
                        if first.isNumber {
                            //如果当前字符是字母,而且窗口符合要求，直接入队列
                            windowArr.append(char)
                        }else{
                            //窗口第一是字母，最后是数字
                            
                            //如果标志数组比窗口小，则替换
                            if maxCharArr.count < windowArr.count {
                                maxCharArr = windowArr
                            }
                            //清空窗口队列
                            windowArr = ""
                            windowArr.append(char)
                        }
                    }
                }
                
            }else{  //当前元素是数字
                
                //与窗口的最后个做比较。
                guard let last = windowArr.last else {
                    print("窗口最后一个不存在")
                    break
                }
                //当前是数字，窗口最后一个是数字
                if last.isNumber {
                    windowArr.append(char)
                }else {
                    //当前是数字，窗口最后一个是字母
                    
                    if windowArr.count == 1{
                        windowArr.append(char)
                    }else{
                        //如果标志数组比窗口小，则替换
                        if maxCharArr.count < windowArr.count {
                            maxCharArr = windowArr
                        }
                        
                        //清空窗口队列
                        windowArr = ""
                        windowArr.append(char)
                    }
                    
                }
            }
            
        }
        //还有一个更简单的方法，把元素数组反转一下就可以了。
        print("最长子串是\(maxCharArr)--\(maxCharArr.count)")
    }
    
    
    //MARK: 找出最大距离，多一个第三方遍历数组，窗口用数字标记。
    static func testMaxDistance(){
        //1、找出数组中最大的间隔，其实也可以用窗口来实现，但是这次是用数学标志来替代(结合)窗口。
        // 窗口是谁？--  最大空座位数组，两个窗口：座位数组，最大距离数组(可以用数字标志)
        // 遍历原始数组是谁？ -- 入场数组，难点在于如何更新最大空座位数组。
        // 遍历入场数组，在入场数组中再寻找最大窗口进入插人，插入后，再去更新最大窗口，然后再入场数组浏览下一个。

        // 1、输入座位数
        let seatNums = Int(readLine()!.trimmingCharacters(in: .whitespaces))!
        if seatNums < 1 {
            print("输入座位数错误")
        }

        //2、输入入场数组
        let personArr = readLine()!.split(separator: " ").map{Int($0)!} //窗口

            //标志器：座位数组，入场数组，记录标志（人的位置索引，距离下一人(包括)最大空距离），三人之后有用，平凡情况，一般情况。
                    // 第一个人到第二个人之间的最大距离。记录标志相当于窗口。
            //特殊：位置0一定要有人，第二位是在队尾，位置满了输出-1

        var seatArr = Array(repeating: false, count: seatNums)  //座位数组

        //标志器：
        var maxMark:(index:Int,distance:Int) = (0,seatNums) //当前最大距离的座位数(第一个空位索引，空位的个数)
        var targetSeat = -1 //目标座位


        //3、如何更新最大距离座位数。
        //  直接在座位数组上更新，还是用栈的方式更新？

        //4、处理特殊情况：1、2人，满人。

        //遍历人员数组
        for value in personArr {
            
            //处理座位总数少于三个的情况
            
            if value > 0 {  //人进来坐
                
                if maxMark.distance == seatNums {   //第一位进来了之后，不可能马上出去了
                    maxMark = (1,seatNums - 1)
                    seatArr[0] = true   //入座
                }else if maxMark.distance == seatNums - 1 {  //第二位进来了。
                    
                    maxMark = (1,seatNums - 1)  //安排做最后一位
                    seatArr[seatNums - 1] = true   //入座
                }else{  //已经有两人在坐了
                   
                    let maxLength = maxMark.distance
                    if maxLength > 0 {
                        let nextMaxLength = Int( Double(maxLength) * 0.5) //向下取整最大的整数，因为是第一位是空位
                        let nextIndex = maxMark.index + nextMaxLength   //下一位索引
                        targetSeat = nextIndex
                        seatArr[nextIndex] = true   //入座
                        
                        //遍历最大空位数
                        var maxEmpty:(index:Int,count:Int) = (0,0)  //遍历寻找当前最大空位数(人的索引，空位数)
                        var curCount:(index:Int,count:Int) = (0,0)     //当前遍历的最大空位
                        
                        for (index,value) in seatArr.enumerated() {
                            if value == false{
                                curCount.count += 1
                            }else{
                                if curCount.count > maxEmpty.count {    //置换最大
                                    maxEmpty = curCount
                                }
                                curCount = (index,0)    //置零
                            }
                        }
                        
                        if maxEmpty.count > 0 {
                            maxMark = (maxEmpty.index + 1 , maxEmpty.count)
                            
                        }
                        
                    }else{  //满人了
                        targetSeat = -1
                        break
                    }
                    
                }
                
            }else{  //人离开
                
                seatArr[-value] = false //位置归零
                //遍历最大空位数
                var maxEmpty:(index:Int,count:Int) = (0,0)  //遍历寻找当前最大空位数(人的索引，空位数)
                var curCount:(index:Int,count:Int) = (0,0)     //当前遍历的最大空位
                
                for (index,value) in seatArr.enumerated() {
                    if value == false{
                        curCount.count += 1
                    }else{
                        if curCount.count > maxEmpty.count {    //置换最大
                            maxEmpty = curCount
                        }
                        curCount = (index,0)    //置零
                    }
                }
                
                if maxEmpty.count > 0 {
                    maxMark = (maxEmpty.index + 1 , maxEmpty.count)
                }
            }

        }

        print("当前入座的座位是：",targetSeat)
    }
    
    //MARK: 找字符串交集
    static func testFindSonStr(){
        var sStr = readLine()!.trimmingCharacters(in: .whitespaces)
        var lStr = readLine()!.trimmingCharacters(in: .whitespaces)

        if sStr.isEmpty || lStr.isEmpty{
            print("输入不符合要求")
        }

        for char in lStr {
            if char == sStr.first {
                sStr.removeFirst()
            }
        }
        if sStr.count == 0 {
            print("s是有效字符串")
        }else{
            print("s不是有效字符串")
        }
    }
    
}
