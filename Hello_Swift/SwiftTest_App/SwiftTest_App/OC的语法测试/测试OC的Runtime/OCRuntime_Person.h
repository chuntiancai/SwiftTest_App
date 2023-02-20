//
//  OCRuntime_Person.h
//  SwiftTest_App
//
//  Created by mathew on 2022/5/27.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// MARK: - 笔记
/**
    1、super关键字。
        > 在OC的消息传递中，方法有两个默认的参数：self，_cmd。self表示的是当前对象，_cmd表示的是当前方法类型，两者均是局部变量。
        > super底层是一个结构体，该结构体包含了当前类对象和父类类对象两个成员变量。执行super是到父类的类对象中寻找方法。
          但是无论是[self class]还是[super class] ，最终的方法实现都是在NSObject的类对象里。而NSObject的class方法返回的是self 的class。
          所以[super class]实际最终返回的还是self的object_getClass。
          super消息的接受者仍然是self，只是先从父类的类对象的方法列表开始寻找方法而已。
 
    2、class方法。
        >[[NSObject class] isMemberOfClass:[NSObject class]];   //判断当前对象的类对象是否是参数的类对象。类对象的类对象是元类。
                                                                // object_getClass(self) 是取出当前对象的元类对象，所以当是静态方法时，是判断元类对象。
         [[NSObject class] isKindOfClass:[NSObject class]]; //判断当前对象的类对象是否是在参数类对象的父系继承树中。
                                                            // object_getClass(self) 是取出当前对象的元类对象，所以当是静态方法时，是判断元类对象。
                                                            // 因为[NSObject class]已经没有父类了，所以[NSObject class]的元类也是[NSObject class]。
         [[NSObject class] isSubclassOfClass:[NSObject class]];
 
    3、方法栈的地址分配。
        > 栈空间的地址值是从大到小分配的。对象的C结构体找成员变量都是按照地址偏移去找，并不是根据符号去寻找的，而对象结构体的内存地址值分配是从小到大分配的。
        > C语言的强制类型转换，可以把当前栈空间的地址当成isa指针，也就是最单纯的地址偏移来读取成员变量。(跳8个字节来读取下一个结构体成员)
        > (__bridge id)personPtr 可以把C语言指针强制转换为OC对象的指针。
 
 */

#import <Foundation/Foundation.h>

@interface OCRuntime_Person : NSObject

-(void)changeAAA:(NSString * )name;
-(void)changeBBB:(NSString * )name;
-(void)testSuper;
-(void)testSuper2;

@end
