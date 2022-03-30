//
//  main.swift
//  Swift_Syntax_CommandLine
//
//  Created by Mathew Cai on 2020/11/5.
//  Copyright © 2020 com.fendaTeamIOS. All rights reserved.
//
//MARK: - 这里作为笔记使用

import Foundation

print("Hello, World!")

//请输入调用的函数名
func InputInvokeFunctionName() -> String{
    print("\n请输入调用的函数名:")
//    var inputStr = NSString.init(data: FileHandle.standardInput.availableData, encoding: String.Encoding.utf8.rawValue) as! String
    let inputStr = readLine() ?? "nil"
    print("你输入的函数名是：(\(inputStr)) \n")
    return inputStr
}

while true {
    let inStr = InputInvokeFunctionName()
    switch inStr {
    case "test":
        print("test方法")
    default:
        print("没有匹配的方法：\(inStr)")
        break
    }
}
