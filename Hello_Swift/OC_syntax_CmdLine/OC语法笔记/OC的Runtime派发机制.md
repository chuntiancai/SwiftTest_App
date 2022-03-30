# OC的Runtime消息派发机制
实用技术

----------
day01
------------------------
## 学习ios新特性的思路：
### 1、使用新的xcode创建项目,用旧的xcode去打开。Xcode的特性往往是编译器的特性，和语言新特性是等同的地位。
### 2、出现了新的关键字：如何去使用 --> 怎么去使用 --> 是Xcode特性还是标准库特性。(都是属于语法)
    例如nullable关键字: 
    1.怎么使用(语法) 2.什么时候使用(作用)
    nullable作用:可能为空
    关键字:可以用于属性,方法返回值和参数中
    关键字作用:提示作用,告诉开发者属性信息
    关键字目的:迎合swift,swift是个强语言,swift必须要指定一个对象是否为空
    关键字好处:提高代码规划,减少沟通成本
    关键字仅仅是提供警告,并不会报编译错误
 
    nullable 语法1，在@property的关键字里
    @property (nonatomic, strong, nullable) NSString *name;
 
    nullable 语法2 * 关键字 变量名
    @property (nonatomic, strong) NSString * _Nullable name;
 
    nullable 语法3
    @property (nonatomic, strong) NSString * __nullable name;
    
    /*
     nonnull:1.怎么使用(语法) 2.什么时候使用(作用)
     nonnull作用:不能为空
     // nonnull 语法1
     @property (nonatomic, strong, nullable) NSString *name;
     // nonnull 语法2 * 关键字 变量名
     @property (nonatomic, strong) NSString * _Nonnull name;
     // nonnull 语法3
     @property (nonatomic, strong) NSString * __nonnull name;
     */
     
     /*
      null_resettable:1.怎么使用(语法) 2.什么时候使用(作用)
      null_resettable:必须要处理为空情况,重写get方法，也就是以属性名作为方法名的方法，默认是get方法。
      null_resettable作用:get方法不能返回nil,set可以传入为空
      null_resettable 语法1
      @property (nonatomic, strong, null_resettable) NSString *name;
      */

     /*
         _Null_unspecified:不确定是否为空
      */

     /*
         关键字注意点
         在NS_ASSUME_NONNULL_BEGIN和NS_ASSUME_NONNULL_END之间默认是nonnull
         关键字不能用于基本数据类型(int,float),nil只用于对象
      */
#### 2.1、先去用，然后再去看特点，慢慢试验。
#### 2.2、要注意系统新增的全局宏命令，例如 在NS_ASSUME_NONNULL_BEGIN和NS_ASSUME_NONNULL_END之间默认是nonnull
### 3、OC中的泛型Person<Java *>，仅仅是报警告，可以使用点语法，id类型不可以用点语法：
    泛型:限制类型 
    为什么要推出泛型?迎合swift
 
    泛型作用:1.限制类型 2.提高代码规划,减少沟通成本,一看就知道集合中是什么东西
    泛型定义用法:类型<限制类型>
    泛型声明:在声明类的时候,在类的后面<泛型名称>，在定义时才会确定真正的泛型是什么。@interface NSMutableArray<ObjectType> : NSArray<ObjectType>
    泛型仅仅是报警告
    泛型好处:1.从数组中取出来,可以使用点语法
            2.给数组添加元素,有提示
    
    泛型在开发中使用场景:1.用于限制集合类型，id是不能使用点语法
 
    为什么集合可以使用泛型?使用泛型,必须要先声明泛型? => 如何声明泛型 ：@property (nonatomic, strong) NSMutableArray<NSString *> *arr;
 
    自定义泛型?
    什么时候使用泛型?在声明类的时候,不确定某些属性或者方法类型,在使用这个类的时候才确定,就可以采用泛型
    例如：自定义Person,会一些编程语言(iOS,Java),在声明Person,不确定这个人会什么,在使用Person才知道这个Person会什么语言
    
    //泛型的使用：
    Java *java = [[Java alloc] init];
    iOS *ios = [[iOS alloc] init];
    
    // iOS
    Person<iOS *> *p = [[Person alloc] init];
    p.language = ios;
    
    // Java
    Person<Java *> *p1 = [[Person alloc] init];
    p1.language = java;
#### 3.1、集合中可以用点语法，但是必须先声明这个集合的元素是哪一种泛型。
    @property (nonatomic, strong) NSMutableArray<NSString *> *arr;
#### 3.2、集合如果没有定义泛型，那么元素默认就是id类型。
#### 3.3、泛型声明(.h文件):在声明类的时候,在类的后面<泛型名称>，在定义时才会确定真正的泛型是什么。@interface NSMutableArray<ObjectType> : NSArray<ObjectType>
#### 3.4、泛型中的__covariant:协变, 是子类转父类。__contravariant:逆变，是父类转子类。强制类型转换。
    //Language是父类，iOS是子类
    
    ◆ 父类转子类
    iOS *ios = [[iOS alloc] init];
    Language *language = [[Language alloc] init];
    
    Person<Language *> *p = [[Person alloc] init];
    p.language = language;
    
    // 属性 iOS 转换为 anguage
    Person<iOS *> *p1 = [[Person alloc] init];
    p1 = p;
    
    
    ◆ 子类转父类
    iOS *ios = [[iOS alloc] init];
    Language *language = [[Language alloc] init];
    // iOS
    Person<iOS *> *p = [[Person alloc] init];
    p.language = ios;
    
    //属性 Language 转换为 iOS
    Person<Language *> *p1;
    p1 = p;
    
#### 3.5、泛型注意点:在数组中,一般用可变数组添加方法,泛型才会生效,如果使用不可变数组,初始化添加元素,泛型没有效果，不会报警告。

### 4、 __kindof关键字，用于类型的前缀，修饰类型。
    // Xcode5之前 id:可以调用任何对象方法,不能进行编译检查
    // instancetype:自动识别当前类的对象
    + (__kindof Person *)person;

## Runtime的简介，运行时的消息机制，运行时绑定方法体。
    RunTime简称运行时。OC就是运行时机制，也就是在运行时候的一些机制，其中最主要的是消息机制。
    对于C语言，函数的调用在编译的时候会决定调用哪个函数。
    对于OC的函数，属于动态调用过程，在编译的时候并不能决定真正调用哪个函数，只有在真正运行的时候才会根据函数的名称找到对应的函数来调用。
    事实证明：
        在编译阶段，OC可以调用任何函数，即使这个函数并未实现，只要声明过就不会报错。
        在编译阶段，C语言调用未实现的函数就会报错。
