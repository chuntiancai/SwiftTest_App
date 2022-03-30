--------
day16：
--------------------
## autorelease基本使用
### @autoreleasepool{ } 关键字，其实就是定义一个代码作用区域，在{ }作用域的对象，都会在作用域结束后，被发送release 消息。前提是对象在池子内有调用 autorelease 方法(放入池子内)。相当于延迟释放。
    也就是把@autoreleasepool{} 作用域中的所有对象全部都调用一次release方法。其实就是自定义了作用域作为池子。
    自动释放池，自动释放的意思就是作用域结束后，自动把池子里面的所有对象都调用一次release方法进行释放。
### 注意: Foundation框架的类, 但凡是通过类工厂方法创建的对象都是autorelease的，即是已经加入了autorelease的代码了  
以上是MRC涉及的范围

## ARC的基本概念（OC中）
### ARC是编译器特性，而不是运行时特性，ARC不是其它语言中的垃圾回收, 有着本质区别。ARC只是编译器帮你编写上释放内存的代码而已。
    也就是ARC是xcode自动帮你编写MRC代码。

###  ARC的判断原则：只要还有一个强指针变量指向对象，对象就会保持在内存中。没有强指针指向该对象，该对象就会被释放。
    例如把指针置nil也是去除强指针的一种方法，只要是没强指针指着该对象就行。
    // 默认情况下所有的指针都是强指针
    Person *p = [[Person alloc] init];
    p = nil;
    
    __strong Person *p = [[Person alloc] init]; //显示写出强指针
    __weak Person *p2 = p;  // 弱指针，不会导致引用计数加1
    p = nil;
    
### ARC下@property中的参数意义：
    strong : 用于OC对象, 相当于MRC中的retain
    weak : 用于OC对象, 相当于MRC中的assign
    assign : 用于基本数据类型, 跟MRC中的assign一样

### Xcode的MRC转换为ARC：Edit -> Convert -> To Objective-C ARC
### Category 分类是给这个类扩充一些方法，但是不允许在分类中添加变量，因为分类是操作类对象数据结构中的方法列表结构，并不能操作整个类对象。
    个人理解是方法列表是链表结构体维护，而变量是非链表结构体维护，所以方法可添加，但是变量不可以添加。因为维护变量太过于复杂，增加编译器工作量。
    Category所以也是预编译指令，指导编译器工作，不是逻辑流指令。只是为了方便程序员写规范代码而添加的功能，很有用。
### Category也有声明和实现，不可以有变量。
    //声明：
    @interface ClassName (CategoryName)
    NewMethod; //在类别中添加方法
    //不允许在类别中添加变量
    @end
    
    //实现：
    @implementation ClassName(CategoryName)
    NewMethod
    ... ...
    @end
#### Category中写property只会生成getter/setter方法的声明, 不会生成实现和私有成员变量。强制使用会运行时错误。
#### 如果Category和原来类出现同名的方法, 优先调用Category中的方法, 原来类中的方法会被忽略
#### 类扩展(Class Extension) 就是@Interface后面的( )里面没东西，本来是放分类的名字的，这不是继承，没有冒号。也叫做匿名分类。
##### (Class Extension)可以扩充私有属性可私用方法，相当于内部的工具方法。
    个人理解：类对象的变量应该也是类似链表的数据结构，可以扩展，但是必须是私有，这样可以减少一些维护复杂度，也是很复杂。

