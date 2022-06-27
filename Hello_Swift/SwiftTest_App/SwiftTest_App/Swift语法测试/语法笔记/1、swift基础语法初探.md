##  Swift基础语法，汇编初探

## 语法环境

### 编译器与命令
swiftc是swift的编译器，存放在Xcode内部:Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
一些操作:
生成语法树： swiftc -dump-ast main.swift
生成最简洁的SIL代码：swiftc -emit-sil main.swift
生成LLVM IR代码： swiftc -emit-ir main.swift -o main.ll
生成汇编代码： swiftc -emit-assembly main.swift -o main.s

swift代码经过编译转换成可执行代码的各个中间代码流程，参考https://swift.org/swift-compiler/#compiler-architecture

### 内存地址从低到高：
#### 代码区 --> 常量区 --> 全局区（数据段）--> 堆空间 --> 栈空间 -->  动态库

### 编译过程：
#### OC,Swift源文件  --> Mach-O可执行文件 --> 虚拟内存分布：[(其他信息) : (Mach-O) : (内存) : (动态库) : (其他)  ]


---------------------------------------------------------------------------------------------------------------------------------------
##### 语法小知识（API与ABI）
API（Application Programming Interface）：应用程序编程接口
        源代码和库之间的接口
ABI（Application Binary Interface）：应用程序二进制接口
        应用程序与操作系统之间的底层接口
涉及的内容有：目标文件格式、数据类型的大小\布局\对齐、函数调用约定等等

--------------------------------------------------------------------------------------------------------------------------------------------

## swift语法
#### 数据类型
数据类型：
    值类型：
                枚举(enum)：Optional；
                结构体(struct)：Bool,Int,Float,Double,Chracter；String,Array,Dictionary,Set 
    引用类型：
                    类(class)
直接写出来的值，叫做字面量，就是字面的上显示的意思。

#### 区间类型：
    let range1: ClosedRange<Int> = 1...3
    let range2: Range<Int> = 1..<3
    let range3: PartialRangeThrough<Int> = ...5

    // 字符、字符串也能使用区间运算符，但默认不能用在for-in中
    let stringRange1 = "cc"..."ff" // ClosedRange<String>
    stringRange1.contains("cb") // false
    stringRange1.contains("dz") // true
    stringRange1.contains("fg") // false
    let stringRange2 = "a"..."f"
    stringRange2.contains("d") // true
    stringRange2.contains("h") // false

    // \0到~囊括了所有可能要用到的ASCII字符
    let characterRange: ClosedRange<Character> = "\0"..."~"
    characterRange.contains("G") // true

##### 区间运算Range
    let range = 1...3
    for i in range {
        print(names[i])
    }

    let names = ["Anna", "Alex", "Brian", "Jack"]
    for name in names[0...3] {
        print(name)
    }

##### 带间隔的区间值
    let hours = 11
    let hourInterval = 2
    // tickMark的取值：从4开始，累加2，不超过11
    for tickMark in stride(from: 4, through: hours, by: hourInterval) {
        print(tickMark)
    } // 4 6 8 10


#### switch语法
##### 使用fallthrough可以实现贯穿效果
    var number = 1
    switch number {
    case 1:
        print("number is 1")
        fallthrough
    case 2:
        print("number is 2")
    default:
        print("number is other") 
    }
##### 复合条件匹配
    switch string {
    case "Jack", "Rose":
        print("Right person")
    default:
        break
    } // Right person

##### 区间匹配、元组匹配
    let count = 62
    switch count {
    case 0:
        print("none")
    case 1..<5:
        print("a few")
    case 5..<12:
        print("several")
    case 12..<100:
        print("dozens of")
    case 100..<1000:
        print("hundreds of")
    default:
        print("many")
    } //dozens of

    let point= (1,1)
    switch point {
    case (0, 0):
        print("the origin")
    case (_, 0):
        print("on the x-axis")
    case (0, _):
        print("on the y-axis")
    case (-2...2, -2...2):
        print("inside the box")
    default:
        print("outside of the box")
    } // inside the box


##### 匹配时值绑定
    let point = (2, 0)
    switch point {
    case (let x, 0):
        print("on the x-axis with an x value of \(x)")
    case (0, let y):
        print("on the y-axis with a y value of \(y)")
    case let (x, y):
        print("somewhere else at (\(x), \(y))")
    } // on the x-axis with an x value of 2
    //必要时let也可以改为var

