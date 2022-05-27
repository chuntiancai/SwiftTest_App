

## Error处理

### 错误类型
    开发过程常见的错误：
        语法错误（编译报错）
        逻辑错误p运行时错误（可能会导致闪退，一般也叫做异常）
        .....


### 自定义Error
#### 遵循Error协议自定义运行时的错误信息
##### ⭐️类、结构体、枚举均可遵循Error协议
    
    //类遵循Error协议
    class MyError2: Error {
        var msg:String
        init(msg: String) {
            self.msg = msg
        }
    }
    
    //结构体遵循Error协议
    struct MyError: Error {
        var msg:String = "struct Error"
    }
    
    //枚举遵循Error协议
    enum SomeError : Error {
        case illegalArg(String)
        case outOfBounds(Int, Int)
        case outOfMemory
    }
    
#### 函数内部用throw，函数声明用throws，调用用try

    //函数内部通过throw抛出自定义Error，可能会抛出Error的函数必须加上throws声明
    func divide(_ num1: Int, _ num2: Int) throws -> Int {
        if num2 == 0 {
            throw SomeError.illegalArg("0不能作为除数") }
        return num1 / num2
    }

    需要使用try去调用可能会抛出Error的函数
    var result = try divide(20, 10)

#### do-catch包裹try，只能catch Error
##### 可以用catch let myError 语句来获取Error的实现体
##### do-catch的使用类似switch-case语句
>  抛出Error后，try下一句直到作用域结束的代码都将停止运行

    //可以使用do-catch捕捉Error
    func test() {
        print("1")
        do {
            print("2")
            print(try divide(20, 0))
            print("3")
        } catch let SomeError.illegalArg(msg) {
            print("参数异常:", msg)
        } catch let SomeError.outOfBounds(size, index) {
            print("下标越界:", "size=\(size)", "index=\(index)")
        } catch SomeError.outOfMemory {
            print("内存溢出")
        } catch {
            print("其他错误")
        }
        print("4")
    }
    test()
    // 1 ；2；参数异常: 0不能作为除数；4
    
    //抛出Error后，try下一句直到作用域结束的代码都将停止运行
    do {
        try divide(20, 0)
    } catch let error {
        switch error {
        case let SomeError.illegalArg(msg):
            print("参数错误：", msg)
        default:
            print("其他错误")
        }
    }



## 处理Error

### do-catch捕捉，类似catch-case语法
### 不作处理，抛给调用者
> 不捕捉Error，在当前函数增加throws声明，Error将自动抛给上层函数，如果最顶层函数（main函数）依然没有捕捉Error，那么程序将终止
    
    func test() throws {
        print("1")
        print(try divide(20, 0))
        print("2")
    }
    try test()// 1;Fatal error: Error raised at top level
    func test() throws {
        print("1")
        do {
            print("2")
            print(try divide(20, 0))
            print("3")
        } catch let error as SomeError {    //抛出的可能是as的错误
            print(error)
        }
        print("4")
    }
    try test()  // 1; 2;illegalArg("0不能作为除数");4

    do {
        print(try divide(20, 0))
    } catch is SomeError {  //没有处理所有可能出现的Error，所以编译不通过
        print("SomeError")
    }

### try?、try!不处理Error
    // try?、try!
    //可以使用try?、try!调用可能会抛出Error的函数，这样就不用去处理Error
    func test() {
        print("1")
        var result1 = try? divide(20, 10) // Optional(2), Int?
        var result2 = try? divide(20, 0) // nil
        var result3 = try! divide(20, 10) // 2, Int
        print("2")
    }
    test()
    
    //a、b是等价的
    var a = try? divide(20, 0)
    var b: Int?
    do {
        b = try divide(20, 0)
    } catch { b = nil }

### rethrows关键字，函数的声明(和throws是一样的)
    // rethrows表明：函数本身不会抛出错误，但调用闭包参数抛出错误，那么它会将错误向上抛
    func exec(_ fn: (Int, Int) throws -> Int, _ num1: Int, _ num2: Int) rethrows {
    print(try fn(num1, num2))
    }
    // Fatal error: Error raised at top level
    try exec(divide(20, 0))
    

### defer语句，在函数中定义 “离开前必须执行” 的代码块
 > defer语句：用来定义以任何方式（抛错误、return等）离开代码块前必须要执行的代码
 > defer语句将延迟至当前作用域结束之前执行，可以解决文件在catch语句中未关闭的情景，相当于java的finally
 #### ⭐️defer语句的执行顺序与定义顺序相反
 
    func open(_ filename: String) -> Int {
        print("open")
        return 0
    }
    func close(_ file: Int) {
        print("close")
    }
    func processFile(_ filename: String) throws {
        let file = open(filename)
        defer {
            close(file)
        }
        // 使用file
        // ....
        try divide(20, 0)
        // close将会在这里调用
    }
    try processFile("test.txt")
        // open
        // close
        // Fatal error: Error raised at top level
    > defer语句的执行顺序与定义顺序相反
    func fn1() { print("fn1") }
    func fn2() { print("fn2") }
    func test() {
        defer { fn1() }
        defer { fn2() }
    }
    test()// fn2 fn1