### Block是iOS中一种比较特殊的数据类型，是数据类型，意味着可以作为参数，作为变量使用。
#### Block是苹果官方特别推荐使用的数据类型，用来保存某一段代码, 可以在恰当的时间再取出来调用，功能类似于函数和方法。
#### " * "在方法的声明定义中，是指针双目运算符，左侧是返回值，右侧是指针变量名，再后面是参数列表；
#### * ^ * 在Block的声明定义中，也是双目运算符，左侧是返回值，右侧是Block变量名，再后面是参数列表。
##### block变量,可以没有返回值,也可以没有形参；有一些省略写法，需要注意。定义的时候，在表达式中可以不写返回值。
    # 声明然后定义一个函数指针
    // void代表指向的函数没有返回值
    // (*roseP)代表roseP是一个指向函数的指针
    // ()代表指向的函数没有形参
    void (*roseP) ();
    roseP = printRose;
    roseP();
        
    # 声明然后定义一个block变量
    // void代表block将来保存的代码没有返回值
    // (^roseBlock) 代表reseBlock是一个block变量, 可以用于保存一段block代码
    // ()代表block将来保存的代码没有形参
    void (^roseBlock) ();
    roseBlock = ^(){    // 如果block没有参数, 那么^后面的()可以省略
        printf("  {@} \n");
        printf("   |  \n");
        printf("  \\|/ \n");
        printf("   | \n");
    };  //因为是变量，所以要有分号结束。
    
    roseBlock(); // 要想执行block保存的代码, 必须调用block才会执行


    # block最简单形式：
    void (^block名)() = ^{代码块;}
    例如:
    void (^myBlock)() = ^{ NSLog(@"李南江"); };

    # block带有参数的block的定义和使用：
    void (^block名称)(参数列表) = ^ (参数列表) { // 代码实现; }
    例如:
    void (^myBlock)(int) = ^(int num){ NSLog(@"num = %i", num); };

    # 带有参数和返回值的block：
    返回类型 (^block名称)(参数列表) = ^ (参数列表) { // 代码实现; }
    例如:
    int (^myBlock)(int, int) = ^(int num1, int num2){ return num1 + num2; };

    # 调用Block保存的代码：
    block变量名(实参);

### typedef是预编译指令，功能是给类型起别名，在编译过程再把别名更改为实际类型，这是编译器的工作。
#### typedef给Block起别名时比较特殊，表达式中的Block变量名，就是Block类型的别名。其实结构体、函数指针也有这种特殊的用法。
    # block别名：
    // 注意: 利用typedef给block起别名, 和指向函数的指针一样, block变量的名称就是别名
    typedef int (^calculteBlock)(int , int);
    
    calculateBlock sumBlock = ^(int value1, int value2){
        return value1 + value2;
    };
    int res = sumBlock(10, 20);
    NSLog(@"res = %i", res);
    calculateBlock minusBlock = ^(int value1, int value2){
        return value1 - value2;
    };
    res = minusBlock(10, 20);
    NSLog(@"res = %i", res);

### 默认情况下，Block内部不能修改外面的局部变量，外部的局部变量是值传递，是拷贝的。如果要修改，那么就需要指针传递。
#### __block 关键字，也是预编译指令，由Xcode帮你管理内存，编译过程中为你编写上相应的源代码。用于维护指针传递、强引用问题。
#### __block 在ARC概念中，相当于__weak作用。
#### block逻辑流默认在栈中，可以通过Block_copy方法拷贝Block到堆中，栈堆都是允许时概念，block肯定有汇编代码在代码区啊（静态概念）。
#### Block在堆中会对使用的对象进行引用计数，在栈中则不会对使用的对象进行引用计数。

    // block是存储在堆中还是栈中：
    // 默认情况下block存储在栈中, 如果对block进行一个copy操作, block会转移到堆中。如果block在栈中, block中访问了外界的对象, 那么不会对对象进行retain操作。
       但是如果block在堆中, block中访问了外界的对象, 那么会对外界的对象进行一次retain。
    
    // 如果在block中访问了外界的对象, 一定要给对象加上__block, 只要加上了__block, 哪怕block在堆中, 也不会对外界的对象进行retain。如果是在ARC开发中就需要在前面加上__weak
    __block Person *p = [[Person alloc] init]; // 1
    
    // 如果在做iOS开发时, 在ARC中不这样写容易导致循环引用
    Person *p = [[Person alloc] init];
    __weak Person *weakP = p;
        
    NSLog(@"retainCount = %lu", [p retainCount]);
    void (^myBlock)() = ^{
    NSLog(@"p = %@", p); // 2
        NSLog(@"block retainCount = %lu", [p retainCount]);
    };
    Block_copy(myBlock);    //拷贝Block到堆中
    myBlock();
    
    [p release]; // 1



-------
day17:
--------------------
## 协议(Protocol)基本概念
### 协议仅仅是用来存储方法的声明而已，protocol只有声明没有实现，仅仅是个.h文件。类也是在.h文件中遵循协议。
    # 定义协议
    @protocol 协议名称
    // 方法声明列表
    @end
    
    # 在类的.h文件中遵循协议
    @interface 类名 : 父类 <协议名称1, 协议名称2,…>
    @end
### 协议可以遵守协议,一个协议遵守了另一个协议,就可以拥有另一份协议中的方法声明
#### @required和@optional关键字用于修饰协议的方法的声明。(仅仅是有Xcode提示的效果)
    @required：这个方法必须要实现（若不实现，编译器会发出警告）
    @optional：这个方法不一定要实现

#### 类型限定，其实就是在变量声明时加上协议的限定，写法像范型，OC没有范型的概念。
    // 注意: 记住一点, 类型限定是写在数据类型的右边的
    @property (nonatomic, strong) Wife<WifeCondition> *wife;
    
    // 1.协议的第一个应用场景, 可以将协议写在数据类型的右边, 明确的标注如果想给该变量赋值, 那么该对象必须遵守某个协议
    Wife<WifeCondition> *w = [Wife new];
    
    注意: 虽然在接受某一个对象的时候, 对这个对象进行了类型限定(限定它必须实现某个协议), 但是并不意味着这个对象就真正的实现了该方法. 所以每次在调用对象的协议方法时应该进行一次验证
    if ([self.wife respondsToSelector:@selector(cooking)]) {
        [self.wife cooking];
    }

#### 协议的方法最终底层都是可选的，所以调用时，要作安全检查。
#### 协议的编写规范:
    1.一般情况下, 当前协议属于谁, 我们就将协议定义到谁的头文件中
    2.协议的名称一般以它属于的那个类的类名开头, 后面跟上protocol或者delegate
    3.协议中的方法名称一般以协议的名称protocol之前的作为开头
    4.一般情况下协议中的方法会将触发该协议的对象传递出去，即被代理的对象作为方法的参数。
    5.一般情况下一个类中的代理属于的名称叫做 delegate
    6.当某一个类要成为另外一个类的代理的时候, 
      一般情况下在.h中用@protocol 协议名称;告诉当前类 这是一个协议。在.m中用#import真正的导入一个协议的声明。

#### @protocol关键字的作用之一是与@class关键字的作用一样，仅做声明，不做拷贝。所以是在.h文件中使用@protocol，在.m文件中使用#import **.h

### Foundation框架，就是定义了很多基础类的集合，由苹果公司提供的框架，很多其他框架引用了该框架。
    Foundation框架提供了非常多好用的类, 比如：
        NSString : 字符串
        NSArray : 数组
        NSDictionary : 字典
        NSDate : 日期
        NSData : 数据
        NSNumber : 数字
    Foundation框架包含了很多开发中常用的数据类型: 结构体、枚举、类

### Xcode缓存路径：/Users/用户名/Library/Developer/Xcode/DerivedData(默认情况下, 这是一个隐藏文件夹)
### NSString 字符串对象不同的创建方法，在内存中的位置不一样，堆或者栈。
    通过不同的方式创建字符串,字符串对象储存的位置也不一样：
        >如果是通过字符串常量创建,那么字符串对象存储在常量区中。
        >如果是通过alloc initWithFormat/stringWithFormat创建,那么字符串对象存储在堆区中。
    而且需要注意:
        >不同的平台存储的方式也不一样,如果是Mac平台系统会自动对字符串对象进行优化,但是如果是iOS平台就是两个对象。
        >不同的编译器存储的方式也不一样,如果是Xcode6以下并且是在iOS平台,那么每次alloc都会创建一个新的对象,如果是在Xcode6以上那么alloc多次指向同一块存储空间。

    //1.通过字符串常量创建，栈中
    //注意:如果是通过字符串常量创建对象,并且字符串常量的内容一致,那么如果创建多个字符串对象,多个对象指向同一块存储空间
    NSString *str1 = @"lnj";
    NSString *str11 = @"lnj";
    NSLog(@"str1 = %p, str11 = %p", str1 ,str11);
    
    //2.通过alloc init创建，堆中
    //只要调用alloc就会在堆内存中开辟一块存储空间
    NSString *str2 = [[NSString alloc]initWithFormat:@"lmj"];
    NSString *str22 = [[NSString alloc]initWithFormat:@"lmj"];
    NSLog(@"str2 = %p, str22 = %p", str2, str22);
    
    //3.通过类工厂方法创建/ stringWithFormat
    //内部其实就是封装了alloc init
    NSString *str3 = [NSString stringWithFormat:@"zs"];
    NSString *str33= [NSString stringWithFormat:@"zs"];
    
    /*
     注意:一般情况下,只要是通过alloc或者类工厂方法创建的对象,每次都会在堆内存中开辟一块新的存储空间
     但是如果是通过alloc的initWithString方法除外,因为这个方法是通过copy返回一个字符串对象给我们
     而copy又分为深拷贝和浅拷贝,如果是深拷贝会创建一个新的对象,如果是浅拷贝不会创建一个新的对象,而是直接返回被拷贝的对象的地址给我们
     */
    
    NSString *str4 = [[NSString alloc]initWithString:@"ls"];
    NSString *str44 = [[NSString alloc]initWithString:@"ls"];
    NSLog(@"str4 = %p, str44 = %p", str4, str44);
#### NSString对象通过字面量创建，在对象存放在栈里
#### NSString对象通过alloc创建，则对象存放在堆里，但是不同的方式创建，会对堆中的字符串对象做指针优化。
#### NSString之从文件中读写字符的方法：
    // 用来保存错误信息
    NSError *error = nil;
    // 读取文件内容
    NSString *str = [NSString stringWithContentsOfFile:@"/Users/LNJ/Desktop/lnj.txt" encoding:NSUTF8StringEncoding error:&error];
    
    //写入文件中
    NSString *str = @"江哥";
    BOOL flag = [str writeToFile:@"/Users/LNJ/Desktop/lnj.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (flag == 1){
        NSLog(@"写入成功");
    }
### 小技巧：以后在OC方法中但凡看到XXXofFile的方法, 传递的一定是全路径(绝对路径)
### 小技巧：以后在OC方法中，带 * 的参数一般都是对象, 没带 * 的参数百分之九十都是枚举。

### URL表示法，或者说URL格式，其实就是一种路径的规范写法，或说是约束写法。
    可以简单认为: URL == 协议头://主机域名/路径
    常见的URL协议头(URL类型)
        http:// 或 https:// :超文本传输协议资源, 网络资源
        ftp:// :文件传输协议
        file:// :本地电脑的文件
        
    ★ 注意:如果加载的资源是本机上的资源,那么URL中的主机地址可以省略
      虽然主机地址可以省略,但是需要注意,文件路径中最前面的/不能省略,文件路径最前面的/代表根路径
    NSString *path = @"file:///Users/NJ-Lee/Desktop/lnj.txt";  /* Users前的斜杠不可以省略，因为这是文件路径前的斜杆*/
    NSURL *url = [NSURL URLWithString:path];
#### file://是URL的电脑本地协议头的表示法，表示是电脑本地的资源。
#### 如果是通过NSURL的fileURLWithPath:方法创建URL,那么系统会自动给我们传入的字符串添加协议头(file://),所以字符串中不需要再写file://
#### 因为URL不支持中文,如果URL中包含中文,建议使用fileURLWithPath方法创建，此时系统内部会自动对URL中包含的中文进行处理。
#### URL中包含中文字符的处理：
    NSString *path = @"file:///Users/NJ-Lee/Desktop/未命名文件夹/lnj.txt";
    //如果想手工解决URL的中文问题，就必须在创建URL之前先对字符串中的中文进行处理,进行百分号编码
    NSLog(@"处理前:%@", path);
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"处理后:%@", path);
    
#### NSString之从URL中读写字符的方法：
    ■ 根据URL加载文件中的字符串：
    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"str = %@", str);
    
    ■ 文件写入URL的资源中：
    NSString *str = @"lnj";
    NSString *path = @"/Users/NJ-Lee/Desktop/未命名文件夹/abc.txt";
    NSURL *url = [NSURL fileURLWithPath:path];
    [str writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //注意点:如果多次往同一个文件中写入内容,那么后一次的会覆盖前一次的
    NSString *str2 = @"xxoo";
    [str2 writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:nil];

#### NSString之比较字符串的方法：
    // 比较两个字符串的"内容"是否相同
    BOOL flag = [str1 isEqualToString:str2];
    NSLog(@"flag = %i", flag);
    
    // 下面这个方法, 是比较两个字符串的"地址"是否相同
    flag = (str1 == str2);
    NSLog(@"flag = %i", flag);
    
    // 比较字符串的大小，其实是比较ascii码，compare方法
    // NSOrderedAscending  前面的小于后面的
    // NSOrderedSame,  两个字符串相等
    // NSOrderedDescending  前面的大于后面的
    switch ([str1 compare:str2]) {
        case NSOrderedAscending:
            NSLog(@"str1小于str2");
            break;
        case NSOrderedSame:
            NSLog(@"str1等于str2");
            break;
        case NSOrderedDescending:
            NSLog(@"str1大于str2");
            break;
        default:
            break;
    }
    
    // 忽略大小写进行比较，caseInsensitiveCompare方法
    switch ([str1 caseInsensitiveCompare:str2]) {
        case NSOrderedAscending:
            NSLog(@"str1小于str2");
            break;
        case NSOrderedSame:
            NSLog(@"str1等于str2");
            break;
        case NSOrderedDescending:
            NSLog(@"str1大于str2");
            break;
        default:
            break;
    }
#### NSString之搜索字符串的方法：rangeOfString，不区分中文
    NSString *str = @"abcd";
    // 只要str中包含该字符串, 那么就会返回该字符串在str中的起始位置以及该字符串的长度
     ★ 注意:rangeOfString是从左至右的开始查找, 只要找到就不找了，所以要有参数
     
    // location从0开始 , length从1开始，如果str中没有需要查找的字符串, 那么返回的range的length=0, location = NSNotFound
    
    NSRange range =  [str rangeOfString:@"lnj"];
    NSRange range2 = [str rangeOfString:@"<" options:NSBackwardsSearch]
    //    if (range.location == NSNotFound) {
    if (range.length == 0){
        NSLog(@"str中没有需要查找的字符串");
    }else{
        NSLog(@"str中有需要查找的字符串");
        NSLog(@"location = %lu, length = %lu", range.location, range.length);
    }
    
### 小技巧：只要是OC提供的结构体, 一般都可以使用NSMakeXXX来创建。所以NSRange是结构体
    NSRange range = NSMakeRange(6, 3);
#### NSString之截取字符串的方法：substringWithRange
    // 从什么地方开始截取, 一直截取到最后
    NSString *newStr = [str substringFromIndex:6];
    NSLog(@"newStr = %@", newStr);
    
    // 从开头开始截取, 一直截取到什么位置，不包含该位置的字符
    NSString *newStr = [str substringToIndex:6];
    
#### NSString之替换字符串的方法：stringByReplacingOccurrencesOfString
    // 1.去除空格
    NSString *str = @"   http:   &&www.   520it.com   &img&lnj.gif   ";
    NSString *newStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 2.替换首尾
    NSString *str = @"HTTP://www.520it.com/img/LNJ.GIF";
    NSCharacterSet *set = [NSCharacterSet uppercaseLetterCharacterSet]; //去掉首尾的大写字母
    NSString *newStr = [str stringByTrimmingCharactersInSet:set];

### 小技巧：凡是调用NSString中的方法是以stringXXX开头的都是返回新的字符串，不是修改原来的字符串。

#### NSString之字符串与路径的转换：isAbsolutePath、lastPathComponent、stringByDeletingLastPathComponent、pathExtension
    // 1.判断是否是绝对路径
    // 其实本质就是判断字符串是否以/开头
    if([str isAbsolutePath])
    {
        NSLog(@"是绝对路径");
    }else{
        NSLog(@"不是绝对路径");
    }
    
    // 2.获取文件路径中的最后一个目录
    // 本质就是获取路径中最后一个/后面的内容
    NSString *newStr = [str lastPathComponent];
    NSLog(@"%@", newStr);
    
    // 3.删除文件路径中的最后一个目录
    // 本质就是删除最后一个/后面的内容, 包括/也会被删除
    NSString *newStr = [str stringByDeletingLastPathComponent];
    NSLog(@"%@", newStr);
    
    // 4.给文件路径添加一个目录
    // 本质就是在字符串的末尾加上一个/ 和指定的内容
    ◆ 注意: 如果路径后面已经有了/, 那么就不会添加了
           如果路径后面有多个/, 那么会自动删除多余的/, 只保留一个
    NSString *newStr = [str stringByAppendingPathComponent:@"xmg"];
    NSLog(@"%@", newStr);
    
    // 5.获取路径中文件的扩展名
    // 本质就是从字符串的末尾开始查找., 截取第一个.后面的内容
    NSString *newStr = [str pathExtension];
    NSLog(@"%@", newStr);
    
    // 6.删除路径中文件的扩展名
    // 本质就是从字符串的末尾开始查找.,删除第一个.和.后面的内容
    NSString *newStr = [str stringByDeletingPathExtension];
    NSLog(@"%@", newStr);
    
    // 7.给文件路径添加一个扩展名
    // 本质就是在字符串的末尾加上一个.和指定的内容
    NSString *newStr = [str stringByAppendingPathExtension:@"jpg"];
    NSLog(@"%@", newStr);
    
#### NSString之字符串的大小写转换、基本数据类型的转换：uppercaseString、stringWithUTF8String
    NSString *str = @"abc";
    
    // 1.将字符串转换为大写
    NSString *newStr = [str uppercaseString];
    NSLog(@"%@", newStr);
    
    // 2.将字符串转换为小写
    NSString *newStr2 = [newStr lowercaseString];
    NSLog(@"%@", newStr2);
    
    // 3.将字符串的首字符转换为大写
    NSString *newStr = [str capitalizedString];
    NSLog(@"%@", newStr);
    
    // 4.字符串与基本数据类型的转换
    NSString *str1 = @"110";
    NSString *str2 = @"120";
    //    str1 + str2; // 错误
    int value1 = [str1 intValue];
    int value2 = [str2 intValue];
    NSLog(@"sum = %i", value1 + value2);
    
    ◆ 注意: 如果不是int,double,float,bool,integer,longlong这些类型就不要乱用
    NSString *str3 = @"abc";
    int value3 = [str3 intValue];
    NSLog(@"value3 = %i", value3);
    */
    
    // 5.C语言字符串和OC字符串之间的转换
    char *cStr = "lnj";
    NSString *str = [NSString stringWithUTF8String:cStr];
    NSLog(@"str = %@", str);
    
    NSString *newStr = @"lmj";
    const char *cStr2 = [newStr UTF8String];
    NSLog(@"cStr2 = %s", cStr2);

### 小技巧：OC凡是名字里有Mutable的类，一般都有个没有Mutable名字的类，且有Mutable的类包含所有没有Mutable的类的方法，例如NSMutableString与NSString
### 小技巧： 注意: 一般情况下OC方法要求传入一个参数如果没有*, 大部分都是枚举。一般情况下如果不想使用枚举的值, 可以传入0, 代表按照系统默认的方式处理

### NSMutableString常用方法：appendFormat、deleteCharactersInRange、insertString、replaceCharactersInRange
    NSMutableString *strM = [NSMutableString stringWithFormat:@"www.520it.com.520"];
    ■ 1.在字符串后面添加/image， appendString方法
    
    [strM appendString:@"/image"];
    [strM appendFormat:@"/age is %i", 10];
    NSLog(@"strM = %@", strM);
    
    ■ 2.删除字符串中的520， deleteCharactersInRange方法
      技巧: 在开发中, 我们经常利用rangeOfString和deleteCharactersInRange方法配合起来删除指定的字符串
     ◇ 2.1先查找出520在字符串中的位置
    NSRange range = [strM rangeOfString:@"520"];
     ◇ 2.2删除520
    [strM deleteCharactersInRange:range];
    NSLog(@"strM = %@", strM);
    
    ■ 3.在520前面插入love这个单词，insertString方法
        // insertString : 需要插入的字符串
        // atIndex: 从哪里开始插入
    NSRange range = [strM rangeOfString:@"520"];
    [strM insertString:@"love" atIndex:range.location];
    NSLog(@"strM = %@", strM);
    
    ■ 4.要求将字符串中的520替换为530，  stringByReplacingOccurrencesOfString方法
    ◆ 注意: 如果是调用NSString的字符串替换方法, 不会修改原有字符串, 而是生成一个新的字符串
    NSString *newStr =[strM stringByReplacingOccurrencesOfString:@"520" withString:@"530"];
        
            // OccurrencesOfString: 需要替换的字符串
            // withString: 用什么替换
            // options: 替换时的搜索方式
            // range: 搜索的范围
            // 返回值: 代表替换了多少个字符串
    NSUInteger count = [strM replaceOccurrencesOfString:@"520" withString:@"530" options:0 range:NSMakeRange(0, strM.length)];
    NSLog(@"strM = %@", strM);
    NSLog(@"count = %lu", count);


------
day18
--------------------
## NSArray基本概念
### NSArray中只能存放任意OC对象(基本数据类型会自动转换为对象), 并且是有顺序的，元素个数、内容均不可变，初始化后就是固定的。
### NSArray的常用方法：

    - (NSUInteger)count;
        获取集合元素个数

    - (id)objectAtIndex:(NSUInteger)index;
        获得index位置的元素

    - (BOOL)containsObject:(id)anObject;
        是否包含某一个元素

    - (id)lastObject;
        返回最后一个元素

    - (id)firstObject;
        返回最后一个元素

    - (NSUInteger)indexOfObject:(id)anObject;
        查找anObject元素在数组中的位置(如果找不到，返回-1)

    - (NSUInteger)indexOfObject:(id)anObject inRange:(NSRange)range;
        在range范围内查找anObject元素在数组中的位置

### NSArray数组中的，如果原始为nil，则nil是结束符。nil之后的元素不再被初始化，被丢弃。
    NSArray *arr = [NSArray arrayWithObjects:@"lnj", @"lmj", @"jjj", nil];
### NSArray创建数组简写：@关键字表示创建NSArray数组
    NSString *str = @"lnj";
    //    NSArray *arr = [NSArray arrayWithObjects:@"lnj", @"lmj", @"jjj", nil];
    NSArray *arr = @[@"lnj", @"lmj", @"jjj"];
    // 获取数组元素的简写
    NSLog(@"%@", [arr objectAtIndex:0]);
    NSLog(@"%@", arr[0]);   //C语言的写法也可以

### NSArray遍历：增强for循环，block迭代器
    ■ 增强for循环：
    for (NSString *obj in arr) {
        NSLog(@"obj = %@", obj);
    }
    
     ■ 使用OC数组的迭代器来遍历：
     // 每取出一个元素就会调用一次block
     // 每次调用block都会将当前取出的元素和元素对应的索引传递给我们
     // obj就是当前取出的元素, idx就是当前元素对应的索引
     // stop用于控制什么时候停止遍历
     [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         if (idx == 1) {
             *stop = YES;
         }
         NSLog(@"obj = %@, idx = %lu", obj, idx);
     }];

