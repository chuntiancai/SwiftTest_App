//
//  16、指针.swift
//  TestSwift
//
//  Created by 蔡天春 on 2020/9/28.
//  Copyright © 2020 蔡天春. All rights reserved.
//

import Foundation

//MARK: - do 关键字,可以单独存在（局部作用域）
//1、单独使用时，可以实现单独局部作用域的功能，不被打扰

do{
    let age = 10
    print(age)
}
do{
    let age = 10
    print(age,"123")
}

//MARK: - 访问级别下的成员重写
//1、子类的对父类的成员的进行重写时，访问级别大于等于父类该成员的访问级别，或者大于等于当前子类的访问级别
//2、继承或者遵循，都必须比原有的访问权限要大于或者等于
//3、父类的成员不能被 成员所在的作用域外 的子类重写，也就是重写必须时在成员可见的作用域内操作，例如模块内，文件内
//4、required init 的访问级别必须大于等于他的默认访问级别（init的默认访问级别就是当前类定义时的访问级别，跟随的）
class Person{
    var age: Int = 0
    private func run(){ print("person run")}    //也就是run方法不能在外面的作用域被重写
    
    class Student: Person {
        override func run(){ print("Student run")}
    }
}

class Student: Person {
    public required override init() {  //required init 的访问级别必须大于等于他的默认访问级别
        print("student init")
    }
     func run(){ print("Student run")}
}

//MARK:- 逃逸闭包不可以捕获inout参数
//1、

typealias  Fnn = () -> ()

var gFn: ( () ->() )?
func test1(fn: @escaping Fnn){  //fn是逃逸闭包，因为fn赋值给了外面的变量，也就是这段汇编代码会在某个时机执行，当不是当前函数的作用域内
    gFn = fn
    DispatchQueue.global().async {
        fn()
    }
}

func test2(v: inout Int){
   
    test1 { //这里是逃逸闭包，为了安全，不让地址传出去作用域，所以不允许inout参数被捕获
            //因为不确定inout的地址在逃逸闭包执行时，是否还存在
    }
}

//MARK:- 内存访问冲突（Conflict Access to Memory），编译或运行时报错
//1、多个操作时，如果至少一个是写入操作，访问同一块内存，访问时间重叠（比如在同一个函数内），那么就会产生内存访问冲突
//2、即不允许在一条表达式时，同时修改两次同一块内存地址（即便是元组的两个成员的地址，因为是属于同一块整体内存）
//3、如果是在访问的内存地址是在局部作用域，那么这些内存访问冲突swift会做处理，不报错（为了安全所作出的限制）

func plus(num: inout Int) -> Int {
    num + 1
}

//以下不存在内存访问冲突
var num1 = 1
num1 = plus(num: &num1)

//以下存在内存访问冲突
var step = 1
func increment(num: inout Int){ num += step} //在其他语言的时候，是不会产生访问冲突的，但是swift为了更加安全，所以将其设置为访问冲突
increment(num: &step)


//MARK: - 指针
//1、swift有自己的指针类型，与c语言的指针有所区别（有所约束），
//2、swift的引用本质是指针，但是约束有点区别
//3、swift的指针类型都被定性为 Unsafe ，也就是不安全的，常见的有以下4种类型：
//  UnsafePointer<Pointee> 类似于const Pointee *  ，常量 Pointee是指类型，例如Int，Double，String
//  UnsafeMutablePointer<Pointee> 类似于Pointee * ，变量
//  UnsafeRawPointer  类似于const void * ，并非泛型，也就是单纯的指针
//  UnsafeMutableRawPointer  类似于void *

class Person2{
    var age: Int = 0
    
}

var age2 = 32
func test2(ptr: UnsafeMutablePointer<Int>) {}
func test21(ptr: UnsafePointer<Int>) {
    print("test21", ptr.pointee)    //pointee就相当于c语言的 * 运算符
}

test2(v: &age2)
test21(v: &age2)


var arr = NSArray(objects: 11,12,13,14)

//oc版枚举数组的元素
//arr.enumerateObjects(block: (Any, Int, UnsafeMutablePointer<ObjCBool>) -> Void)
//elem是元素，idx是下标
//stopPtr是UnsafeMutablePointer<ObjCBool>指针，指向bool类型，这里用于判断枚举是否结束
arr.enumerateObjects { (elem, idx, stopPtr) in
    print(idx,elem)
    if idx == 2 { stopPtr.pointee = true} //不是立马停止，而是在循环语句的判断条件中停止
}

//swift版枚举数组元素
for (idx,elem) in arr.enumerated() {
    print(idx,elem)
    if idx == 2 { break}
}




//MARK: - 获取某个变量的指针
//1、调用withUnsafePointer(to: &age) {$0}系列方法
var age = 10

//@inlinable public func withUnsafePointer<T, Result>(to value: T, _ body: (UnsafePointer<T>) throws -> Result) rethrows -> Result
var ptr1 = withUnsafePointer(to: &age) { (p) -> Int in
    return 20
}


//withUnsafePointer的方法定义类似这样：
//func withUnsafePointer<Result>(to: UnsafePointer<T>,body: (UnsafePointer<T>) -> Result ) -> Result {
//    return body(to)
//}

var ptr12 = withUnsafePointer(to: &age) {$0}    //$0代表方法的第一个参数，第二个参数是尾随闭包
var ptr13 = withUnsafeMutablePointer(to: &age) { (p) -> Int in
    return p.pointee
}
var ptr14 = withUnsafeMutablePointer(to: &age) {$0}
var ptr15 = withUnsafeMutablePointer(to: &age) {UnsafeMutableRawPointer($0)}   //UnsafeMutableRawPointer的构造函数参数可以是withUnsafeMutablePointer

