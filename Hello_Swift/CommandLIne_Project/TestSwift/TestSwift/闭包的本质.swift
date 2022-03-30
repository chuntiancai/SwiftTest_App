//
//  闭包的本质.swift
//  TestSwift
//
//  Created by 蔡天春 on 2020/9/6.
//  Copyright © 2020 蔡天春. All rights reserved.
//

import Foundation

//闭包表达式是定义函数的另一种方式
//也就是函数的定义语法有两种，一种是func关键字，另一种是闭包表达式；有参数，有函数体，可以调用的，就是函数
var fn0 = {
    (v1: Int,v2:Int) -> Int in
    return v1 + v2
}

//闭包的书写格式不要求换行，但是为了美观，还是换行吧
//所以闭包的格式符号就只有() -> in 这三个而已，而且，有时候，不产生歧义的情况下，这三个闭包符号也可以省略，具体看情况
//闭包的声明更简单，只是() -> 就可以了，即和方法的签名式一样的

//闭包的声明和方法的签名是一样的，但是闭包的执行实体可以在执行的时候使用不同程度的简写，而不是声明的时候简写，声明就那么一句话
//闭包的简写都是在执行的时候
//以下是闭包体的定义：
//{
//    (参数列表) -> 返回值类型 in
//    函数体代码
//}


//闭包体内的参数可以用美元符来表示，从$0开始$1、$2....
//注意，作为函数参数的闭包，还是在其他区域定义的闭包要区分开来，简写是作为参数的时候，也即执行的时候，不容易产生歧义的时候
//尾随闭包，是闭包作为方法的参数列表中的最后一个实参的时候，即是执行的时候，不是声明的时候
//尾随闭包简写甚至可以省略掉原来方法的括号，exec{$0 + $1}
//闭包不可以不写参数而直接写值，除非没有歧义，如果你不知道有没有歧义，那就写多一点


//数组的排序规则，可以用闭包来指定


func testSort(){
    var arr = [3,2,6,1,9]
    //闭包的返回值代表了是否按照参数的顺序来排序，默认是按照参数的顺序排序的就返回true，按照相反顺序排序的就返回false
    //所以比较函数与参数的大小无关，与参数的顺序有关，是由顺序赋于了大小的意义；相等的话，按照false来操作
    arr.sort(by: {$0 > $1}) //譬如说$0 > $1的话，就按照这个顺序排序，如果不大的话，就按照相反顺序排列
    
}

//以上讨论的是闭包的表达式
//以下讨论的才是闭包
//闭包的定义是：一个函数和它所捕获的变量\常量环境组合起来，称为闭包；
//1、一般是指定义在函数内部的函数；
//2、一般闭包捕获的是外层函数定义的局部变量\常量
//所以闭包可以把它从外层函数捕获的值传递出去，实现闭包传值，栈空间传值出去
//函数都在代码段，属于汇编指令的存储区域。
typealias Fn = (Int) -> Int

func getFn() -> Fn {
    
    var num = 0
    
    func plus(i: Int) -> Int{
        return i + num
    }
    return plus
}//返回的plus和num形成了闭包
var fn1 = getFn()   //每调用一次getFn()都会分配一份堆空间
//print(fn1(1))   ---1
//print(fn1(2))   ---3
//闭包会把num变量申请到堆空间，引用计数完毕后才会释放，所以闭包涉及到外层函数的变量时，会为外层的变量申请堆空间；
//查看alloc函数分配了多少堆空间字节给我，swiftAllocObject，通过汇编和si命令查看参数寄存器esi

//可以把闭包想象成类的实例对象，捕获的变量就看着实例的成员，因为都是在堆空间分配内存；组成的闭包就是实例里面定义的的函数
//fn的前8个字节放的是plus函数的地址，后8个字节放的是闭包的堆空间地址（存放类信息，引用计数，num变量，共24个字节）



//闭包的本质2
func sum(_ v1: Int,_ v2: Int) -> Int{ v1 + v2}
var fnSum = sum
//fnSum前8个字节放的是sum函数的地址值，后8个字节填零补充
//print(MemoryLayout.stride(ofValue: fnSum))  //窥探fnSum的内存分配
//函数的返回值一般放在rax寄存器，如果返回值超过8个字节的话，会继续使用rdx
//间接调用，函数中的闭包属于间接调用，所以call指令后的参数不是直接的物理地址，而是通过寄存器间接调用
//闭包的捕获发生在最后的时刻，即return的时候

