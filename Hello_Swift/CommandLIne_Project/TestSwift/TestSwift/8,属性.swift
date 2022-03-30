//
//  属性.swift
//  TestSwift
//
//  Created by 蔡天春 on 2020/9/14.
//  Copyright © 2020 蔡天春. All rights reserved.
//

import Foundation

class Size8{
    
}

struct Point8 {
    var x:Int   //占8个字节
    var y:Int   //占第二个8个字节
    init() {
        x = 10
        y = 20
    }
}

enum Season: Double {
    case spring,summer  //只占用一个字节
    //如果关联了关联值，则占用关联值的内存总数加一，加一个字节是用来存储case的。
}





//跟实例相关的属性分为两大类
//1、存储属性
//1.1 、类似于成员变量，存储在实例的内存中，结构体、类可以定义存储属性，枚举不可以定义存储属性
//2、计算属性
//2.1、计算属性的本质就是方法，方法本身就不占用实例的内存，枚举、类、结构体都可以定义方法
//2.2、在创建类或结构体的实例的时候，必须为所有的“存储属性”赋于初始值，在初始化方法执行完之前，必须都有值
//2.3、可以有只读的计算属性（只有get方法），计算属性只能用var，不能用let，因为get方法的返回值是可变的，而let的语义规定了是常量，不可变



struct Circle8 {
    //存储属性
    var radius: Double
    
    // 计算属性
    var diameter: Double{   //本质是方法
        set{
            radius = newValue / 2
        }
        get{
            radius * 2
        }
    }
}

//枚举的rawvalue原理：就是调用了get方法
enum Season8: Int {
    case spring,summer,autumn,winter  //只占用一个字节，原始值不一定要存储，它可能就是一个方法，是一个标志器而已
    //如果关联了关联值，则占用关联值的内存总数加一，加一个字节是用来存储case的。而case就是一个字节的标志器
    //rawvalue本质是一个计算属性，是get、set方法
//    func rawValue() -> Int {        //类似于这样的实现
//        switch self {
//        case .spring:
//            return 11
//        case .summer:
//            return 46
//        case .autumn:
//            return 32
//        case .autumn:
//            return 16
//        default:
//            break
//        }
//    }
    
    var rawValue: Int { //rawValue的本质，其实就是get、set方法的调用，可以看汇编代码
        switch self {
        case .spring:
            return 11
        case .summer:
            return 46
        case .autumn:
            return 32
        case .autumn:
            return 16
        case .winter:
            return 89
        }
    }
}

struct Shape8 {
    var width:Int
    var side: Int{  //willset和didset是存储属性,其实再深层一点willset和didset是通过set和get来调用的
        willSet{
            print("shape willset",newValue)//inout 关键字不会直接拿出side的地址值，拷贝出它的值，然后再通过set方法来设置的的，而不是直接就是设置的
        }
        didSet{
            print("shape didset",oldValue)//带有属性观察器的存储属性，也是传递一个临时变量的地址给inout关键字，而这个临时变量由didiset、willset方法维护
        }
    }
    var grith: Int{     //get set是计算属性，传给inout的是方法的地址值
        set{
           width = newValue / side
            print("setGrith",newValue)
        }
        get{
            //调用get方法是，返回值会先放在一个局部变量，如果是inout关键值的话，会把这个局部变量的地址值传递给inout关键字
            //然后调用set方法的效果是，将get方法得到的局部变量作为newValue传递给set方法，所以传递的过程中借用了一个临时的局部变量的地址值（栈空间）
            print("getGrith")
           return width * side
        }
    }
    
    func show(){
        
    }
}

///inout关键字并不维护属性观察器，而是单纯的地址而已，属性观察器由get、set方法自身维护，编译器会先把get、set方法的汇编代码拷贝到这个位置的
func testInout8(_ num: inout Int){  
    print("testInoout8")
    num = 21
}


func testAttribute(){
    var p = Point8()
    print(MemoryLayout.stride(ofValue: p))  //x，y存储在堆空间
    
    var c = Circle8(radius: 2)
    var x = c.diameter
    
    var s = Season8.summer      //其实就是调用了get方法
    print("summer的rawValue",s)
}

