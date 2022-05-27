//
//  Generic_Person.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/5/26.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试泛型和关联类型(不是关联值)的Person

/**
    1、泛型用在类的定义上,用于限制类里面的 属性，方法的参数、返回值，作为参考。
    2、方法中参数的泛型，必须在方法名后面来限制，不能单独在参数的声明中限制，这是格式。
 */
//MARK: 泛型在class
class Generic_Stack<E>:NSObject {
    var elements = [E]()
    func push(_ element: E) { elements.append(element) }
    func pop() -> E { elements.removeLast() }
    func top() -> E { elements.last! }
    func size() -> Int { elements.count }
    
    ///泛型在 方法定义中 限制参数的类型。
    ///注意，本类的泛型是E，该方法的泛型是T。
    func swapValues<T>(_ a: inout T, _ b: inout T) {
        (a, b) = (b, a)
    }
    
    /// 方法的类型的泛型 (T1, T2) -> ()
    /// 这里泛型是T1，T2
    func test<T1, T2>(_ t1: T1, _ t2: T2) {}
    
    
    /// 泛型的使用
    func testStack(){
        let stack = Generic_Stack<Int>()
        stack.push(11)
        stack.push(22)
        stack.push(33)
        print(stack.top()) // 33
        print(stack.pop()) // 33
        print(stack.pop()) // 22
        print(stack.pop()) // 11
        print(stack.size()) // 0
        
        var i1 = "haha"
        var i2 = "lala"
        swapValues(&i1, &i2)
        
        /// 方法的类型的泛型
        let fn: (Int, Double) -> () = test
        fn(1, 2.0)  //执行方法
    }
}

//MARK:泛型可以继承
class SubStack<E> : Generic_Stack<E>{
    var subName:String = ""
}

//MARK: 泛型在struct
struct Generic_StructStack<E> {
    var elements = [E]()
    mutating func push(_ element: E) { elements.append(element) }
    mutating func pop() -> E { elements.removeLast() }
    func top() -> E { elements.last! }
    func size() -> Int { elements.count }
    
    
}


//MARK: 泛型在enum
enum Generic_Score<T> {
    case point(T)
    case grade(String)
}

func testGeneric_Enum(){
    let score0 = Generic_Score<Int>.point(100)
    let score1 = Generic_Score.point(99)
    let score2 = Generic_Score.point(99.5)
    let score3 = Generic_Score<Int>.grade("A")
    
    func printEnum<T>(_ score:Generic_Score<T>){
        print("\n枚举的值：\(score)")
        switch score {
        case .point(let num):
            print("枚举的关联类型：\(num)")
        case .grade(let str):
            print("枚举的String关联类型：\(str)")
        }
    }
    printEnum(score0)
    printEnum(score1)
    printEnum(score2)
    printEnum(score3)
}

//MARK: 协议中的关联类型
/**
 二、协议中的关联类型：associatedtype，typealias，关联类型（Associated Type）
     1 、⭐️泛型可以做关联类型的实际类型，但是关联类型不能作为泛型的实际类型，避免循环引用导致最终不明确返回的类型是啥。
         所以协议作为返回值时，要注意返回值的协议不能有关联类型，因为不明确关联的类型是啥。
  
     2、> 关联类型的作用：给协议中用到的类型定义一个占位名称
        > 协议中可以拥有多个关联类型
        > 供协议使用，作用与泛型相似，主要是针对协议，更加灵活。
         就是在变量中定义泛型，起到占位参考的作用，使用者调用时才去关联实际的类型。
     
     3、 迷惑点还是在于，上下文可推断时，可省略显示写声明。
 */
 /// 协议中声明关联类型
protocol Associated_Stackable {
    associatedtype Element // 声明关联类型
    mutating func push(_ element: Element)
    mutating func pop() -> Element
    func top() -> Element
    func size() -> Int
}

//MARK: 遵循有关联类型的协议
class StringStack : Associated_Stackable {
    // 给关联类型设定真实类型
    // typealias Element = String   //遵循协议的方法中有写具体类型，可以明确推断出Element的实际类型，故可以省略这句显示定义
    var elements = [String]()
    func push(_ element: String) { elements.append(element) }
    func pop() -> String { elements.removeLast() }
    func top() -> String { elements.last! }
    func size() -> Int { elements.count }
    
    class func testAssociated_Stackable(){
        let ss = StringStack()
        ss.push("Jack")
        ss.push("Rose")
    }
}


//泛型绑定关联类型，泛型也可以作为关联类型的实际类型，最终的实际类型就既是泛型的实际类型，也是关联类型的实际类型
class Stack<E> : Associated_Stackable {
    // typealias Element = E
    var elements = [E]()
    func push(_ element: E) {
        elements.append(element)
    }
    func pop() -> E { elements.removeLast() }
    func top() -> E { elements.last! }   //遵循协议的方法中有写具体类型，可以明确推断出Element的实际类型，故可以省略这句显示定义
    func size() -> Int { elements.count }
    
}



// MARK: - 笔记
/**
 1、泛型的主要迷惑点在于上下文推断得出泛型的具体类型就不需要明确写出。
    在上下文可以明确泛型的具体类型时，单书名号<T>可以不写，喜欢也可以写。

 2、泛型的名字可以任意起，一般直接是大写的E或者T
    
二、协议中的关联类型：associatedtype，typealias，关联类型（Associated Type）
    1 、⭐️泛型可以做关联类型的实际类型，但是关联类型不能作为泛型的实际类型，避免循环引用导致最终不明确返回的类型是啥。
        所以协议作为返回值时，要注意返回值的协议不能有关联类型，因为不明确关联的类型是啥。
 
    2、> 关联类型的作用：给协议中用到的类型定义一个占位名称
       > 协议中可以拥有多个关联类型
       > 供协议使用，作用与泛型相似，主要是针对协议，更加灵活。
        就是在变量中定义泛型，起到占位参考的作用，使用者调用时才去关联实际的类型。
    
    3、 迷惑点还是在于，上下文可推断时，可省略显示写声明。
   

## 类型约束
### 用协议去约束 方法中参数的具体类型 的范围
### 协议结合泛型、结合关联类型 去约束 方法中的参数的具体类型
    protocol Runnable { }
    class Person { }
    func swapValues<T : Person & Runnable>(_ a: inout T, _ b: inout T) {
        (a, b) = (b, a)
    }
    protocol Stackable {
        associatedtype Element: Equatable
    }
    class Stack<E : Equatable> : Stackable { typealias Element = E }
    func equal<S1: Stackable, S2: Stackable>(_ s1: S1, _ s2: S2) -> Bool
        where S1.Element == S2.Element, S1.Element : Hashable {
            return false
    }
    var stack1 = Stack<Int>()
    var stack2 = Stack<String>()
    // error: requires the types 'Int' and 'String' be equivalent
    equal(stack1, stack2)
 */
