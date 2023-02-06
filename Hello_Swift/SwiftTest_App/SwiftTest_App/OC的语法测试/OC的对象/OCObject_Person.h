//
//  OCObject_Person.h
//  SwiftTest_App
//
//  Created by mathew on 2023/1/10.
//  Copyright © 2023 com.mathew. All rights reserved.
//
//MARK: - 笔记
/**
    1、oc对象的自身大小 = 自身成员变量的大小 + 父类结构体自身的大小。(编译时按照C语言语法规则内存对齐，执行的时候按照系统的动态内存分配规则对齐)
        注意，一个指针自身的大小是8个字节。
 
    2、如果没有太多的实现，直接把类的实现代码写在.h头文件好了，不用那么多文件，因为都是经过编译器编译，头文件只是一种书写规范，我不遵循了。
 
    3、实例对象的内存空间只存放成员变量空间，不存放方法。因为方法是多个实例对象可以共用的代码，而成员变量是不共用的。
        方法是存放在类对象的方法列表里。
        C语言的内存对齐，是你自己用C语言写一个编译器的时候，可以自定义对齐的规则。
 
    4、实例对象\类对象方法调用的C语言底层是调用objc_msgSend(id,@selector)方法，所以方法的调用也叫消息传递。
        isa指针：实例对象-->类对象-->元类对象-->NSObject(基类)的元类对象。
                arm64的iOS系统，isa指针的值需要进行一次位移取值，才能得出类对象\元类对象的地址中。&ISA_MASK。
                arm64系统之后，isa指针变成了一个共用体数据结构，使用了位域映射技术。掩码：一般用于按位与(&)运算。
 
        superclass指针：是在class对象里的。实例对象isa --> 类对象 --> superclass指针 --> 父类的类对象 --> 父类的方法。
                       类对象的superclass指针是指向父类类对象，元类对象的superclass指针是指向父类的元类对象。
                       NSObject(基类)的元类对象的superclass指针指向的是NSObject的类对象。(特殊，跟类对象的isa指针形成一个死循环)
                       NSObject类对象的superclass指针指向的是Nil，此时会报实例方法找不到的错误。
                       NSObject元类对象的superclass指针指向的是NSObject类对象，元类对象里面找不到类方法的时候，就通过NSObject类对象的superclass指针报错(找不到方法)。如果NSObject类对象有同名的实例方法，那么就会调用NSObject类对象的实例方法，这是个类方法最后调用实例方法的特例。
 
    5、.mm文件，xcode识别为oc/c++文件，.m文件只识别为oc文件。
                        
                        
 */

#import <Foundation/Foundation.h>

//MARK: - 类的声明
@interface OCObject_Person : NSObject
{
                //父类结构体的自身大小
    @public
    int _no;    //4字节
    int _age;   //4字节
//    int _height;    //@property是编译器语法糖，会在这里生成对应的成员变量。
}
@property(nonatomic,assign) int height; //属性，会自动在成员变量列表生成_height变量，并且生成get、set方法。
-(void) perspnInstanceMethod;   //实例方法，会存放在类对象里。
+(void) perspnClassMethod;  //类方法，会存放在元类对象里。

@end

//MARK: - 类的实现
@implementation OCObject_Person
-(void) perspnInstanceMethod{
    
    NSLog(@"OCObject_Person的实例方法%s",__func__);
}
+(void) perspnClassMethod{
    NSLog(@"OCObject_Person的类方法%s",__func__);
}
@end
