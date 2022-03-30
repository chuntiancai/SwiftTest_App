//
//  15、访问控制、内存管理.swift
//  TestSwift
//
//  Created by 蔡天春 on 2020/9/27.
//  Copyright © 2020 蔡天春. All rights reserved.
//

import Foundation

//MARK: - CustomStringConvertible协议，CustomDebugStringConverible协议，都可以自定义实例的打印字符串
//1、print调用的好似CustomStringConvertible协议的description（计算属性）
//2、debugPrint，po调用的是CustomDebugStringConverible协议的debugDescription（计算属性）


class Person: CustomStringConvertible,CustomDebugStringConvertible{
    var debugDescription: String{"debug person_\(age)"}
    var age: Int = 0
    var description: String { "Person: \(age)" }
}



var person = Person()
print(person)
debugPrint(person)

//MARK: - Self
//1、首字母小写的self是实例，首字母大写的Self代表是类型
//2、首字母大写的Self代表当前类型，一般用作返回值类型，限定返回值跟方法调用者必须是同一类型（也可以作为参数类型）




//MARK: - assert（断言）
//1、不符合指定条件就抛出 运行时错误 ，常用于调试（debug）阶段的条件判断
//2、默认情况下，swift语言的断言只会在debug模式下生效，在release模式下不生效
//3、在building setting中，增加swift flag来修改断言的默认行为，也就是配置编译器
//3.1: -assert-config Realease: 强制关闭断言
//3.2: -assert-config Debug: 强制开启断言




func divide(v1: Int,v2: Int) -> Int{
    assert(v2 != 0 , "除数不能为0")
    return v1 / v2
}

//MARK: - fatalError
//1、如果遇到严重问题，希望结束程序运行时，可以直接使用fatalError函数抛出错误（这是无法通过do-catch捕捉的错误）
//2、使用了fatalError函数，就不需要再写return
//3、在某些不得不继承的函数，但是又不希望使用者调用的话，可以在继承的方法中编写fatalError函数

func test(num: Int) -> Int {
    if num >= 0 {
        return 1
    }
    fatalError("num不能小于零")
}


//MARK: - 访问控制（Access Control）
//1 、就是public，private这些，swift提供了五种访问级别（下面是从高到低描述，实体指被访问级别修饰的内容）
//2、open：允许在 定义实体的模块 或者 其他模块 中访问，允许其他模块进行继承，重写（open只能用于类，类成员上）
//3、public：允许在 定义实体的模块 或者 其他模块 中访问，不允许其他模块进行继承（可读不可写）
//4、internal：只允许在定义实体的模块中访问，不允许其他模块中访问。（项目内可读可写）
//5、fileprivate：只允许在定义实体的源文件中访问，即swift文件（文件内可读可写）
//6、private：只允许在定义实体的封闭声明中访问(类内可读可写)
//7、绝大多数默认是internal级别
//8、一个实体不可以被耕地访问级别的实体定义，这里的实体是指被访问符号修饰的东西，不是说类，也不是说结构体，而是更抽象，更笼统
//9、枚举的访问级别是成员中最低的那个
//10、泛型类型访问级别是 类型的访问级别 以及 所有泛型类型参数的访问级别 中最低的那个
//11、类型的访问级别会影响成员（属性、方法、初始化器、下标）、嵌套类型的默认访问级别
//12、一般情况下，类型为internal或public，那么成员\嵌套类型默认是internal


class Person1{
    var age: Int = 0
}


fileprivate typealias MyInt = Int
fileprivate typealias MyString = String


class Test {
    private struct Dog {
        var age: Int = 0        //age跟随所在类的访问级别，所以下面的person可以访问，但是如果显示声明为private，则不可以访问了
        func run(){}
    }
    
    private struct Person1{
        var dog: Dog = Dog()
        mutating func walk(){
            dog.run()
            dog.age = 2
        }
        
    }
    
}


//MARK: - getter、setter的访问级别声明
//1、getter、setter默认自动接收它们所属环境的访问级别
//2、可以给setter单独设置一个比getter更低的访问级别，用以限制写的权限

class Person2{
    private(set) var age: Int = 0
    fileprivate(set) public var weight: Int{
        set{}
        get{ 21 }
    }
    
    internal(set) public subscript(index: Int) -> Int {
        set{}
        get{ 12 }
    }
    
}

//MARK: - 初始化器的访问级别声明
//1、如果想在其他模块调用本模块中的无参构造器，那么本模块该类的构造器必须显示声明为public，不能是编译器自动生成的构造器（public的跟随默认是internal的）
//2、成员构造器的访问级别，是参数成员中最低访问级别的那个级别，否则默认是internal
//3、不允许给enum的每个case单独设置访问级别
//3.1: 每个case自动接收enum的访问级别
//3.2: public enum定义的case也是public（类的话，public的跟随默认是internal的）
//4、协议体里面的定义（属性，方法。。。），不能单独设置访问级别，只能跟随协议声明时的访问级别（public 的跟随也是public）
//4。1: 类里面对协议的方法的实现，只要大于等于协议中或者当前类的访问级别就可以了



enum Season {
    case sp,sum,aut,win
}
protocol Runnable {
    func run()
}

//MARK: - 扩展
//1、如果有显式声明扩展关键字的访问级别，那么扩展里的方法跟随该访问级别
//2、但是如果扩展时用于遵循某协议的，则不可以声明访问级别（协议的访问级别限制）
//3、扩展体里的私有成员（方法），可以被其他扩展访问，也可以被本体访问

class Person3{
    var age: Int = 0
    
}

fileprivate extension Person3 {
    func test3(num: Int){ print( "\(num + 1 )" ) }
}



