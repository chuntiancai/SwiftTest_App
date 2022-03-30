## 属性


## 实例属性（Instance Property）：只能通过实例去访问
跟实例相关的属性分为两大类：存储属性、计算属性。

> 1.2、存储实例属性（Stored Instance Property）：存在实例的内存里面（堆空间）
> 1.3、计算实例属性（Computed Instance Property）：其实就是方法，
> 每次调用方法的时候，编译器就会执行那个方法的汇编代码，也就是把那一段方法的汇编代码放到当前的IP寄存器上执行。
    所以这是由编译器维护的，不是由类来维护。

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
    
    struct Point8 {
        var x:Int   //占8个字节
        var y:Int   //占第二个8个字节
        init() {
            x = 10
            y = 20
        }
    }
    

### 存储属性
> 类似于成员变量，存储在实例的内存中，结构体、类可以定义存储属性，枚举不可以定义存储属性。
> 在创建一个类或结构体的实例的时候，必须为所有的存储属性设置一个合适的初始值，在初始化方法执行完成之前，必须都有值。
    通过在初始化方法里面赋值，或者编译器自动生成的构造器。
    注意一点是，只有没有定义任何构造器的时候，编译器才会自动生成构造器。
> 只能为非lazy的var存储属性设置属性观察器

#### 属性观察器: willSet,didSet
> 1、只能为非lazy的var存储属性设置属性观察器
> 2、全局变量，局部变量均可以使用属性观察器
> 3、初始化不会触发属性观察器
> 4、实质上willSet和didSet方法是通过set方法间接进行调用的，inout会把局部变量的地址值传入到方法体内部，即便局部变量在栈空间(作为临时中介变量)；
        然后属性观察器就会根据这个局部变量去修改真正的属性变量。
        而willSet后面会调用didSet方法。


### 计算属性
> 计算属性的本质就是方法，方法本身就不占用实例的内存，枚举、类、结构体都可以定义方法
> 可以有只读的计算属性（只有get方法），计算属性只能用var，不能用let，因为get方法的返回值是可变的，而let的语义规定了是常量，不可变。
> 不可以设置属性观察器

##### get和set的本质是方法

struct Shape8 {
    var width:Int
    var side: Int{  //willset和didset是存储属性,其实再深层一点willset和didset是通过set和get来调用的
        willSet{
            print("shape willset",newValue)//inout 关键字不会直接拿出side的地址值，而是拷贝出它的值，然后再通过set方法来设置的，而不是直接就是设置的
        }
        didSet{
            print("shape didset",oldValue)
            //带有属性观察器的存储属性，也是传递一个临时变量的地址给inout关键字，而这个临时变量由didiset、willset方法维护
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
    
    func show(){ }
}




    
### 延迟存储属性（lazy stored property）
> 使用lazy可以定义一个延迟存储属性，在第一次调用到该属性的时候才会被初始化，注意初始化是指第一次初始化，只有第一次才叫初始化，其余的叫赋值。
> 1、记得类是在堆空间分配内存的，而不是代码段的汇编指令维护的，所以lazy就决定了实例中的lazy变量在堆中的分配内存时机，
         即用到该属性的时候，才分配堆空间来安排该属性
> 2、lazy只能是var属性，swift规定let属性必须在构造器完整完成之前必须有值，即构造器未完成的时候，let可以暂时没有值
> 3、多条线程访问lazy属性时，无法保证lazy属性只被分配一次，即lazy不是线程安全的
> 4、当结构体包含一个延迟存储属性的时候，只有结构体的实例为var变量的时候才可以访问结构体内部的延迟属性。
        因为延迟属性初始化时需要改变结构体的内存结构
    
    class Car4{
        init(){
            print("Car Init")
        }
        func run(){
            print("Car run")
        }
    }

    class Person4 {
        lazy var car = Car4()   //延迟的存储属性，是存储属性
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
        }()     //闭包表达式，即函数调用赋值给lazy属性，即用到该lzay属性时，就会调用该闭包表达的代码，只会执行一次(多线程则无法保证只执行一次)
    }

### inout关键字的本质是传递地址

    struct Shape4 {
        var width:Int
        var side: Int { //存储属性
            willSet{
                print("will set radius",newValue)
            }
            didSet{
                print("did set radius",oldValue,radius)
            }
        }
        
