OC理解上的一些注意点，易误解点，提醒点，坑点。

--------------------
day11:
---------------------------
## OC相对C语言新增的语法
### @synthesize，编译器会自动为每个 @property 添加 @synthesize ，即编译器自动给变量起别名，自动生成getter 和 setter 方法，如以下形式：
    @synthesize propertyName = _propertyName;
    使用 @synthesize 只有一个目的——给实例变量起个别名，或者说为同一个变量添加两个名字。
    iOS 6 之后 LLVM 编译器引入property autosynthesis，即属性自动合成。这行代码会创造一个带下划线前缀的实例变量名，同时使用这个属性生成getter 和 setter 方法。
#### 1、 属性生成器 @property、@synthesize；自动生成getter 和 setter 方法
    //声明属性
    @property (nonatomic,strong)NSString *name;
    //合成属性
    @synthesize name = _name;
##### 1.1、点语法实际上是对setter和getter方法的调用。
    属性的setter方法和getter方法是不能同时进行重写的，这是因为，一旦你同时重写了这两个方法，那么系统就不会帮你生成这个成员变量了，所以会报错。如果真的就想非要重写这个属性的setter和getter方法的话，就要手动生成成员变量，然后就可以重写了


### 2、分类 @interface，使用分类扩展类,无需子类化。这个跟声明的关键字一样，但是有括号括住的分类名。
        分类与继承
    @interface NSString (MyNSString)
    - (NSString *) encryptWithMD5;
    @end

### 3、协议 @protocol
        使用协议声明方法
        协议类似于C#，java中的接口
    @protocol MyProtocol
    - (void)myProtocolMethod;
    @end

### 4、Fundation框架
        创建和管理集合，如数组和字典
        访问存储在应用中的图像和其他资源
        创建和管理字符串
        发布和观察通知
        创建日期和时间对象
        操控URL流
        异步执行代码
        
### 5、异常处理@try .... @catch .... @finally
    //创建对象car
    Car *car = [Car new];
    @try {
        //调用一个没有实现的方法
        [car test];
    }@catch (NSException *exception) {
        NSLog(@"%@",exception.name);
    }@finally {
        NSLog(@"继续执行!\n");
    }

## #import和#include的区别，#import是预处理指令。
### 1、#import与#include的类似，都是把其后面的文件拷贝到该指令所在的地方
### 2、#import可以自动防止重复导入
### 3、#import <> 用于包含系统文件
### 4、#import""用于包含本项目中的文件
### 5、#import , 告诉编译器找到并处理名为Foundation.h文件,这是一个系统文件,#import表示将该文件的信息导入到程序中。
    框架地址xcode: /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneO S.sdk/System/Library/Frameworks/
## NSLog可以格式化输出。
    是Foundation框架提􏰀供的Objective-C日志输出函数,与标准C中的printf函数类似,并可以格式化输出。
    NSLog传递进去的格式化字符是NSString的对象,而不是char *这种字符串指针，NSLog输出的内容中会自动包含一些系统信息。
    NSLog(@“this is a test”); //打印一个字符串
    NSString *str = @"hello xiaomage!”;
    NSLog(@"string is:%@",str);//使用占位符,%@表示打印一个对象,%@ OC特有的
    NSLog(@"x=%d, y=%d",10,20);//使用多个占位符,%d表示整型数

## “@”的使用方法
### 1、@"" 这个符号表示将一个C的字符串转化为OC中的字符串对象NSString.
### 2、@符号 OC中大部分的关键字都是以@开头的,比如@interface,@implementation,@end @class等。
### 3、注意: OC中的NSLog对C语言的字符串支持不是很好, 如果返回的是中文的C语言字符串可能输出的是乱码, 也有可能什么都不输出。

## NS前缀：看到NS前缀就知道是Cocoa中的系统类的名称
    NS来自于NeXTStep的一个软件 NeXT Software
    OC中不支持命名空间(namespace)， NS是为了避免命名冲突而给的前缀。

## OC中定义一个类也分为声明和实现。
## 声明一个类：OC中的类其实本质就是一个结构体, 所以实例对象的这个指针其实就是指向了一个结构体。
### 1、必须以@interface开头，@end结尾
### 2、成员变量的声明，必须写在@interface与@end之间的大括号中
### 3、方法的声明必须在{}下面，不能写在{}中
## 实现一个类：类可以只有实现没有声明，在开发中不建议这样写。
### 1、必须以@implementation开头，@end结尾
### 2、类名必须和声明的一致
    @implementation MyClass

    - (id)initWithString:(NSString *)aName
    {
        //写代码处
    }

    + (MyClass *)myClassWithString:(NSString *)aName
    {
        //写代码处
    }

    @end
    
    Iphone *p = [Iphone new];
    p->_size = 3.5; //可以通过这种c语言的方法来访问属性，也可以通过点语法。

## 通过一个类创建一个对象的过程：
### 1、 [Car new];做了三件事，new是NSObject的方法。new是alloc 和 init的结合体。
    每次new都会创建一个新的对象, 分配一块新的存储空间
    1.在堆内存中开辟了一块新的存储空间
    2.初始化成员变量(写在类声明大括号中的属性就叫成员变量,也叫实例变量)
    3.返回指针地址
### 2、每个实例对象都会被自动生成一个isa属性，指向自己的类对象。
    1.开辟存储空间, 通过new方法创建对象会在堆 内存中开辟一块存储空间
    2.初始化所有属性
    3.返回指针地址
    
    创建对象的时候返回的地址其实就是类的第0个属性的地址
    但是需要注意的是: 类的第0个属性并不是我们编写的_age, 而是一个叫做isa的属性
    isa是一个指针, 占8个字节
    
    其实类也是一个对象, 也就意味着Person也是一个对象
    平时我们所说的创建对象其实就是通过一个 类对象 来创建一个 新的对象
    类对象是系统自动帮我们创建的, 里面保存了当前对象的所有方法
    而实例对象是程序自己手动通过new来创建的, 而实例对象中有一个isa指针就指向了创建它的那个类对象
    
## 一个类中，对象的方法声明：
### 1、方法类型标识符--放回值类型--方法签名关键字--参数类型--参数名；
### 2、你也可以叫做方法名、参数标签。

## 一个类中，对象方法的实现。所以方法的实现是指你设计方法的实现体。
### 1、必须写在以@implementation开头，@end之间
### 2、在声明的后面加上{}即表示实现
### 3、将需要实现的代码写在{}中

## 类方法：
### 1、类方法中不能访问实例(成员)变量,因为类方法由类来调用,并没有创建存储空间来存储类中的成员变量。成员变量在内存的堆空间。
### 2、节省内存空间、不依赖于对象,执行效率更高、能用类方法解决的问题,尽量使用类方法;
### 3、类方法和对象方法可以同名。