### NSArray遍历 结合发送消息 使用（调用元素的方法）：makeObjectsPerformSelector
    ◆ 注意点: 如果数组中保存的不是相同类型的数据, 并且没有相同的方法, 那么会报错
    // withObject: 需要传递给调用方法的参数
    [arr makeObjectsPerformSelector:@selector(sayWithName:) withObject:@"lnj"];
### NSArray排序，默认是升序排序：sortedArrayWithOptions，参数Block的返回值用于判断是否交换元素位置，true则交换位置(其实是-1，0，1)
    typedef NS_CLOSED_ENUM(NSInteger, NSComparisonResult) {
        NSOrderedAscending = -1L,   //不交换顺序
        NSOrderedSame,//不交换顺序
        NSOrderedDescending//交换顺序，true的值为1
    };
    // 该方法默认会按照升序排序
    NSArray *newArr = [arr sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(Person *obj1, Person *obj2) {
    // 每次调用该block都会取出数组中的两个元素给我们
    // 二分
    if (obj1.age > obj2.age) {
        return NSOrderedDescending;
    }else if(obj1.age < obj2.age)
    {
        return NSOrderedAscending;
    }else
    {
        return NSOrderedSame;
    }
    }];
    NSLog(@"排序后: %@", newArr);

### NSArray拼接成字符串，切割字符串为NSArray：componentsJoinedByString、componentsSeparatedByString
    1、用-将所有的姓名连接起来生成一个字符串
    NSArray *arr = @[@"lnj", @"lmj", @"jjj"];
    NSString *str = [arr componentsJoinedByString:@"-"];
    
    2、通过一个字符串生成一个数组，也叫做字符串切割
    NSString *str = @"lnj**lmj**jjj";
    NSArray *arr = [str componentsSeparatedByString:@"**"];

