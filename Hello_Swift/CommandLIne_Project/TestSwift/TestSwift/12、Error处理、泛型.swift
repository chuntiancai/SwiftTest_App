//
//  12、Error处理、泛型.swift
//  TestSwift
//
//  Created by 蔡天春 on 2020/9/20.
//  Copyright © 2020 蔡天春. All rights reserved.
//

import Foundation

//关联类型
protocol Stackable {
    associatedtype Element  //关联类型，其实就是限定后面函数声明时要用到的泛型
    mutating func push(_ elem: Element)
}

//类型约束
protocol Runnable {}
class Person2{}
func swappp<T: Person2 & Runnable>(_ a: inout T, _ b: inout T ){
    (a,b) = (b,a)
}
protocol Stackkk{
    associatedtype Element2: Equatable
}


func testError() throws {
    class Person{
        static var age = 0
        static func run(){}
    }
    //所以Person.self与Person具有相同的性质，都是类信息
    Person.self.run()
    print(Person.self.age)

    //这四句没有区别，在汇编层面是一样的
    let p1 = Person()
    let p10 = Person.self()
    let p11 = Person.init()
    let p12 = Person.self.init()


    class Student: Person {
        
    }

    //异常 == 错误
    //MARK: - 错误类型（error）：
    //1、语法错误（编译报错）
    //2、逻辑错误
    //3、运行时错误（可能会导致删图，一般也就异常）


    //MARK: - 自定义错误
    //1、Swift可以通过“Error协议”自定义运行时的错误信息（Fatal Error运行时错误，致命错误）
    //2、throw关键字，throw抛出的对象必须遵循Error协议；throws用在声明的名字上，throw用在方法体内
    //3、调用抛出错误的方法时，需要用try-catch来捕获错误
    //4、枚举，结构体，类都可以遵循“Error协议”
    //5、单独的try只是告诉编译器有可能抛出错误，但是未做处理，只是一层一层地往调用者抛出；所以要用do-catch来捕获
    //6、抛出异常之后，try代码行到try所在的作用域最末的代码都不会执行
    //7、如果方法体内有try语句，在方法体的名字声明上写上throws关键字，可以将异常抛给调用者处理，一层一层地往上抛
    //8、如果最顶层地函数（main函数）依然没有捕捉异常error，那么程序将终止
    //9、通过try?、try!去调用可能抛出异常的函数，可以不用去处理Error
    //   try? 表示出错返回nil，try！表示强制解包，最终抛飞main函数
    //10、rethrows声明：
    //   表示函数本身不会抛出错误，但是方法的 闭包参数 可能会抛出错误，那么它会将错误往上抛
    //11、defer语句：
    //   11.1:用来定义以任何方式（抛错误、return等）离开代码块钱必须要执行的代码
    //   11.2、defer语句将延迟至当前作用域结束之前执行

    class MyError: Error {
        
    }
    enum SomeEorror: Error {
        case illegalArg(String)
        case outOfBounds(Int,Int)
        case outOfMemory
    }

    //要在方法声明的名字的返回值类型前加入throws关键字，表明可能抛出错误
    func divide(_ num1: Int, _ num2: Int) throws -> Int{
        if num2 == 0 {
    //        throw MyError()
            throw SomeEorror.illegalArg("0不能作为除数")
        }
        return num1 / num2
    }

    //divide(1, 0)

    //var result = try divide(10, 0)
    //print(result)

    do {
        print("1")
        print(try divide(21, 0))    //在do代码体内，调用可能抛出异常的方法
        print("3")
    }catch let SomeEorror.illegalArg(msg){  //let的意思是msg为let
        print("参数异常",msg)
    }catch let SomeEorror.outOfBounds(size, index){
        print("下标越界","size:\(size),index:\(index)")
    }catch SomeEorror.outOfMemory{
        print("内存溢出")
    }catch let error {
        print("其他错误\(error)")
    }
    do {
        print("1")
        print(try divide(21, 0))    //在do代码体内，调用可能抛出异常的方法
        print("3")
    }catch let error as SomeEorror{  //let的意思是msg为let
        print("异常\(error)")
    }

    do {
        print("1")
        print(try divide(21, 0))    //在do代码体内，调用可能抛出异常的方法
        print("3")
    }catch is SomeEorror{  //is表达的是，只要是SomeError就捕捉
        print("异常SomeError")
    }

    //retrows声明：更加精确的表达是 方法的参数闭包 抛出的异常，其实用throws也可以
    func exec(_ fn: (Int,Int) throws -> Int, _ num1: Int, _ num2: Int) rethrows {
        print(try fn(num1,num2))
    }


    //defer语句：
    func open(_ filename: String) -> Int{
        print("打开文件")
        return 0
    }

    func close(_ file: Int){
        print("close文件")
    }

    func opFile(_ fileName: String) throws{
        let file = open(fileName)
        try divide(1, 0)
        close(file) //如果无论如何都要执行colse的话，则用defer语句可以延迟colse函数到当前作用域结束前执行
        defer { //无论如何，当前作用域结束前都会执行
                //如果有两个defer，那么先写的defer执行时机最后，即是倒序
            close(file)
        }
        

    }

    //MARK: - 泛型（Generic）
    //1、泛型可以将类型类型参数化，提高代码复用率，减少代码量
    //2、泛型用<T>函数名后面，用来约束参数的类型要与调用该方法的类型T一致，所以泛型的T是通过参数的类型来自动传递的
    //  T可以用任意字符代串代替，但是习惯写T，Type的意思
    //3、泛型的类的类型:
    //   在实例化时，需要将泛型的类型也写出来，即调用构造函数的时候，也要将泛型用<T>写出来，在类名字后面；
    //   如果构造函数有参数，就可以不用写<T>了，因为构造函数的参数的类型自动传递给泛型了
    //4、泛型的继承：
    //   class subStack<T>: Stack<T> {}
    //5、枚举，结构体的方法前面要加mutating关键字，因为类型不同，会修改内存的结构;
    //6、如果没有参数的类型传递给泛型，那么你必须在类或者结构体或者枚举的名字后面用<T>说明，不能模棱两可
    //7、其实函数的泛型就是编译器自动帮你函数重载，但是swift的话，调用的是同一个函数地址，swift自动改造该函数的内存结构，或者指针调用（传递元类型）




    var n1 = 43
    var n2 = 21
    var d1 = 1.23
    var d2 = 3.65
    func swapValue<T>(_ a: inout T, _ b: inout T){
        (a,b) = (b,a)
    }
    swapValue(&n1, &n2)
    swapValue(&d1, &d2)

    var fn: (inout Int,inout Int) -> () = swapValue //所以泛型是可以通过参数的类型自动传递的



    //泛型的类的类型
    class Stack<E> {
        var elements = [E]()
        
    }

    var stack = Stack<Int>()

    class subStack<T>: Stack<T> {
        
    }

    enum Score<T> {
        case point(T)
        case grade(String)
    }

    let sc1 = Score<Int>.grade("A")



    //MARK: - 关联类型(Associated Type),协议里面的泛型，因为协议不可以直接用泛型
    //1、关联类型的作用： 给协议中用到的类型定义一个占位名称
    //2、协议中可以拥有多个关联类型
    //关联类型
//    protocol Stackable {
//        associatedtype Element  //关联类型，其实就是限定后面函数声明时要用到的泛型
//        mutating func push(_ elem: Element)
//    }

    class StringStack: Stackable {
        func push(_ elem: String) {
            print(elem)
        }
        
        typealias Element = String  //明确给关联类型赋值，其实也可以省略，通过定义方法时，参数的类型自动传递
        
    }

    //MARK: - 类型约束，用&运算符，在返回值类型后加上 where语句
    //类型约束
//    protocol Runnable {}
//    class Person2{}
//    func swappp<T: Person2 & Runnable>(_ a: inout T, _ b: inout T ){
//        (a,b) = (b,a)
//    }
//    protocol Stackkk{
//        associatedtype Element2: Equatable
//    }
    class Stackk<E: Equatable>: Stackable {
        func push(_ elem: Int) {    //这里是Stackable协议的关联类型
            print(elem)
        }
        typealias Element2 = Int //所以必须说明协议的关联类型,这里是Stackkk协议
        
    }


    //MARK: - 协议类型的注意点
    //1、如果协议中有associatedtype，遵循协议的类或者方法有多个不同的关联类型时，必须每个关联类型都被明确地表达
    //2、使用泛型来说明，进一步将泛型的关联类型抽象化，实质写方法体的代码时，向上转型为协议
    //3、使用不透明类型（Opaque Type）说明，使用some关键字声明一个不透明类型



    //MARK: - 不透明类型（Opaque Type）,使用some关键字
    //1、some限制只能返回一种明确的协议关联类型的类型，但此时的协议的关联类型还是有一层抽象的（泛型）
    //2、不透明的类型意思是不对外公开，就是你只知道我返回的是一个遵循协议的类型，但是协议的关联类型并不公开。
    //   根据你传递的参数，我想返回给你什么的关联类型的协议，就返回什么的关联类型的协议的类
    //3、some除了用在返回值类型上，一般也还可以用在属性类型上
    protocol Runnable3 {
        associatedtype Speed
        var speed: Speed{get}
    }
    class Person3: Runnable3 {
        var speed: Double { 0.0 }
        
    }

    class Car3: Runnable3 {
        var speed: Int { 0 }
    }
    func get(_ type: Int) -> some Runnable3 {   //some Runnable3 限制只能返回一种明确的协议关联类型的类型
        return Car3()
    }

    //some用在属性类型上
    class Dog4: Runnable3{
        var speed: Int { 0 }
        typealias Speed = Int
        
    }
    class Person4: Runnable3 {
        var speed: Double = { 1.2}()
        var pet: some Runnable3{
            return Dog4()
        }
    }

}