## 消息机制：使用对象(或类)调用方法就是OC中的消息机制
## OC中方法的注意点：
### 1、方法可以没有声明只有实现。继承的时候容易混淆，编译器不提示。
### 2、方法可以只有声明没有实现, 编译不会报错, 但是运行会报错 unrecognized selector sent 。。。
    如果方法只有声明没有实现, 那么运行时会报: 
    reason: '+[Person demo]: unrecognized selector sent to class 0x100001140'
    发送了一个不能识别的消息, 在Person类中没有+开头的demo方法
    reason: '-[Person test]: unrecognized selector sent to instance 0x100400000'
## C语言中的函数和OC中的方法的区别：
### 1、函数属于整个文件, 方法属于某一个类。方法如果离开类就不行
### 2、函数可以直接调用, 方法必须用对象或者类来调用
#### 2.1、注意: 虽然函数属于整个文件, 但是如果把函数写在类的声明中会不识别。
### 3、不能把函数当做方法来调用, 也不能把方法当做函数来调用。

## 局部变量：写在方法体里的临时变量。
### 1、存储在 栈，从定义的那一行开始, 一直到遇到大括号或者return。系统会自动给我们释放
    // 写在函数或者代码块中的变量, 我们称之为局部变量
    // 作用域: 从定义的那一行开始, 一直到遇到大括号或者return
    // 局部变量可以先定义再初始化, 也可以定义的同时初始化
    // 存储 : 栈
    // 存储在栈中的数据有一个特点, 系统会自动给我们释放
    
## 全局变量：写在文件的作用域的变量，不属于类或者方法的作用域，而是整个App。
### 1、存储: 静态区。写在函数和大括号外部的变量。直到程序结束才会释放。
    // 写在函数和大括号外部的变量, 我们称之为全局变量
    // 作用域: 从定义的那一行开始, 一直到文件末尾
    // 局部变量可以先定义在初始化, 也可以定义的同时初始化
    // 存储: 静态区
    // 程序一启动就会分配存储空间, 直到程序结束才会释放
    int a;
    int b = 10;


## 成员变量：类作用域里面声明或定义的变量。
### 1、存储：堆。 不会被自动释放, 只能程序员手动释放
    @interface Person : NSObject
    {
        // 写在类声明的大括号中的变量, 我们称之为 成员变量(属性, 实例变量)
        // 成员变量只能通过对象来访问
        // 注意: 成员变量不能离开类, 离开类之后就不是成员变量 \
                成员变量不能在定义的同时进行初始化
        // 存储: 堆(当前对象对应的堆的存储空间中)
        // 存储在堆中的数据, 不会被自动释放, 只能程序员手动释放
        int age;
    }
    @end

## OC编写的常见语法错误：
    //    1.只有类的声明，没有类的实现
    //    2.漏了@end
    //    3. @interface和@implementation嵌套
    //    4.成员变量没有写在括号里面
    //    5.方法的声明写在了大括号里面
    //    6.成员变量不能在{}中进行初始化、不能被直接拿出去访问
    //    7.方法不能当做函数一样调用
    //    8.OC方法只能声明在@interface和@end之间，只能实现在@implementation和@end之间。也就是说OC方法不能独立于类存在
    //    9.C函数不属于类，跟类没有联系，C函数只归定义函数的文件所有
    //    10.C函数不能访问OC对象的成员
    //    11.低级错误：方法有声明，但是实现的时候写成了函数
    //    12.OC可以没有@interface同样可以定义一个类
    
    
--------------------
day12:
-------------------- 
## OC中的字符串：是一个对象，所以要用@关键字标明，与C 语言的区分，因为C语言的字符串不是对象。
### 1、只需要在C语言字符串前面加上@符号, 系统就会自动将C语言字符串转换为OC字符串。
     注意: 输出C语言的字符串使用%s
          输出OC的字符串使用%@,  %@就专门用于输出对象类型的
    char *name1 = "lnj";    //C语言的字符串实现
    NSString *str = @"lk";  //OC的字符串实现，前面加@关键字
   
    NSLog(@"content = %s", [p loadMessage]);
    NSLog(@"content = %@", [p loadMessage]);
    NSLog(@"age = %i", p->age); //也可以通过指针的方式访问属性

## 属性： 必须写到{}中, 属性名称以_开头，但@property是让指令编译器帮我们编写号这些属性的代码。
    @interface 类名 : NSObject
    {
       属性; // 属性必须写到{}中, 属性名称以_开头
    }
    方法; // 方法必须写到{}外面
    @end

### 1、方法的声明必须写在类的声明中
#### 1.1、方法的实现只能写在@implementation和@end之间。
#### 1.2、在OC方法中()就一个作用, 用来括住数据类型。
    - (int)addNum1:(int)num1 andNum2:(int)num2; // 每个参数数据类型前面都必须写上:，没有参数就不要写:。

### 2、成员变量不能在定义(声明)的时候进行初始化。声明，定义，实现，赋值。
#### 2.1、方法叫声明，实现。成员变量叫定义，初始化，赋值。
    @interface Person : NSObject
    {
        @public
        int age;
        double height; // 成员变量不能在定义的时候进行初始化
    }
    - (void)study; // 方法只能写在{}外面
    @end

### 3、地址只能使用指针保存，所以OC中的对象引用的都是指针。注意方法中参数的值传递。
    Person *p = [Person new];


## 结构体：只能在定义的时候初始化，系统并不清楚它是数组还是结构体
### 1、结构体和基本数据类型的内存分配一样，只是用来存储数据，默认在栈空间，可以被拷贝到堆空间，但只是存储数据的容器而已， 没有引用计数这些概念。
### 1.1、结构体肯定也有它的指令代码啊，所有你写过的东西都是有指令代码的啊，只是有可能被优化了而已。
    typedef struct {
        int year;
        int month;
        int day;
    } Date;         //和C语言的结构体写法一样，Date是整个结构体的别名，这个结构体没有名字，只有别名。
    Date d1  = {1999, 1, 5};
    Date d2;
    d2 = d1; // 本质是将d1所有的属性的值都拷贝了一份赋值给d;

### 1.2、结构体的赋值是直接拷贝，不是引用传递，而是直接的空间拷贝。所以结构体作为属性时，也是直接申请结构体的空间。
    方法三:分别赋值，说明是直接赋值给 属性的结构体的存储空间赋值，生成对象时就分配了对应的结构体空间给属性。
    Student *stu = [Student new];
    //因为结构体已经初始化为0了,在次初始化就报错了,但是可以逐个赋值。因为这样写{1990,12,3};是表示初始化的意思。可以赋值，不可以再次初始化。
    //p->_birthday = {1990,12,3};
    stu->_birthday.year = 1986;
    stu->_birthday.month = 1;
    stu->_birthday.day = 15;

### 1.3、而对象作为方法的参数，是地址传递的，而不是拷贝。
### 1.4、通过new创建出来的对象存储在堆中, 堆中的数据不会自动释放。ARC的话会管理，MRC的话，要自己释放。
## 多个源文件开发中, 要使用谁就导入谁的.h文件就可以了。如果导入.m文件会报重复定义错误。
### 1、@interface和@implementation的分工：@interface就好像暴露在外面的时钟表面，@implementation就好像隐藏在时钟内部的构造实现。
## 匿名对象就是没有名字的对象，但只要调用new方法都会返回对象的地址，每次new都会新开辟一块存储空间。
### 1、当对象只需要使用一次的时候就可以使用匿名对象，例如可以作为方法的参数(实参)。方法执行完后会释放方法栈，不会保留指针。

