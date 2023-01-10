//
//  OCObject_Student.h
//  SwiftTest_App
//
//  Created by mathew on 2023/1/10.
//  Copyright © 2023 com.mathew. All rights reserved.
//
// OC对象继承关系时，C语言层面的源码结构，和内存分配
//MARK: - 笔记
/**
    1、底层的C语言结构：
        struct OCObject_Student_IMPL {
            struct  OCObject_Person_IMPL OCObject_Person_IVARS; //结构体占用内存分配的大小；假设分配16字节，自身只使用了8字节。
            int _score;    //4字节
        };
      C语言结构体内存分配原则：结构体自身的大小必须是自身最大成员大小的倍数。如果成员变量里有多余的空间，则往多余的空间挤，也就是上面的空间大小是16 * 1 = 16个字节的大小。
 */

#import "OCObject_Person.h"


@interface OCObject_Student : OCObject_Person
{
    int _score;
}
@end


@implementation OCObject_Student

@end