### 1、 对于OC的函数，属于动态调用过程，在编译的时候并不能决定真正调用哪个函数，只有在真正运行的时候才会根据函数的名称找到对应的函数来调用。
#### 1.1、在编译阶段，OC可以调用任何函数，即使这个函数并未实现，只要声明过就不会报错。而C语言调用未实现的函数就会报错。
#### 1.2、对于C语言，函数的调用在编译的时候会决定调用哪个函数。
### 2、发送消息，方法调用的本质，就是让对象发送消息。只有对象才能发送消息，因此runtime的前缀以objc开头。如果是关于方法，那就是method前缀。类推
    // 最终代码生成消息机制,是编译器做的事情， 最终代码,需要把当前代码重新编译,用xcode编译器,clang
    // clang -rewrite-objc main.m 查看最终生成代码
    在终端输入：clang -rewrite-objc main.m 查看最终生成代码main.cpp
    ◆  消息机制简单使用：
    // 创建person对象
    Person *p = [[Person alloc] init];

    // 调用对象方法
    [p eat];

    // 本质：让对象发送消息
    objc_msgSend(p, @selector(eat));

    // 调用类方法的方式：两种
    // 第一种通过类名调用
    [Person eat];
    // 第二种通过类对象调用
    [[Person class] eat];

    // 用类名调用类方法，底层会自动把类名转换成类对象调用
    // 本质：让类对象发送消息
    objc_msgSend([Person class], @selector(eat));

    消息机制原理:对象根据方法编号SEL去映射表查找对应的方法实现 
#### 2.0、最终代码如何生成消息机制,是编译器做的事情。在终端输入：clang -rewrite-objc main.m 查看最终生成代码main.cpp
#### 2.1、使用全局方法objc_msgSend让对象发送消息。使用消息机制前提，必须导入#import <objc/message.h>
    objc_msgSend(p, @selector(eat));
#### 2.2、类方法的本质：类对象调用[NSObject class]，用类名调用类方法，底层会自动把类名转换成类对象调用。
    / 类方法本质:类对象调用[NSObject class]
    // id:谁发送消息
    // SEL:发送什么消息
    // ((NSObject *(*)(id, SEL))(void *)objc_msgSend)([NSObject class], @selector(alloc));
    
    // xcode6之前,苹果运行使用objc_msgSend.而且有参数提示
    // xcode6苹果不推荐我们使用runtime

### xcode小技巧：解决runtime消息机制没方法参数提示步骤；查找build setting -> 搜索msg -> 设置为NO。否则报错：Too many arguments to function call, expected 。。
    // 查找build setting -> 搜索msg
    
### 3、Runtime的常用方法(一般都是全局方法)：
#### 3.1、objc_msgSend全局方法是使对象发送消息，对象作为参数。
#### 3.2、objc_getClass全局方法是根据类的名字获取类对象，参数是类名字的字符串。
#### 3.3、sel_registerName全局方法是查找类对象相应的类方法，参数是方法的名字字符串，与objc_getClass结合使用。
    Person *p = objc_msgSend(objc_getClass("Person"), sel_registerName("alloc"));
#### 3.4、@selector(eat)是编译器指令，作用相似sel_registerName方法，也是找到方法底层的结构体
    id objc = objc_msgSend([NSObject class], @selector(alloc));
   
### 4、Rumtime的使用场景，为了调用私有方法。调用多参数的方法。修改系统类的实现(添加属性，添加方法)。
    //调用多参数的方法
    objc_msgSend(p, @selector(run:),20);
### 5、Runtime机制寻找方法的流程：
    // 方法调用流程
    // 怎么去调用eat方法 ,对象方法:类对象的方法列表 类方法:元类中方法列表
    // 1.通过isa去对应的类中查找
    // 2.注册方法编号
    // 3.根据方法编号去查找对应方法
    // 4.找到只是最终函数实现地址,根据地址去方法区调用对应函数
    
    内容5大区
    1.栈 2.堆 3.静态区 4.常量区 5.方法区
    1.栈:不需要手动管理内存,自动管理
    2.堆,需要手动管理内存,自己去释放
    
    
### 6、Runtime交换方法method_exchangeImplementations，想修改系统的方法实现，用Runtime交换实现体。给旧有的类添加分类来创建新的对象，但设计时不能影响旧的对象。
#### 6.1、 给系统的方法添加分类
#### 6.2、自己实现一个带有扩展功能的方法
#### 6.3、 交互方法,只需要交互一次,
#### 6.4、 在+load方法里面交换方法体，那么在所有地方调用的方法名，都是交换了方法体的，所以要注意方法实现体里调用了被交换的方法。
    给系统的imageNamed添加功能,只能使用runtime(交互方法)
    // 把类加载进内存的时候调用,只会调用一次
    + (void)load
    {
        // self -> UIImage
        // 获取imageNamed
        // 获取哪个类的方法
        // SEL:获取哪个方法
        Method imageNamedMethod = class_getClassMethod(self, @selector(imageNamed:));
        // 获取xmg_imageNamed
        Method xmg_imageNamedMethod = class_getClassMethod(self, @selector(xmg_imageNamed:));
        
        // 交互方法:runtime
        method_exchangeImplementations(imageNamedMethod, xmg_imageNamedMethod);
        // 调用imageNamed => xmg_imageNamedMethod
        // 调用xmg_imageNamedMethod => imageNamed
    }
    
    //用于交换的方法
    + (UIImage *)xmg_imageNamed:(NSString *)name
    {
        // 图片
       UIImage *image = [UIImage xmg_imageNamed:name];  // ◆ 这里的实际方法体是imageNamed，因为在+load方法体里面已经交换了
        if (image) {
            NSLog(@"加载成功");
        } else {
            NSLog(@"加载失败");
        }
        return image;
    }


### 7、Runtime动态添加方法，使用对象的performSelector方法，延迟提供方法实现体。OC都是懒加载机制,只要一个方法实现了,就会马上添加到方法列表中。
    会员机制的App可以使用动态加载，是会员的时候，去动态加载会员的方法。
