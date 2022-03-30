//
//  14、可选项本质，运算符重载，扩展.swift
//  TestSwift
//
//  Created by 蔡天春 on 2020/9/27.
//  Copyright © 2020 蔡天春. All rights reserved.
//

import Foundation

//可选项的本质、运算符重载、扩展

//MARK: - 可选项的本质 - 枚举(关联值)加泛型
//1、enum Optional<Wrapped> : ExpressibleByNilLiteral {} 本质就是枚举，可选，泛型的三个关键字连在一起，其实就是枚举
//2、用Int？这些表示，其实就是语法糖，编译器会做转换，这样写是为了让用户编写方便
//3、enum也是可以有构造器的
//4、泛型是加载类型名命名，用于给该类型的作用域一个参考值，该参考值由使用者提供
//5、多重可选项，就是枚举里的泛型也是可选类型。枚举的泛型是枚举



var age: Int? = 10
age = 23
age = nil

var age1: Optional<Int> = nil
age1 = .some(23)
age1 = .none


var age2 = Optional<Int>.none
var age3: Optional<Int> = 12
var age4: Int? = .none


//MARK: - 可选项的switch case 语法
//1、case let 语句，把case接收到的值放在let关键字声明的变量中
//2、where 关键字用于限制当前语句成立的约束，是整个语句
//3、if let 语句判断let后面的变量获取的可选项值是不是空，不是nil就解包进入作用域，是nil就到else作用域
var age5 = 32
switch age5 {
    
case let a where a > 20:
    print(a)
case let b:
    print(b)
    
}

switch age {
case let v?:    //加上问号，表示对当前值解包
    print("1",v)
case nil:
    print("2")
}
//与上面的代码完全等价
if let v = age {
    print("1",v)
}else {
    print("2")
}

var height: Int? = 21
var height2: Int?? = height
height2 = nil
var heig3 = Optional.some(Optional.some("abc"))


//MARK: - 溢出运算符&+、&-、&*，取模运算
//1、取模运算，公式的本质是商往负无穷方向舍人，被除数 减去 商乘以除数；而取余预算则是商往0方向舍入
//2、模的意思是说，用多少个模表示数字，例如二进制，用两个模0、1来表示数字，十进制用0、1、2、3、4、5、6、7、8、9这十个符号来表示数字；
//   十六进制用0、1、2、3、4、5、6、7、8、9、a、b、c、d、e、f 这十六个符号来表示数字，超过模的数量的数字，则用多个模来组成表示。
//   例如十进制的十用 1 和 0 组合来表示十。所以，所有的进制的表示都有0这个符号作为模，这是大家约定好的

var v1 = UInt8.max
var v11 = v1 &+ 1 //结果为0

var v2 = UInt8.min
var v22 = v2 &- 1 //结果是255

var s1:Int8 = Int8.max
var s11 = s1 &+ 1

var s2:Int8 = Int8.min
var s21 = s2 &- 1


//MARK: - 运算符重载，使用者为自定义的类提供自定义的运算符规则
//1、类、结构体、枚举都可以为现有的运算符提供自定义的实现，这个操作叫做：运算符重载
//2、重载的意思是，为某个模块提供不同的功能实现，重写的意思是修改某个模块的功能
//3、运算符+、-、*、\ 、自身本来就有功能，但是现在为为它们提供额外的功能定义，例如针对某类的做不同的操作。主角是运算符，而不是类。
//4、重载（结合性，运算符使用时，参数在左右两侧，定义时时正常的函数参数的定义）
//5、声明在类型里面，运算符重载函数必须时static，因为是全局使用
//6、prefix关键字表示的是前缀的意思，也就是中缀，数据结构中的前缀、中缀、后缀的意思。运算符重载默认是中缀;
//7、postfix关键字表示后缀

struct  Point { //为类型提供运算符规则
    var x = 0,y = 0
    static func + (p1: Point , p2: Point) -> Point { //默认中缀，运算符放在两个参数的中间
        Point(x: p1.x + p2.x, y: p1.y + p2.y)
    }
    static prefix func - (p1: Point) -> Point { //前缀，表示运算符放在参数的前面
        Point(x: -p1.x , y: -p1.y)
    }
    
    static func += (p1: inout Point , p2: Point){
        p1 = p1 + p2
    }
    static prefix func ++ (p1: inout Point) -> Point {
        p1 += Point(x: 1, y: 1)
        return p1
    }
    
    static postfix func ++ (p1: inout Point) -> Point{ //后缀，表示运算符放在参数的后面
        let tmp = p1
        p1 += Point(x: 1, y: 1)
        return tmp
    }
    static func == (p1: inout Point , p2: Point){
        p1 = p1 + p2
    }
    
}

var p1 = Point(x: 1, y: 2)
var p2 = Point(x: 10, y: 20)

// 重载 + 号运算符，为Point结构体提供功能
//func + (p1: Point , p2: Point) -> Point {
//    Point(x: p1.x + p2.x, y: p1.y + p2.y)
//}



