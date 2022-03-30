## iOS标准库的基础知识
>> 参考链接：https://www.jianshu.com/p/6ebda3cd8052

## Runtime的介绍
### Runtime是将OC转换为纯C的一个库(用汇编和C写的)
    OC并不能直接编译为汇编语言，而是要先转写为纯C语言再进行编译和汇编的操作，从OC到C语言的过渡就是由runtime来实现的。
    Objective-C 是一个动态语言，这意味着它不仅需要一个编译器，也需要一个运行时系统来动态得创建类和对象、进行消息传递和转发。
    runtime是 Objective-C 面向对象和动态机制的基石。

### Objective-C Runtime是apple提供的 低级访问类型 标准库
    通过Objective-C Runtime标准库，获得对Objective-C运行时和Objective-C根类型的低级访问。
>> 参考链接：https://developer.apple.com/documentation/objectivec



## Runtime的消息(方法)传递
### Runtime时执行的流程是这样的：
     一个对象的方法像[obj foo]这样，编译器要转成消息发送机制，像objc_msgSend(obj, foo)这样。
     objec_msgSend的方法定义如下：
     OBJC_EXPORT id objc_msgSend(id self, SEL op, ...)

####  首先，通过obj的isa指针找到它的 class ;
####  在 class 的 method list 找 foo ;
####  如果 class 中没到 foo，继续往它的 superclass 中找 ;
####  一旦找到 foo 这个函数，就去执行它的实现IMP(方法的实现) 。
    但这种实现有个问题，效率低。但一个class 往往只有 20% 的函数会被经常调用，可能占总调用次数的 80% 。
    每个消息都需要遍历一次objc_method_list 并不合理。如果把经常被调用的函数缓存下来，那可以大大提高函数查询的效率。
    这也就是objc_class 中另一个重要成员objc_cache 做的事情：在找到foo 之后，把foo 的method_name 作为key ，method_imp作为value 给存起来。
    当再次收到foo 消息的时候，可以直接在cache 里找到，避免去遍历objc_method_list。从前面的源代码可以看到objc_cache是存在objc_class 结构体中的。
    
    * 方法执行的流程：
    1、系统首先找到消息的接收对象，然后通过对象的isa找到它的类。
    2、在它的类中查找method_list，是否有selector方法。
    3、没有则查找父类的method_list。
    4、找到对应的method，执行它的IMP。
    5、转发IMP的return值。


### objc_class中objc_cache缓存接收过的消息(即调用过的方法)
### 对象(object)，类(class)，方法(method)在 转换成纯C时 都是结构体


## 类对象(objc_class)
### 类对象是OC的Class，在C层面是一个单例对象，用于产生实例对象。
### Objective-C的类 实际上是指针，指向objc_class结构体，是由Class类型来表示。
### 类对象就是一个结构体struct objc_class，这个结构体存放的数据称为 “元数据(metadata)”。

    typedef struct objc_class *Class;
    
    struct objc_class {
        Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
    #if !__OBJC2__
        Class _Nullable super_class                              OBJC2_UNAVAILABLE;
        const char * _Nonnull name                               OBJC2_UNAVAILABLE;
        long version                                             OBJC2_UNAVAILABLE;
        long info                                                OBJC2_UNAVAILABLE;
        long instance_size                                       OBJC2_UNAVAILABLE;
        struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
        struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
        struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
        struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
    #endif

    } OBJC2_UNAVAILABLE;
    
    struct objc_class结构体定义了很多变量，通过命名不难发现，
    结构体里保存了指向父类的指针、类的名字、版本、实例大小、实例变量列表、方法列表、缓存、遵守的协议列表等，
    一个类包含的信息也不就正是这些吗？
    没错，类对象就是一个结构体struct objc_class，这个结构体存放的数据称为元数据(metadata)，
    该结构体的第一个成员变量也是isa指针，这就说明了Class本身其实也是一个对象，因此我们称之为类对象，类对象在编译期产生用于创建实例对象，是单例。