#### 7.1、类的+resolveInstanceMethod方法，用于寻找实例对象的方法，只要一个对象调用了一个未实现的方法就会调用这个方法。
    需要先导入runtime的头文件#import <objc/message.h>
    // 任何方法默认都有两个隐式参数,self,_cmd
    // 什么时候调用:只要一个对象调用了一个未实现的方法就会调用这个方法,进行处理
    // 作用:动态添加方法,处理未实现
    + (BOOL)resolveInstanceMethod:(SEL)sel
    {
        // [NSStringFromSelector(sel) isEqualToString:@"eat"];
        if (sel == NSSelectorFromString(@"run:")) {
            // eat
            // class: 给哪个类添加方法
            // SEL: 添加哪个方法，(底层是表征方法的结构体)
            // IMP: 方法实现 => 函数 => 函数入口 => 函数名(你定义好的方法，用于动态加载进去，塞进去)
            // type: 方法类型（查看官网api怎么去声明这个类型，类型编码），v是void，@是对象(隐藏参数)，:是方法类型(_cmd),@是方法签名中的参数。
            class_addMethod(self, sel, (IMP)aaa, "v@:@");
            return YES;
        }
        
        return [super resolveInstanceMethod:sel];

    }
##### 7.11、 任何方法默认都有两个隐式参数,self (接收方法的对象)，_cmd (方法编号)，是默认隐藏的，你可以在方法体里调用，实际是可用的，这就是隐藏的参数。
    - (void)viewDidLoad {
        [super viewDidLoad];
       
        NSLog(@"@",NSStringFromSelector(_cmd))  // _cmd:当前方法的方法编号
        Person *p = [[Person alloc] init];   
        
        //    [p performSelector:@selector(eat)];   // 执行某个方法
        [p performSelector:@selector(run:) withObject:@10];
    }
    
    ◆ 也可以写在方法的参数列表里，没有返回值,也没有参数
    // void,(id,SEL)
    void aaa(id self, SEL _cmd, NSNumber *meter) {
        NSLog(@"跑了%@", meter);
    }

##### 7.12、查看官网文档Runtime Programming Guide的Type Encodings章节，可以知道方法的类型的编码意义，在字符串中的意义，例如v表示Void，“:”冒号表示方法。
    class_addMethod(self, sel, (IMP)aaa, "v@:@");

### 8、Runtime动态添加属性， 本质就是让某个属性与对象产生关联。(关联的意思是引用，而非在自己的堆空间容纳一个对象)
    // 需求:让一个NSObject类 保存一个字符串
#### 8.1、使用分类添加@property属性，只会生成getter、setter方法，不会生成实现,也不会生成下划线成员属性。
#### 8.2、再使用Runtime的objc_setAssociatedObject方法去关联一个对象，这样属性的生命周期就可以(策略)和宿主对象的生命周期一样了。获取是objc_getAssociatedObject方法。
    - (void)setName:(NSString *)name
    {
        //    _name = name;  // 让这个字符串与当前对象产生联系
        
        // object:给哪个对象添加属性
        // key:属性名称
        // value:属性值
        // policy:保存策略
        objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    - (NSString *)name
    {
        return objc_getAssociatedObject(self, @"name");
    }

### 9、Runtime来理解KVC，就是根据key来寻找Value，这是键值对编码，是在NSObject的分类中提供的方法。KVO才是属性监听。
#### 9.1、Runtime结合NSDictionary，实现NSDictionary与OC对象的转换，使用isKindOfClass方法作类型判断，思想是KVC。在NSDictionary的分类中设计。
    
    @implementation NSDictionary (Property) //在NSDictionary的分类中：字典转换为模型对象，这里是生成模型对象的属性声明的文本字符串。
    
    // isKindOfClass:判断是否是当前类或者子类
    // 生成属性代码 => 根据字典中所有key
    - (void)createPropertyCode
    {
        NSMutableString *codes = [NSMutableString string];
        // 遍历字典
        [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
            
            NSString *code;
            if ([value isKindOfClass:[NSString class]]) {
                code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;",key];
            } else if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
                code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
            } else if ([value isKindOfClass:[NSNumber class]]) {
                 code = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",key];
            } else if ([value isKindOfClass:[NSArray class]]) {
                 code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                 code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
            }

            // @property (nonatomic, strong) NSString *source;
            
            [codes appendFormat:@"\n%@\n",code];
            
        }];
        
        NSLog(@"%@",codes);
    }
#### 9.2、BOOL类型是私有的，所以用NSClassFromString(@"__NSCFBoolean")方法来获取BOOL类型的类对象，是NSNumber的子类。


----------
day02
------------------------

## KVC是NSObject的分类(NSKeyValueCoding)中的一些方法，体现了KVC的思想。
### 1、-setValuesForKeysWithDictionary方法是 传入NSDictionary对象 ，根据NSDictionary给当前对象的所有属性赋值，所以要注意key和属性名的对应规则。
    // KVC原理:
    [item setValue:@"来自即刻笔记" forKey:@"source"]:
    1.首先去模型中查找有没有setSource,找到,直接调用赋值 [self setSource:@"来自即刻笔记"]
    2.去模型中查找有没有source属性,有,直接访问属性赋值  source = value
    3.去模型中查找有没有_source属性,有,直接访问属性赋值 _source = value
    4.找不到,就会直接报错 setValue:forUndefinedKey:报找不到的错误
    
    // 1.遍历字典中所有key,去模型中查找有没有对应的属性(名字)
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        
        // 2.去模型中查找有没有对应属性 KVC
        // key:source value:来自即刻笔记
        // [item setValue:@"来自即刻笔记" forKey:@"source"]
        [item setValue:value forKey:key];
        
    }];
    
#### 1.1、KVC必须保证字典的key和model的属性一一对应，不然会报找不到属性的错误，所以要进行二次封装。
## OC小技巧：方法的参数如果传入的是基本类型的指针，那么一般方法执行完之后，会修改该指针指向的值，也就是参数作返回值。
### 2、利用Runtime可以从属性去遍历字典，这样就不会报找不多属性的错误。或者重写setValue方法。都是对NSObject进行分类。
    // 拿到每一个模型属性,去字典中取出对应的值,给模型赋值
    // 从字典中取值,不一定要全部取出来
    // MJExtension:字典转模型 runtime:可以把一个模型中所有属性遍历出来
    // MJExtension:封装了很多层
    / /    item.pic_urls = dict[@"pic_urls"];
    //    item.created_at = dict[@"created_at"];