## xcode小技巧：修改源文件头部的项目模板。
    修改项目模板以及main函数中的内容
     /Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/Project Templates/Mac/Application/Command Line Tool.xctemplate/
     
     修改OC文件头部的描述信息
     /Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/File Templates/Source/Cocoa Class.xctemplate
     
     Xcode文档安装的位置1:
     /Applications/Xcode.app/Contents/Developer/Documentation/DocSets
     注意: 拷贝之前最好将默认的文档删除, 因为如果同时存在高版本和低版本的文档, 那么低版本的不会显示
     
     Xcode文档安装的位置2:
     /Users/你的用户名/Library/Developer/Shared/Documentation/DocSets
     如果没有该文件夹可以自己创建一个

## 阅读文档小技巧：
    关键字说明

    Getting Started —— 新手入门，一般来说，是给完全的新手看的。建议初学者看看，这里面有一些建立观念的东西，有了这些建立观念的东西，后面的学习就比较容易了。
    Guides —— 指南，指南是Xcode里面最酷最好的部分，学会看指南则大多数情况完全不用买书。Xcode文档里面的指南，就是一个一个问题的，从一个问题，或者系统的一个方面出发，一步一步详细介绍怎么使用Cocoa库的文档。一般程序员比较熟悉的是Reference，就是你查某个类、方法、函数的文档时候，冒出来的东西。那些其实是一点一点的细碎知识，光看那些东西就完全没有脉络。而Guides就是帮你整理好的学习的脉络。
    Reference —— 参考资料。一个一个框架一个一个类组织起来的文档，包含了每个方法的使用方法。
    Release Notes —— 发布说明。一个iOS新版本带来了哪些新特性，这样的信息，熟悉新iOS，比较不同iOS版本API不同，都需要参考这些文档。
    Sample Code —— 示例代码。苹果官方提供的一些示例代码，帮助你学习某些技术某些API。非常强烈建议学习的时候参考， 一方面光看文档有时候还是很难弄明白具体实现是怎么回事儿。另外一方面这些示例代码都是苹果的工程师写的，你从示例代码的变迁可以看到苹果官方推荐的代码风格流变。
    Technical Notes —— 技术说明。一些技术主题文章，有空的时候可以浏览一下。往往会有一些收获。
    Technical Q&A —— 常见技术问答。这是技术社区里面一些常见问题以及回答的整理。
    Video —— 视频。目前主要是WWDC的视频，实际上是登录到开发者网站上去浏览的，这里就是快捷方式。 想深入学习的话，一定不能错过，大量的看，不仅可以学好技术，还可以练好英文。

    这里面的Reference、Release Notes、Sample Code、Technical Notes、Technical Q&A，一般来说只是备查的。主要要看的是Getting Started和Guides。
    
    

    Start Developing iOS Apps Today
        马上着手开发 iOS 应用程序, 建立基本iOS开发概览

    iOS Technology Overview
        iOS技术概览,阅读这个文档的目的和检测标准是，遇到具体问题，知道应该去看哪方面的文档

    iOS Human Interface Guidelines
        iOS 人机交互指南,阅读这个文档的目的和检测标准是，看到任何一个App，你可以知道它的任何一个UI是系统控件，还是自定义控件，它的层次关系等等。

    Programming with Objective-C
        学习OC基础语法,阅读这个文档的目的和检测标准是，看得懂基本的Objective-C代码，方便后面的学习和阅读各种示例代码

    App Programming Guide for iOS
        iOS应用程序编程指南,介绍的就是开发一个App的完整流程，包括App的生命周期、休眠、激活等等. 阅读这个文档的目的和检测标准是，了解全部流程和很多细节问题

    View Programming Guide for iOS

    View Controller Programming Guide for iOS
        阅读这两个文档的目的和检测标准是，深刻理解什么是View，什么是View Controller，理解什么情况用View，什么情况用View Controller。

    Table View Programming Guide for iOS
        阅读这个文档的目的和检测标准是，深刻理解UITableView／UITableViewController的理论和使用方法

--------------------
day13:
--------------------
## getter-setter方法：只要用@property修饰的属性，xocde都会默认自动为我们编写getter-setter方法， ARC也是在默认的getter-setter方法做内存管理处理。
### 1、getter方法：方法名必须以set开头，而且后面跟上成员变量名去掉”_” 首字母必须大写。
    命名规范：
        必须是对象方法
        返回值类型为void
        方法名必须以set开头，而且后面跟上成员变量名去掉”_” 首字母必须大写
        必须提供一个参数，参数类型必须与所对应的成员变量的类型一致
        形参名称和成员变量去掉下划线相同
        
    如：如果成员变量为int _age 那么与之对应seter方法为
    -(void) setAge: (int) age;

### 2、setter方法：必须有返回值,返回值的类型和成员变量的类型一致，方法名必须是成员变量去掉下划线。
    命名规范：
        必须是对象方法
        必须有返回值,返回值的类型和成员变量的类型一致
        方法名必须是成员变量去掉下划线
        一定是没有参数的

    如：如果成员变量为int _age 那么与之对应geter方法为
    - (int) age;

### 3、成员变量名使用下划线开头有两个好处：与get方法的方法名区分开来。以下划线开头变量，一定是成员变量。
    可以和一些其他的局部变量区分开来,下划线开头的变量,通常都是类的成员变量。当我看到以下划线开头变量，那么他一定是成员变量。
### 4、◆ 定义了getter-setter方法就可以使用点语法，本质还是方法调用，编译器会在编译成二进制文件时，自动转换代码成调用相应的方法。
#### 4.1、当点语法使用在 “=“赋值符号左侧的时候，点语法会被展开为setter方法的调用，其他情况（等号右侧、直接使用） 为点语法展开为getter方法的调用。
#### 4.2、不要在getter 与 setter方法中使用本属性的点语法，会造成递归无限循环调用该getter-setter方法。
    如果给属性提供了getter和setter方法, 那么访问属性就又多了一种访问方式 , 点语法
    点语法其实它的本质是调用了我们的setter和getter方法
    ◆ 点语法是一个编译器的特性, 会在程序翻译成二进制的时候将.语法自动转换为setter和getter方法
    如果点语法在=号的左边, 那么编译器会自动转换为setter方法
    如果点语法在=号的右边, 或者没有等号, 那么编译器就会自动转换为getter方法
    
    p.age = 30; 会被编译器转换成[p setAge:30];

#### 4.3、◆  点语法也可以用于普通的方法，因为编译器也是机械地转换。类似于get方法，所以不能传参数。
    p.test; // [p test];

## 小技巧：网上搜索自定义代码段，也就是自定义完善代码的快捷键，提示补全。

## self关键字：不能离开设计类时的作用域，离开类之后没有任何意义。
    OC语言中的self,就相当于C++、Java中的this指针。
