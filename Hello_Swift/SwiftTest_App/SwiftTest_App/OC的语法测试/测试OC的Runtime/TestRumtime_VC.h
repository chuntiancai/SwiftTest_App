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

#import <UIKit/UIKit.h>

@interface TestRumtime_VC : UIViewController

@end