### NSArray读写到文件中，NSArray默认会以xml文件的格式写入的文件中，ios的xml文件默认一般保存为plist。只能读写Foundation的类对象，
    ■ 1.将数组写入到文件中
    NSArray *arr = @[@"lnj", @"lmj", @"jjj"];
    // 其实如果将一个数组写入到文件中之后, 本质是写入了一个XML文件，在iOS开发中一般情况下我们会将XML文件的扩展名保存为plist
    BOOL flag = [arr writeToFile:@"/Users/xiaomage/Desktop/abc.plist" atomically:YES];
    
    ■ 注意:writeToFile只能写入数组中保存的元素都是Foundation框架中的类创建的对象, 如果保存的是自定义对象那么不能写入
    BOOL flag = [arr writeToFile:@"/Users/xiaomage/Desktop/person.plist" atomically:YES];
    
    ■ 2.从文件中读取一个数组
    NSArray *newArray = [NSArray arrayWithContentsOfFile:@"/Users/xiaomage/Desktop/abc.plist"];
    NSLog(@"%@", newArray);

### NSMutableArray不可以用@[]创建可变数组
    // 将指定数组中的元素都取出来, 放到arrM中，并不是将整个数组作为一个元素添加到arrM中
    [arrM addObjectsFromArray:@[@"lmj", @"jjj"]];
   
    // 注意: 以下是将整个数组作为一个元素添加
    [arrM addObject:@[@"lmj", @"jjj"]];
     
    // 插入一组数据, 指定数组需要插入的位置, 和插入多少个
    NSRange range = NSMakeRange(2, 2);
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
    [arrM insertObjects:@[@"A", @"B"] atIndexes:set];
        
    //NSMutableArray的读取：
    NSLog(@"%@", arrM[0]);
    NSLog(@"%@", [arrM objectAtIndex:0]);
    
    - (void)removeObjectsInRange:(NSRange)range;
        删除range范围内的所有元素

    - (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
        用anObject替换index位置对应的元素

    - (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
        交换idx1和idx2位置的元素

### NSDictionary字典的创建、遍历enumerateKeysAndObjectsUsingBlock、读写到文件中writeToFile
    
    1.字典的创建：
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[@"lnj", @"30", @"1.75"] forKeys:@[@"name", @"age", @"height"]];
    NSDictionary *dict = @{@"name":@"lnj", @"age":@"30", @"height":@"1.75"};

    2、字典的遍历：
    //闭包遍历
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key = %@, value = %@", key, obj);
    }];
    //forin遍历字典, 会将所有的key赋值给前面的obj
    for (NSString *key in dict) {
        NSString *value = dict[key];
        NSLog(@"key = %@, value = %@", key, value);
    }
    
    3.字典文件读写
    NSDictionary *dict = @{@"name":@"lnj", @"age":@"30", @"height":@"1.75"};
    [dict writeToFile:@"/Users/xiaomage/Desktop/info.plist" atomically:YES];// XML 扩展名plist
    
    4、读取文件为字典，注意: 字典和数组不同, 字典中保存的数据是无序的
    NSDictionary *newDict = [NSDictionary dictionaryWithContentsOfFile:@"/Users/xiaomage/Desktop/info.plist"];
    NSLog(@"%@", newDict);

