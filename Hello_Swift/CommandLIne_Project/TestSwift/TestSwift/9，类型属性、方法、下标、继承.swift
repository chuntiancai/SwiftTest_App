//
//  9，类型属性、方法、下标、继承.swift
//  TestSwift
//
//  Created by 蔡天春 on 2020/9/15.
//  Copyright © 2020 蔡天春. All rights reserved.
//

import Foundation

func testStatic9(){
    let a = 10
    var b = 11



    class Car9{
        //静态属性的初始化代码是一个闭包，也就是一个方法，这个方法是在一个安全的线程中执行的，就是gcd的dispatch_once，先调用线程，再在线程里面调用方法
        //所以静态属性的内存地址和全局变量的地址是在同一段内存空间的（代码段），
        //然后放在类里面和外面的不同是，类里面的静态属性附加了一些约束条件，会触发一些方法或者动作，编译器会把这些动作的汇编代码放在恰当调用的位置的
        static var count = 0
    }

    Car9.count = 13     //所以静态属性就是调用了swift_once， 就是gcd的dispatch_once，为了保证只执行一次，并且线程安全
    var c = 12
}

//MARK: - 方法
func testFunc9(){
    
    //1、实例方法（Instance Method）： 通过实例调用
    //2、类型方法（Type Method）：通过类型调用，用static或者class关键字定义
    
    class Car9{
        static var count = 0
//        var name = 2
        
        init() {
            Car9.count += 1
        }
        static func getCount() -> Int {
            self.count  //也可以写成self的形式
            
        }
    }
    
    Car9.count = 13     //所以静态属性就是调用了swift_once， 就是gcd的dispatch_once，为了保证只执行一次，并且线程安全
    var c = 12
    
}

//MARK: - mutating关键字
//1、结构体和枚举都是值类型，默认情况下，值类型的属性不能被自身的实例方法修改。因为值类型是在当前栈空间分配内存的，而不是对象的堆空间
//在func关键字前加mutating关键字就可以允许修改值类型里面的属性。
//就简单是语法的约定而已（语法糖）；因为修改值类型的属性，是会自己修改到自身的内存结构，而不是其他人修改我的内存结构


func testMutating(){
    struct Point{
        var x = 0.0,y=0.0
        mutating func move(){
            x = 2.0 //如果func前没有mutating，是不可以修改自身的属性的
        }
    }
}

//MARK: - @discardableResult关键字
//在方法定义的func前加@discardableResult,可以消除未使用返回值的编译警告
@discardableResult func testDiscard() -> Int{
    return 12
}


//MARK: - 下标（sub script）
//其实完整的中文是下标脚本，简称为下标（subscript）
//对应的也有上标，其实就是x的平方上的平方
//1、使用subscript可以给任意类型（类，结构体，枚举）增加下标功能
//2、subscript的语法类似于实例方法、计算属性。其实下标的本质就是方法
//3、subscript中定义的放回值类型决定了：
//3.1、get方法放回的值类型
//3.2、set方法中newValue的类型
//4、subscript可以接受多个参数，并且任意类型，也就是[]中可以是任意类型
//5、subscript可以没有set方法，但是必须有get方法。只有get方法的时候，可以省略get关键字
//6、可以设置参数的标签，既可以不是index，例如：bbb index就是p[bbb: 1]
//7、下标可以是类型的方法，本来是实例的方法，当作实例方法的时候，其实就是花俏一点的方法定义和使用而已
//8、如果要对通过subscript获取到的值类型进行赋值操作的话，subscript的定义里必须要有set方法，因为只有get方法的subscript约束为只读属性，因为获取和设置都是要通过subscript的；
//引用类型不受此限制，因为引用类型是堆空间（通过指针操作内存），而值类型在栈空间（直接就是操作内存）。
func testSubscript(){
    class Point{
        var x = 0.0,y=0.0
        
        subscript(index: Int) -> Double {   //其实就是get、set方法
            set {
                if index == 0 {
                    x = newValue
                }else if index == 1 {
                    y = newValue
                }
            }
            
            get {
                if index == 0 {
                    return x
                }else if index == 1 {
                    return y
                }
                return 0
            }
            
        }
        
    }
    
    let p = Point()
    p[0] = 2.1
    p[1] = 3.2
    print(p[1])
}

