//
//  main.swift
//  TestingSwift_CommandLine
//
//  Created by Mathew Cai on 2020/11/5.
//  Copyright © 2020 com.ctchTeamIOS. All rights reserved.
//
//MARK: - 这里只作为测试语法用，不做笔记

import Foundation
var atemp = 10
print("Hello, World!")

let exitStr = "exit"
var isLoop = true







TestODAlgorithm.testTreeCount()

while isLoop {
    
    class Person:NSObject {
        var name:String = ""
        var age = 18
        
        init(name: String, age: Int = 18) {
            super.init()
            self.name = name
            self.age = age
        }
        
        override var description:String {
            "name:(\(name),age:\(age) )\n"
        }
    }
    
    var preOne = Person(name: "张三",age: 18)
    var personArr = [Person]()
    for i in 0 ..< 5 {
        var curOne = Person(name: "张\(i)",age: i + 1)
        if i == 2 {
            preOne = curOne
            personArr.append(preOne)
        }else{
            personArr.append(curOne)
        }
        
        
    }
    preOne.name = "张二"
    print("当前数组：\(personArr)")
    print("当前人：\(preOne)")

    
    
    
    print("请输入你的指令: ",terminator: "")
    let inputStr = readLine() ?? "nil"
    if let inputInt = Int(inputStr) {
        if let algType = AlgorithmTestType.init(rawValue: inputInt) {
            print("你输入的是：\(inputStr) ---",terminator: "")
            algType.executeFunc()
        }
    }
   
    print(" ")
    if inputStr == exitStr {
        isLoop = false
    }
}

//TestAlgorithm.mergeArrSortTest()


/**
 TestAlgorithm.maopao()
 TestAlgorithm.nixu()
 TestAlgorithm.shaixuan()
 TestAlgorithm.findFirstCharacter()
 TestAlgorithm.BinaryFind()

 let numArr:[Int] = [23, 34, 2, 4, 99, 56, 23, 1, 56, 78]
 let max = TestAlgorithm.diguiFind(numArr: numArr)
 print("递归的查找的最大值：\(max)")

 TestAlgorithm.selectionSort()
 TestAlgorithm.mergeSortTest()
 TestAlgorithm.quickSortTest()
 TestAlgorithm.mergeSortTest()
 TestAlgorithm.bucketSort()
 
 let bleVstr = "V0.1.2.3"
 let strStartIndex = bleVstr.index(after: bleVstr.startIndex)
 let vNumberStr = bleVstr[strStartIndex..<bleVstr.endIndex]
 print("截取后的str\(vNumberStr)")

 */


/**
 //请输入调用的函数名
 func InputInvokeFunctionName() -> String{
     print("请输入调用的函数名:",separator: "")
 //    var inputStr = NSString.init(data: FileHandle.standardInput.availableData, encoding: String.Encoding.utf8.rawValue) as! String
     let inputStr = readLine() ?? "nil"
     print("你输入的函数名是：(\(inputStr))")
     return inputStr
 }

 while true {
     let inStr = InputInvokeFunctionName()
     
     // 测试perform方法
 //    let person = Person.init(sex: "男_Man")
 //    let selector = Selector.init("sayYourSex")
 //    let returnValue = person.perform(selector, with: nil).takeRetainedValue()
 //    print("执行selector的返回值是：\(returnValue)")
     
     let clsStr = NSStringFromClass(Person.self)
     let workName = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
     var clsType = NSClassFromString(clsName) as! UIViewController.Type
     print("workName: \(workName)")
     print("clsStr的值是：\(clsStr)")
     
     print("while函数结束\(inStr)")
 }
 */