#### 2.1、 Ivar:成员变量 以下划线开头，是对应C语言中的成员变量； Property:属性，OC对成员变量的封装。
    // 本质:创建谁的对象，在NSObject的分类文件中编写。 NSObject+Model.m 文件
    + (instancetype)modelWithDict:(NSDictionary *)dict
    {
        id objc = [[self alloc] init];
        
        // runtime:根据模型中属性,去字典中取出对应的value给模型属性赋值
        // 1.获取模型中所有成员变量 key
        // 获取哪个类的成员变量
        // count:成员变量个数
        unsigned int count = 0;
        // 获取成员变量数组
        Ivar *ivarList = class_copyIvarList(self, &count);
        
        // 遍历所有成员变量
        for (int i = 0; i < count; i++) {
            // 获取成员变量
            Ivar ivar = ivarList[i];
            
            // 获取成员变量名字
            NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            // 获取key
            NSString *key = [ivarName substringFromIndex:1];
            
            // 去字典中查找对应value
            id value = dict[key];
            
            // 给模型中属性赋值
            if (value) {
                [objc setValue:value forKey:key];
            }
        }
            
        return objc;
    }
#### 2.2、 runtime获取类里面所有方法class_copyMethodList
    // 获取类里面所有方法
    // class_copyMethodList(__unsafe_unretained Class cls, unsigned int *outCount)
#### 2.3、runtime获取类里面属性class_copyPropertyList
    // 获取类里面属性
    //  class_copyPropertyList(__unsafe_unretained Class cls, unsigned int *outCount)

#### 2.4、如果属性也是非NS对象，也就是字典中的元素是字典，那么要进行二级转换。将元素字典转换为模型，再转换为对象的属性。递归调用。 （注意是转换为model，不是转成工具类）
    
    // 遍历所有成员变量
    for (int i = 0; i < count; i++) {
        // 获取成员变量
        Ivar ivar = ivarList[i];
        
        // 获取成员变量名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 获取成员变量类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // @\"User\" -> User
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        // 获取key
        NSString *key = [ivarName substringFromIndex:1];
        
        // 去字典中查找对应value
        // key:user  value:NSDictionary
        
        id value = dict[key];
        
        // 二级转换:判断下value是否是字典,如果是,字典转换层对应的模型
        // 并且是自定义对象才需要转换
        if ([value isKindOfClass:[NSDictionary class]] && ![ivarType hasPrefix:@"NS"]) {
            // 字典转换成模型 userDict => User模型
            // 转换成哪个模型

            // 获取类
            Class modelClass = NSClassFromString(ivarType);
            
            value = [modelClass modelWithDict:value];   //递归调用
        }
        
        // 给模型中属性赋值
        if (value) {
            [objc setValue:value forKey:key];
        }
    }

#### 2.5、字典中的元素是字典的话，key是key，value是NSDictionary，就不一定都是字符串，而且xcode做好了plist与NSDictionary的转换了的。


## super与self关键字：
### 0、self：是对象方法调用则表示是实例对象，是类方法调用，则表示是类对象 。并不是方法体定义中的self，而是通过调用者传递过去的self，是地址传递。
    SubPerson *p = [[SubPerson alloc] init];
    [p test];
    //那么在test方法体中定义的self都是表示p这个对象实例，哪怕是在父类的方法体中定义的self，因为这个是地址传递。
    //父类Person中定义的test方法体代码
    - (void)test
    {
        // self -> SubPerson
        // SubPerson Person  SubPerson Person
         NSLog(@"%@ %@ %@ %@",[self class], [self superclass], [super class], [super superclass]);
    }
### 1、super:仅仅是一个编译指示器的指令,就是给编译器看的,不是一个指针。本质:只要编译器看到super这个标志,就会让当前对象去调用父类方法,本质还是当前对象在调用。
#### 1.1、所以super底层传递的第一个参数还是self，只是去调用了父类的方法，但是class方法调用的就当前者的类，所以就不是父类的类对象，关键是class这个方法的影响。
    // SubPerson Person  SubPerson Person
    NSLog(@"%@ %@ %@ %@",[self class], [self superclass], [super class], [super superclass]);   //所以这里的super代表的仍然是子类对象SubPerson的地址，而class方法返回的是当前对象的类。
    
    - (NSString *)description
    {
        /*
            //所以super传递的第一个参数还是self，只是去调用了父类的方法，但是class方法调用的就当前者的类，所以就不是父类的类对象，关键是class这个方法的影响。
            objc_msgSendSuper({self, class_getSuperclass(objc_getClass("Person"))}, sel_registerName("description"));   
         */
        return [super description];
    }
    
### 2、[self class] 中的class: 是获取当前方法调用者的类。
### 3、 [self superclass] 中的superclass: 是获取当前方法调用者的父类。
  
## xcode小技巧：在TARGETS --> Building Phases --> Compile Source中可以查看被编译的.m 、.h 、.swift文件是否缺失，没有被引入。

## const,static,extern的区别：
### 1、宏，常用字符串,常见基本变量，我们一般 定义宏 来表征，只是字符串的替代。 宏是预编译，没有编译检测，可定义函数，但是太乱，导致预编译时间过长。
    #define XMGUserDefaults [NSUserDefaults standardUserDefaults]
    #define XMGNameKey @"name"
### 2、const，苹果一直推荐我们使用const,而不是宏。const是编译阶段，有编译检查，不可以定义函数
    CGFloat const a = 3;
    const与宏的区别(面试题)
    1.编译时刻 宏:预编译 const:编译
    2.编译检查 宏没有编译检查,const有编译检查
    3.宏的好处 定义函数.方法, const不可以 
    4.宏的坏处 大量使用宏,会导致预编译时间过长
 
 ### 3、const作用(用于修饰右边的类型):  1.修饰右边基本变量或者指针变量 ；2.被const修饰变量只读
     // 修饰基本变量
    //int const a = 3;  //修饰a，a不能变
    // const int a = 3;
    // a = 5;
        
        // 修饰指针变量
    //    int a = 3;
    //    int b ;
    //    int  * const p = &a;
    //     a = 5;
    //    *p = 8;
    //    p = &b;
    
    // 面试题
    int * const p;  // p:只读  *p:变量
    int const * p1; // p1:变量 *p1:只读
    const int * p2; // p2:变量 *p2:只读
    const int * const p3; // p3:只读 *p3:只读
    int const * const p4; // p4:只读 *p4:只读
    
