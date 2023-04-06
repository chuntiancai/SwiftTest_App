//
//  TestRumtime_VC.h
//  SwiftTest_App
//
//  Created by mathew on 2022/5/27.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//MARK: - 笔记
/**
    1、OC编码指令：Type Encoding
        > 为了方便运行时识别方法的意义，也就是可读性，编译器会把一些字符串指令映射成方法的参数、返回值信息，也就是所谓的类型编码；也叫做 @encode 指令。
            例如 v16@0:8   //v表示方法返回值为void，整个方法占16个字节；@表示参数一的值是id类型，在第0个字节；:冒号表示参数二类型是SEL类型，在第8个字节；
 
    2、消息传递objc_msgSend
        > 阶段一：消息发送。
               当你代码调用了方法，底层的代码方法寻找逻辑是：
                    去类对象的方法缓存列表寻找--> 去类对象的方法列表寻找 --> 父类的类对象的方法缓存找 --> 父类的类对象的方法列表寻找 --> 动态方法解析
        > 阶段二：动态方法解析。
                //resolveInstanceMethod方法的C语言底层，是会判断当前是类对象还是元类对象。
                OC的NSObject类提供了一个动态方法解析的api，也就是你复写的+(BOOL)resolveInstanceMethod:方法，当消息发送找不到方法时，就会执行这个方法，
                根据resolveInstanceMethod(当前流程)是否执行过了来判断已经找到了方法。 --> 未执行过 --> 消息发送 --> 执行过了 --> 消息转发
 
        > 阶段三：消息转发。
                //将消息转发给别人实现。OC底层会去调用forwardingTargetForSelector:方法。
                  NSInvocation对象是封装了一个方法调用，包括：方法调用者、方法名、方法参数。
                在你复写的forwardingTargetForSelector:方法里，实现把消息转发给别人(return别人) --> OC调用methodSignatureForSelector: 方法解析方法签名
                --> 调用forwardInvocation:方法让别人执行消息内容 --> 调用doesNotRecognizeSelector:方法，报识别不了方法错误(找不到)

        > 阶段四：上报方法找不到错误。
 
        @dynamic关键字是用于告诉编译器不用自动生成getter和setter方法、也不用生成成员变量，等到运行时再添加方法实现。
 */
//MARK: - 汇编工具
/**
    1、查看当前.m文件汇编代码：xcode --> Product --> perform action --> Assemble xxxx.m文件
 */
//MARK: - Runtime常用的API，C函数
/**
    1、类相关：
        动态创建一个类（参数：父类，类名，额外的内存空间）
        Class objc_allocateClassPair(Class superclass, const char *name, size_t extraBytes)
        
        注册一个类（要在类注册之前添加成员变量）
        void objc_registerClassPair(Class cls)
        
        销毁一个类
        void objc_disposeClassPair(Class cls)
        
        获取isa指向的Class。(元类是特殊的类对象)
        Class object_getClass(id obj)
        
        设置isa指向的Class
        Class object_setClass(id obj, Class cls)
        
        判断一个OC对象是否为Class
        BOOL object_isClass(id obj)
        
        判断一个Class是否为元类
        BOOL class_isMetaClass(Class cls)
        
        获取父类
        Class class_getSuperclass(Class cls)
 
    2、成员变量相关：
        获取一个实例变量信息
        Ivar class_getInstanceVariable(Class cls, const char *name)

        拷贝实例变量列表（最后需要调用free释放）
        Ivar *class_copyIvarList(Class cls, unsigned int *outCount)

        设置和获取成员变量的值
        void object_setIvar(id obj, Ivar ivar, id value)
        id object_getIvar(id obj, Ivar ivar)

        动态添加成员变量（已经注册的类是不能动态添加成员变量的）
        BOOL class_addIvar(Class cls, const char * name, size_t size, uint8_t alignment, const char * types)

        获取成员变量的相关信息
        const char *ivar_getName(Ivar v)
        const char *ivar_getTypeEncoding(Ivar v)    ///获取成员变量的编码。
 
    3、属性相关：
        获取一个属性
        objc_property_t class_getProperty(Class cls, const char *name)

        拷贝属性列表（最后需要调用free释放）
        objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount)

        动态添加属性
        BOOL class_addProperty(Class cls, const char *name, const objc_property_attribute_t *attributes,
                        unsigned int attributeCount)

        动态替换属性
        void class_replaceProperty(Class cls, const char *name, const objc_property_attribute_t *attributes,
                            unsigned int attributeCount)

        获取属性的一些信息
        const char *property_getName(objc_property_t property)
        const char *property_getAttributes(objc_property_t property)

    4、方法相关：
        获得一个实例方法、类方法
        Method class_getInstanceMethod(Class cls, SEL name)
        Method class_getClassMethod(Class cls, SEL name)

        方法实现相关操作
        IMP class_getMethodImplementation(Class cls, SEL name)
        IMP method_setImplementation(Method m, IMP imp)
        void method_exchangeImplementations(Method m1, Method m2)

        拷贝方法列表（最后需要调用free释放）
        Method *class_copyMethodList(Class cls, unsigned int *outCount)

        动态添加方法
        BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types)

        动态替换方法
        IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types)

        获取方法的相关信息（带有copy的需要调用free去释放）
        SEL method_getName(Method m)
        IMP method_getImplementation(Method m)
        const char *method_getTypeEncoding(Method m)
        unsigned int method_getNumberOfArguments(Method m)
        char *method_copyReturnType(Method m)
        char *method_copyArgumentType(Method m, unsigned int index)
 
        选择器相关
        const char *sel_getName(SEL sel)
        SEL sel_registerName(const char *str)
        
        用block作为方法实现
        IMP imp_implementationWithBlock(id block)
        id imp_getBlock(IMP anImp)
        BOOL imp_removeBlock(IMP anImp)
 */

//MARK: - Runtime的应用场景
/**
    1、利用关联对象，给分类添加属性。
    2、遍历类的所有成员变量，修改私有属性，例如修改textfield的占位字符颜色，字典转模型，自动解档归档实例对象。
    3、交换方法的实现，交换系统方法。
    4、利用消息转发机制，解决方法找不到的异常问题。
    runtime是运行时的意思，OC是一门动态语言，runtime机制可以运行很多操作在延迟到程序运行时再执行，由runtime的api提供支持，runtime的api是c语言函数。
    平时写的OC代码，底层都是转换成runtime的api进行调用的。
 */
#import <UIKit/UIKit.h>

@interface TestRumtime_VC : UIViewController

@end