## 泛型（Generics）
### 泛型在方法中作为参数
>  泛型可以将类型参数化，也就是类型也是以一个参数的形式传进方法里面来，根据T进行处理

    //泛型在方法定义中作为参考
    func swapValues<T>(_ a: inout T, _ b: inout T) {
        (a, b) = (b, a)
    }
    var i1 = 10
    var i2 = 20
    swapValues(&i1, &i2)
    
    var d1 = 10.0
    var d2 = 20.0
    swapValues(&d1, &d2)
    
    struct Date {
        var year = 0, month = 0, day = 0 }
    var dd1 = Date(year: 2011, month: 9, day: 10)
    var dd2 = Date(year: 2012, month: 10, day: 11)
    swapValues(&dd1, &dd2)
    
    func test<T1, T2>(_ t1: T1, _ t2: T2) {}
    var fn: (Int, Double) -> () = test


### 泛型在类型中作为类型
#### 泛型无论在方法中还是类型中，都是以参数的形式确定具体类型，且必须以某种方式确定具体类型。
#### 泛型的主要迷惑点在于上下文推断得出泛型的具体类型就不需要明确写出。
#### 在上下文可以明确泛型的具体类型时，单书名号<T>可以不写，喜欢也可以写。
> 泛型的名字可以任意起，一般直接是大写的E或者T
    
    //泛型在类型的定义中作为参考
    class Stack<E> {
        var elements = [E]()
        func push(_ element: E) { elements.append(element) }
        func pop() -> E { elements.removeLast() }
        func top() -> E { elements.last! }
        func size() -> Int { elements.count }
    }
    var stack = Stack<Int>()
    stack.push(11)
    stack.push(22)
    stack.push(33)
    print(stack.top()) // 33
    print(stack.pop()) // 33
    print(stack.pop()) // 22
    print(stack.pop()) // 11
    print(stack.size()) // 0
    
    //泛型在struct
    struct Stack<E> {
        var elements = [E]()
        mutating func push(_ element: E) { elements.append(element) }
        mutating func pop() -> E { elements.removeLast() }
        func top() -> E { elements.last! }
        func size() -> Int { elements.count }
    }
    
    //泛型在enum
    enum Score<T> {
        case point(T)
        case grade(String) 
    }
    let score0 = Score<Int>.point(100)
    let score1 = Score.point(99)
    let score2 = Score.point(99.5)
    let score3 = Score<Int>.grade("A")
    //泛型可以继承
    class SubStack<E> : Stack<E>{}


## associatedtype，typealias，关联类型（Associated Type）
### 就是在变量中定义泛型，起到占位参考的作用，使用者调用时才去关联实际的类型。
### 供协议使用，作用与泛型相似，主要是针对协议，更加灵活。
### 迷惑点还是在于，上下文可推断时，可省略显示写声明。
### ⭐️泛型可以做关联类型的实际类型，但是关联类型不能作为泛型的实际类型，避免循环引用导致最终不明确返回的类型是啥。
        所以协议作为返回值时，要注意返回值的协议不能有关联类型，因为不明确关联的类型是啥。
> 关联类型的作用：给协议中用到的类型定义一个占位名称
> 协议中可以拥有多个关联类型

    //协议中声明关联类型
    protocol Stackable {
        associatedtype Element // 声明关联类型
        mutating func push(_ element: Element)
        mutating func pop() -> Element
        func top() -> Element
        func size() -> Int
    }
    
    //类型中定义关联类型，即绑定实际类型
    class StringStack : Stackable {
        // 给关联类型设定真实类型
        // typealias Element = String   //遵循协议的方法中有写具体类型，可以明确推断出Element的实际类型，故可以省略这句显示定义
        var elements = [String]()
        func push(_ element: String) { elements.append(element) }
        func pop() -> String { elements.removeLast() }
        func top() -> String { elements.last! }
        func size() -> Int { elements.count } }
    var ss = StringStack()
    ss.push("Jack")
    ss.push("Rose")
    
    //泛型绑定关联类型，泛型也可以作为关联类型的实际类型，最终的实际类型就既是泛型的实际类型，也是关联类型的实际类型
    class Stack<E> : Stackable {
        // typealias Element = E
        var elements = [E]()
        func push(_ element: E) {
            elements.append(element)
        }
        func pop() -> E { elements.removeLast() }
        func top() -> E { elements.last! }   //遵循协议的方法中有写具体类型，可以明确推断出Element的实际类型，故可以省略这句显示定义
        func size() -> Int { elements.count }
        
    }

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


## some关键字，不透明类型（Opaque Type）
### 解决方法返回值是 协议并携带关联类型 的情况，限制只能明确返回一种明确的类型
### some关键字修饰类型，some限制只能返回一种类型
> 解决方案②：使用some关键字声明一个不透明类型

    func get(_ type: Int) -> some Runnable { Car() }
    var r1 = get(0)
    var r2 = get(1)
    
> some限制只能返回一种类型

### some除了用在返回值类型上，一般还可以用在属性类型上

    protocol Runnable { associatedtype Speed }
    class Dog : Runnable { typealias Speed = Double }
    class Person {
        var pet: some Runnable {
            return Dog()
        }
    }
