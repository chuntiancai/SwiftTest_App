//
//  语法_Note.h
//  C_Syntac_CmdLine
//
//  Created by mathew on 2023/5/18.
//

//MARK: 全局变量与局部变量
/**
    1、局部变量：
        定义在函数内部的变量以及函数的形参称为局部变量。
        作用域：从定义哪一行开始直到与其所在的代码块结束。
        生命周期:从程序运行到定义哪一行开始分配存储空间到程序离开该变量所在的作用域。
        存储位置：静态存储区，在方法栈中。
 
    2、全局变量：
        定义在函数外边的变量称为全局变量。
        作用域范围：从定义哪行开始直到文件结尾。
                  内部全局变量:只能在本文件中访问的变量。
                  外部全局变量:可以在其他文件中访问的变量,多个同名外部全局变量指向同一个内存单元，默认所有全局变量都是外部变量。
        生命周期:程序一启动就会分配存储空间,直到程序结束。
        存储位置：静态存储区，在二进制文件中。
 
    3、static 与 extern关键字。
        static对局部变量的作用
            延长局部变量的生命周期,从程序启动到程序退出,但是它并没有改变变量的作用域。
            定义变量的代码在整个程序运行期间仅仅会执行一次。
        static对全局变量的作用：
            把静态全局变量的作用域局限于一个源文件内,只能为该源文件内的函数公用,因此可以避免在其它源文件中引起错误。
 
        extern用在函数内部
            不是定义局部变量,它用在函数内部是声明一个全局变量。在编译时，把函数内部的局部变量变成全局变量。
 
        extern对全局变量的作用
            如果声明的时候没有写extern那系统会自动定义这个变量,并将其初始化为0。
            如果声明的时候写extern了，那系统不会自动定义这个变量。声明的意思是值保留了该变量的信息，但是没有分配内存。
 
    4、static 与 extern对函数的作用：
        内部函数:只能在本文件中访问的函数。static 作用，可以在定义函数内容前，用static来声明一个函数，就可以提前使用。
        外部函数:可以在本文件中以及其他的文件中访问的函数。extern作用(默认)。
        默认情况下所有的函数都是外部函数。

 */