### 1、类方法中的self：代表类对象。
#### 1.1、 在整个程序运行过程中，一个类有且仅有一个类对象。通过类名调用方法就是给这个类对象发送消息。类方法的self就是这个类对象
#### 1.2、在类方法中可以通过self来调用其他的类方法。不能在类方法中去调用对象方法或成员变量，因为对象方法与成员变量都是属于具体的 实例对象的。
#### 1.3、◆  在类方法中调用类方法除了可以使用类名调用以外, 还可以使用self来调用。在类方法中的self代表类对象，实例方法中的self，代表 实例对象本身。

### 2、对象方法中的self：代表实例对象本身。
    在整个程序运行过程中，对象可以有0个或多个。通过对象调用方法就是给这个对象发送消息。 对象方法中self就是调用这个方法的当前对象。
    在对象方法中，可以通过self来调用本对象上的其他方法。在对象方法中，可以通过self来访问成员变量。
### 2.1、self会自动区分类方法和对象方法, 如果在类方法中使用self调用对象方法, 那么会直接报错。
### 2.2、不能在对象方法或者类方法中利用self调用当前self所在的方法。
    通过self调用方法的格式：[self 方法名];
    通过self访问成员变量格式：self->成员变量名
    
### 3、全局变量 & 成员变量 & 局部变量
    全局变量：只要是有声明它的地方都能使用，直接在空白的源文件中定义。
    成员变量：只能在本类和其子类的对象方法中使用，在定义类的作用域中定义。
    局部变量：只能在本函数或方法中使用。
    从作用域的范围来看：全局变量 > 成员变量 > 局部变量
    当不同的作用域中出现了同名的变量，内部作用域的变量覆盖外部作用域变量，所以同名变量的覆盖顺序为：局部变量覆盖成员变量，成员变量覆盖全局变量
    如果在对象方法中出现与成员变量同名的局部变量，如果此时想使用该成员变量可以通过self->成员变量名的方式


## 继承： ◆ 基类的私有属性能被继承,但不能在子类中被访问。
### 1、B类继承A类，那么B类将拥有A类的所有属性和方法(类方法/对象方法)，此时我们说A类是B类的父类，B类是A类的子类
#### 1.2、C类继承B类，那么C类将拥有B类中的所有属性和方法，包括B类从A类中继承过来的属性和方法，此时我们说B类是C类的父类， C类是B类的子类。
    子类与父类的关系也称为isA（是一个）关系，我们说子类isA父类，也就是子类是一个父类，比如狗类继承动物类，那么我们说狗isA动物，也就是狗是一个动物。 在如汽车继承交通工具，那么们说汽车isA交工工具，也就是汽车是一个交通工具
### 2、方法重写： 重写以后当给子类发送这个消息的时候，执行的是在子类中重写的那个方法，而不是父类中的方法。
#### 2.1、在子类中实现与父类中同名的方法，称之为方法重写；
#### 2.2、如果想在“子类中”调用被子类重写的父类的方法，可以通过super关键字。
    使用场景：当从父类继承的某个方法不适合子类,可以在子类中重写父类的这个方法。
    
### 3、继承中方法调用的顺序：如果找到了就执行这个方法，就不再往后查找了。
    1、在自己类中找
    2、如果没有,去父类中找
    3、如果父类中没有,就去父类的父类中
    4、如果父类的父类也没有,就还往上找,直到找到基类(NSObject)
    5、如果NSObject都没有就报错了
        如果找到了就执行这个方法，就不再往后查找了

### 4、◆ 子类不能定义和父类同名的成员变量，私有成员变量也不可以；因为子类继承父类，子类将会拥有父类的所有成员变量， 若在子类中定义父类同名成员变量 属于重复定义。 
  
## super关键字：  super只是个编译器的指令符号,只是告诉编译器在执行的时候,去调谁的方法。(没有代表父类)
### 1、super 并不是隐藏的参数，不代表消息接受着。但是self是一个隐私参数，代表消息接受者。
    self refers to the object receiving a message in objective-C programming.
    super 并不是隐藏的参数，它只是一个“编译器指示符”，它和 self 指向的是相同的消息接收者       
### 2、super用在子类中，适用于子类重写父类的方法时想保留父类的一些行为。
    1.直接调用父类中的某个方法
    2.super在对象方法中，那么就会调用父类的对象方法。只是个编译器符号。
    super在类方法中，那么就会调用父类的类方法
        
## 多态：父类指针却指向子类对象，为了方便调用被子类重写的方法。
### 1、当父类指针指向不同的对象的时候，通过父类指针调用被重写的方法的时候，会执行该指针所指向的那个(子类)对象的方法。
### 2、注意点: 在多态中, 如果想调用子类特有的方法必须强制类型转换为子类才能调用。（重写的方法则不用强制类型转换）
### 3、动态类型: 在编译的时候编译器只会检查当前类型对应的类中有没有需要调用的方法。在运行时,系统会自动判断a1的真实类型(可能是子类)。
    Animal *a1 = [Dog new];
    [a1 eat];

## 实例变量的修饰符：@public、@private、@protected、@package
### 1、实例变量修饰符作用域: 从出现的位置开始, 一直到下一个修饰符出现。如果没有遇到下一个实例变量修饰符, 那么就会修饰后面所有的实例变量。
    @public
    >可以在其它类中访问被public修饰的成员变量
    >也可以在本类中访问被public修饰的成员变量
    >可以在子类中访问父类中被public修饰的成员变量
    
    @private
    >不可以在其它类中访问被private修饰的成员变量
    >可以在本类中访问被private修饰的成员变量
    >不可以在子类中访问父类中被private修饰的成员变量
    
    @protected
    >不可以在其它类中访问被protected修饰的成员变量
    >可以在本类中访问被protected修饰的成员变量
    >可以在子类中访问父类中被protected修饰的成员变量
    
    注意: 默认情况下所有的实例变量都是protected
    
    @package
    >介于public和private之间的
    如果是在其它包中访问那么就是private的
    如果是在当前代码所在的包种访问就是public的

## description方法：其实是NSObject的一个@property属性，重写它，其实就是重写该description属性的getter方法。
### 1、description方法是基类NSObject 所带的方法,因为其默认实现是返回类名和对象的内存地址。
### 2、NSLog(@"%@", objectA);这会自动调用objectA的description方法来输出ObjectA的描述信息。
    description方法是基类NSObject 所带的方法,因为其默认实现是返回类名和对象的内存地址, 这样的话,使用NSLog输出OC对象,意义就不是很大, 因为我们并不关心对象的内存地址,比较关心的是对象内部的一些成变量的值。因此,会经常重写description方法,覆盖description方法 的默认实现。
### 3、只要利用%@打印对象, 就会调用description方法。
    如果通过%@打印对象就会调用-号开头的description方法。
    如果通过%@打印类对象就会调用+号开头的description方法。
    // 如果打印的是对象就会调用-号开头的description方法
    - (NSString *)description
    {
        
        NSString *str = [NSString stringWithFormat:@"age = %i, name = %@, height = %f, weight = %f, tel = %@, email = %@", _age, _name, _height, _weight, _tel, _email];
        return str;
        // 建议: 在description方法中尽量不要使用self来获取成员变量\因为如果你经常在description方法中使用self, 可能已不小心就写成了 %@, self
        // 如果在description方法中利用%@输出self会造成死循环
        // self == person实例对象
    }

    // 仅仅作为了解, 开发中99%的情况使用的都是-号开头的description
    + (NSString *)description
    {
        return @"ooxx";
    }
     
    