//MARK: - Equatable 协议
//1、要想知道两个实例是否等价，一般做法是遵守Equatable协议，重载 == 运算符
//2、其实不遵循Equatable协议也可以，但是遵循该协议可以告知使用者它重载了==符号
//3、如果遵循了Equatable协议，重载了==符号，那么编译器会帮你自动重载!=符号
//4、swift会为这些类型默认实现Equatable协议：
//4.1：没有关联值的枚举（即有原始值也可以），因为关联值可以关联类，很难比较
//4.2：枚举的所有关联值都遵循Equatable协议，但是比较的是同一种枚举成员(定义时要显示编写遵循Equatable协议)
//4.3：所有的存储属性都遵循Equatable的 结构体(定义时要显示编写遵循Equatable协议)

//5、引用类型比较存储的地址值是否相等的话(即是否引用着同一个对象)，使用恒等运算符===,!==

//6、要想比较两个实例的大小，一般的做法是： 1.遵循Compare协议，2.重载相应的运算符


enum Answer: Equatable {
    case wrong(Int,String)
    case right
}

var en1 = Answer.wrong(1, "aa") == Answer.wrong(2, "aa")

class Person: Equatable{
    static func == (lhs: Person, rhs: Person) -> Bool {//重载==符号
        if lhs.name == rhs.name && lhs.age == rhs.age {
            return true
        }else {
            return false
        }
    }
    
    var age:Int
    var name:String
    
    required init(age: Int,name: String) {
        self.age = age
        self.name = name
    }
    
}
//equaltable可以告知编译器泛型实现了==符号的重载
func equals<T: Equatable>(t1: T , t2: T) -> Bool {
    t1 == t2
}


//MARK: - 自定义运算符（Custom Operator） （无中生有）
//1、可以定义新的运算符：在全局作用域使用Operator进行声明
//prefix operatpr  前缀
//postfix operator  后缀
//infix operator   中缀：优先级组
//2、precedencegroup 关键字用于定义优先级组，相当于class，struct这些关键字
//官网有文档解析，优先组各个成员的值的意义
//precedencegroup 优先组名字 {
//    associativity: none              //结合性（left/right/none）
//    higherThan: AdditionPrecedence   //比谁的优先级高
//    lowerThan: MultiplicationPrecedence   //比谁的优先级低
//    assignment:true   //代表在可选链操作中拥有跟赋值运算符一样的优先级
//}

//结合性为none表示不管是从左到右，还是从右到左，只能有两个操作数 a1 + a2 + a3 是不允许的，因为无法判断结合的优先级

prefix operator +++

prefix func +++ (_ i: inout Int){
    i += 2
}

infix operator +- : PlusMinusPrecedence

precedencegroup PlusMinusPrecedence {
    associativity: none
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
    assignment:true //代表在可选链操作中拥有跟赋值运算符一样的优先级，判空在执行
}


struct  Point1 { //为类型提供运算符规则
    var x = 0,y = 0
    static func +- (p1: inout Point1 , p2: Point1) -> Point1 {     //这个就是我们自定义的运算符
        Point1(x: p1.x + p1.y, y: p1.y - p2.y)
    }
    
}
var p11 = Point(x: 1, y: 2)
var p12 = Point(x: 10, y: 20)


//代表在可选链操作中拥有跟赋值运算符一样的优先级
class Person1{
    var age:Int = 0
    var point:Point1 = Point1()
}

var p13: Person1? = Person1()
var p14 = p13?.point +- Point1(x: 12, y: 21) //也就是如果p13?为nil，则不执行该语句剩下的部分


//MARK: - 扩展（Extension） ，类似如oc中的分类（category）
//1、扩展可以为枚举、结构体、类、协议添加新功能
//1.1：可以添加方法，计算属性，下标，（便捷）初始化器、嵌套类型、协议等等
//2、扩展不能办到的事情
//2.1、不能覆盖原有的功能
//2.2：不能添加存储属性，不能向已有的属性添加属性观察器
//2.3：不能添加父类
//2.4： 不能添加指定初始化器，不能添加反初始化器
//2.5: 。。。

extension Array {
    subscript(index idx: Int) -> Element? { //Element是Array里面定义的泛型，也就是Array里面元素参考的类型
        if (startIndex ..< endIndex).contains(idx){ //startIndex,endIndex也是Array里面定义的计算属性
            return self[idx]
        }
        
        return nil
    }
}

var arr: Array<Int> = [1,23,32]


//MARK: - 扩展协议
//1、给原有的协议扩展方法，计算属性
//2、扩展可以给协议提供默认的实现，是实现，不是声明，也间接实现了 可选协议 的效果（也就是协议的扩展中的方法是可选实现的）
//3、扩展可以给协议扩充 协议中从未声明的方法 ，但是扩充的必须是新方法的实现，而不是新方法的声明
protocol TestPortocol {
    func test1()
}

extension TestPortocol {
    func test1(){
        print("test1 extension")
    }
    
    func test2(){
        print("test2 extension")
    }
}

class TestClass: TestPortocol {
    func test1() {
        print("testClass 1")
    }
    func test2() {
        print("testClass 2")
    }
}

var cls: TestPortocol = TestClass()
cls.test2() //会是去调用TestPortocal的test2（），因为编译器采取保守策略，并不保证实例的类是有定义test2的，但是协议就是一定有test2的
