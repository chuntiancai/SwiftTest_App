//
//  枚举、可选项.swift
//  TestSwift
//
//  Created by 蔡天春 on 2020/9/15.
//  Copyright © 2020 蔡天春. All rights reserved.
//

import Foundation

//@inline关键字,用于指明编译器是否使用内联优化，仅当代码很长时也优化
@inline(never) func testInline(){
    print("tesst")
}



//枚举类型、关联值，原始值
//1、枚举类型时单独的一种类型，关联值只是内存上和枚举类型存放在一起，关联值有自己的类型；可以关联元组；关联值可以通过()来引用
//2、原始值也是枚举值内存上的某一个约定的区域，约束更大，与其他成员有联系；而且做了优化，原始值的内存只存了一个字节的索引，通过引用去引用原始值，编译器做了优化。或者函数之类的去引用原始值
//3、枚举成员自己也是一种类型，有自己的标识
//4，而关联值就真正的使用了定义该枚举类型的内存
//5、成员值：内存对齐后，枚举会默认为每一个成员分配成员值，从零开始，然后最后一个对齐单元存放的成员值，前面的对齐单元存放的事关联值。必定有一个字节存放成员值；关联值是共用体的内存分配布局；成员值是枚举内部用于区分成员的；
//6、枚举的本质是通过成员值的比较来匹配的，也就是汇编指令的test指令，所以每一个枚举实例都会维护一个成员值的内存空间，哪怕前面有再多的关联值
enum Direction{
    case north
    case south
    case east
    case west
}
//原始值,原始值不允许改变，定义后就是常量，有了原始值不再允许关联值（内存冲突），原始值是字符串、Int等类型的话，内存上存的原始值是引用，一个字节而已，做了优化
//隐式原始值会自动分配原始值（字符串与枚举成员同名的隐式原始值，注意，成员不是字符串，而是枚举类型），int类型原始值默认从零开始递增
enum PokeSuit: Character {  //不是继承关系，而是约束每一个枚举成员的原始值的类型要一致，枚举没有继承这一设定
    case spade = "♠️"
    case heart = "♥️"
}
//递归枚举加indirect关键字



func testEnum(){
    //Memorylayout关键字，测量类型的内存大小
    var age = "niid"
    //单位是字节
    let sizeInt1 = MemoryLayout<Int>.size       //实际使用的空间大小
    let sizeInt2 = MemoryLayout<Int>.stride     //分配的空间大小
    let sizeInt3 = MemoryLayout<Int>.alignment  //内存对齐参数


    MemoryLayout.size(ofValue: age)

    enum Password {
        case number(num1: Int,num2: Int,num3: Int)//占用24个字节
        case other  //占用一个字节，没有关联值就不分配而外的字节，关联值类型相同的枚举成员是共用体的分配，即共用一个内存区域，而关联值不同类型的就需要分配不同的内存空间来区分，而不是共用体的内存
    }
    //测量枚举变量的内存空间,所以枚举的内存空间分配和c语言的共用体是类似的
    var pwd = Password.number(num1: 72, num2: 13, num3: 98)
    pwd = .other

    MemoryLayout.size(ofValue: pwd)
    MemoryLayout.alignment(ofValue: pwd)

    enum Season: Int {
        case spr = 1,sum,auth,winter
    }
    let seatemp = Season(rawValue: 3)   //枚举值的构造函数，由原始值反构造枚举类型成员
    MemoryLayout<Season>.size


    //可选项 ？optional，是对其他类型的一种包装
    //强制解包 ！ ，强制解包会报运行时错误
    //可选项绑定if let 或者 if var
    //空合并运算符 ??
    //if let =  a ?? b , ??的优先级比=号要高
    //if let c = a , let d = b 这是if语句的双判断与条件
    var age1: Int   //相当于声明了初始值为nil的可选类型


    //while语句的两个判断条件
    while 2>3,5>4 {
        print("jin ru xun huan le ")
        break
    }

    //guard语句,与if刚好相反，if判对，guard判错；而且guard let name的作用域在大括号外面，不限于大括号里面，作用域更加大
    guard 3>2 else {
        //退出当前作用域
    }

    //隐式解包，默认解包
    let num1 : Int! = 32    //所以num1可以做判空操作，if num1 == nil

    //多重可选项,包装了可选类型的可选类型，直接给多重赋值nil的话，编译器会做优化，为只有一层包装的nil的可选项，不像有值时的两层包装
    var num3: Int? = 23
    var num4: Int?? = num3

    //lldb的指令fr v -R 查看内存布局； xcode的调试指令

    enum numtest{
        case test1(Int,Int)
        case test2(Bool)
        case other
    }
    let test3 = numtest.other
    print("\(test3)")
}