--------------------
day14:
--------------------  
## OC中的私有变量和私有方法：
### 1、无论使用什么成语变量修饰符修饰成员变量, 我们都可以在其它类中看到这个变量。只不过有得修饰符修饰的变量我们不能操作而已。
    @interface Person : NSObject
    {
        @public
        int _age;
        @protected
        double _height;
        @private
        NSString *_name;
        @package
        double _weight;
    }
    
    int main(int argc, const char * argv[]) {

        Person *p = [Person new];
        // 无论使用什么成语变量修饰符修饰成员变量, 我们都可以在其它类中看到这个变量
        // 只不过有得修饰符修饰的变量我们不能操作而已
        p->_age;
        p->_height;
        p->_name;
        p->_weight;
        [p test];
        
        id pp = [Person new];
        [pp test];
        
        [p performSelector:@selector(test)];
        
        return 0;
    }
#### 1.1、写在@implementation中的成员变量, 默认就是私有的成员变量。在@implementation中定义的私有变量只能在本类中访问， 在其它类中无法查看。在@interface中利用@private修饰的私有变量可以被看到，但是不能被操作。
    // 实例变量(成员变量)既可以在@interface中定义, 也可以在@implementation中定义
    // 写在@implementation中的成员变量, 默认就是私有的成员变量, 并且和利用@private修饰的不太一样, 在@implementation中 定义的成员变量在其它类中无法查看,也无法访问。
    // 在@implementation中定义的私有变量只能在本类中访问。
    
    @implementation Person
    {
        @public
        double _score;  //哪怕是@public属性，只要是在.m文件中，就是私有变量，不能被其他类查看。 
    }
    
#### 1.2、 如果只有方法的实现(.m文件), 没有方法的声明(.h文件), 那么该方法就是私有方法。 在OC中没有真正的私有方法, 因为OC是消息机制， 动态绑定。用id类型来破解私有方法不能被查看的限制。
    也就是其他类不可以查看.m文件中的方法，编译时提示报错没有该方法，但是具体有没有这个方法，是运行时绑定的。只是表面上是私有方法。

### 2、@property是编译器的指令，用在声明文件中，告诉编译器，自动生成声明成员变量的的访问器(getter/setter)方法。
    用@property int age;就可以代替下面的两行,编译器只要看到@property, 就知道我们要生成某一个属性的getter/setter方法的声明。
    - (int)age;   // getter
    - (void)setAge:(int)age;  // setter
    
    @property编写步骤：
    1.在@inteface和@end之间写上@property，编译器会自动为每个 @property 添加 @synthesize关键字生成 下划线_ 别名。
    2.在@property后面写上需要生成getter/setter方法声明的属性名称, 注意因为getter/setter方法名称中得属性不需要_, 所以@property后的属性也不需要_.并且@property和属性名称之间要用空格隔开。
    3.在@property和属性名字之间告诉需要生成的属性的数据类型, 注意两边都需要加上空格隔开。
    格式:
    @property(属性修饰符) 数据类型 变量名称;
    
    /*
    setter: 
    作用: 用于给成员变量赋值
    1.一定是对象方法
    2.一定没有返回值
    3.方法名称以set开头, 后面跟上需要赋值的成员变量名称, 并且去掉下划线, 然后首字母大写
    4.一定有参数, 参数类型和需要赋值的成员变量一致, 参数名称就是需要赋值的成员变量名称去掉下划线
    */
    - (void)setHeight:(double)height;   //.h文件中
    - (void)setHeight:(double)height    //.m文件中
    {
        _height = height;
    }
    
    /*
    getter:
    作用: 用于获取成员变量的值
    1.一定是对象方法
    2.一定有返回值, 返回值类型和需要获取的成员变量的类型一致
    3.方法名称就是需要获取的成员变量的名称去掉下划线
    4.一定没有参数
    */
    - (double)height;    //.h文件中
    - (double)height       //.m文件中
    {
        return _height;
    }
### 3、@synthesize是一个编译器指令，用在.m文件中，用于给@property属性起别名，并为@property属性实现getter/setter方法。
### 4、如果利用@property来生成getter/setter方法, 那么我们可以不写成员变量, 系统会自动给我们生成一个_开头的成员变量，在.m中生成。
    注意: @property自动帮我们生成的成员变量是一个私有的成员变量, 也就是说是在.m文件中生成的, 而不是在.h文件中生成的 
### 5、如果同时重写了getter/setter方法, 那么property就不会自动帮我们生成私有的成员变量。
    程序员之间有一个约定, 一般情况下获取BOOL类型的属性的值, 我们都会将获取的方法名称改为isXXX
    @property(getter=isMarried) BOOL married;

## id一个动态数据类型，也就是一个数据类型。
### 1、既然是数据类型, 所以就可以用来：1.定义变量。2.作为函数的参数。3.作为函数的返回值。
### 2、默认情况下所有的数据类型都是静态数据类型，在编译的时候就可以访问这些属性和方法。
    静态数据类型的特点: 
    在编译时就知道变量的类型,知道变量中有哪些属性和方法，在编译的时候就可以访问这些属性和方法。 
    并且如果是通过静态数据类型定义变量, 如果访问了不属于静态数据类型的属性和方法, 那么编译器就会报错。

### 3、动态数据类型的特点:在编译的时候编译器并不知道变量的真实类型, 只有在运行的时候才知道它的真实类型。
#### 3.1、并且如果通过动态数据类型定义变量, 如果访问了不属于动态数据类型的属性和方法, 编译器不会报错。

### 4、id 是一种通用的对象类型,它可以指向属于任何类的对象,也可以理解为万能指针 ,相当于C语言的 void *，直接调用指向对象中的方法, 编译器不会报错。
    id == NSObject * 万能指针
    id和NSObject *的区别: 
    NSObject *是一个静态数据类型
    id  是一个动态数据类型
    
    
#### 4.1、通过动态数据类型定义变量, 可以调用子类特有的方法，可以调用私有方法，因为编译器不做检查。
    // 弊端: 由于动态数据类型可以调用任意方法, 所以有可能调用到不属于自己的方法, 而编译时又不会报错, 所以可能导致运行时的错误
    // 应用场景: 多态, 可以减少代码量, 避免调用子类特有的方法需要强制类型转换。
    // 而通过静态数据类型定义变量, 不能调用子类特有的方法
#### 4.2、 为了避免动态数据类型引发的运行时的错误, 一般情况下如果使用动态数据类型定义一个变量, 在调用这个对象的方法之前会进行一次判断, isKindOfClass方法、isMemberOfClass方法用于判断，当前对象是否能够调用这个方法。
    id obj = [Student new];
    if ([obj isKindOfClass:[Student class]]) {
        // isKindOfClass , 判断指定的对象是否是某一个类, 或者是某一个类的子类
        [obj eat];
    }
    
    if ([obj isMemberOfClass:[Student class]]) {
        // isMemberOfClass : 判断指定的对象是否是当前指定的类的实例
        [obj eat];
    }

