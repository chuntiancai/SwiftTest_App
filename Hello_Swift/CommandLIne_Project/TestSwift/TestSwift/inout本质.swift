//
//  inout本质.swift
//  TestSwift
//
//  Created by 蔡天春 on 2020/9/9.
//  Copyright © 2020 蔡天春. All rights reserved.
//

import Foundation
//swift跟实例相关的两种属性，存储属性，计算属性
//储存属性： 1，类似成员变量，存储在实例的内存中。2，结构体、类可以定义存储属性，枚举不行。
//计算属性：1、本质就是方法。2、不占用实例的内存（通过引用来调用全局的计算属性），所以计算属性就是一连串的指令，代码段内存。3、类，枚举，结构体都可以定义计算属性
//计算属性只能有var，不能用let；let是常量，永远不会被改变的量。

//延迟存储属性（lazy stored property）:

//属性观察器（property observer）：

//在创建一个类或结构体的实例的时候，必须为所有的存储属性设置一个合适的初始值，通过在初始化方法里面赋值，或者编译器自动生成的构造器，注意一点是，只有没有定义任何构造器的时候，编译器才会自动生成构造器

//类
struct Point4 {
    var x: Int
    var y: Int
    
}
var p4 = Point4(x: 20, y: 12)


//结构体
struct Circle {
    
    var radius: Double
    
    var diameter: Double{
//        set{
//            radius = newValue / 2
//        }
        
        set(newParam) {
            radius = newParam / 2
        }
        get{
            radius * 2      //只有一条表达式，省略了return
        }
    }
    
}
var c4 = Circle(radius: 10)


//枚举
enum Season4: Int{   //枚举成员只需要一个字节来标识，关联值、原始值则是另外一种内存分配方式
    case spring = 1,summer,atumn,winter
//枚举的原始值rawValue的原理：
//    var rawValue: Int {     //rawValue本质就是一个计算属性
//        switch self {
//        case .spring:
//            return 11
//        case .summer:
//            return 12
//        case .atumn:
//            return 15
//        case .winter:
//            return 18
//        }
//    }
    
//    func rawValue() -> Int{ //其实枚举的rawValue值的获取类似于该方法的 get 方法
//        switch self {
//        case .spring:
//            return 11
//        case .summer:
//            return 12
//        case .atumn:
//            return 15
//        case .winter:
//            return 18
//        }
//    }
}
var s4 = Season4.spring


//延迟存储属性：
//1,记得类是在堆空间分配内存的，而不是代码段的汇编指令维护的，所以lazy就决定了实例中的lazy变量在堆中的分配内存时机，即用到该属性的时候，才分配堆空间来安排该属性
//2、lazy只能是var属性，swift规定let属性必须在构造器完整完成之前必须有值，即构造器未完成的时候，let可以暂时没有值
//3、多条线程访问lazy属性时，无法保证lazy属性只被分配一次，即lazy不是线程安全的
//4、当结构体包含一个延迟存储属性的时候，只有结构体的实例为var变量的时候才可以访问结构体内部的延迟属性，因为延迟属性初始化时需要改变结构体的内存结构
class Car4{
    init(){
        print("Car Init")
    }
    func run(){
        print("Car run")
    }
}

class Person4 {
    lazy var car = Car4()
    init(){
        print("Person Init")
    }
    func goOut(){
        car.run()
    }
}

class PhotoView {
    lazy var image: String = {
        let url = "www.baidu.com"
        return url
    }()     //闭包表达式，即函数调用赋值给lazy属性，即用到该lzay属性时，就会调用该闭包表达的代码
}


struct Point44 {
    var x = 1
    lazy var z = 0      //即不能 let p4 = Point44() 然后p4.z是会报错的
}
//属性观察器：
//1、只能为非lazy的var存储属性设置属性观察器
//2、全局变量，局部变量均可以使用属性观察器
struct Circle41 {
    
    init() {
        self.radius = 13.2  //在初始化期间是不会触发属性观察器，外层调用时才会触发
        print("circle init")
    }
    
    var radius: Double{ //在声明成员变量时就赋予的值，本质上也是等同于在构造器中赋值的
        willSet{
           print("will set radius",newValue)
        }
        didSet{
            print("did set radius",oldValue,radius)
        }
    }
    
    var diameter: Double{
        set{
            radius = newValue / 2
        }
        
        get{
            radius * 2      //只有一条表达式，省略了return
        }
    }
}

//inout关键字的原理：
struct Shape4 {
    var width:Int
    var side: Int {
        willSet{
            print("will set radius",newValue)
        }
        didSet{
            print("did set radius",oldValue,radius)
        }
    }
    
    var radius: Int{ //在声明成员变量时就赋予的值，本质上也是等同于在构造器中赋值的
        willSet{
            print("will set radius",newValue)
        }
        didSet{
            print("did set radius",oldValue,radius)
        }
    }
    
    var diameter: Int{
        set{
            radius = newValue
        }
        
        get{
            return radius      //只有一条表达式，省略了return，不能在get方法里面调用set方法 
        }
    }
    func show(){
        
    }
}