ptr15.storeBytes(of: 33, as: Int.self)  //原始指针必须调用storeBytes方法存储某类型数据进内存
print(ptr15.load(as: Int.self))



//MARK: - 获取堆空间的指针
//1、withUnsafePointer返回的指针式 变量名 所在的地址值，而变量内存的内容是 实例在堆空间的地址值
//2、UnsafeMutableRawPointer(bitPattern: 0x000000001234)可以获取指向某地址的指针。由此可以获取到堆空间的指针（而非引用）
class Person{
    var age: Int
    init(age: Int) {
        self.age = age
    }
    deinit {
        print("Person deinit ~~")
    }
}
var per = Person(age: 20)       //编译器提示为Person类型，但实际是指针
var ptr2 = withUnsafePointer(to: &per) { $0 }   //思考ptr2是引用变量名的地址值，还是实例对象在堆空间的地址值？

print(ptr2) //打印出来的是per变量名所在的内存的地址，而不是per指向的地址值
var _ = ptr2.pointee.age
var _ = per.age


var age1 = 21
var ptr21 = withUnsafePointer(to: &age1) { $0 }

//该方法可以获取指向某地址的指针
var ptr22 = UnsafeMutableRawPointer(bitPattern: 0x000000001234) //传入地址值，如果地址值存在则返回该指针，是可失败构造器，可nil


var ptr23 = withUnsafePointer(to: &per) { UnsafeRawPointer($0)} //获取per变量名所在的地址值指针
var perAddress = ptr23.load(as: Int.self )    //加载内存地址的值，直接操作内存，而不经过转换；因为per默认直接是去引用实例

var heapPtr = UnsafeMutableRawPointer(bitPattern: perAddress)  //获取 实例所在堆空间的地址值 的指针


//MARK: - 创建指针，堆空间
//1、malloc方法返回UnsafeMutableRawPointer指针，原始指针
//2、advanced返回偏移后的新指针
//3、只有mutable的指针才可以分配内存
//4、范型指针的allocate方法的参数是容量，而不是偏移

var ptr3 = malloc(32)   //分配32个字节的堆空间
//存
ptr3?.storeBytes(of: 10, as: Int.self)      //存Int类型到当前指针的内存（Int是8个字节）
ptr3?.storeBytes(of: 456, toByteOffset: 8, as: Int.self)    //偏移8个字节存Int类型到该指针的内存

//取
let _ = ptr3?.load(fromByteOffset: 8, as: Int.self)
free(ptr3)  //记得释放内存

var ptr31 = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1) //申请16个字节，1个字节的对齐

ptr31.storeBytes(of: 857, toByteOffset: 8, as: Int.self)
var ptr32 = ptr31.advanced(by: 8)   //放回当前指针偏移8个字节后的指针

ptr31.deallocate()  //释放内存

var ptr33 = UnsafeMutablePointer<Int>.allocate(capacity: 2) //2是指两个Int类型的内存空间
ptr33.initialize(to: 36)    //初始化内存，即赋值
ptr33.successor().initialize(to: 46)   //后继，下一个元素的地址
ptr33.successor().successor().initialize(to: 56)   //后继，下一个元素的地址

print(ptr33.pointee)        //类似于c语言的语法，36
print((ptr33 + 1).pointee)  //46
print((ptr33 + 2).pointee)  //56

ptr33.deallocate()  //释放内存


var ptr34 = UnsafeMutablePointer<Person>.allocate(capacity: 3)

ptr34.initialize(to: Person(age: 10))       //初始化多少个person，就要销毁多少个person，这样创建的对象不会自动释放
(ptr34 + 1).initialize(to: Person(age: 20))
(ptr34 + 2).initialize(to: Person(age: 30))

ptr34.deinitialize(count: 3)        //销毁实例，不然会产生内存泄漏
ptr34.deallocate()

//MARK: - 指针间的转换
//1、泛型指针转换为原始指针，可以直接通过原始指针的构造器传参转换
//2、原始指针转换为泛型指针，可以通过原始指针的assumingMemoryBound(to: Int.self)方法，参数是范型的类
//3、原始指针ptr + 8 是偏移8个字节的距离，范型指针ptr + 8 是偏移8个元素的距离
//4、unsafeBitCast(ptr4, to: UnsafeMutablePointer<Int>.self)强制转换指针类型，全局函数
//5、unsafeBitCast是忽略数据类型的强制转换，不会因为数据类型的变化而改变原来的内存数据，而Int转Double这些的强制类型转换，是会修改内存数据的
//6、因为指针存的都是地址值，所以忽略数据类型的强转对指针而言，没有影响，地址值肯定是一样的。
var ptr4 = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1)

var ptr41 = ptr4.assumingMemoryBound(to: Int.self)  //原始指针转换为Int类型的指针

ptr41.pointee = 22

(ptr4 + 8).assumingMemoryBound(to: Double.self).pointee = 23.2

var _ = unsafeBitCast(ptr4, to: UnsafeMutablePointer<Int>.self)
print(unsafeBitCast(ptr4 + 8, to: UnsafeMutablePointer<Int>.self).pointee)

ptr4.deallocate()

var intAge = 12
var dAge = unsafeBitCast(intAge, to: Double.self)
print("Int: \(intAge)","double age: \(dAge)")