#### 3.1、修饰全局变量 => 全局只读变量 => 代替宏
#### 3.2、修饰方法中参数，不允许在方法体里面修改参数的值。
    - (void)test:(int const *)a
    {
        *a = 3; //报错，不能修改参数的值
        
    }

### 4、static：被static修饰局部变量,只会分配一次内存；被static修饰全局变量,作用域会修改,只能在当前文件下使用(swift不是这样)。
#### 4.1、static和const结合使用，会限制全局变量的作用域。
    1.修饰局部变量,被static修饰局部变量,延长生命周期,跟整个应用程序有关
    * 被static修饰局部变量,只会分配一次内存
    * 被static修饰局部变量什么分配内存? 程序一运行就会给static修饰变量分配内存
    
    2.修饰全局变量,被static修饰全局变量,作用域会修改,只能在当前文件下使用
    
### 5、extern：只能用于声明外部全局变量,不能用于定义。会去其他文件查找。
#### 5.1、extern和const结合使用，
    extern:声明外部全局变量,注意:extern只能用于声明,不能用于定义
    extern工作原理:先会去当前文件下查找有没有对应全局变量,如果没有,才会去其他文件查找。一运行就被分配内存。

### 6、const和extern的联合使用：避免全局变量的重复定义。
#### 6.1、规定:全局变量不能定义在自己类中,自己创建全局文件管理全局东西。
#### 6.2、在.h文件中用extern声明全局变量，在.m文件中用const定义全局变量 。
    
    //可以自己定义宏来代替extern
    #ifdef __cplusplus
    #define XMGKIT_EXTERN        extern "C" __attribute__((visibility ("default")))
    #else
    #define XMGKIT_EXTERN            extern __attribute__((visibility ("default")))
    #endif
    XMGKIT_EXTERN NSString * const discover_name;
    
    
    在.h文件中：
    extern NSString * const discover_name;
    
    在.m文件中：
    // 定义整个项目中全局变量
    /***************发现*************/
    NSString * const discover_name = @"name";


## 父子控制器：多控制器管理,导航控制器,UITabBarController
### 1、UIViewController也是可以管理子控制器。
#### 1.1、子控制器会自己管理自己的事件传递。

### 2、➽ 开发规则:如果A控制器的view添加到B控制器的view上,那么A控制器必须成为B控制器的子控制器。
### 2.1、UITabBarController永远只会显示一个VC的view,把之前的VC的view暂存。
### 2.2、占位视图思想：用一个View来暂存所有的子VC的View，用addSubview来切换VC的View，这样就不用做尺寸适配了，全部等于占位View的尺寸就好，还方便管理。
    UITabBarController有个专门存放子控制器view,占位视图思想,1.不用去考虑子控制器的view尺寸 2.屏幕适配也不用管理