### NSMutableDictionary的创建，不能使用@{}来创建一个可变的字典
    1.创建一个空的字典，并添加元素
    NSMutableDictionary *dictM = [NSMutableDictionary  dictionary];
    [dictM setObject:@"lnj" forKey:@"name"];
    
    ■ 如果利用setObject方法给同名的key赋值, 那么新值会覆盖旧值
    [dictM setObject:@"88" forKey:@"age"];
    dictM[@"age"] = @"88";
    
    //会将传入字典中所有的键值对取出来添加到dictM中
    [dictM setValuesForKeysWithDictionary:@{@"age":@"30", @"height":@"1.75"}];

#### 如果是不可变字典出现了同名的key, 那么后面的key对应的值不会被保存
#### 如果是在可变数组中, 后面的会覆盖前面的

### CGPoint和NSPoint是同义的，是结构体
### CGSize和NSSize是同义的，是结构体
### NSRect和CGRect，是结构体
    typedef CGPoint NSPoint;
    CGPoint的定义
    struct CGPoint {
      CGFloat x;
      CGFloat y;
    };
    typedef struct CGPoint CGPoint;
    typedef double CGFloat;
    
    typedef CGSize NSSize;
    CGSize的定义
    struct CGSize {
      CGFloat width;
      CGFloat height;
    };
    typedef struct CGSize CGSize;

    typedef CGRect NSRect;
    CGRect的定义
    struct CGRect {
      CGPoint origin;
      CGSize size;
    };
    typedef struct CGRect CGRect;