## new方法，是alloc和init的结合体，分配空间，初始化，返回对象地址：
    new做了三件事情
    1.开辟存储空间  + alloc 方法
    2.初始化所有的属性(成员变量) - init 方法
    3.返回对象的地址
### 1.1、alloc做了什么事情: 1.开辟存储空间。 2.将所有的属性设置为0。3.返回当前实例对象的地址。
### 1.2、init提供给用户自定义：1.初始化成员变量, 但是默认情况下init的实现是什么都没有做 2.返回初始化后的实例对象地址。
### 1.3、alloc 与 init合起来称为构造方法，表示构造一个对象。alloc返回的地址, 和init返回的地址是同一个地址。
    建议大家以后创建一个对象都使用 alloc init, 这样可以统一编码格式。
    
## 构造方法：用于初始化一个对象, 让某个对象一创建出来就拥有某些属性和值。
### 1、重写init方法, 在init方法中初始化成员变量， 重写init方法必须按照苹果规定的格式重写, 如果不按照规定会引发一些未知的错误。
#### 1.1、必须先初始化父类, 再初始化子类。防止父类的初始化方法release掉了self指向的空间并重新alloc了一块空间。
    + self 为什么要赋值为[super init]:
    简单来说是为了防止父类的初始化方法release掉了self指向的空间并重新alloc了一块空间(强引用)。还有[super init]可能alloc失败, 这时就不再执行if中的语句。
#### 1. 2、必须判断父类是否初始化成功, 只有父类初始化成功才能继续初始化子类。
#### 1.3、返回当前对象的地址。[super init]返回的仍然是子类的地址，当前执行的方法的对象的地址。
    在OC中init开头的方法, 我们称之为构造方法，重写init方法格式:
    - (id)init {
        self = [super init];
        
        if (self) {
            // Initialize self.
        }
        return self;
    }
    
    - (instancetype)init
    {
        // 1.初始化父类
        // 只要父类初始化成功 , 就会返回对应的地址, 如果初始化失败, 就会返回nil
        // nil == 0 == 假 == 没有初始化成功
        //+ self 为什么要赋值为[super init]:
        //简单来说是为了防止父类的初始化方法release掉了self指向的空间并重新alloc了一块空间。还有[super init]可能alloc失败, 这时就不再执行if中的语句。
        
        self = [super init];
        
        // 2.判断父类是否初始化成功
        if (self != nil) {
            // 3.初始化子类
            // 设置属性的值
            _age = 6;

        }
        // 4.返回地址
        return self;
    }
    
### 2、instancetype和id的区别：instancetype与id相似，不过instancetype只能作为构造方法的返回值，它会进行类型检查，编译器会报错。
    instancetype只能作为方法返回值，它会进行类型检查，如果创建出来的对象，赋值了不相干的对象就会有一个警告信息，防止出错。
#### 2.1、如果是在以前, init的返回值是id, 那么将init返回的对象地址赋值给其它对象，编译器是不会报错的。
#### 2.2、注意: 以后但凡自定义构造方法, 返回值尽量使用instancetype, 不要使用id。
    - (instancetype)init
    //- (id)init
    {
        if (self = [super init]) {
            _age = 5;
        }
        return self;
    }
#### 2.3、id可以用来定义变量, 可以作为返回值, 可以作为形参，instancetype只能用于作为返回值。

### 3、自定义构造方法：
#### 3.1、(1)一定是对象方法,以减号开头。(2)返回值一般是instancetype类型。(3)方法名必须以initWith开头
    // 注意: 自定义构造方法中的init后面的With的W一定要大写，- (instancetype)initwithAge:(int)age是错误写法。 
    - (instancetype)initWithAge:(int)age
    {
        if (self = [super init]) {
            _age = age;
        }
        return self;
    }

    - (instancetype)initWithName:(NSString *)name
    {
        if (self  =[super init]) {
            _name = name;
        }
        return self;
    }

    - (instancetype)initWithAge:(int)age andName:(NSString *)name
    {
        if (self = [super init]) {
            _age = age;
            _name = name;
        }
        return self;
    }
    
   
    }