### 2.3、addSubview方法会把当前的View提到最前显示，如果是已经是父子关系的View，则只会提前。View不可以有多个父亲。
    // 移除之前控制器的view，makeObjectsPerformSelector让数组中的所有元素都执行这个方法的参数方法removeFromSuperview。
    [self.containView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

### 3、➽ self.navigationController，VC首先去判断下自己是否是导航控制器的子控制器,判断父控制器是否是导航控制器的子控制器,直到没有父控制器为止。
    [self.navigationController pushViewController:vc animated:YES];
    
### 4、导航VC的push操作是会把当前的VC push进栈存起来，然后把当前的VC放到屏幕上显示。

### 5、VC的modal(模态)父子关系，任何控制器都可以使用modal效果。
#### 5.1、modal展示一个VC其实跟导航VC的push管理方式是一样的，都是把当前的VC在window上显示，但是modal的父VC不会被入栈暂存，而是一直在屏幕上。
#### 5.2、➽ self dismissViewControllerAnimated 也是会判断下当前方法调用者是否被modal,如果不是,判断父控制器是否被modal，然后判断收回。


----------
day03
------------------------
## 父子控制器的使用
### 1、一个页面多个按钮之间需要通信的话，可以设置前置标志器(在按钮的Action中)，把上一个选中的按钮状态还原，还可以通过View的tag属性进行通信。

### 2、VC的View和VC都是懒加载(到屏幕)的ViewDidLoad，所以没有使用的时候不会加载，例如设置背景颜色的时候就会去加载。懒加载是为了提高性能，不要太多东西占用内存。
#### 2.1、vc.viewIfLoaded用于判断该VC是否已经被加载。

### 3、iOS7以后,导航控制器中scollView顶部会添加64的额外滚动区域。
    解决：self.automaticallyAdjustsScrollViewInsets = NO;
    
### 4、ScrollView的分页是以scrollView的frame为一页进行分页弹回的。
    self.contentScrollView.pagingEnabled = YES;
#### 4.1、ScrollView的偏移量是指没被显示的contentOffset，而不是当前点距离原点的距离，而是第一点偏移bounds原点的距离。注意正负。
#### 4.2、设置contentOffset就是把contentsize的contentOffset点，移动到bounds原点的位置。就是移动指定点到原点。

### 5、修改button的字体大小，可以通过修改Button的形变，就是修改transform。
#### 5.1、颜色的渐变是不断地设置RGB的值，三种通道，可以只改变其中一个值实现渐变。
    颜色:3种颜色通道组成 R:红 G:绿 B:蓝
    白色: 1 1 1
    黑色: 0 0 0
    红色: 1 0 0

### 6、你写好的VC可以当作父VC，这样就相当于模版，以后就不用再敲一遍了。直接调用super就好。但是要考虑扩展性。
#### 6.1、方法是不占用内存的(编译器会优化)，占用的是成员变量。

## UIScrollView的SB自动布局: contentView是要自己设置的，设置了contentView之后，scrollView的约束才会有效。
### 1、UIScrollView的原理是：contentSize其实是自定义想使用bounds的坐标系的部分大小，移动是因为修改的scrollView的bounds的x，y点的位置，导致contentView移动。
#### 1.1、只是修改了UIScrollView的bounds的x,y点，并没有修改bounds的size大小，修改size会导致frame也改变。size不是bounds的坐标系，坐标系是无限的。
#### 1.2、所以UIScrollView的contentSize是想拿来使用的bounds的坐标系部分，而不是scrollView的bounds的size。size是内容的可视范围，只是被展示的大小。

## UIView的frame和bounds：
### 1、frame是从左上角向右下角扩展size的。
#### 1.1、frame描述的是可视范围。
#### 1.2、bounds描述可视范围在内容坐标系的区域，所有的子控件都是相对于内容坐标系，会导致子view移动。修改bounds的x，y点，导致移动的是坐标系。

### 2、bounds是从中心向四周扩展size的，绘制。bounds会撑大frame(也会缩小)的size，因为bounds的size是取值了frame的size。
#### ◆ 2.1、对于bound的point：它不会改变frame的原点，改变的是bounds自己的原点，进而影响到“子view”的显示位置。这个作用更像是移动bounds原点的意思。
#### ◆ 2.2、对于bound的size：它可以改变的frame。如果bounds的size比frame的size大。那么frame也会跟着变大，那么frame的原点也会变，但是center不会变。 这个作用更像边界的意思。
#### ◆ 2.3、bounds 定义时 Rect的点 是左上角的点 在自身坐标系中的位置，也就是左上角的点并不是原点，而是位置。代表了相对于原点的位置。
##### 2.3.1、进而影响到“子view”的显示位置。位置不移动，移动的是整个自身坐标系，从而导致子view移动。
    -(CGRect)frame{
        return CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    }
    -(CGRect)bounds{
        return CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    }
    


## 多线程中的通知：谁发布，就是谁执行。
### 1、通知可以在delloc方法中移除，通知不会导致强引用。但是通知中的block引用了self，会造成强引用。
### 2、带block的通知很方便，不用再定义一个方法，系统会自动移除监听，但是避免在block中引用了self，所以最好还是自己再显式移除一下这个通知。

### 3、收到通知的代码的执行 由 发出通知线程决定。也就是谁发通知，谁执行代码。而不管是哪个线程注册了通知。
#### 3.1、异步:监听通知 主线程:发出通知。接收通知代码在主线程执行
#### 3.2、主线程:监听通知 异步:发出通知。 接收通知代码在异步执行。要注意UI的更新必须在主线程，注意这个bug。
#### 3.3、bug:监听不到通知,马上想到有可能是先发出通知,然后才监听通知。顺序发生了问题。


## 面试:解释weak,assgin,什么时候使用Weak和assign。
### 1、ARC才有weak 。weak:__weak 弱指针,不会让引用计数器+1,如果指向对象被销毁,指针会自动清空。
#### 1.1、方法体中的临时view，方法体一执行完就会销毁，方法栈退出就会销毁对象，除非有外部引用。

### 2、 assgin:__unsafe_unretained修饰,不会让引用计数器+1,如果指向对象被销毁,指针不会清空。会有野指针。

-------------
day04
-------------------

## Block的基本使用
### 1、Block有一种声明方式，有三种定义(赋值)方式
#### 1.1、 block声明:返回值(^block变量名)(参数)    void(^block)();      block定义(赋值):三种方式 = ^(参数){}; 
#### 1.2、第一种，无参无返回值：
    void(^block1)() = ^{
        NSLog(@"调用了block1");
    };
#### 1.3、第二种，如果没有参数,参数可以隐藏,如果有参数,定义的时候,必须要写参数,而且必须要有参数变量名。
    void(^block2)(int) = ^(int a){
        
    };
#### 1.4、第三种， block返回值可以省略,不管有没有返回值,都可以省略
    int(^block3)() = ^int{
        return 3;
    };

### 2、Block的类型，其实相似指针函数的定义，只不过block是用 ^ ，而指针函数用 * 。一般block的类型用别名比较方便。
#### 2.1、int(^)(NSString *)   
    int(^block4)(NSString *) = ^(NSString *name){
        return 2;
    };
#### 2.2、block的调用和方法的调用一样，用block名字加括号。
    block1();   // block调用
#### 2.3、声明且定义block快捷方式，键盘直接敲inline

### 3、Block的使用场景：
#### 3.1、在一个方法里定义，在另一个方法里调用。
    block怎么声明,就如何定义成属性；
    @property (nonatomic, strong) void(^block1)(); //名字是block1
    void(^bloc1k)() = ^{
        NSLog(@"调用block");
    };
    _block1 = block1;

#### 3.2、在一个类中定义,在另外一个类中调用。例如VC与tableview的cell。保存代码在模型中。

#### 3.3、block传值：只要能拿到对方就可以传值，也就是把自己传出去。(常用，但是我觉得很乱)
##### 3.3.1、顺传：给需要传值的对象,直接定义(赋值)属性就能传值。
##### 3.3.2、代理、block用于逆传：block就是利用block去代替代理，关键在于把自己传出去。把自己传给下级，所以要在下级设置代理或者block作为属性。
    代理传值：
    
    下级定义代理属性、协议和方法：
    @protocol ModalViewControllerDelegate <NSObject>
    @optional
    // 设计方法:想要代理做什么事情
    - (void)modalViewController:(ModalViewController *)modalVc sendValue:(NSString *)value;
    @end
    
    
    // 传值给上级，ViewController
    if ([_delegate respondsToSelector:@selector(modalViewController:sendValue:)]) {
        [_delegate modalViewController:self sendValue:@"123"];
    }
    
    block传值：
    @property (nonatomic, strong) void(^block)(NSString *value);
    // 传值给ViewController，上级
    if (_block) {
        _block(@"123");
    }

#### 3.4、block的内存管理，只要block没有引用外部局部变量,block放在全局区。block是一个OC对象，可以添加到集合中。底层是用对象来支撑block的。
##### 3.4.1、MRC:只要block没有引用外部的局部变量，block放在全局区，相当于全局可用。是block代码体内部没有引用到外面的东西。否则在栈里面。
##### 3.4.2、MRC: block只能使用copy,不能使用retain,使用retain,block还是在栈里面(因为是代码体)。使用copy是复制到堆，不然block在栈里就被释放了，无法再次使用。
    @property (nonatomic, copy) void(^block)();
    不能 @property (nonatomic, retain) void(^block)();

##### 3.4.3、ARC：只要block引用到外部的局部变量,block放在堆里面，block使用strong.最好不要使用copy
    ARC中只要用到了强引用，就可以保证对象在方法栈中不被销毁，即便是方法栈已经销毁。会自动copy到堆，或者全局区，全局区的话就是相当于不可变的逻辑流。弱引用的话，方法栈中的对象会随着栈被销毁。
    因为使用copy关键字和strong的话，系统会在调用该block属性时，调用很多没必要的copy方法。而block属性

#### 3.5、◆ block的循环引用
##### 3.5.1、modalViewController不会被销毁是因为VC默认有一个presentedViewController属性强引用了modalVC。
##### 3.5.2、block造成循环引用:Block会对里面所有强指针变量都强引用一次，所以在block哪怕是自己定义时，引用self，也会导致自己不能被释放。
##### 3.5.3、在block赋值前使用__weak关键字，使得block中的强指针变成弱指针，不会retain计数加一。__weak typeof(self) weakSelf = self; 
##### 3.5.4、延迟执行block2里的代码块，可能会导致block2里的弱指针已经被销毁，无法使用。
##### 3.5.5、可以在block1代码体里使用__strong 关键字，执行完block2代码，block2被系统释放。一层一层地导致weakSelf也被释放。__strong typeof(weakSelf) strongSelf = weakSelf;其实是再强引用了上一个vc对象，但是vc对象没有强引用到block2.
    因为block代码块中引用了外部的变量的话，会被复制到堆区，而堆区就强引用了外部变量，导致外部变量不能被释放。如果block刚好又是外部变量的属性的话，那么外部变量也强引用了block，导致block不能被释放。于是循环引用了。
    __weak typeof(self) weakSelf = self;    //
    _block1 = ^{ 
                                                             //注意，由于block1本来就已经复制到堆中了，所以strongSelf只是一个栈的临时变量，block1的代码块执行完后就会被销毁。
        __strong typeof(weakSelf) strongSelf = weakSelf;    //这个strongSelf是属于栈里面的局部变量，虽然引用了局部变量的block2会复制到堆区，但是堆区里面的block2没有人指向它的话，就会释放掉，
                                                            //所以，持有strongSelf的block2会被释放掉。然后vc对象就没有人强引用指向它了，然后vc对象释放。然后block1没有人强引用它了，然后block1释放。
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             NSLog(@"%@",strongSelf);   //延迟执行block里的代码块，可能会导致block里的弱指针已经被销毁，无法使用。
                                        //__strong其实是在dispatch_after闭包强引用了一次block1里的weakself，导致weakself不会被释放。
                                        //而dispatch_after闭包里的代码体执行完之后会释放weakSelf的强引用，因为新的block是执行完会被释放掉，所以weakSelf最后就会被释放。
        });
    };

