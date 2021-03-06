//
//  LLDBcommandTest.swift
//  TestSwift
//
//  Created by 蔡天春 on 2020/9/6.
//  Copyright © 2020 蔡天春. All rights reserved.
//

import Foundation

//lldb,常用的命令行调试指令
//register read rax 读取寄存器的值
//register write rax 23
//x/数量-格式-字节大小 内存地址                --读取内存中的值
//x/3xw 0x00000000fe150e
//x/4xg      --b,h,w,g对应1,2,4,8个字节；x代表十六进制

//expr 表达式
//expr $rax

//po 表达式
//po/x $rax

//p 指令，print打印的意思


//调试指令
//thread step-over、next、n
//单步运行，把子函数当作整体一执行（源码级别）
//前面的thread可以省略，即直接step-over或者next或者n就可以了
//step-over会跳过整个函数的一行，step-in是会进入到函数中的一行

//thread step-in、step、s
//单步运行，会进入到子函数（源码级别）

//thread step-inst-over、nexti、ni
//单步运行（汇编级别），跳过函数调用call指令


//thead step-inist、stepi、si
//单步运行（汇编级别），不会跳过call指令，而是进入

//thread step-out、finsh
//执行完汇编指令到断点，或者执行完针整个函数的指令，返回到上一个函数

//bt打印函数调用栈（函数被调用的栈）

//rip寄存器存储的是cpu要执行的下一条指令的地址，rip = 正在执行的指令地址 + 地址长度

//rax常作为函数返回值使用
//rdi、rsi、rdx、rcx、r8、r9等寄存器常用于存放函数的参数
//rsp、rbp用于栈操作，函数的指令放在rsp与rbp之间的栈空间，rsp之外用于放参数
//rip作为指令指针的寄存器

//所以，一般内存地址格式为：0x10(%rax) 这种形式的，几乎都是堆空间

