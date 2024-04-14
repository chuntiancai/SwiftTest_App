//
//  TestOCNSObject_VC.h
//  SwiftTest_App
//
//  Created by mathew on 2023/1/10.
//  Copyright © 2023 com.mathew. All rights reserved.
//
// OC的类与对象的底层
//MARK: - 笔记
/**
    OC所谓的运行时动态添加方法就是：
        我没有继承原来的类，也没有修改原来的类的源代码，而是写一个分类，改变它的方法体使它原来的方法执行不同的功能，或者添加一个新的方法。
        说白了就是从旁敲击，注射，或者说反射也可以。
        swift没有动态添加方法的功能，也就是不能修改原来的方法体实现，但是可以通过extension添加新的方法，或者高阶函数传闭包。
 
    1、对象的alloc方法，底层是c++实现，会分配内存和对象的标识符进行绑定，然后init方法相当于一个抽象接口，给用户自定义使用。
        
        OC对象在内存上那段空间的内容：
            元数据描述的所用属性，一个萝卜一个坑填进去。//初始化，就是在这些坑里面填默认数据。
            元数据的地址指针isa_t，通过这个指针去找方法的所在地址，消息派发。
            引用计数也在isa_t联合体里，通过位域存储信息来维护。
        
    
    2、OC对象对应的C++数据结构：
        OC首先会经过Clang编译器，编译成C++语言的源码。
        NSObject对象 <-对应->  C++ 的结构体： objc_object
        NSObject的类 也对应 --> C++ 的结构体：objc_class 继承 objc_object
        所以OC中的对象和类的描述数据结构，最顶层都是继承objc_object
 
            而objc_object结构体，包含了isa_t联合体，这个联合体的每一位域，每一个bit位都代表了不同信息，也有ref引用计算、对象等信息，
            这里简单理解相当于是一个指针。主要包含了类地址，不仅仅包含类地址，也存储了一些别的信息。
            isa_t是联合体+位域的方式存储信息的。可以节省大量内存。通过位域的方式，可以在isa上面存储更多相关信息。
            如果想要获取objc_class的地址，则需要用isa_t的位域与一个ISA_MASK常量相与得出。
 
    3、通过isa_t联合体找到类的地址后（OC的类），对应的是C++的objc_class结构体，（objc_class继承objc_object结构体。）
        所以objc_object是最顶层的结构体，包含了最基础的信息：isa_t联合体。   //实例对象，类，在C++中都继承这个结构体
 
        总结：objc_class结构体有三个变量，分别是指向superclass，方法缓存，类数据bits。
                属性、方法、协议则是从data_bits结构体中获取,主要是有一个class_rw结构体成员，可以理解为容器的类结构体。
                你可以从这个容器类结构体里面访问类的属性，方法，协议等信息，而这些信息的维护则是通过两个类的具体描述的结构体维护的。
                class_rw类读写结构体主要兼容了两个类描述的结构体，一个是只读的class_ro_t类结构体，一个是可读可写的class_rw_ext_t类结构体。
                而这两个具体的类结构体，则真正维护了方法、属性、协议等信息，容器的类结构体也是从这两个结构体中获取这些方法、属性、协议的。
                然后，只读的具体类的结构体是编译时就已经确定了方法、属性了的，读写的具体类结构体则是在动态添加方法、属性时再决定其内容的。
                也就是class_ro_t里面的存储方法列表时一个一维数组，里面直接存的就是描述方法method_t、变量等的结构体。
                而class_rw_ext_t的方法列表存储则是一个列表数组，每一个元素就是一个方法列表，例如一个分类里的方法，从而实现了动态添加方法的功能。
                class_rw_ext_t有一个指向class_ro_t的指针，所以可以通过这个指针去访问class_ro_t里的方法列表。
                
        
 
        现在来看类对应的C++结构体：objc_class
            objc_class结构体主要的成员变量有：
                第一个变量superclass:指向他的父类。
                第二个变量cache:这里面存储的方法缓存。（相当于快表的作用，优先在这里找方法的地址直接调用，没有的话再去方法列表中找）
                第三个变量bits：存储对象的方法、属性、协议等信息。！！！方法就是存在这个结构体里！！！
                                这个结构体里面分别又有属性列表、方法列表、协议列表的结构体作为其成员(方法返回值)。
 
 
                bit是一个class_data_bits_t结构体，里面有成员class_rw_t结构体(方法返回值)。
                    class_rw_t里面的公共方法，用来获取方法列表、属性列表、协议列表。
                    class_rw_t结构体里获取属性、方法、协议，其实是从class_ro_t或者class_rw_ext_t结构体获取的，这里只是做一个转接。
 
                class_rw_t里面有成员ro_or_rw_ext_t指针，该指针只能是指向class_ro_t 结构体或者 class_rw_ext_t 结构体。
                    通过成员is()方法来判断，ro_or_rw_ext 当前是 class_rw_ext_t 还是 class_ro_t
 
                class_rw_ext_t模仿ro_or_rw_ext_t结构体，也有方法列表、属性列表、协议列表，还有class_ro_t指针。
                        class_rw_ext_t是根据class_ro_t进行创建的，class_ro_t的属性、方法、协议则是编译时就确定的的。

                class_ro_t模仿ro_or_rw_ext_t结构体，有基础方法列表、基础协议列表、成员变量列表、基础属性列表，不可修改。
 
                方法的获取：
                维护方法的method_array_t、维护属性的property_array_t、维护协议的protocol_array_t 都是继承list_array_tt结构体。
                    list_array_tt维护了一个数组列表，可以是一维数组也可以是二维数组(联合体区分)，方法结构结构体就存储在这个数组列表中。
                                方法的描述结构体是method_t。
 
                class_rw_t里的方法列表存储，public方法返回结构体method_array_t，这个用来维护方法列表。
 
                class_rw_t里的属性存储，public方法返回property_array_t，这个用来维护属性。
                            属性的描述结构图体是property_t。
                
        方法和属性的总结：
            bits中存储了属性、方法、协议、成员变量。成员变量只存储在class_ro_t中，它是编译器就决定好的，不可修改。

            bits中这些信息，是通过class_rw_t结构存储，它有一个ro_or_rw_ext_t变量，它可以是ro类型，也可能是rw_ext类型。
                如果该类没有动态添加属性、方法、协议等，就是ro类型
                否则就是rw_ext类型，然后它内部会包含ro。
                之所以会出现两种结构，都是为了优化内存。

            ro是干净内存，类的加载时类本身的数据存放在ro中，编译期决定。
                它存储的方法、属性、协议等列表，是一个一维数组

            rw_ext是脏内存，运行时动态创建成员或分类中的成员都在rw_ext里。
                它存储的方法、属性、协议等列表，是一个二维数据。动态添加的是一个数组，编译期决定的是一个数组，方便动态添加对应信息。


        
        元类的出现：用于表达 描述当前OC对象的类的类信息meta_class的结构体 也就是objc_class的isa指针指向的结构体。
                    元类用来存储类信息，所有的类方法都存储在元类中。元类是系统编译器自动创建的，和用户没关系
                    所以元类也是objc_object类型，元类的类其实就是根元类，因为isa指针指向根元类。
                    根元类的类是本身，因为isa指向指向了本身。
 
        元类的设计目的：元类来保证无论是 类 还是 对象 都能通过 "相同的机制" 查找方法的实现。
 
                因为无论是OC的对象或者是类，都只是一个objc_object抽象类，只存了一个isa指针，指向对应的结构体类。
                实例方法调用时，通过对象(objc_object)的 isa 在类中获取方法的实现。   （对应objc_class结构体里面的方法）
                类方法调用时，通过类(objc_class)的 isa 在元类中获取方法的实现。（对应meta_class结构体里的方法）
 
        无论是objc_class还是meta_class都有superclass指针来描述继承链。
 
            所有meta_class的isa指针都是指向根meta_class，为了统一性，根meta_class也有isa指针，指向自己。
            根objc_class的superclass指针指向nil。
            
        什么是方法？就是封装的1段代码,都表示1个相对独立的功能.
 
 */