//MARK: - 将方法赋值给let/var、闭包

// (Person3) -> ( (Int) -> () )
var fn = Person3.test3  //绑定方法

//(Int) -> ()
var fn2 = fn( Person3() )   //绑定实例
fn2(21)

var fn3: (Person3) -> ( (Int) -> () ) = Person3.test3
fn3( (Person3()) ) (32)



//MARK: - 内存管理（我们讨论的内存管理都是针对堆空间而已的）
//1、swit和oc都是采用基于引用计数的ARC内存管理方案（针对堆空间）
//2、swift的arc有3种引用
//2.1、强引用（strong reference）：默认情况下，引用都是强引用
//2.2、弱引用（weak reference）：通过weak定义弱引用
//     不会产生引用计数加一；
//     当指向对象被销毁的话，弱引用的成员被置成nil（所以必须是可选类型）；
//     当弱引用置成nil时，不会触发属性观察器

//3、无主引用（unowned reference）： 通过unowned定义无主引用
//     不会产生强引用(即arc不会加一)，非可选类型，实例销毁后仍然存储这实例的内存地址（类似oc中的unsafe_unretained）
//     试图在实例销毁后还去访问实例，则会产生运行时错误（野指针）

//4、weak和unowned只能用在类实例上（即结构体不能声明为weak和unowned）



class Dog4 {
    deinit {
        print("dog4 deinit ~")
    }
}

class Person4{
    var age: Int = 0
    deinit {
        print("Person4 deinit~")
    }
}

func test(){ let p = Person4(); p.age = 1}
print(1)

weak var p4: Person4? = Person4()

print(2)


//MARK: - Autoreleasepool 自动释放池
//1、这是一个全局的函数
//2、用于缓解内存压力

//public func autoreleasepool<Result>(invoking body: () throws -> Result) rethrows -> Result
autoreleasepool{
    let p = Person4()
    p.age = 2
}


//MARK: - 循环引用（Reference Cycle）
//1、weak 和 unowned 都能解决循环引用问题，unowned要比weak少一些性能销毁（unowned不用管理nil）
//2、在生命周期中可能会变为nil的，使用weak
//3、初始化赋值后再也不会变为nil的使用unowned

//MARK: - 闭包的循环引用
//1、闭包表达式默认会对用到的外层对象产生额外的强引用（对外层对象进行了retain操作,arc加一）
//2、去掉闭包的强引用，可以在闭包内加上捕获列表；与参数列表区分，捕获列表写在参数列表前面
//3、使用捕获列表，要写完整闭包的声明表达式

class Person5{
    var age = 0
    var fn: (() -> ())?
    var fn2: ((Int) -> ())?
    lazy var fn3: (() -> ()) = {  //必须加上lazy，因为下面有用到self，lazy是用到的时候才会去初始化
        [unowned p=self] in         //真正的闭包，所以会对self产生强引用，因为一直存在。本质是一个方法。所以编译器要你显式写成self
        self.run()
        p.run()
    }
    lazy var getAge: Int = {    //这个lazy后面有个（），实际上就是执行了闭包，把返回值赋值给getAge，而闭包执行完毕后生命周期就结束了。
                                //而上面的那个lazy是声明一个闭包，这个才是真正的闭包，所以会对self产生强引用，因为一直存在。是一个方法
        self.age
    }()
    
    
    func run(){ print("run")}
    deinit {
        print("person5 deinit")
    }
}
func test5(){
    let p = Person5()
    p.fn = {
        [weak p] in     //引用的捕获列表,记得弱引用时可选类型
        p?.run() //所以会对外面的实例p产生强引用
    }
    p.fn = {
        [unowned p] in //unowned的捕获列表
        p.run()
    }
    p.fn2 = {
        [weak p](age) in    //捕获列表写在参数列表前面
        p?.run()
    }
    
    p.fn2 = {
        [weak wp = p , unowned up = p ](age) in    //可以在捕获列表写别名
        wp?.run()
        up.run()
    }
}

//MARK: - @escaping 逃逸闭包
//1、非逃逸闭包 和 逃逸闭包，一般都是当作参数传递给函数的
//2、非逃逸闭包：闭包调用发生在函数结束前，闭包调用（执行）在函数作用域内
//3、逃逸闭包：逃逸了函数的作用域，闭包有可能在函数结束后调用，需要通过@escaping声明，也是就是闭包的执行不在函数作用域内了。
//4、@convention关键字，说明指的是oc里面的block

func test6(fn: () -> ()){  //fn是非逃逸闭包
    fn()
}
typealias  Fnn = () -> ()

var gFn: ( () ->() )?
func test7(fn: @escaping Fnn){  //fn是逃逸闭包，因为fn赋值给了外面的变量，也就是这段汇编代码会在某个时机执行，当不是当前函数的作用域内
    gFn = fn
    DispatchQueue.global().async {
        fn()
    }
    
}


class Person7{
    
    var age: Int = 0
    var fn: Fnn
    init(fn: @escaping Fnn) {   //fn是逃逸闭包，因为不知道fn会在什么时机执行
        self.fn = fn
    }
    
    func run(){
        //1、DispatchQueue.global().async 的最后一个参数也是一个逃逸闭包
        //2、它用到了实例成员（方法、属性），所以编译器会强制要求明确写出self
        DispatchQueue.global().async {
            
            self.fn()   //该闭包执行完之后，即闭包的生命周期结束后，才会释放对Person7的强引用
            
        }
        
        DispatchQueue.global().async {
            [weak p = self] in
            p?.fn()   //那么该闭包表示的是，如果person7已经销毁，则不再执行该代码 p?.fn()
            
        }
        
    }
    
    
    deinit {
        print("Person7 deinit~")
    }
}
