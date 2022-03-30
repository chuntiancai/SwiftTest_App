//
//  17、字面量协议、模式匹配、条件编译.swift
//  TestSwift
//
//  Created by 蔡天春 on 2020/10/6.
//  Copyright © 2020 蔡天春. All rights reserved.
//

import Foundation

class Person{}


var person = Person()
var ptr = withUnsafePointer(to: &person ){ UnsafeRawPointer( $0) }
//var ptr0 = UnsafeRawPointer(bitPattern: )


//MARK: - 字面量（Literal）
//1、常见字面量的默认类型：
//  public typealias IntegerLiteralType = Int
//  public typealias FloatLiteralType = Double
//  public typealias BooleanLiteralType = Bool
//  public typealias StringLiteralType = String

//2、可以通过typealias修改字面量的默认类型
//3、swift自带的绝大部分类型，都支持直接通过字面量进行初始化
//   Bool、Int、Double、String、Array、Dictionary、Set、Optional
//4、字面量协议，swift自带类型子所以能通过字面量初始化，是因为它们遵守了对应的协议，例如：
//   ExpressibleByBooleanLiteral协议、ExpressibleByIntegerLiteral协议、ExpressibleByFloatLiteral协议。。。
//   一个类型可以遵循多个字面量协议，Float: ExpressibleByIntegerLiteral,ExpressibleByFloatLiteral



//MARK: - 字面量协议应用
//1、遵守字面量协议，可以通过字面量来实例化类；也有数组字面量协议，字典字面量协议
//2、类如果要实现协议中的构造器，那么构造器必须是必要构造器
//3、自定义类可以通过实现字面量协议，利用字面量实例化自定义类

class Person{}


extension Int : ExpressibleByBooleanLiteral {
//    public typealias BooleanLiteralType = Bool  //关联类型，下面的value会绑定，看api
    public init(booleanLiteral value: Bool) {   //传入是true就会调用该构造器
        self = value ?  1 : 0
    }
}

var num = true
print(num)


//自定义类可以通过实现字面量协议，利用字面量实例化自定义类，类似c++的转换构造函数
class Student: ExpressibleByIntegerLiteral,ExpressibleByFloatLiteral,ExpressibleByStringLiteral,CustomStringConvertible {
    var name = ""
    var score = 0.0
    required init(floatLiteral value: Double) { //浮点数据的字面量协议
        self.score = value
    }
    
    required init(stringLiteral value: String) {    //ExpressibleByStringLiteral协议，还有两个特殊的字符串构造器
        self.name = value
    }
    
    required init(integerLiteral value: Int) {      //ExpressibleByIntegerLiteral协议
        self.score = Double(value)
    }
    
   
    
    var description: String { "name = \(self.name) , score = \(self.score)"}
    
}

var stu: Student = 87
stu = "jack"



struct Point {
    var x=0.0,y=0.0
}

//数组字面量协议，字典字面量协议的应用
extension Point: ExpressibleByArrayLiteral,ExpressibleByDictionaryLiteral {

//    typealias Key = String
//
//    typealias Value = Double
//
//    typealias ArrayLiteralElement = Double
//
    init(arrayLiteral elements: Double...) {
        guard elements.count > 0 else {
            return
        }
        self.x = elements[0]
        guard elements.count > 1 else {
            return
        }
        self.y = elements[1]
    }
    
    init(dictionaryLiteral elements: (String, Double)...) {
        for (k,v) in elements {
            if k == "x" { self.x = v}
            else if k == "y" { self.y = v}
        }
    }
    
}


//MARK: - 模式匹配
//1、模式是用于匹配的规则，比如switch的case、捕捉错误的catch、if\guard\while\for与的条件等
//2、swift中的模式有：
//  通配符模式（Wildcard Pattern）
//  标识符模式（Identifier Pattern）
//  值绑定模式（Value-Binding Pattern）
//  元组模式（Tuple Pattern）
//  枚举Case模式（Enumeration Case Pattern）
//  可选模式（Optional Pattern）
//  类型转换模式（Type-Casting Pattern）
//  表达式模式（Expression Pattern）

//通配符模式
//1、 "_" 匹配任何值
//    "_?" 匹配非nil值,加个问号就是要求非空，例如v?

enum Life{
    case human(name: String, age: Int?)
    case animal(name: String, age: Int?)
    
}
func check(_ life: Life) {
    switch life {
    case.human(let name, _):
        print("human", name)
    case.animal(let name, _?):
        print("animal", name)
    default:
        print("other")}
}
check(.human(name: "Rose", age: 20))    // human Rose
check(.human(name: "Jack", age: nil))   // human Jack
check(.animal(name: "Dog", age: 5))     // animal Dog
check(.animal(name: "Cat", age: nil))   //other


//MARK: - if case 语句；枚举模式(Enumeration Case Pattern）
//1、if case语句等价于只有1个case的switch语句枚举Case模式，这里的等号是匹配的意思

let age = 2// 原来的写法

if age >= 0 && age <= 9 {print("[0, 9]")}//枚举Case模式

if case 0...9 = age {print("[0, 9]")}   //这里的等号是匹配的意思

func caseTest(){
    guard case 0...9 = age else { return }
}