### @关键字，将字面量自动装箱成OC对象，而不是C语言的基本数据类型。变量可以用@( )装换
    1.将基本数据类型转换为对象类型
    NSNumber *ageN = [NSNumber numberWithInt:age];
    NSNumber *valueN = [NSNumber numberWithInt:value];
    
    2.将对象类型转换为基本数据类型
    int temp = [ageN intValue];
    double temp = [numberN doubleValue];
    
    3.基本数据类型转换对象类型简写
    //注意: 如果传入的是变量那么必须在@后面写上(), 如果传入的常量, 那么@后面的()可以省略
    NSNumber *temp = @(number);

### NSValue可以将任意对象(例如自定义类，结构体)包装为OC对象，然后就可以把包装后的对象放到字典、数组这些集合类型的容器中。
    1.利用NSValue包装常用的结构体
    CGPoint point = NSMakePoint(10, 20);
    NSValue *value = [NSValue valueWithPoint:point];
    NSArray *arr = @[value];
    NSLog(@"%@", arr);
    
    2.利用NSValue包装自定义的结构体
    typedef struct{
        int age;
        char *name;
        double height;
    }Person;
    
    Person p = {30, "lnj", 1.75};
#### 读取值为NSValue用valueWithBytes方法
    // valueWithBytes: 接收一个指针, 需要传递需要包装的结构体的变量的地址
    // objCType: 需要传递需要包装的数据类型
    NSValue *pValue = [NSValue valueWithBytes:&p objCType:@encode(Person)];
    NSArray *arr = @[pValue];
    NSLog(@"%@", arr);
    
#### 从NSValue中取出自定义的结构体变量，用getValue，参数是接收的地址值
    Person res;
    [pValue getValue:&res];
    NSLog(@"age = %i, name = %s, height = %f", res.age, res.name, res.height);

### NSDate的唯一根据是时间戳，默认的打印字符串是零时区的显示格式，所以我们所处的东八区会相差8个小时。
    // 只要是通过date方法创建的时间对象, 对象中就保存了当前的时间
    NSDate *now = [NSDate date];
    
    // 在now的基础上追加多少秒
    NSDate *date = [now dateByAddingTimeInterval:10];
        
    // 1.获取当前所处的时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    // 2.获取当前时区和指定时区的时间差
    NSInteger seconds = [zone secondsFromGMTForDate:now];
    
    // 3.时间格式化  NSDate --> NSString
    NSDate *now = [NSDate date];
        
    // 创建一个时间格式化对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 告诉时间格式化对象, 按照什么样的格式来格式化时间
    // yyyy 年
    // MM 月
    // dd 日
    // HH 24小时  hh 12小时
    // mm 分钟
    // ss 秒钟
    // Z 时区
    //   formatter.dateFormat = @"yyyy年MM月dd日 HH时mm分ss秒 Z";
    formatter.dateFormat = @"MM-dd-yyyy HH-mm-ss";

    // 利用时间格式化对象对时间进行格式化
    NSString *res = [formatter stringFromDate:now];
    NSLog(@"res = %@", res);
    
    // NSString --> NSDate
    NSString *str = @"2015-06-29 07:05:26 +0000";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 注意: 如果是从NSString格式化为NSDate, 那么dateFormat的格式, 必须和字符串中的时间格式一致, 否则可能转换失败
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    NSDate *date = [formatter dateFromString:str];
    NSLog(@"%@", date);