typealias Fns = (Int) -> (Int,Int)
func getFns() -> (Fns,Fns){
    var num1 = 0        //放在堆空间，堆空间可以是一个区域，而不是仅仅一个变量的空间，可以是一个空间包含多个变量，然后再额外存一些说明信息就可以了
    var num2 = 0        //放在堆空间
    func plus(_ i: Int) -> (Int,Int){   //校验plus和minus捕获的num1和num2堆空间是不是同一个，还是分开的
        num1 += i
        num2 += i << 1
        return (num1,num2)
    }
    func minus( i: Int) -> (Int,Int){
        num1 -= i
        num2 -= i << 1
        return (num1,num2)
    }
    return (plus,minus)
}

let (p,m) = getFns()
let a6 = p(6)   //结果验证plus和minus是共用同一份堆空间的num1，num2，只会分配一份堆空间；参考类的成员与函数，是一样的
let a5 = m(5)
let a3 = p(4)
let a2 = m(3)
let a1 = p(2)

//对比对象在堆空间的储存信息，8个类型信息，8个引用计数，后面就是成员变量了；而num1，和num1都是相当于一个对象的格式存储在堆空间了
//所以这两个变量都是有类型信息和引用计数的

var functions: [() -> Int] = []

func testFunctions(){
    for i in 1...3 {
        functions.append({i})   //因为闭包是分配在堆堆空间，所以i在闭包中是另外分配的一个堆空间的变量，从for语句的i的值类型中拷贝过来
    //    functions.append{i} //简写的尾随闭包
        func funM() -> Int{ //闭包的详写
            return i
        }
    }
    
    for f in functions{
        print(f())
    }
}

//如果函数的返回值也是函数的话，那么返回值函数的参数类型，与函数体里面的要被返回的函数的参数要完全一致

//自动闭包
func getFisrtPositive(_ v1: Int, _ v2: Int) -> Int{
    return v1 > 0 ? v1 : v2 //此时还是会去执行v2
}
//改造getFisrtPositive参数为闭包
func getFisrtPositive2(_ v1: Int, _ v2: () -> Int) -> Int{
    return v1 > 0 ? v1 : v2()       //此时如果返回v1，则不会再执行v2了，可以省略执行一些代码的
}
func getNum() -> Int{
  return 23
}
//因为尾随闭包可能导致可读性很差。例如下面这样，所以又有了自动闭包
let gf1 = getFisrtPositive2(10) {20}
let gf2 = getFisrtPositive2(10, {20})  //闭包的写法太过于简洁，阅读性变差
let gf22 = getFisrtPositive2(12,getNum)    //这个getNum是一定执行的，这里传入的只是函数名
//于是，自动闭包出现了,声明为自动闭包，编译器自动为你生成闭包表达式，就是编译器会把太过于简洁的闭包自动生成，语法糖
//声明参数为自动闭包，太过于简洁到一个值的闭包，编译器自动闭包起来通过编译，通过关键@autoclosure说明编译器会自动闭包
//自动闭包是要写成调用的形式的，即要加上()作为函数调用
func getFirstPositive3(_ v1: Int, _ v2: @autoclosure () -> Int) -> Int{
    return v1 > 0 ? v1 : v2()
}
let gf3 = getFirstPositive3(10,30)  //于是参数30会被编译器自动封装成闭包表达式{30}()
let gf33 = getFirstPositive3(10,{() -> Int in return 30}())
let gf333 = getFirstPositive3(10,{30}())
//@autoclosure只支持无参的、有返回值的闭包表达式 () -> T
//有无@autoclosure关键字的函数，构成了重载函数
//声明了@autoclosure的参数，不可以传入完整的闭包表达式
//@autoclosure的自动闭包是延迟执行的
func getTestAuto (){
    var num1: Int? = nil
    var num2: Int? = nil
    let num3 = num1 ?? num2
    //public func ?? <T>(optional: T?, defaultValue: @autoclosure () throws -> T?) rethrows -> T?     //??本质是一个函数
}