        var diameter: Int{  //计算属性
            set{
                width = newValue
            }
            get{
                return width      //只有一条表达式，省略了return，不能在get方法里面调用set方法 
            }
        }
    }

    func testInout(_ num: inout Int){   //testInout(&num1),实质上就是传入num1的地址值，指针传递
        num = 32
    }
    var s = Shape4(width: 2, side: 4, radius: 23)
    testInout(&s.width) //传入的是s的地址值，然后根据.符号找到width
    testInout(&s.side) //传入的是s的地址值，然后根据.符号找到width
    testInout(&s.diameter) //传入的不是是s的地址值，因为diameter不是存储属性，而是函数的代码段地址

> inout 只传递地址，如果传入的是有属性观察器的属性，那么传入的就是属性观察器方法的地址。 通过inout修改存储属性，也是会触发属性观察器的

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


#### inout本质总结，
> 1、如果实参有自己的物理，且没有设置属性观察器，则inout会直接将实参的内存地址传入函数（实参进行引用传递）
> 2、如果实参是计算属性 或者 设置了属性观察器；那么编译器采取copy in copy out的做法（先get后set），
         编译器会把相应的汇编代码拷贝到响应的逻辑流中的。
> 2.1、调用该函数时，先复制实参的值，产生副本（局部变量，即在栈空间开辟一个局部变量作为中介）（get）；副本说的就是那个局部变量
> 2.2、将副本的内存地址传入函数（副本进行引用传递），在函数内部可以修改副本的值；关键就是这个副本的内存地址被传递
> 2.3、函数返回后，再将副本的值覆盖实参的值（set）；做这么多就是为了触发属性观察器
> 2.4、所以传递的归根到底都是地址，要么是属性的真实地址，要么就是一个临时变量的地址作为中介
> 所以inout的本质就是地址传递，也叫做引用传递


## --------------------------------
    
## 类型属性（Type Property）：只能通过类型去访问

> 2.1、存储类型属性（Stored Type Property）：不占用类型的实例的内存，即不占用堆空间；(整个App中只有一份内存)
> 类型只是一个索引，而存储的类型属性是全局唯一的一个地址上的变量，其实与类型的内存无关，只是通过类型的名字来引用；（在app的代码段）
> 2.2、计算类型属性。
>可以通过static来定义类型属性
>如果是类，也可以用关键字class来定义，但是结构体只能用static来定义
>类型属性必须在声明是手动赋予初始值，因为类型没有init构造器，它不是实例


### 存储型的类型属性默认是lazy属性，第一次调用时才会初始化。
        （也就是只执行一次初始化代码，也可以理解为只执行一次闭包，一样的道理，所以也可以是闭包）线程安全。
>可以是let，因为let只是约束了实例初始化完成之前必须有值，没有约束类；
>枚举不能定义实例的内存属性，因为枚举是值类型，不在堆空间；但是可以定义类的存储属性，因为类的存储属性不在堆空间，不在实例里面；


###  类型属性的经典应用就是单例模式，因为线程安全，且唯一
>let要求必须在初始化完成之前，属性必须有值；而lazy则运行初始化完成之后，首次调用时才赋值也可以，所以let和lazy刚好是矛盾的，故不能共存。

------------------------------------------------------------------------------------
##### 单例模式（类型属性的应用）：
    
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

------------------------------------------------------------------------------------------------------------------------------


### 类型属性的内存地址
>  静态属性的初始化代码是一个闭包，也就是一个方法。
    这个方法是在一个安全的线程中执行的，调用了swift_once，就是gcd的dispatch_once，先调用线程，再在线程里面调用方法，线程安全。
>  所以静态属性的内存地址和全局变量的地址是在同一段内存空间的（代码段），然后放在类里面和外面的不同是：
    类里面的静态属性附加了一些约束条件(访问控制)，会触发一些方法或者动作，编译器会把这些动作的汇编代码放在恰当调用的位置的。

    let a = 10
    var b = 11  //类里面静态属性的内存地址和全局变量的地址是在同一段内存空间的（代码段）。类里面的静态属性多了访问控制。
    
    class Car9{
        static var count = 0
    }
    Car9.count = 13     //所以静态属性就是调用了swift_once， 就是gcd的dispatch_once，为了保证只执行一次，并且线程安全