#### 3.2、父类的属性交给父类的方法来处理，不能在子类直接访问父类私有变量。可以通过父类的set/get方法访问。
    - (instancetype)initWithAge:(int)age andName:(NSString *)name andNo:(int)no
       {
           /*
           if (self = [super init]) {
       //        _age = age;
               // 狗拿耗子, 多管闲事，_age和_name是从父类中继承过来的属性。
               // 自己的事情自己做
               [self setAge:age];
               [self setName:name];
           }
            */
           if (self = [super initWithAge:age andName:name]) {
               _no = no;
           }
           return self;
#### 3.3、在父类中通过property自动在.m中生成的属性，子类无法继承，不能直接访问(编译器不提示)，但是可以通过set/get方法访问。

## 类工厂方法：
### 1、是返回实例的类方法：
    类工厂方法是一种用于分配、初始化实例并返回一个它自己的实例的类方法。类工厂方法很方便，因为它们允许您只使用一个步骤（而不是两个步骤）就能创建对象. 例如new
### 2、自定义类工厂方法的规范：(1)一定是+号开头。(2)返回值一般是instancetype类型。(3)方法名称以类名开头,首字母小写。
    ，
    + (id)person;
    + (id)person
    {
        return  [[Person alloc]init];
    }

    + (id)personWithAge:(int)age;
    + (id)personWithAge:(int)age
    {
        Person *p = [[self alloc] init];
        [p setAge:age];
        return p;
    }

        apple中的类工厂方法

    其实苹果在书写工厂方法时也是按照这样的规划书写
        [NSArray array];
        [NSArray arrayWithArray:<#(NSArray *)#>];
        [NSDictionary dictionary];
        [NSDictionary dictionaryWithObject:<#(id)#> forKey:<#(id<NSCopying>)#>];
        [NSSet set];
        [NSSet setWithObject:<#(id)#>];
### 3、子类自然会继承父类的类方法：如果子类调用父类的类工厂方法创建实例对象,创建出来的还是父类的实例对象。
#### 3.1、为了解决这个问题, 以后在自定义类工厂时候不要利用父类创建实例对象, 改为使用self创建, 因为self谁调用当前方法self就是谁。    
    @interface Person : NSObject
    + (id)person;
    @end

    @implementation Person
    + (id)person
    {
    //   return  [[Person alloc]init];
    //     谁调用这个方法,self就代表谁
    //    注意:以后写类方法创建初始化对象,写self不要直接写类名
        return  [[self alloc]init];
    }
    @end

    @interface Student : Person
    @property NSString *name;
    @end

    @implementation Student
    @end

    int main(int argc, const char * argv[])
    {
        Student *stu = [Student person];// [[Student alloc] init]
        [stu setName:@"lnj"];
    }
    
## 类的本质：
### 1、类的本质其实也是一个对象(类对象)。程序中第一次使用该类的时候被创建，在整个程序中只有一份。此后每次使用都是这个类对象， 它在程序运行时一直存在。
### 2、类对象是一种数据结构,存储类的基本信息:类大小,类名称,类的版本，继承层次，以及消息与函数的映射表等。
### 3、类对象代表类,Class类型,对象方法属于类对象。 如果消息的接收者是类名,则类名代表类对象。
### 4、所有类的实例都由类对象生成,类对象会把实例的isa的值修改成自己的地址,每个实例的isa都指向该实例的类对象。
### 5、类对象的获取：(1) 通过实例对象。 (2) 通过类名获取(类名其实就是类对象).
        通过实例对象:
    格式：[实例对象   class ];
    如：   [dog class];

        通过类名获取(类名其实就是类对象):
    格式：[类名 class];
    如：[Dog class]
    
    类对象的用法:
        用来调用类方法:
    [Dog test];
    Class c = [Dog class];
    [c test];

        用来创建实例对象：
    Dog *g = [Dog new];
    Class c = [Dog class];
    Dog *g1 = [c new];
### 6、OC实例对象、类对象、元对象之间关系：
        Objective-C是一门面向对象的编程语言。
            每一个对象 都是一个类的实例。
            每一个对象 都有一个名为isa的指针,指向该对象的类。
            每一个类􏰁述了一系列它的实例的特点,包括成员变量的列表,成员函数的列表等。
            每一个对象都可以接受消息,而对象能够接收的消息列表是保存在它所对应的类中。
## xcode小技巧：在Xcode中按Shift + Command + O打开文件搜索框，然后输入NSObject.h和objc.h,可以打开 NSObject的定义头文件,通过头文件我们可以看到,NSObject就是一个包含isa指针的结构体,如下图所示:
    NSObject.h
    @interface NSObject <NSObject> {
        Class isa  OBJC_ISA_AVAILABILITY;
    }

    objc.h
    /// An opaque type that represents an Objective-C class.
    typedef struct objc_class *Class;

    /// Represents an instance of a class.
    struct objc_object {
        Class isa  OBJC_ISA_AVAILABILITY;
    };

        按照面向对象语言的设计原则,所有事物都应该是对象(严格来说 Objective-C并没有完全做到这一点,因为它有int,double这样的简单变量类型)
    在Objective-C语言中,每一个类实际上也是一个对象。每一个类也有一个名为isa的指针。每一个类都可以接受消息,例如[NSObject new], 就是向NSObject这个类发送名为new的消息。
## xocode小技巧：在Xcode中按Shift + Command + O,然后输入runtime.h, 可以打开Class的定义头文件, 通过头文件我们可以看到,Class也是一个包含isa指针的结构体,如下图所示。(图中除了isa外还有其它成员变量, 但那是为了兼容非2.0版的Objective-C的遗留逻辑,大家可以忽略它。)

    runtime.h
    struct objc_class {
        Class isa  OBJC_ISA_AVAILABILITY;

    #if !__OBJC2__
        Class super_class                                        OBJC2_UNAVAILABLE;
        const char *name                                         OBJC2_UNAVAILABLE;
        long version                                             OBJC2_UNAVAILABLE;
        long info                                                OBJC2_UNAVAILABLE;
        long instance_size                                       OBJC2_UNAVAILABLE;
        struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
        struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
        struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
        struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
    #endif

    } OBJC2_UNAVAILABLE;

#### 6.1、因为类也是一个对象,那它也必须是另一个类的实例,这个类就是元类 (metaclass)。
    元类保存了类方法的列表。 当一个类方法被调用时,元类会首先查找它本身是否有该类方法的实现,如果没有则该元类会向它的父类查找该方法,直到一直找到继承链的头。
    元类(metaclass)也是一个对象,那么元类的isa指针又指向哪里呢?为了设计上的完整,所有的元类的isa指针都会指向一个根元类(root metaclass)。
#### 6.2、根元类(root metaclass)本身的isa指针指向自己,这样就行成了一个闭环。 
    上面说􏰀到,一个对象能够接收的消息列表是保存在它所对应的类中的。在实际编程中,我们几乎不会遇到向元类发消息的情况,那它的isa 指针在实际上很少用到。 不过这么设计保证了面向对象的干净,即所有事物都是对象,都有isa指针。
    由于类方法的定义是保存在元类(metaclass)中,而方法调用的规则是,如果该类没有一个方法的实现,则向它的父类继续查找。 所以为了保证父类的类方法可以在子类中可以被调用,所以子类的元类会继承父类的元类,换而言之,类对象和元类对象有着同样的继承关系。
    
    上图中,最让人困惑的莫过于Root Class了。在实现中,Root Class是指 NSObject,我们可以从图中看出:
    NSObject类对象包括它的对象实例方法。
    NSObject的元对象包括它的类方法,例如new方法。
    NSObject的元对象继承自NSObject类。
    一个NSObject的类中的方法同时也会被NSObject的子类在查找方法时找到。


## 类的加载、启动过程
### 类的 + (void)load 方法，在类的二进制代码加载进内存时仅调用一次
### 类的+ (void)initialize 方法，在类第一次被使用时，仅调用一次
        // 只要程序启动就会将所有类的代码加载到内存中, 放到代码区
        // load方法会在当前类被加载到内存的时候调用, 有且仅会调用一次
        // 如果存在继承关系, 会先调用父类的load方法, 再调用子类的load方法
        + (void)load
        {
            NSLog(@"Person类被加载到内存了");
        }

        // 当当前类第一次被使用的时候就会调用(创建类对象的时候)
        // initialize方法在整个程序的运行过程中只会被调用一次, 无论你使用多少次这个类都只会调用一次
        // initialize用于对某一个类进行一次性的初始化
        // initialize和load一样, 如果存在继承关系, 会先调用父类的initialize再调用子类的initialize
        + (void)initialize
        {
            NSLog(@"Person initialize");
        }

### SEL类型代表着方法的签名，在类对象的方法列表中存储着该签名与方法代码的对应关系。@selector 关键字配对使用
####  respondsToSelector方法 、performSelector方法的使用

     其实SEL就是方法的指针，或者说是 定义方法的 结构体的 指针
     ## respondsToSelector方法     
     1. SEL类型的第一个作用, 配合对象/类来检查对象/类中有没有实现某一个方法
     
     SEL sel = @selector(setAge:);
     Person *p = [Person new];
     // 判断p对象中有没有实现-号开头的setAge:方法
     // 如果P对象实现了setAge:方法那么就会返回YES
     // 如果P对象没有实现setAge:方法那么就会返回NO
     BOOL flag = [p respondsToSelector:sel];
     NSLog(@"flag = %i", flag);
     
     // respondsToSelector注意点: 如果是通过一个对象来调用该方法那么会判断该对象有没有实现-号开头的方法
     // 如果是通过类来调用该方法, 那么会判断该类有没有实现+号开头的方法
     SEL sel1 = @selector(test);
     flag = [p respondsToSelector:sel1];
     NSLog(@"flag = %i", flag);
     flag = [Person respondsToSelector:sel1];
     NSLog(@"flag = %i", flag);
     
     ## performSelector方法
     2. SEL类型的第二个作用, 配合对象/类来调用某一个SEL方法
     
     SEL sel = @selector(demo);
     Person *p = [Person new];
     // 调用p对象中sel类型对应的方法
     [p performSelector:sel];
     
     SEL sel1 = @selector(signalWithNumber:);
     // withObject: 需要传递的参数
     // 注意: 如果通过performSelector调用有参数的方法, 那么参数必须是对象类型,
     // 也就是说方法的形参必须接受的是一个对象, 因为withObject只能传递一个对象
     [p performSelector:sel1 withObject:@"13838383438"];
     
     SEL sel2 = @selector(setAge:);
     [p performSelector:sel2 withObject:@(5)];
     NSLog(@"age = %i", p.age);
     
     // 注意:performSelector最多只能传递2个参数
     SEL sel3 = @selector(sendMessageWithNumber:andContent:);
     [p performSelector:sel3 withObject:@"138383438" withObject:@"abcdefg"];
        

-----
day15:
--------------------
## 内存管理
### 创建一个OC对象、定义一个变量、 调用一个函数或者方法 都会增加一个app的内存占用
### 当app所占用的内存较多时，系统会发出内存警告，这时得回收一些不需要再使用的内存空间。比如回收一些不需要使用的对象、变量等    

### 引用计数器
#### 任何一个对象, 刚生下来的时候, 引用计数器都为1，当使用alloc、new或者copy创建一个对象时，对象的引用计数器默认就是1
    引用计数器为0才会释放内存，不然都不会释放，所以初始化对象没有使用的话，就一直是1，一直没使用，就一直没释放（除非整个App退出）
#### 引用计数器的常见操作
    给对象发送一条retain消息,可以使引用计数器值+1（retain方法返回对象本身）
    给对象发送一条release消息, 可以使引用计数器值-1
    给对象发送retainCount消息, 可以获得当前的引用计数器值

#### ARC是编译器行为，不是运行时行为。
    ARC: Automatic(自动) Reference(引用) Counting(计数)
    什么是自动引用计数? 
    不需要程序员管理内容, 编译器会在适当的地方自动给我们添加release/retain等代码
    注意点: OC中的ARC和java中的垃圾回收机制不太一样, java中的垃圾回收是系统干得, 而OC中的ARC是编译器干得
    
    MRC: Manul(手动) Reference(引用) Counting(计数)
    什么是手动引用计数?
    所有对象的内容都需要我们手动管理, 需要程序员自己编写release/retain等代码
    
    内存管理的原则就是有加就有减
    也就是说, 一次alloc对应一次release, 一次retain对应一次relese
 #### release方法并不代表销毁\回收对象, 仅仅是计数器-1
 #### retainCount方法代表当前的计数，但是在释放时会有延迟，也就是存在（释放了，但是retainCount还没改成0）的情况。
 #### 释放内存只是把当前内存区域标识为未使用的区域，并没有擦除原来的内容。再次访问时会报错，因为没有改内存区域的维护信息，非法行为。
    只要一个对象被释放了, 我们就称这个对象为 "僵尸对象"。
    当一个指针指向一个僵尸对象, 我们就称这个指针为野指针。
    只要给一个野指针发送消息就会报错。
    
#### 给野指针发消息会报EXC_BAD_ACCESS错误。
#### 给空指针发消息是没有任何反应的。

### xcode监听僵尸对象：edit scheme -> run -> diagnostics ->  zombie object
### xcode全局断点：右侧导航栏下方 -> 断点标签栏 -> 点击+号 -> Exception Breakpoint
    让程序停留在报错的那行代码
#### dealloc方法：对象即将被销毁时系统会自动给对象发送一条dealloc消息 (因此, 从dealloc方法有没有被调用,就可以判断出对象是否被销毁) 
    一般会重写dealloc方法,在这里释放相关资源,dealloc就是对象的遗言。
    一旦重写了dealloc方法, 就必须调用[super dealloc],并且放在最后面调用。
    不能直接调用dealloc方法。
    一旦对象被回收了, 它占用的内存就不再可用,坚持使用会导致程序崩溃（野指针错误）。

#### @property的修饰符
    @property(nonatomic, retain) Room *room;

    // 1.相同类型的property修饰符不能同时使用，例如retain和assign不能同时存在
    // 2.不同类型的property修饰符可以多个结合在一起使用, 多个之间用,号隔开
    // 3.iOS开发中只要写上property, 那么就立刻写上nonatomic


    /*
     - (void)setAge:(int)age;
     - (int)age;
     
     - (void)setAge:(int)age
     {
        _age = age;
     }
     - (int)age
     {
        return _age;
     }
     
     readonly: 只会生成getter方法
     readwrite: 既会生成getter也会生成setter, 默认什么都不写就是readwrite
     
     getter: 可以给生成的getter方法起一个名称
     setter: 可以给生成的setter方法起一个名称
     
     retain: 就会自动帮我们生成getter/setter方法内存管理的代码
     assign: 不会帮我们生成set方法内存管理的代码, 仅仅只会生成普通的getter/setter方法, 默认什么都不写就是assign
        ## 有内存管理的set方法
        - (void)setRoom:(Room *)room // room = r
        {
            // 只有房间不同才需用release和retain
            if (_room != room) {// 0ffe1 != 0ffe1
            
                // 将以前的房间释放掉 -1
                [_room release];
                
                // retain不仅仅会对引用计数器+1, 而且还会返回当前对象
                _room = [room retain];
            }
        }
        
     多线程
     atomic ：性能低（默认）
     nonatomic ：性能高
     在iOS开发中99.99%都是写nonatomic
    */

### @class和#import是预编译指令关键字，仅是起到指导编译器工作的作用。不参与汇编指令的运行。
#### @class放在.h文件中，#import放在.m文件中，@class只是起到声明作用，#import起到拷贝的作用。@class避免多次重新拷贝覆盖。
        #import会包含引用类的所有信息(内容),包括引用类的变量和方法
        @class仅仅是告诉编译器有这么一个类, 具体这个类里有什么信息, 完全不知
        如果两个类相互拷贝死循环, 例如A拷贝B, B拷贝A, 这样会报错，在.h中用@class, 在.m中用import可以避免这种问题。
            因为如果.h中都用import, 那么A拷贝B, B又拷贝A, 会形成死循环
            如果在.h中用@class, 那么不会做任何拷贝操作, 而在.m中用import只会拷贝对应的文件, 并不会形成死循环
### 循环retian概念，对应swift就是循环强引用，解决办法是其中一方的属性用weak self。
    // 如果A对用要拥有B对象, 而B对应又要拥有A对象, 此时会形成循环retain
    // 如何解决这个问题: 不要让A retain B, B retain A ，只让其中一方不要做retain操作即可。
    要注意，发送release消息给空指针的隐藏问题，可以在没有retain的一方中（假设是A），在A的delloc方法中置nil B，
    而不是发release消息给B，以此来解决空指针问题。