#### where语法
##### 限制switch匹配的条件

    let point = (1, -1)
    switch point {
    case let (x, y) where x == y:
        print("on the line x == y")
    case let (x, y) where x == -y:
        print("on the line x == -y")
    case let (x, y):
        print("(\(x), \(y)) is just some arbitrary point")
    } // on the line x == -y

##### 限制数组的过滤的条件
    // 将所有正数加起来
    var numbers = [10, 20, -10, -20, 30, -30]
    var sum = 0
    for num in numbers where num > 0 { // 使用where来过滤num
        sum += num
    }
    print(sum) // 60

####  outer:标签语句，跳出双重for循环，也可以跳出if语句

    outer: for i in 1...4 {
        for k in 1...4 {
            if k == 3 {
                continue outer
            }
            if i == 3 {
                break outer
            }
            print("i == \(i), k == \(k)")
        }
    }

#### 函数的定义

##### 参数标签
    /// 可以修改参数标签，可以使用下划线_省略参数标签
    /// - Parameter time: at是参数标签，time是形参，tiem供外部传值，at仅供参考(作标签的作用)
    func goToWork(at time: String) {
        print("this time is \(time)")
    }
##### 参数可以有默认值
    func goToWork(at time: String="haha") {
        print("this time is \(time)")
    }
##### 可变参数
    func sum(_ numbers: Int...) -> Int {
        var total = 0
        for number in numbers {
            total += number
        }
        return total
    }
    // error: ambiguous use of 'sum'
    sum(10, 20)

##### inout输入输出参数
可以在函数内部修改外部实参的值
inout参数的本质是地址传递(引用传递)
inout参数只能传递能多次被赋值的

    var number = 10
    func add(_ num: inout Int) {
        num = 20
    }
    add(&number)


##### 函数重载
重写牵扯到继承，重载没有牵扯到继承
函数名相同
参数个数不同或参数类型不同或参数标签不同
但是返回值类型无关(不能用做判别重载)

##### 内联函数
> 如果开启了编译器优化(Release模式下默认开启)，编译器会自动将某些函数变成内联函数
  将函数展开成函数体
  
###### @inline(never) 永远不会被内联
//在target -> building setting -> swift compiler -code generation -> optimization level中修改优化级别

    func sum(_ v1: Int, _ v2: Int) -> Int {
        v1 + v2
    }

##### 函数类型
> 每一个函数都是有类型的，函数类型由 形式参数类型 和 返回值类型 进行判别
> 函数类型可以作为函数的参数
> 返回值类型是 函数类型 的函数，叫做高阶函数
> Void 就是空元组

    func sum(v1: Int, v2: Int) -> Int {
        v1 + v2
    }
    var fn: (Int,Int) -> Int = sum 
    fn(2,3) //调用时不需要传递标签

##### 高阶函数
##### 嵌套函数


#### typealias 给类型起别名


### Any、AnyObject类型，不是类(相似协议)
>  Swift提供了2种特殊的类型：Any、AnyObject （但都不是代表类信息）
> Any：可以代表任意类型（枚举、结构体、类，也包括函数类型），不仅仅是类。
> AnyObject：可以代表任意类的类型（在协议后面写上: AnyObject代表只有类能遵守这个协议），必须是类才可以。
>  在协议后面写上: class也代表只有类能遵循这个协议

    var stu: Any = 10
    stu = "Jack"
    stu = Student()
    
    // 创建1个能存放任意类型的数组
    // var data = Array<Any>()
    var data = [Any]()
    data.append(1)
    data.append(3.14)
    data.append(Student())
    data.append("Jack")
    data.append({ 10 })

### is、as?、as!、as关键字
####  is用来判断是否为某种类型，as用来做强制类型转换
    //is 的使用
    var stu: Any = 10
    print(stu is Int) // true
    stu = "Jack"
    print(stu is String) // true
    stu = Student()
    print(stu is Person) // true
    print(stu is Student) // true
    print(stu is Runnable) // true

    //as 的使用
    protocol Runnable { func run() }
    class Person {}
    class Student : Person, Runnable {
        func run() {
            print("Student run") }
        func study() {
            print("Student study") }
    }
    var stu: Any = 10
    (stu as? Student)?.study() // 没有调用study
    stu = Student()
    (stu as? Student)?.study() // Student study
    (stu as! Student).study() // Student study
    (stu as? Runnable)?.run() // Student run
    var data = [Any]()
    data.append(Int("123") as Any)
    var d = 10 as Double
    print(d) //10.0