print("[0, 9]")

switch age {
    case 0...9:
        print("[0, 9]")
    default:
        break
    
}
let ages: [Int?] = [2, 3, nil, 5]

for case nil in ages{  //从ages里面拿出所有值跟case 后的nil进行匹配
    print("有nil值")
    break
    
} // 有nil值
let points = [(1, 0), (2, 1), (3, 0)]
for case let (x, 0) in points{print(x)}


//MARK: - 可选模式
let age1: Int? = 23
if case .some(let x) = age1 {
    print(x)
}

if case let x? = age1 { print(x)}


//MARK: - is 关键字，类型转换模式
//1、按照实际类型进行匹配，但不会进行强转
//2、as也不会将原来的强转，只是将强转的结果放到新的值
let num1: Any = 6

switch num1 {
case is Int:
    print("is Int",num1)
default:
    break
}

//MARK: - 表达式模式（case语句）
//1、swift复杂一点的匹配是通过调用 "~=" 运算符来匹配的
//2、可以重载"~="运算符修改匹配的规则，这就是自定义表达模式来匹配表达式。
//3、重载类型的匹配运算符函数，可以在switch case语句中根据相关的方法将switch去匹配case

struct Student1 {
    var score = 0,name = ""
    static func ~= (pattern: Int, value: Student1) -> Bool {    //value是switch后的东西，pattern是case后面的东西
        value.score >= pattern
    }
    static func ~= (pattern: ClosedRange<Int>, value: Student1) -> Bool {
        pattern.contains(value.score)
        
    }
    static func ~= (pattern: Range<Int>, value: Student1) -> Bool {
        pattern.contains(value.score) }
}

var stu1 = Student1(score: 75, name: "Jack")
switch stu1 {
case 100: print(">= 100")
case 90: print(">= 90")
case 80..<90: print("[80, 90)")
case 60...79: print("[60, 79]")
case 0: print(">= 0")
default: break
}



extension String {
    static func ~= (pattern: (String) -> Bool, value: String) -> Bool {
        pattern(value)
    }
    
}
func hasPrefix(_ prefix: String) -> ((String) -> Bool)  {
    {
        $0.hasPrefix(prefix)
    }
}
func hasSuffix(_ suffix: String) -> ((String) -> Bool)  {
    {
        $0.hasSuffix(suffix)
    }
}
var str = "jack"
switch str  {
    case hasPrefix("j"), hasSuffix("k"):    //case后面是一个函数调用，并且返回bool值
         print("以j开头，以k结尾")
    default:
            break
}

//case后面传入一个函数类型，即函数名去匹配case
func isEven(_ i: Int) -> Bool { i % 2 == 0}
func isOdd(_ i: Int) -> Bool { i % 2 != 0}


extension Int {
    static func ~= (pattern: (Int)->Bool,value: Int) -> Bool{   //Int类型与函数类型匹配
        pattern(value)
    }
}

var age12 = 8

switch age12 {
case isEven:        //将isEven函数变量传入给case的 "~=" 运算符重载方法
    print("是偶数")
case isOdd:
    print("是奇数")
default:
    print("非奇数非偶数")
}


//MARK: - where关键字
//1、一般写在表达式的最后

//MARK: - MARK,TODO,FIXME  标记


//MARK: - 条件编译“#”符号
//1、编译器的去编译时的预设条件，前提条件
//2、可以在项目的target的building中，在swift complier列表下配置编译器，编译的标记，可以自定义标记，在代码中设置条件编译 -D Other
//3、swift中没有宏定义这个概念，可以直接定义全局函数，可以设置条件去进行编译

// 操作系统：macOS\iOS\   tvOS\watchOS\Linux\Android\Windows\FreeBSD
#if os(macOS) || os(iOS)
// CPU架构：i386\x86_64\arm\arm64
#elseif arch(x86_64) || arch(arm64)
// swift版本
#elseif swift(<5) && swift(>=3)
// 模拟器
#elseif targetEnvironment(simulator)
// 可以导入某模块
#elseif canImport(Foundation)
#else

#endif


func log(_ msg: String){
    #if DEBUG       //在DEGUG模式下，执行print
    print(msg)
    #else           //否则，什么都不做
    #endif
}

//MARK: - #file,#line,#function 是获取当前行的信息,捕捉当前环境
//1、#file是当前所在的文件（源文件）
//   #line是在当前文件的所在行数
//   #function 是当前语句所在的方法

func test2(){
    print(#file,#line,#function)
}


//MARK: - #available 系统检测
//1、#available 标记是运行时判断，不是条件编译
if #available(iOS 10, macOS 10.12, *) {
    // 对于iOS平台，只在iOS10及以上版本执行
    // 对于macOS平台，只在macOS 10.12及以上版本执行
    // 最后的*表示在其他所有平台都执行
}

//MARK: - api可用性说明@available，deprecated
@available(iOS 10, macOS 10.15, *)
class Person2{ }

struct Student2{
    @available(*, unavailable, renamed: "study")    //将study_改名为study
    func study_() {}
    func study() {}
    
    @available(iOS, deprecated: 11)
    @available(macOS, deprecated: 10.12)
    func run() { }
}


