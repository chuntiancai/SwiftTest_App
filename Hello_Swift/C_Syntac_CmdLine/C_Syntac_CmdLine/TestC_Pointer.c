//
//  TestC_Pointer.c
//  C_Syntac_CmdLine
//
//  Created by mathew on 2023/5/17.
//
// 测试指针

#include <stdio.h>

//MARK: - 输出指针内容
void printPointer(void){
    
    int num; // 普通变量
    num = 10;
    
    int *p; // 指针 , 在64位编译器下占用8个字节
    // 千万注意: 指针变量只能存储地址
    p = &num; // 将num的地址存储到p这个指针中
    
    // p == &num
    printf("num = %p\n", &num);
    printf("p = %p\n", p);
    
    // 指针变量前的*号代表访问指针变量指向的那一块存储空间
    // *p == num
    *p = 55;
    printf("num = %i\n", *p);
}