## 实例(objc_object)
    类对象中的元数据存储的都是如何创建一个实例的相关信息，那么类对象和类方法应该从哪里创建呢？
### 实例是从isa指针指向的结构体创建，类对象的isa指针指向的东西 我们称之为元类(metaclass)。
### 只有是类对象isa指针指向的东西 我们才称之为“元类(metaclass)”。实例对象的isa指针指向的，我们不称之为元类，爱啥啥。
    /// Represents an instance of a class.
    struct objc_object {
        Class isa  OBJC_ISA_AVAILABILITY;
    };

    /// A pointer to an instance of a class.
    typedef struct objc_object *id;


## 元类(Meta Class)
### 元类(Meta Class)是一个类对象里面的其中一个类。
### 只有是类对象isa指针指向的东西 我们才称之为“元类(metaclass)”。
### 类对象里面有很多指针，isa只是其中的一枚指针而已。
### 元类中保存了创建类对象以及类方法所需的所有信息。
    struct objc_object结构体（实例）它的isa指针指向类对象，类对象的isa指针指向了元类，super_class指针指向了父类的类对象；
    而元类的super_class指针指向了父类的元类，而这个元类的isa指针又指向了自己。

    + 元类(Meta Class)是一个类对象里面的其中一个类。
    在上面我们提到，所有的类自身也是一个对象，我们可以向这个对象发送消息(即调用类方法)。
    为了调用类方法，这个类的isa指针必须指向一个包含这些类方法的一个objc_class结构体。这就引出了meta-class的概念，元类中保存了创建类对象以及类方法所需的所有信息。
    任何NSObject继承体系下的meta-class都使用NSObject的meta-class作为自己的所属类，而(基类的)meta-class里的isa指针是指向它自己。

