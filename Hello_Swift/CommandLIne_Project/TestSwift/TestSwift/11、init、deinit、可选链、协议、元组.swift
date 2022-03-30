//
//  11、init、deinit、可选链、协议、元组.swift
//  TestSwift
//
//  Created by 蔡天春 on 2020/9/19.
//  Copyright © 2020 蔡天春. All rights reserved.
//

import Foundation

//协议的组合
protocol Livable { }
protocol Runnable { }

//Self（大写的）：
protocol Runnable2 {
    func test() -> Self
}

public typealias AnyClass = AnyObject.Type  //所以AnyClass可以代表任意的类的类型

func testDeinit(){
    
    class Person{
        var age: Int = 0
       required init(age: Int) {
            self.age = age
        }
        convenience init() {
            self.init(age: 0)
        }
    }

    class Student: Person {
        var score: Int
        init(age: Int, score: Int) {
            self.score = score  //必须先初始化自身的属性
            super.init(age: age)
        }
        
        required init(age: Int) {   //子类必须实现父类的required 构造器，子类重写required初始化器，也必须加上required关键字，不用加override
            self.score = 0
            super.init(age: age)
            fatalError("init(age:) has not been implemented")
        }
    }


    //required关键字
    //1、用required修饰指定初始化器，表明其所有的子类都必须实现该初始化器（继承或重写）
    //2、如果子类重写required初始化器，也必须加上required关键字，不用加override

    //属性观察器的继承
    //1、父类的属性在它自己的初始化器中不会出发属性观察器，但是子类的的初始化器中赋值会触发父类的属性初始化器


    //可失败初始化器
    //1、类、结构体、枚举都可以用init?定义可失败初始化器
    //  可失败初始化器就是调用该构造器时，可能返回一个nil而不是想要的实例对象
    //2、不允许同时定义参数标签、参数个数、参数类型相同的可失败初始化器和非可失败初始化器
    //3、可以用init!来定义隐式解包的可失败构造器（跟问问号区别）
    //4、* 可失败构造器可以调用非可失败构造器，而非可失败调用可失败则必须要解包（所以第三点就用得上了，但是有运行时报错的危险）
    //5、如果初始化器调用一个可失败初始化器导致初始化失败，那么整个初始化过程都失败，并且以后的代码都停止执行（所以第4点很危险）
    //6、可以用一个非可失败构造器重写一个可失败构造器
    class Persion2{
        init?(name: String) {
            if name.isEmpty { return nil}
            print(name)
        }
        deinit {
            print("person2对象销毁了")
        }
    }
    let num = Int("123")    //其实就是可失败构造器

    //MARK: - 反初始化器（deinit）
    //1、deinit类似于c++的析构函数，oc中的dealloc方法
    //2、当类的实例对象被释放内存的时候，就会调用实例对象的deinit方法
    //3、deinit不接受任何参数，不能写小括号，不能自行调用
    //4、子类的deinit执行完毕之后才会去调用父类的deinit方法(自动继承)




    //MARK: - 可选链（Optional Chaining）
    //1、如果属性或者函数返回值本来就是可选，则不会变成可选的可选，即不会二次包装
    //2、无论在定义中是否是可选类型，通过可选链返回的都会被自动包装可选类型
    //3、如果可选链器中一环失败，则直接返回nil，返回失败

    class Car{var price = 123.5}
    class Dog{var age = 2}
    class Person3{
        var name = ""
        var dog = Dog()
        var car: Car? = Car()
        func age() -> Int {
            18
        }
        func eat() {
            print("person eat!!")
        }
        subscript(index: Int) -> Int{
            index   //单语句闭包的简写
        }
    }

    var p3: Person3? = Person3()
    let a31 = p3!.age()   //强制解包，危险
    let a32 = p3?.age()   //会先检查person是不是nil，是nil则返回nil，不是nil则返回正常的age()调用，所以a32是可选类型（包装了Int的可选类型，Int?）
    p3?.name = { "jack" }()   //如果p3是nil，则不会执行该闭包
    let age3 = p3?.age()    //如果属性或者函数返回值本来就是可选，则不会变成可选的可选，即不会二次包装
    let eat: () = p3!.eat() //没有返回值也可以调用，可以认为是一个空元组Void
    let eat2: ()? = p3?.eat() //没有返回值也可以调用，可以认为是一个空元组Void

    //无论在定义中是否是可选类型，通过可选链返回的都会被自动包装可选类型
    //如果可选链器中一环失败，则直接返回nil，返回失败
    var dog = p3?.dog //Dog?
    var dage = p3?.dog.age //Int?
    var price = p3?.car?.price  //Int?

    //字典也是可选类型
    var scores = [
        "jack": [12,43,89],
        "rose": [32,34,78]
    ]

    var sjack = scores["jack"]  //[Int]?


    var num1: Int? = 5
    num1? = 10  //num1加上?会先执行判断num1是不是空，再赋值给10给num1，不然就不会进行赋值操作

    var dict: [String: (Int,Int) -> Int] = [
        "sum": (+),
        "diff": (-) //闭包的最简形式，编译器会帮你处理好
    ]
    var res = dict["sum"]?(2,3) //Optional(30),即Int?






    //MARK: - 协议（Protocol）
    //1、协议可以用来定义方法，属性，下标声明（只定义声明，交给遵循者实现），协议可以被枚举、结构体、类遵循（多个协议之间用逗号隔开）
    //2、协议定义方法是不能有默认参数值
    //3、默认情况下，协议中定义的内容必须全部实现（有办法弄成可选的）
    //4、协议中的属性；并不要求是存储属性还是计算属性，只要求可读可写；
    //5、协议定义属性时，必须用var关键字（因为遵循者有可能是用计算性属性实现要求）
    //6、实现协议是的权限不能小于协议中定义的属性权限，可以大于
    //6.1、协议定义get、set，用var存储属性或get、set计算属性去实现
    //6.2 、协议定义get，用任何属性都可以实现
    //7、staic、class关键字
    //7.1、为类通用协议中必须用static或class定义类型方法、类型属性、类型下标（默认是static）
    //8、协议中的static
    //8.1、只用将协议中的实例方法标记为mutating才允许结构体、枚举的具体是心啊修改自身内存（也就是枚举和结构体的方法才会用到该关键字）
    //8.2、类在实现方法是不用加mutating的
    //9、协议还可以定义初始化器init，非final类实现时必须加上required（即遵循者必须实现该初始化器）
    //9.1、如果遵循者实现的初始化器刚好时重写类父类的指定初始化器，那么这个初始化器必须同时加上required、override（区别于子类单纯重写父类的required方法）
    //      所以required和override都是用于继承方面的关键字
    //10、协议中定义的init?、init!，可以用init、init?、init!去实现
    //      协议中定义的init，可以用init、init!去实现
    //11、协议继承（或说遵循）
    //11.1、一个协议可以继承其他协议
    //12、协议的组合，最多只能有组合一个类类型fn3(obj: Person4 & Livable & Runnable)，可以有多个协议
    //13、CaseIterable协议：让枚举遵循该协议，可以实现遍历枚举值，而实现的方法，编译器会帮你编写
    //14、CustomStringConvertible协议：让你可以自定义实例的打印字符串
    //15、Any、AnyObject:
    //    Any:可以代表任意类型（类、结构体、枚举、函数类型）（记住是代表、表征、强制类型转换）
    //    AnyObject:可以代表任意类的类型（只有类可以遵循该协议）
    //16、is、as?、as!、as
    //   is用来判断、as用来强制类型转换（记得考虑转换失败的情况，所以最好用as?），而单纯的as常用于子类转换成父类（百分百可以转换成功的就用单纯用as）
    //17、X.self、X.Type、AnyClass:（注意，这三个东西都是一种类型,元类型，指针变量）
    //    X.self是一个元类型（metadata）的指针，metadata存放着类型相关的信息（对象在堆空间的前八个字节存放的就是类型信息的指针，也就是metadata的指针）
    //    X.self属于X.Type类型（遵循），X.Type代表该类的类信息
    //    X.self通过类的名称来调用，如：ClassName.Type
    //    public typealias AnyClass = AnyObject.Type，所以AnyClass可以代表任意的类的类型
    //18、元类型的应用
    //    var array = [HomeVC.self,AboutVC.self]
    //19、Self（大写的）也是类型
    //    代表必须是本类的类的类型
    //    Self一般作为返回值类型，限定返回值跟方法调用者必须是同一类型（也可以作为参数类型）
    //    如果Self用在类中，哟啊求返回是调用的初始化器是required的（主要是考虑了继承的问题，避免子类没有实现该构造器，结构体就不需要required因为没有继承 ）



    //Self（大写的）：
    class Person8: Runnable2 {
        func test() -> Self {
            type(of: self).init()   //最简闭包形式，所以通过type(of:)调用的构造器必须是required的
            //不能直接返回Person(),而必须是通过元类型进行构造器初始化
        }
        
        required init(){}
        
    }


    //元类型的应用:
    var clArray = [Car.self,Dog.self,Person3.self] as [Any]
    class Animal2{
        required init(){}   //为了安全，必须加上required，要求子类必须实现，不然Animal.Type的构造器子类可能不实现，而是自定义自己的构造器
        
    }
    class Cow:Animal2{}
    class Cat:Animal2{}
    class Robbit:Animal2{}
    var aniarray = [Cat.self,Cow.self,Robbit.self] as [Animal2.Type]
    func create(aArray: [Animal2.Type]) -> [Animal2]{
        var arr = [Animal2]()
        for cls in aArray {
            arr.append(cls.init())      //保证子类都有实现init()方法
        }
        return arr
    }
    class Person7{
        var age: Int = 0
    }
    class Student7: Person7 {
        var no: Int = 0
    }
    print(class_getSuperclass(Student7.self)!)
    print(class_getSuperclass(Person7.self)!)
    //（在runtime里）其实还是有Swift._SwiftObject的作为公共基类，但是这是swift隐藏维护的，在用户层面，Person7就是基类


    //X.self、X.Type、AnyClass:
    class Person6{ }
    var p6 = Person6()
    let p61 = Person6.self //与p6在堆空间的前八个字节是一样的
    var p62: Person6.Type = Person6.self    // X.Type属于X.self类型

    var p6Type = type(of: p6)   //Person6.Type类型，即Person6.Type代表是是Person6的类信息，
                                //其实type(of:)背地里不是函数，而是直接拿出类型指针的值，但是表面上是个函数，swift来负责维护

    //协议的组合
    class Person4{}
    func fn2(obj: Livable & Runnable){} //协议的组合:接收同时遵守 Livable & Runnable的对象,只有&没有|
    func fn3(obj: Person4 & Livable & Runnable){}



    //CaseIterable协议
    enum Season: CaseIterable {
        case sp,su,au,win
    }

    let sea = Season.allCases       //相当于一个数组放了所有元素(类型属性)
    for temp in sea {
        print(temp)
    }

    //CustomStringConvertible协议
    class Person5: CustomStringConvertible{
        var description: String {"自定义实例的打印字符串"} //最简闭包形式，只读计算属性（到时会print的字符串）
    //    var description: String = "自定义实例的打印字符串" //存储属性形式
    }

    let p5 = Person4()
    print(p5)

    //存放任意类型的数组，用Any
    var ints = Array<Int>()
    var ints2 = [Int:Int]()
    var ints3 = Dictionary<Int,Int>()
    var anys = Array<Any>()

    var tt = 10 as Double
    
}
