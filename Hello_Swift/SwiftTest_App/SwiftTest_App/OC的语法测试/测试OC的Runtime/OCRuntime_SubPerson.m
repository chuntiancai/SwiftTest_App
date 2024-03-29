//
//  OCRuntime_SubPerson.m
//  SwiftTest_App
//
//  Created by mathew on 2022/7/6.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试super关键字，父子类的关系。
//MARK: - 笔记
/**
    1、如果是在 OCRuntime_SubPerson 中通过super来调用，那么父类的self指的是OCRuntime_SubPerson，打印结果是SubPerson Person  SubPerson Person
    2、如果 OCRuntime_SubPerson 实例显示调用继承于父类的方法，那么父类的self指的也还是OCRuntime_SubPerson。
    3、super关键是语法糖，是给编译器优化看的，并不代表父类的实例，本质上仍然是当前对象的self。
 
    4、其实super关键字指向了一个super的结构体struct __rw_objc_super ，该结构体有两个成员，分别是当前类，和当前类的父类，当前类是消息的接受者。
        主要是class和superclass方法的实现，消息传递到NSObject时，class方法返回的是当前消息接收者的类，而superclass方法返回的是当前消息接收者的父类。
        所以，在super的结构体中，当前消息的接受者是当前类，所以 [super class] 返回的类是当前类。
 */

#import "OCRuntime_SubPerson.h"

@implementation OCRuntime_SubPerson

- (void)testSuper{
    
    // self -> SubPerson
    // class:获取当前方法调用者的类
    // superclass:获取当前方法调用者的父类
    
    // super:仅仅是一个编译指示器,就是给编译器看的,不是一个指针
    // 本质:只要编译器看到super这个标志,就会让当前对象去调用父类方法,本质还是当前对象在调用
    NSLog(@"在OCRuntime_SubPerson中的打印：%@ %@ %@ %@",[self class], [self superclass], [super class], [super superclass]);
    
    [super testSuper];
    // SubPerson Person Person NSObject
    // SubPerson Person SubPerson Person ✅
    
}

@end