### NSCalendar可以获取一个时间对象的年月日(利用NSDateComponents)，计算两个时间对象的时间差。默认的显示是本地时区。
    // 1.获取当前时间的年月日时分秒
    // 获取当前时间，OC中默认的打印是本地时区的时间显示
    NSDate *now = [NSDate date];
    NSLog(@"now = %@", now);
    // 日历
    NSCalendar *calendar1 = [NSCalendar currentCalendar];
    // 利用日历类从当前时间对象中获取 年月日时分秒(单独获取出来)
    // components: 参数的含义是, 问你需要获取什么?
    // 一般情况下如果一个方法接收一个参数, 这个参数是是一个枚举 , 那么可以通过|符号, 连接多个枚举值
    NSCalendarUnit type = NSCalendarUnitYear |
                          NSCalendarUnitMonth |
                          NSCalendarUnitDay |
                          NSCalendarUnitHour |
                         NSCalendarUnitMinute |
                        NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar1 components:type fromDate:now];
    NSLog(@"year = %ld", cmps.year);
    NSLog(@"month = %ld", cmps.month);
    NSLog(@"day = %ld", cmps.day);
    NSLog(@"hour = %ld", cmps.hour);
    NSLog(@"minute = %ld", cmps.minute);
    NSLog(@"second = %ld", cmps.second);

### 小技巧：在OC中，以default、shared开头的一般都是单例。
### NSFileManager 一般用于操作文件、文件夹的。判读可读可写、是否存在、文件(夹)属性等等。
#### createDirectoryAtPath中的参数createIntermediates代表是否自动创建中间文件夹，否但实际又没有的话，会报错。

    ◆ fileExistsAtPath、attributesOfItemAtPath
    
    ◆ 获取文件夹中所有的文件
    // 注意:contentsOfDirectoryAtPath方法有一个弊端, 只能获取当前文件夹下所有的文件, 不能获取子文件夹下面的文件
    NSArray *res = [manager contentsOfDirectoryAtPath:@"/Users/xiaomage/Desktop/video" error:nil];
    
    ◆ 获取文件夹中所有的文件，包括自文件夹中的文件。
    //NSArray *res = [manager subpathsAtPath:@"/Users/xiaomage/Desktop/video"];
    NSArray *res = [manager subpathsOfDirectoryAtPath:@"/Users/xiaomage/Desktop/video" error:nil];
    
    ◆ 创建文件夹(createIntermediates为YES代表自动创建中间的文件夹)
    - (BOOL)createDirectoryAtPath:(NSString )path withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary )attributes error:(NSError **)error;
        

    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL flag = [manager createDirectoryAtPath:@"/Users/LNJ/Desktop/test" withIntermediateDirectories:YES attributes:nil error:nil];

    ◆ 创建文件(NSData是用来存储二进制字节数据的)
    - (BOOL)createFileAtPath:(NSString )path contents:(NSData )data attributes:(NSDictionary *)attr;
       

    NSString *str = @"lnj";
    NSData  *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL flag = [manager createFileAtPath:@"/Users/LNJ/Desktop/abc.txt" contents:data attributes:nil];
    
    
### 当一个对象加入到集合(Array、Set、Dictionary. .)中,那么该对象的引用计数会+1，当集合被销毁的时候,集合会向集合中的元素发送release消息
### 当把一个对象从集合中移除时,会向被移除的元素(该对象)发送release消息。
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    Person *p = [[Person alloc] init];
    NSLog(@"retainCount = %lu", [p retainCount]);
    [arr addObject:p];
    NSLog(@"retainCount = %lu", [p retainCount]);
    [arr removeObject:p];
    NSLog(@"retainCount = %lu", [p retainCount]);
    [p release];
    [arr release];

### 官方内存管理原则(这些都是MRC时需要很注意的，ARC也是根据这个原则来自动生成MRC代码的)
#### 1> 当调用alloc、new、copy(mutableCopy)方法产生一个新对象的时候,就必须在最后调用一次release或者autorelease
#### 2> 当调用retain方法让对象的计数器+1,就必须在最后调用一次release或者autorelease

### 2.集合的内存管理细节
####    1> 当把一个对象添加到集合中时,这个对象会做了一次retain操作,计数器会+1
####    2> 当一个集合被销毁时,会对集合里面的所有对象做一次release操作,计数器会-1
####    3> 当一个对象从集合中移除时,这个对象会一次release操作,计数器会-1

### 3.普遍规律
####   1> 如果方法名是add\insert开头,那么被添加的对象,计数器会+1
####    2> 如果方法名是remove\delete开头,那么被移除的对象,计数器-1

### 使用copy方法的对象必须是遵守NSCopying协议，实现copyWithZone:方法的。
### 通过copy方法拷贝出来的对象是一个不可变的对象，如果被拷贝的对象本身也是不可变，那么将会是指针拷贝，也就是 “浅拷贝”。
#### 注意点: 如果是浅拷贝, 那么会对拷贝的对象进行一次retain, 那么我们就需要对拷贝出来的对象进行一次release。
#### 因为深拷贝生成了新的对象，所以不会retain。
    ◆ 正是因为调用copy方法有时候会生成一个新的对象, 有时候不会生成一个新的对象
      所以: 如果没有生成新的对象, 我们称之为浅拷贝, 本质就是指针拷贝。
           如果生成了新的对象, 我们称之为深拷贝, 本质就是会创建一个新的对象。
    
    NSMutableString *copyStr = [srcStr mutableCopy];
    NSLog(@"srcStr = %@, copyStr = %@", srcStr, copyStr);
    
### 通过mutableCopy拷贝出来的对象必须是一个可变的对象, 所以必须生成一个新的对象。
    //  会生成一个新的对象
    NSMutableString *srcStr = [NSMutableString stringWithFormat:@"lnj"];
    NSMutableString *copyStr = [srcStr mutableCopy];
    
### @property括号里的copy关键字用于，当外界对象被引用到该属性是否自动copy外界对象副本，如果copy副本，则不会对外界对象retain，否则会。
    //@property (nonatomic, retain) NSString *name;
    @property (nonatomic, copy) NSString *name;

    // 注意: 如果是block使用copy并不是拷贝, 而是转移
    @property (nonatomic, copy) myBlock pBlock;

