//
//  TestOCBlock_VC.h
//  SwiftTest_App
//
//  Created by mathew on 2022/7/19.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//MARK: - 笔记
/**
    Block的底层结构：
    1、block本质上也是一个OC对象，只要是OC对象就有isa指针。
        blcok是封装了函数调用(地址)，以及函数调用环境(参数、返回值、外部变量的引用)的OC对象。
        所以block也有实例对象，类对象，C语言底层是结构体。编译器会为你编写block结构体的代码。
 
    2、如果block引用了外部的变量，则底层的block结构体会定义一个成员变量，而且该成员变量是外部变量的值传递(或引用传递)。
       C语言：auto自动局部变量，你平时写的局部变量默认就是auto变量，只不过auto关键字省略了，自动的意思是，离开作用域自动销毁。(值传递)
             static静态局部变量，静态的意思是：离开了作用域，变量也不会自动销毁。(引用传递)
 
       局部变量会捕获到block里面去，也就是block底层结构体会定义相应的成员变量来存储外部变量的值。
       全局变量不会捕获到block里面去，因为block会直接就去访问全局变量的地址。全局变量本来就是供全局访问的。
       block可以捕获self，因为self本来就是方法的隐含参数，block里有self类型的成员变量。
 
    3、block的类型：
        Block最终都是继承NSBlock类型。可以通过class或isa指针来查看block的类型。
        不同的block的类型目的就是放在不同的内存空间，用于管理内存。
        > __NSGlobalBlock类型-->NSBlock类型-->NSObject
        > __NSGlobalBlock类型:没有访问auto变量。放在内存的数据段。
          __NSStackBlock类型:访问了auto变量。放在内存的栈段。
          __NSMallocBlock类型:stackblock调用了copy，也就是要复制到堆段里。放在内存的堆段。
        所以，如果你想保存blcok里面的数据，往往需要调用blcok的copy方法，把它移动到堆里面，不然会被栈释放。但是现在的ARC会根据情况自动copy了。
        > ARC会将block移到堆的情况：
            1.block作为函数的返回值。
            2.block赋值给_strong指针的时候。一般都是强指针。因为离开了栈的作用域之后，block还存在。
            3.block作为cocoa 、cgd API框架里的方法的usingblock参数的时候。避免block的参数被销毁。
 
        > 属性block声明的copy关键字就是当需要时就把block复制到堆空间，在ARC下strong和copy都有复制到堆空间的功效，MRC只有copy才有。
 
    4、block的修饰符：
        > __block修饰符：用于修饰变量，用于解决block内部无法修改auto变量值的问题。
                        __block不能修饰全局变量、静态变量(staic)。
                        编译器会将__block变量包装成一个对象。不管是基本数据类型，还是对象类型，编译器都会包装成__block数据结构。
        > 当block是在栈上时，block并不会对外部的__block变量产生强引用。
        > __block结构体仅在ARC环境下才会对__block变量产生强/弱引用，MRC环境下只产生弱引用。
            __block __weak Person * person = [[Person alloc] init]; //ARC下的弱引用，__weak修饰符不可以修饰基本数据类型。
    
    5、block的循环引用：
        > typeof(person) 相当于 Person *
        > __unsafe_unretained 相当于 __weak 。 但是weak是安全的(置nil)，__unsafe_unretained是不安全的。
        > MRC是不支持弱指针的，只支持__unsafe_unretained。
        > __strong 关键字，其实只是欺骗 编译器 的行为，因为复制给weak指针，编译是不通过的。同时也是确保在block执行过程中，该指针是强引用，但是退出了这个过程就不是了。
 
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestOCBlock_VC : UIViewController

/// 返回值是一个block，block的返回值是TestOCBlock_VC,block的参数是 两个NSString

-( TestOCBlock_VC *(^)(NSString * name, NSString * nickName) ) blockLink;

@end

NS_ASSUME_NONNULL_END