//MARK: - 对象的内存引用管理
/**
 
    1、OC中操作对象引用的方法(在NSObject里)：
            生成并持有对象     alloc/new/copy/mutableCopy等
            持有对象     retain
            释放对象     release
            废弃对象     dealloc
        总结：OC也是是对引用计数变量+1减1操作，当开发者使用 ARC 时，编译器会负责在适当的时候插入 retain、release 和
             autorelease 消息，以确保对象的正确引用计数。但是OC的底层代码并没有暴露，所以只能是推测。
 
    2、autorelease方法的实现是通过NSAutoreleasePool的生存周期来实现的，当废弃NSAutoreleasePool时所有对象都将调用release方法。
        也就是在当对象调用autorelease方法时，对象的释放就交给NSAutoreleasePool来管理，NSAutoreleasePool作用域结束时，
        对每一个对象都执行release方法。
 
    3、循环引用容易发生内存泄漏，所谓内存泄漏： 就是应当废弃的对象在超出其生命周期后继续存在。
        用__strong修饰变量时，表明了该作用域内对这个对象进行了强引用，即持有了该对象。
                持有强引用的变量在超出其作用域时被废弃，随着强引用的失效，引用的对象会随之释放。
 
        循环引用条件：
                1.两个对象互相强引用对方。
                2.在该对象持有其自身时（自己引用自己）。
    
        __weak修饰符,提供弱引用，即不持有对象实例，没有对对象进行retain。
                在持有某对象的弱引用时，若该对象被废弃，则此弱引用将自动失效且处于nil被赋值的状态。
                可以通过检查附有该修饰符的变量是否为nil，可以判断被赋值的对象是否已经废弃
 
    4、ARC规则：
        1.不能使用retain/release/retainCount/autorelease。
        2.不能使用NSAllocateObject/NSDeallocateObject。
        3.须遵守内存管理的方法命名规则。
        4.不要显示调用dealloc。
        5.使用@autoreleasepool块代替NSAutoreleasePool类。
        6.不能使用区域（NSZone）。
        7.对象型变量不能作为c语言结构体成员。
        8.显示转换id和void *。
 
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestOCNSObject_VC : UIViewController

@end

NS_ASSUME_NONNULL_END
