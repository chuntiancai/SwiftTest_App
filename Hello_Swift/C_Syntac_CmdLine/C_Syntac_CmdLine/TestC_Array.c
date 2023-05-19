//
//  TestC_Array.c
//  C_Syntac_CmdLine
//
//  Created by mathew on 2023/5/16.
//
// 测试数组

#include "TestC_AllHeader.h"

//MARK: 遍历数组
void iteratorArray(int nums[]){
    int num2[10] = {[8] = 7, [9] = 3};
    int num3[5];
    num3[0] = 3;
    printf("遍历数组= %i ～\n",num2[8]);
    int count = sizeof(num2) / sizeof(num2[0]);
    for (int i = 0; i < count; i++) {
        printf("数组的值：%i \n",num2[i]);
    }
    printf("num3数组的元素： %i",num3[0]);
}




