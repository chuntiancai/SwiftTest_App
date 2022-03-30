//
//  Swicth、函数的定义.swift
//  TestSwift
//
//  Created by 蔡天春 on 2020/9/15.
//  Copyright © 2020 蔡天春. All rights reserved.
//

import Foundation



func testFun(){
    
    //区间类型，有闭区间，开区间，无穷区间，重要的是区间的类型是范型，字符区间默认不能使用for in 语句
    let strRange: ClosedRange<String> = "a"..."z"

    for var i in 1...5 {    //所以这个不能作为间隔咯
        i += 2
        print(i)
    }

    strRange.contains("f")

    //带间隔的区间，用到stride函数
    for index in stride(from: 1, to: 10, by: 3){
        print(index)
    }
    var number = 3
    switch number {
    case 1:
        print("\(number)")
        fallthrough //默认是break，自己加贯穿，就继续执行下一步
    default:
        break
    }

    let valueBind = (2,4)   //值绑定
    switch valueBind {
    case (let x,4):
        print("\(x)")
        fallthrough //默认是break，自己加贯穿，就继续执行下一步
    default:
        break
    }

    //where语句，用于表达式或者其他语句后面起过滤作用，相当于continue语句

    //标签语句 outer
    outer: for i in 1...4{
        for k in 2...5{
            if k == 3 {
                continue outer
            }
            
            if i == 3{
                break outer
            }
            print("\(i),\(k)")
        }
        
    }

    //函数的定义
    //形参默认是let，也只能是let
    //隐式返回
    //返回元组，实现多返回值
    //函数的文档注释是用三条斜杆///，注意每个换行
    //参数标签
    //默认参数值，可以不传有默认参数的值。在不产生歧义的情况下，你怎么简洁都可以
    //可变参数，一个函数最多只能有一个可变参数
    //输入输出参数，即是参数的类型声明前的inout关键字。可变参数不能是inout，inout不能是默认参数
    //函数重载，不是重写（重写是重新编写）；重载是参数个数，或者类型，或者标签不同，但是返回值不是重载的条件
    //默认参数值函数和重载具有二义性，但是编译器不会报错；其他产生的二义性会报错；尽量避免二义性
    //默认debug模式下不会转换为内联函数，当时release时会转换部分函数为内联函数
    //内联函数其实是汇编的概念，但是可以理解为将函数展开为函数体（即指令行）
    //函数类型，由形式参数类型，返回值类型组成： (Int,String) -> Int
    //函数类型 也可以做为参数传递；函数类型，也可以作为函数的返回值类型； -> 是左侧优先匹配规则
    //返回值类型 是函数类型 的函数，叫做高阶函数

    //typealias 用来给类型起别名

    //Void就是空元组

    //嵌套函数，函数里面的函数

}