## Method(objc_method)方法的结构体
###  Method和我们平时理解的函数是一致的，就是表示能够独立完成一个功能的一段代码。
#### SEL method_name 方法名
#### char *method_types 方法类型
#### IMP method_imp 方法实现

    runtime.h
    /// An opaque type that represents a method in a class definition.代表类定义中一个方法的不透明类型
    typedef struct objc_method *Method;
    struct objc_method {
        SEL method_name                                          OBJC2_UNAVAILABLE; //方法名
        char *method_types                                       OBJC2_UNAVAILABLE; //方法类型
        IMP method_imp                                           OBJC2_UNAVAILABLE; //方法实现

    *** 
    Method和我们平时理解的函数是一致的，就是表示能够独立完成一个功能的一段代码，比如：
        - (void)logName{
            NSLog(@"name");
        }
    ***
    在这个结构体中国呢，我们已经看到了SEL和IMP，说明SEL和IMP其实都是Method的属性。

### SEL(objc_selector) 方法名结构体
#### SEL 是selector在Objective-C中的表示类型（Swift中是Selector类）。
#### selector是方法选择器，可以理解为区分方法的 ID，而这个 ID 的数据结构是SEL
    Objc.h
    /// An opaque type that represents a method selector.代表一个方法的不透明类型
    
    typedef struct objc_selector *SEL;
    
    *** 
    objc_msgSend函数第二个参数类型为SEL，SEL是selector在Objective-C中的表示类型（Swift中是Selector类）。
    selector是方法选择器，可以理解为区分方法的 ID，而这个 ID 的数据结构是SEL:
    *** 

    @property SEL selector;

#### selector是SEL的一个实例。其实selector就是个映射到方法的C字符串。
#### @selector( )是编译器命令
    A method selector is a C string that has been registered (or “mapped“) with the Objective-C runtime. 
    Selectors generated by the compiler are automatically mapped by the runtime when the class is loaded.

    其实selector就是个映射到方法的C字符串，你可以用 Objective-C 编译器命令@selector()或者 Runtime 系统的sel_registerName函数来获得一个 SEL 类型的方法选择器。
    
    selector既然是一个string，我觉得应该是类似className+method的组合，命名规则有两条：

        ● 同一个类，selector不能重复
        ● 不同的类，selector可以重复

    这也带来了一个弊端，我们在写C代码的时候，经常会用到函数重载，就是函数名相同，参数不同，但是这在Objective-C中是行不通的，
    因为selector只记了method的name，没有参数，所以没法区分不同的method。

    比如：
    - (void)caculate(NSInteger)num;
    - (void)caculate(CGFloat)num;

    是会报错的。

    我们只能通过命名来区别：
    - (void)caculateWithInt(NSInteger)num;
    - (void)caculateWithFloat(CGFloat)num;

    在不同类中相同名字的方法所对应的方法选择器是相同的，即使方法名字相同而变量类型不同也会导致它们具有相同的方法选择器。

## IMP指针,指向方法的实现的代码。
> 就是指向最终实现程序的内存地址的指针。
> 在iOS的Runtime中，Method通过selector和IMP两个属性，实现了快速查询方法及实现，相对提高了性能，又保持了灵活性。

    /// A pointer to the function of a method implementation.  指向一个方法实现的指针
    typedef id (*IMP)(id, SEL, ...); 
    #endif

## 类缓存(objc_cache)结构体
### 就是类似OS中的快表，用于缓存最近调用的方法
    当Objective-C运行时通过跟踪它的isa指针检查对象时，它可以找到一个实现许多方法的对象。
    然而，你可能只调用它们的一小部分，并且每次查找时，搜索所有选择器的类分派表没有意义。
    所以类实现一个缓存，每当你搜索一个类分派表，并找到相应的选择器，它把它放入它的缓存。
    所以当objc_msgSend查找一个类的选择器，它首先搜索类缓存。
    这是基于这样的理论：如果你在类上调用一个消息，你可能以后再次调用该消息。
    
    为了加速消息分发， 系统会对方法和对应的地址进行缓存，就放在上述的objc_cache。
    所以在实际运行中，大部分常用的方法都是会被缓存起来的，Runtime系统实际上非常快，接近直接执行内存地址的程序速度。

 
 ## Category(objc_category)指针
 ### Category是表示一个指向“分类”的结构体的指针，“分类”结构体的定义如下：
    struct category_t { 
        const char *name;   //name：是指 class_name 而不是 category_name。
        classref_t cls;     // cls：要扩展的类对象，编译期间是不会定义的，而是在Runtime阶段通过name对 应到对应的类对象。
        struct method_list_t *instanceMethods;      //instanceMethods：category中所有给类添加的实例方法的列表。
        struct method_list_t *classMethods;     //classMethods：category中所有添加的类方法的列表。
        struct protocol_list_t *protocols;      //protocols：category实现的所有协议的列表。
        struct property_list_t *instanceProperties;     // instanceProperties：表示Category里所有的properties，
                                                        //这就是我们可以通过objc_setAssociatedObject和objc_getAssociatedObject增加实例变量的原因，
                                                        //不过这个和一般的实例变量是不一样的。
    };
    
    从上面的category_t的结构体中可以看出，分类中可以添加实例方法，类方法，甚至可以实现协议，添加属性，不可以添加成员变量。


## Runtime消息转发，提供给你自定义动态方法的绑定
### 动态方法解析
### 备用接收者
### 完整消息转发
### 也就是Runtime机制提供了三个机会给你自定义动态方法的绑定，你直观上只需要在定义的类源文件中实现着三个方法就可以了，它会搜索检测的。

    前文介绍了进行一次发送消息会在相关的类对象中搜索方法列表，如果找不到则会沿着继承树向上一直搜索知道继承树根部（通常为NSObject），
    如果还是找不到并且消息转发都失败了就回执行doesNotRecognizeSelector:方法报unrecognized selector错。那么消息转发到底是什么呢？接下来将会逐一介绍最后的三次机会。
    ● 动态方法解析
    ● 备用接收者
    ● 完整消息转发





