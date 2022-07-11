//
//  Point_MetaData.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/7/5.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 模仿swift源码，堆内存里的 描述 对象的元数据 的结构体

struct Point_MetaData {
      var kind: Int
      var superClass: Any.Type
      var cacheData: (Int, Int)
      var data: Int
      var classFlags: Int32
      var instanceAddressPoint: UInt32
      var instanceSize: UInt32
      var instanceAlignmentMask: UInt16
      var reserved: UInt16
      var classSize: UInt32
      var classAddressPoint: UInt32
      var typeDescriptor: UnsafeMutableRawPointer
      var iVarDestroyer: UnsafeRawPointer
 }
