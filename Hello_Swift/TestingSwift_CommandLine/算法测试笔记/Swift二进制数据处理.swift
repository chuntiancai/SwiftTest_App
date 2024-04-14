//
//  Swift二进制数据处理.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/26.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//
// MARK: 处理二进制数据，用来做标志位很有用
/**
    1、记得：正数的补码和原码是一样的，负数的补码才是不一样的。
 */

struct HandlBinaryDataStruct{
    
    
    static func testBinaryPrint(){
        
        //TODO: - 二进制的打印
        let a = 25
        let aStr = String(a,radix: 2,uppercase: true)
        print("25的二进制：",aStr)
        
        
        //TODO: - 找出整数二进制里的1的个数
        var aNum:Int = 25
        var bitArr = [Int]()
        while(true) {
            if aNum <= 0 {
                break
            }
            let leftNum = aNum % 2
            bitArr.append(leftNum)  //记录位数，最后反转即可
            aNum = aNum / 2 //向下取整，相当于左移一位
        }
        let myBitArr = Array(bitArr.reversed()) //数组反转，即可得到整数的二进制数组
        print("整数的二进制位数，正序：\(myBitArr)----逆序：\(bitArr)")
        
        
        //TODO: - 二进制数组转换为整数
        let binaryArray = [1, 1, 0, 1] // 二进制表示 13
        var decimalNumber = 0
        for bit in binaryArray {
            decimalNumber = (decimalNumber << 1) | bit  //只需要每一个位与数组中的每个元素相与即可。
        }
        print("转换后的整数：\(decimalNumber)")
        
    }
    
    
}
