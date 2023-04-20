//
//  testArm.h
//  SwiftTest_App
//
//  Created by mathew on 2023/1/4.
//  Copyright © 2023 com.mathew. All rights reserved.
//
//MARK: - 笔记
/**
    1、和C语言文件一样，用.h头文件来声明变量方法，用.s文件来编写汇编代码来实现变量方法。
    2、intel汇编、AT&T汇编（Mac、iOS模拟器）、ARM汇编（嵌入式、iOS设备)
        Intel是 mov dst, src。    //从右到左。x86是intel架构的。
        ATT是 movl src, dst。  //从左到右。
    3、寄存器是在CPU内部的。
 */
//MARK: - 汇编语法
/**
 
 */

#ifndef testArm_h
#define testArm_h

void testArmFunc(void);
int testArmAdd(int a, int b);

#endif /* testArm_h */