## 文档小技巧：以working开头的文档，一般都是介绍基本原理的东西。
## 编程小技巧：只有MRC才能调用super，只有MRC能使用retain,release。ARC不可以。
    MRC了解开发常识:1.MRC没有strong,weak,局部变量对象就是相当于基本数据类型
                  2.MRC给成员属性赋值,一定要使用set方法,不能直接访问下划线成员属性赋。不然会retain，造成内存泄漏，要在set方法中release。
    ARC管理原则:只要一个对象没有被强指针修饰就会被销毁,默认局部变量对象都是强指针,存放到堆里面


#### 3.6、◆ block的变量传递：虽然block代码体里引用了外部的局部变量会复制到堆，但是引用外部的局部变量仍然是值传递。
##### 3.6.1、如果是静态变量,全局变量,__block修饰的变量,block都是指针传递。注意什么事局部变量，什么是全局变量，什么是静态变量，什么是静态全局变量。



#### 3.7、 block作为参数：只要有^，就是把block当做参数。
##### 3.7.1、block作为参数，调用者去定义block的方法体，而设计者决定什么时候调用这个block。并不是马上就调用。
##### 3.7.2、什么时候需要把block当做参数去使用:做的事情由外界决定,但是什么时候做由内部决定。
    也就是调用者传入blcok的设计者，然后设计者在自己设计的类里面决定什么时候去调用block。
    怎么区分参数是block,就看有没有^,只要有^.把block当做参数。

    设计者设计一个block： 在.h文件中
    @interface CacultorManager : NSObject
    - (void)cacultor:(NSInteger(^)(NSInteger result))cacultorBlock; //(NSInteger(^)(NSInteger result))是参数类型，cacultorBlock是参数名字，：前面是参数标签。
    @end

    设计者设计什么时候调用block，在.m文件中：
    - (void)cacultor:(NSInteger (^)(NSInteger))cacultorBlock    
    {
        if (cacultorBlock) {
          _result =  cacultorBlock(_result);
        }
    }
    
 #### 3.8、block当作返回值：可以实现点运算符调用方法，链式编程。其实是执行返回值闭包。block作为方法的返回值，self当作block的返回值，继续调用(两次封装)。
    如果OC中想实现链式编程像调用方法一样，那么就用block作为返回值。是有参数的点运算符，那么参数其实是block。其实相当于直接定义block并且执行。
    self.test(); //执行test方法中的返回值闭包。
    - (void(^)())test
        return ^{
            NSLog(@"调用了block");
        };
    }
    
    //如果block不是返回值。
    self.test1;  //执行方法test1
    - (void)test1
    {
        NSLog(@"%s",__func__);
    }
    
    //链式调用示范：
    - (CalculatorManager *(^)(int))add      //链式方法的定义，相当于封装了两次，真正的执行是在最内层封装的block的代码体。
    {
        return ^(int value){
            _result += value;
            return self;
        };
    }
    
    mgr.add(5).add(5).add(5).add(5);  //链式方法的调用
 
 ## ➽ (小知识)链式编程思想：把所有的语句用.号连接起来,好处:可读性非常好。
 ## ➽ OC中的链式编程思想也是点运算符，但是规定了只有实现了getter、setter方法才可以使用点运算符，不然会报警告，但是一样可用。 


## 自定义collectionView的流水布局：
    //先设置collectionViewLayout的一些常见属性，如果还不能满足需求，则继承collectionViewLayout，再去实现一些代理方法，自定义自己的布局。
    
### ◆ 1、创建UICollectionView必须要有布局参数；cell必须通过注册；cell必须自定义(继承),系统cell没有任何子控件。
#### 1.1、因为系统不提供UICollectionView的cell管理，所以你必须提供cell(注册)和布局参数collectionViewLayout。但是默认提供复用池。
    从xib唤醒cell，注册xib的cell：
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PhotoCell class])  bundle:nil] forCellWithReuseIdentifier:@"cell_ID"];
    