func testInout(_ num: inout Int){   //testInout(&num1),实质上就是传入num1的地址值，指针传递
    num = 32
}



func testUnit4(){
    print(s4.rawValue)
    print(MemoryLayout<Circle>.stride)  //8个字节，也就是值类型，没有类型信息什么的字节，不是堆空间。而直接就是编译器和汇编指令来维护
    print(MemoryLayout.stride(ofValue: p4))
    print(MemoryLayout.stride(ofValue: c4))
    var s = Shape4(width: 2, side: 4, radius: 23)
    testInout(&s.width) //传入的是s的地址值，然后根据.符号找到width
    testInout(&s.side) //传入的是s的地址值，然后根据.符号找到width
    testInout(&s.diameter) //传入的不是是s的地址值，因为diameter不是存储属性，而是函数的代码段地址
}

struct Shape {
    var width:Int
    var side: Int{  //willset和didset是存储属性
        willSet{
            print("shape willset")
        }
        didSet{
            print("shape didset")
        }
    }
    var grith: Int{     //get set是计算属性
        set{
            
        }
        get{
           20
        }
    }
    
    func show(){
        
    }
}


func testInout5(_ num: inout Int){
    
    let f1 = FileManager1.shared
    let f2 = FileManager1.shared
    f1.open()
    f2.open()

    print("testInout---------")
    num = 20
    //真正修改num值不是在testInout方法体内的汇编代码发生的，而是testInout间接调用num的属性观察器进行修改的（如果有属性观察器的话）
    //testInout也不是调用了willset方法，而是直接将值20放到&num的地址值上，然后这个地址值空间就触发了属性观察器；testInout不关心num是存储属性还是计算属性，它只关心地址
}
//通过inout修改存储属性，也是会触发属性观察器的
//实质上willset和didSet方法是通过set方法间接进行调用的，inout会把局部变量的地址值传入到方法体内部，即便局部变量在栈空间
//而willSet后面会调用didSet的方法

//inout本质总结，
//1、如果实参有自己的物理，且没有设置属性观察器，则inout会直接将实参的内存地址传入函数（实参进行引用传递）
//2、如果实参是计算属性 或者 设置了属性观察器；那么编译器采取copy in copy out的做法（先get后set），编译器会把相应的汇编代码拷贝到响应的逻辑流中的
//2.1、调用该函数时，先复制实参的值，产生副本（局部变量，即在栈空间开辟一个局部变量作为中介）（get）；副本说的就是那个局部变量
//2.2、将副本的内存地址传入函数（副本进行引用传递），在函数内部可以修改副本的值；关键就是这个副本的内存地址被传递
//2.3、函数返回后，再将副本的值覆盖实参的值（set）；做这么多就是为了触发属性观察器
//2.4、所以传递的归根到底都是地址，要么是属性的真实地址，要么就是一个临时变量的地址作为中介
//所以inout的本质就是地址传递，也叫做引用传递

//类型属性（Type Property）
//1、实例属性（Instance Property）：只能通过实例去访问
//1.2、存储实例属性（Stored Instance Property）：存在实例的内存里面（堆空间）
//1.3、计算实例属性（Computed Instance Property）：其实就是方法，
//每次调用方法的时候，编译器就会执行那个方法的汇编代码，也就是把那一段方法的汇编代码放到当前的IP寄存器上执行，所以这是由编译器维护的，不是由类来维护的

//2、类型属性（Type Property）：只能通过类型去访问
//2.1、存储类型属性（Stored Type Property）：不占用类型的实例的内存，即不占用堆空间；
//类型只是一个索引，而存储的类型属性是全局唯一的一个地址上的变量，其实与类型的内存无关，只是通过类型的名字来引用；（在app的代码段）
//2.2、计算类型属性：


//可以通过static来定义类型属性
//如果是类，也可以用关键字class来定义，但是结构体只能用static来定义

//类型属性必须在声明是手动赋予初始值，因为类型没有init构造器，它不是实例
//存储类型属性默认是lazy属性，第一调用时才会初始化（也就是只执行一次初始化代码，也可以理解为只执行一次闭包，一样的道理，所以也可以是闭包）线程安全。
//可以是let，因为let只是约束了实例初始化完成之前必须有值，没有约束类；
//枚举不能定义实例的内存属性，因为枚举是值类型，不在堆空间；但是可以定义类的存储属性，因为类的存储属性不在堆空间，不在实例里面；
//类型属性的经典应用就是单例模式，因为线程安全，且唯一

//let要求必须在初始化完成之前，属性必须有值；而lazy则运行初始化完成之后，首次调用时才赋值也可以，所以let和lazy刚好是矛盾的，故不能共存。

//单例模式（应用类型属性）：
class FileManager1 {
    public static let shared : FileManager1 = {
        print("测试闭包会执行多少次，是不是唯一")   //是唯一，闭包只执行一次，所以static属性只初始化一次
        return FileManager1()
    } ()  //static约束了全局内存地址唯一，let约束了不能改变，所以就是单例了，static又是线性安全的
    private init(){}    //私有属性，不让外界进行调用
    func open(){
        print("打印了FileManager1 open··")
    }
}