### @property的成员是Block的话，Block只是一段汇编指令，只是把它转移到堆内存中。在堆中Block的代码引用到外界对象的话，则会retain
#### block默认存储在栈中, 栈中的block访问到了外界的对象, 不会对对象进行retain
#### block如果在堆中, 如果在block中访问了外界的对象, 会对外界的对象进行一次retain

    Person *p = [[Person alloc] init];
    NSLog(@"retainCount = %lu", [p retainCount]);
    void (^myBlock)() = ^{
        NSLog(@"%@", p);
        NSLog(@"retainCount = %lu", [p retainCount]);
    };
    Block_copy(myBlock); // 将block转移到堆中，防止栈中的Block代码访问对象时，对象已经释放了
    myBlock();

### copy block之后引发循环引用，如果对象中的block又用到了对象自己, 那么为了避免内存泄露, 应该将对象修饰为__block。Block通过这个标识不对自身的宿主对象进行强引用，也就是不进行retain。
    __block Person *p = [[Person alloc] init]; // 1
    p.name = @"lnj";
    NSLog(@"retainCount = %lu", [p retainCount]);
    p.pBlock = ^{
        NSLog(@"name = %@", p.name); // 2
    };
    NSLog(@"retainCount = %lu", [p retainCount]);
    p.pBlock();

    [p release]; // 1

### 自定义类遵守NSCopying协议，实现copyWithZone:方法的，其实就是在copyWithZone:方法中alloc一个对象返回。
    ◆ 在.h文件中遵循协议
    @interface Person : NSObject<NSCopying, NSMutableCopying>
    ◆ 在.m文件中
    - (id)copyWithZone:(NSZone *)zone
    {
        // 1.创建一个新的对象
        Person *p = [[[self class] allocWithZone:zone] init];
        
        // 2.设置当前对象的内容给新的对象
        p.age = _age;
        p.name = _name;
        
        // 3.返回新的对象
        return p;
    }
    /**
        zone: 表示空间,分配对象是需要内存空间的,如果指定了zone,就可以指定 新建对象对应的内存空间。
        但是:zone是一个非常古老的技术,为了避免在堆中出现内存碎片而使用的。在今天的开发中,zone几乎可以忽略
    */
    - (id)mutableCopyWithZone:(NSZone *)zone
    {
        // 1.创建一个新的对象
        Person *p = [[[self class] allocWithZone:zone] init];
        
        // 2.设置当前对象的内容给新的对象
        p.age = _age;
        p.name = _name;
        
        // 3.返回新的对象
        return p;
    }

### 小技巧：一般情况下创建一个单例对象都有一个与之对应的类方法，用于创建单例对象的方法名称几乎都以share开头, 或者以default开头。
### 创建单例：由于所有的创建方法都会调用allocWithZone方法, 所以只需要在该方法中控制当前对象只创建一次即可，即复写该类方法。
#### 同时也要复习copy、retain、release这些方法，避免内存泄露或者多个内存的问题。
    创建单例：
    + (instancetype)shareInstance
    {
        Tools *instance = [[self alloc] init]; //每次都会去执行allocWithZone方法。
        return instance;
    }
    
    static Tools *_instance = nil;
    + (instancetype)allocWithZone:(struct _NSZone *)zone
    {
        /*
        // 当前代码在多线程中可能会出现问题
        NSLog(@"%s", __func__);
        // 由于所有的创建方法都会调用该方法, 所以只需要在该方法中控制当前对象只创建一次即可
        if (_instance == nil) {
            NSLog(@"创建了一个对象");
            _instance = [[super allocWithZone:zone] init];//分配堆空间
        }
        return _instance;
         */
        
        // 以下代码在多线程中也能保证只执行一次
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[super allocWithZone:zone] init];
        });
        return _instance;
    }

### static dispatch_once_t onceToken代码快，保证了代码在多线程中也只执行一次。

### 用宏定义来抽取单例：宏定义的本质就是代码替换。
#### 小技巧：在.h或者.m文件中，没有返回值那些看似方法的声明，其实就是宏定义。
#### 宏定义本来就是一行代码而已，为了遍历阅读，用反斜杠( \ )告诉编译器，其实下一行也是这一行的，其实为了人类阅读才假装换行而已。
### 小技巧：条件编译语句，也就是指示编译器工作的指令，符合条件就编译以下代码。
    
    ◆ 在Singleton.h文件中。以后直接#import "Singleton.h"文件就可以使用该宏定义了。
    // 以后就可以使用interfaceSingleton来替代后面的方法声明，也就是编译时用+(instancetype)share##name代替interfaceSingleton(name)
    // 两个#号，其实就是替换前面(name)里面的代码，##不会被实际编译
    #define interfaceSingleton(name)  +(instancetype)share##name


    #if __has_feature(objc_arc) //这是条件编译语句，也就是指示编译器工作的指令，符合条件就编译以下代码
    // ARC的单例宏定义
    #define implementationSingleton(name)  \
    + (instancetype)share##name \
    { \
    name *instance = [[self alloc] init]; \
    return instance; \
    } \
    static name *_instance = nil; \
    + (instancetype)allocWithZone:(struct _NSZone *)zone \
    { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
    _instance = [[super allocWithZone:zone] init]; \
    }); \
    return _instance; \
    } \
    - (id)copyWithZone:(NSZone *)zone{ \
    return _instance; \
    } \
    - (id)mutableCopyWithZone:(NSZone *)zone \
    { \
    return _instance; \
    }
    #else
    // MRC的单例宏定义

    #define implementationSingleton(name)  \
    + (instancetype)share##name \
    { \
    name *instance = [[self alloc] init]; \
    return instance; \
    } \
    static name *_instance = nil; \
    + (instancetype)allocWithZone:(struct _NSZone *)zone \
    { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
    _instance = [[super allocWithZone:zone] init]; \
    }); \
    return _instance; \
    } \
    - (id)copyWithZone:(NSZone *)zone{ \
    return _instance; \
    } \
    - (id)mutableCopyWithZone:(NSZone *)zone \
    { \
    return _instance; \
    } \
    - (oneway void)release \
    { \
    } \
    - (instancetype)retain \
    { \
    return _instance; \
    } \
    - (NSUInteger)retainCount \
    { \
    return  MAXFLOAT; \
    }
    #endif
    
    ◆ 在Person.h文件中
    @interface Person : NSObject
    interfaceSingleton(Person); //这是宏定义，在编译时会替换成宏定义的代码。
    @end
    ◆ 在Person.m文件中
    @implementation Person
    implementationSingleton(Person) //这是宏定义，在编译时会替换成宏定义的代码。
    @end


