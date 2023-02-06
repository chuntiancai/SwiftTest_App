//
//  TestOCCategory_VC+Test.m
//  SwiftTest_App
//
//  Created by mathew on 2023/1/9.
//  Copyright © 2023 com.mathew. All rights reserved.
//
// 测试OC Category的Category。

#import "TestOCCategory_VC+Test.h"
#import <objc/runtime.h>
//MARK: - 笔记
/**
    1、在代码文件层面，实例对象的代码存储的是成员变量，类对象代码存储的是属性、对象方法、协议、成员变量。实例对象代码的isa指针指向类对象代码、类对象代码的isa指针指向父类。
        元类对象的代码空间，存储的是类方法。
 
    2、分类对象的方法代码空间，是追加到类对象代码的方法链表里(前插)，是链表结构，在运行时追加。
        分类编译后有自己的结构体，有自己的代码性质，运行的时候，cpu会把分类结构体的方法代码追加到原来类对象的方法链表里。
        分类可以添加方法、协议、属性、但是不可以添加成员变量。因为成员变量是连续内存空间。
        分类写的 @property属性并不会生成对应的下划线成员变量，也就是不会在原来的对象空间扩展内存，而是你自己用关联对象给分类的属性分配空间。
 
    3、oc的initialize方法，是当 类 第一次接收到用户消息 的时候就调用，是消息机制。(也就是(全局)第一次使用这个类的时候，先父类再子类，第二次就不调用了)
        消息机制是通过isa指针逐层去查找方法。
        initialize方法，会先调用父类的，然后再到子类的，因为这个是NSObject继承的机制，C语言底层会先调用父类的，再执行子类的，要自己实现initialize方法。
        所以如果子类没有实现initialize方法，父类实现了initialize方法，但是又有多个子类的话，子类就会消息传递给父类的initialize方法会被调用多次。
        load方法，首次加载的时候，是直接调用load的方法地址，执行方法体，没有通过消息机制。手动调用的话，是通过消息机制。
        load的方法，父类，子类，分类，都有。分类的load方法不会覆盖原来类的load方法，两者都会被调用。因为是直接通过方法的地址调用的，不是消息机制。
 
    4、分类通过关联对象间接为原来的类添加属性：
        (这些是runtime框架提供的API)
        > 添加关联对象：objc_setAssociatedObject(id object, const void * key,   id  value, objc_AssociationPolicy policy)
        > 获得关联对象：objc_getAssociatedObject(id  object, const void * key)
        > 移除所有的关联对象：objc_removeAssociatedObjects(id  _Nonnull object)
 
        关联对象的原理：
        >runtime框架内部维护了一张多层嵌套的hash表，用来层层映射当前对象的key和value，object --> key --> policy --> value,每一层对应一张哈希表。
        >设置关联的value为nil，则默认为移除该关联关系。
        >如果当前object被销毁之后，对应的关联关系也会被runtime从hash表中移除。 

 */

@implementation TestOCCategory_VC (Test)

- (void)testCategory{
    NSLog(@"测试OC Category的 testCategory 方法");
}

//TODO: 测试通过关联对象添加属性。
//把自己的地址赋值给自己，也就是自己的值就是自己的地址。不加static的弊端：全局变量，别的地方也可以访问。所以要加上static，局限在当前文件才可以访问。
static const void * TestOCCategory_Name = &TestOCCategory_Name;
static const char TestOCCategory_Name2; //也可以直接用C语言,直接用地址。


- (void)setMyName:(NSString *)myName{
    objc_setAssociatedObject(self, TestOCCategory_Name, myName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &TestOCCategory_Name2, myName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //@selector(XXX) 是根据方法名传回某个结构体的地址，这是runtime提供的api。在这里 _cmd 等价于 @selector(setMyName:)
    objc_setAssociatedObject(self, @selector(setMyName:), myName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, _cmd, myName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)myName{
    NSString * curName = objc_getAssociatedObject(self, TestOCCategory_Name); 
    return curName;
}

@end