### self(小写)，X.self、X.Type、AnyClass的区别
#### X.self通过类的名称来调用，如：ClassName.Type
#### X.self属于X.Type类型，代表 类X 的元类型(类信息)。 ---X.self是具体类信息(元类型)，X.Type是类信息的声明。
#### AnyClass是AnyObject.Type的别名
#### AnyObject.Type代表所有类的元类型(可以理解为超类型，所以.Type是表示元类型的抽象类)
#### X.Type 描述 类的信息 的类型。 X.self 描述 自身类信息 的类型。  AnyObject.Type(超类型) --> X.Type(类对象的类型) --> X.self(类对象) --> x.self(实例对象)

>  X.self是一个元类型（metadata）的指针，metadata存放着类型相关信息（对象在堆空间的前八个字节存放的就是类型信息的指针，也就是metadata的指针）
>  X.self属于X.Type类型，X.Type代表该类的类信息。（ 类型不是类，类是类型范畴中的一员(更抽象) ）

    //X.self属于X.Type类型
    class Person {}
    class Student : Person {}
    
    //继承关系中的X.self
    var perType: Person.Type = Person.self
    var stuType: Student.Type = Student.self
    perType = Student.self
    
    ///AnyObject.Type 代表说 可以是任何类的元类型
    var anyType: AnyObject.Type = Person.self
    anyType = Student.self
    
    /// AnyClass代表AnyObject.Type
    public typealias AnyClass = AnyObject.Type
    var anyType2: AnyClass = Person.self
    anyType2 = Student.self
    
    var per = Person()
    var perType = type(of: per) // Person.self, type(of:)类似内联函数，但不是函数，不知道底层怎么实现的
    print(Person.self == type(of: per)) //true



### X.self元类型的应用
#### 元类型代表这个类的类信息，可以调用类的初始化器
   
    /// 元类型代表这个类的类信息，可以调用类的初始化器
    class Animal { required init() {} }
       class Cat : Animal {}
       class Dog : Animal {}
       class Pig : Animal {}
       func create(_ clses: [Animal.Type]) -> [Animal] {
           var arr = [Animal]()
           for cls in clses {
               arr.append(cls.init())
           }
           return arr
       }
    print(create([Cat.self, Dog.self,Pig.self])
  
    /// 获取类的元类型里面的信息
    class Person {
        var age: Int = 0
    }
    class Student : Person {
        var no: Int = 0
    }
    print(class_getInstanceSize(Student.self)) // 32
    print(class_getSuperclass(Student.self)!) // Person
    print(class_getSuperclass(Person.self)!) // Swift._SwiftObject
    
    /// 从结果可以看得出来，Swift还有个隐藏的基类：Swift._SwiftObject
    /// 可以参考Swift源码：https://github.com/apple/swift/blob/master/stdlib/public/runtime/SwiftObject.h

### Self(大写)，也是类的元类型，只是限制在类内部代码中使用。
#### 所以限定了返回值跟方法调用者必须是同一类型（也可以作为参数类型），常用于协议中
        --- 大写Self表示此刻当前的类信息，不能用于父子的类型转换，只代表当前代码的当前类型信息。 小写self则可以是继承层级关系中，真实的实例主体，但是实例属于哪一个层级，暂时不可知。如果是.self则表示是当前层级的具体类信息。
> Self代表当前类型

    class Person {
        var age = 1
        static var count = 2
        func run() {
            print(self.age) // 1
            print(Self.count) // 2  ,大写Self
    }
    
> Self一般用作返回值类型，限定返回值跟方法调用者必须是同一类型（也可以作为参数类型）
    类似OC的instanceType
> 在类中，如果Self用作 方法的返回值 时，那么返回值必须是通过 required初始化器 返回的Self 
    
    protocol Runnable {
        func test() -> Self //限定返回值跟方法调用者必须是同一类型（也可以作为参数类型），例如父子类就不是同一个类型
    }
    class Person : Runnable {
        required init() {}  //初始化器是required
        func test() -> Self { type(of: self).init() }   //通过 required初始化器 返回Self 
    }
    class Student : Person {}

    var p = Person()   
    print(p.test())  // Person

    var stu = Student() 
    print(stu.test())   // Student



### do 语句，实现局部作用域
    do {
        let dog1 = Dog()
        dog1.age = 10
        dog1.run()
    }
    
    