func testSubscript2(){
    struct Point{
        var x = 0.0,y=0.0
        
    }

    class PointManeger{
        var point = Point() //得看point是struct还是class，是值类型还是引用类型，是栈空间还是堆空间
        
        subscript(index: Int) -> Point {   //其实就是get、set方法
            set {
                point = newValue
            }
            
            get {
                return point
            }
            
        }
        
    }

    let p = PointManeger()
    p[0].x = 2.1
    p[1].y = 3.2
    print(p[1])
}

//MARK: - 继承(inheritance)
//1、值类型（枚举，结构体）不支持继承，只有类支持继承
//2、没有父类的类，就称为基类
//3、子类可以重写父类的下标，方法，属性（计算属性），但是重写必须加上override关键字；因为下标，计算属性本质都是方法
//4、被class修饰的类型方法，下标，允许被子类重写；
//5、被static修饰的类型方法，下标，不允许被子类重写;但是可以用static来重写class的方法
//6、子类可以将父类的属性（存储，计算）重写为计算属性，但是不可以将父类的属性（计算或存储）重写为存储属性，因为两者的内存都不在同一个区域；而计算属性的本质就是方法
//重写存储属性为计算属性，其实就是变成了访问子类的方法，而不是访问父类的存储属性了，也就是把访问路径改了而已。也就是就是父类的存储属性的内存还在的，只是不暴露出来了而已，或者说访问被截胡了，
//一直被截胡，必须通过子类的super来访问（即便是在父类的get，set方法中也被截胡），规则如此。
//7、只能重写var属性，不能重写let属性
//8、重写的名称和类型必须一致
//9、子类重写后的属性权限不能小于父类属性的权限
//9.1、只读< 读写
//10、class修饰的存储属性不可以被重写，但计算属性可以；因为存储类型的属性是全局变量，在代码段（类似于值访问）。
//11、子类中可以为父类的属性增减属性观察器（只读计算属性，let属性不可以），willset，didSet，只是添加了方法（变更了访问形式），不是变更为计算属性；willset方法会先拿到oldValue的，然后传递给didset的。
//12、子类可以为父类的计算属性再增加willset、didset属性观察器，本来willset和set是不可以在同一个类中共存的，但是继承就可以在两个类里共存
func testInhertance(){
    
    class Animal{
        
        var age = 0
        func speak(){   //方法可以被子类重写，汇编层就是一段指令，然后被赋值粘贴扩展之类的，都有可能；重写的方法前必须有override关键字
            print("animal speak")
        }
        
        class func sleep(){ //class方法可以被重写
            print("animal sleep")
        }
        
        static func eat(){  //static方法不可以被重写
            print("animal eat")
        }
        subscript(index: Int) -> Int{
            return index
        }
    }
    
    class Dog: Animal{
        var weight = 0
        override func speak() {
            super.speak()
            print("Dog Speak")
        }
    }
    
    class Eha: Dog{
        var iq = 0
    }
    
    let a = Animal()    //堆空间必然是16字节的倍数，因为16字节对齐，类的前面16个字节存储类信息和引用计数；所以animal的对象会是32个字节的内存空间，8个字节是存Int，还有8个字节是对齐
    a.age = 12
    
    let d = Dog()   //也是32个字节，因为animal有8个字节是为了对齐的，并未使用，dog就充分利用了
    d.weight = 21
    
    let e = Eha()   //这里是48个字节，多出的8个字节是为了16字节的内存对齐
    e.iq = 11
    
    //多态演示
    var ani = Animal()
    ani = Dog() //向下转型
    ani.speak()
    
}



