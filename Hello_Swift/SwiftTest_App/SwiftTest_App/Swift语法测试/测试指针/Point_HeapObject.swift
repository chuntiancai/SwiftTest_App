//
//  Point_HeapObject.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/7/5.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 模仿swift源码的 堆内存 里的 对象的 描述结构体

struct Point_HeapObject {
    var metadata: UnsafeRawPointer // 定义一个未知类型的指针
    var refCounts: UInt32 // 引用计数
}