### ◆ 2、布局参数collectionViewLayout，决定了cell的尺寸，布局，并进行调整。
#### 2.1、先设置collectionViewLayout的一些常见属性，如果还不能满足需求，则继承collectionViewLayout，再去实现一些代理方法，重写一些方法，自定义自己的布局。
    自定义布局:只要了解5个方法，重写父类的五个方法。
    
    ◆ 什么时候调用:collectionView第一次布局,collectionView刷新的时候也会调用；作用:计算cell的布局,使用前提条件:cell的位置是固定不变的。(所以不一定适用，有可能只调用一次，滚动不会调用)
    - (void)prepareLayout;
    
    /*
     UICollectionViewLayoutAttributes:确定cell的尺寸
     一个UICollectionViewLayoutAttributes对象就对应一个cell
     拿到UICollectionViewLayoutAttributes相当于拿到cell
     */
     ◆ 作用:指定一段区域，给你这段区域内cell的尺寸， 可以一次性返回所有cell尺寸,也可以每隔一个距离返回cell。通过当前cell与collectionView.contentOffset的距离来计算出当前cell是哪一个。
    - (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
    {
        // 1.获取当前显示cell的布局
        NSArray *attrs = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
        
        for (UICollectionViewLayoutAttributes *attr in attrs) {
            // 2.计算两个中心点的距离，cell和bounds的中心点越靠近，该图片扩张得越大
          CGFloat delta = fabs((attr.center.x - self.collectionView.contentOffset.x) - self.collectionView.bounds.size.width * 0.5);
            // 3.计算比例
            CGFloat scale = 1 - delta / (self.collectionView.bounds.size.width * 0.5) * 0.25;
            
            attr.transform = CGAffineTransformMakeScale(scale, scale);
        }
        return attrs;
    }
    
    ◆ 在滚动的时候是否允许刷新布局，如果返回YES那么会导致调用prepareLayout方法。但要设置为YES，因为layoutAttributesForElementsInRect要用到。★
    - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;    //Invalidate:翻译为刷新。
    
    ◆ 作用:返回值决定了最终偏移量，用户手指一松开就会调用。 调用父类时，不等于 手指离开时偏移量，一般大于松手时的偏移量。
    - (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
        // 拖动比较快 最终偏移量 不等于 手指离开时偏移量
        // 最终偏移量
        CGPoint targetP = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
        
        // 获取collectionView偏移量，这里是松手时的偏移量
        NSLog(@"%@ %@",NSStringFromCGPoint(targetP),NSStringFromCGPoint(self.collectionView.contentOffset));
        return targetP;
    }

   
    ◆计算collectionView的滚动范围 
    - (CGSize)collectionViewContentSize{
        return [super collectionViewContentSize];
    }
    
    
##### 2.1.1、layout.sectionInset用于设置section与父View(即contentView)之间的内边距，上、左、下、右。
    CGFloat margin = (ScreenW - 160) * 0.5;
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
##### 2.1.2、layout.minimumLineSpacing与layout.minimumInteritemSpacing不用太纠结，有可能是ios做了选择，哪个符合你就哪个，不是竖直就是水平间隔。
##### 2.1.3、通过layout的layoutAttributesForElementsInRect方法的参数UICollectionViewLayoutAttributes来控制cell的尺寸。
##### 2.1.4、在layoutAttributesForElementsInRect中，通过当前cell的attribute与collectionView.contentOffset的距离来计算出当前cell是哪一个。
##### 2.1.5、★ [super layoutAttributesForElementsInRect:self.collectionView.bounds];通过调用super的layoutAttributesForElementsInRect方法，也可以获取当前显示区域的所有cell。
##### 2.1.6、★ shouldInvalidateLayoutForBoundsChange需要重写返回YES，不然layoutAttributesForElementsInRect中设置的cell尺寸不起作用。
##### 2.1.7、targetContentOffsetForProposedContentOffset的返回值决定了collectionView的最终偏移量。
##### 2.1.8、★ ★ collectionViewLayout一般需要在重写的方法里面，还要再调用一次父类super的该方法来获取你需要的值。

#### 2.2、如果想collectionView滑动定位到某一个点，只需要在targetContentOffsetForProposedContentOffset方法中设置返回值就可以决定最终位置了。
##### 2.2.1、要在targetContentOffsetForProposedContentOffset调用layoutAttributesForElementsInRect获取当前区域的cell。也要调用super的方法获取本来最终的位置。
    // 定位:距离中心点越近,这个cell最终展示到中心点
    - (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
        // 拖动比较快 最终偏移量 不等于 手指离开时偏移量
        CGFloat collectionW = self.collectionView.bounds.size.width;
        // 最终偏移量
        CGPoint targetP = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
        
        // 0.获取最终显示的区域
        CGRect targetRect = CGRectMake(targetP.x, 0, collectionW, MAXFLOAT);
        
         // 1.获取最终显示的cell
        NSArray *attrs = [super layoutAttributesForElementsInRect:targetRect];
        
        // 获取最小间距，中心cell和内容偏移之间的间距。
        CGFloat minDelta = MAXFLOAT;
        for (UICollectionViewLayoutAttributes *attr in attrs) {
            // 获取距离中心点距离:注意:应该用最终的x
            CGFloat delta = (attr.center.x - targetP.x) - self.collectionView.bounds.size.width * 0.5;
            if (fabs(delta) < fabs(minDelta)) {
                minDelta = delta;
            }
        }
        // 移动间距
        targetP.x += minDelta;
        if (targetP.x < 0) {
            targetP.x = 0;
        }
        return targetP;
    }
## ➽ (小知识)函数式编程思想：把很多功能放在一个函数块(block块)去处理，给一个返回值。(高聚合，方便去阅读、管理)
    编程思想:低耦合,高聚合(代码聚合,方便去管理)
    int c = ({
    int a = 2;
    int b = 3;
    int q = 3;
    int w = 3;
    int e = 3;
    a + b + q;
    });
    NSLog(@"%d",c);

## ➽ OC编程小技巧：用一个代码块 ({ ... }); 赋值 ，得到的值是代码块的最后一行代码；有点相似swift的懒加载写法，方便阅读。
### ps：这种方法一般用于封装控件。
    // 流水布局:调整cell尺寸
    UICollectionViewFlowLayout *layout = ({
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(160, 160);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat margin = (ScreenW - 160) * 0.5;
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
        // 设置最小行间距
        layout.minimumLineSpacing = 50;
        layout;
        
    });

