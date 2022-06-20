//
//  OCRuntime_Person.m
//  SwiftTest_App
//
//  Created by mathew on 2022/5/27.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import "OCRuntime_Person.h"



@implementation OCRuntime_Person
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%s", __func__);
    }
    return self;
}

-(void)move{
    NSLog(@"OCRuntime_Person 移动啦～");
    
}

-(void)eat{
    NSLog(@"OCRuntime_Person 吃饭啦～");
}

-(void)run: (NSInteger) meter and:(NSString *) minute {
    NSLog(@"OCRuntime_Person 跑了%ld米～, %@ 的时间",meter,minute);
}

+(void)sleeping{
    NSLog(@"OCRuntime_Person 睡觉啦～");
}

//TODO: 动态解析方法。
/**
    解析实例方法。去看Objective-C Runtime Programming Guide文档。
    任何方法默认都有两个隐式参数,self,_cmd
    什么时候调用:只要一个对象调用了一个未实现的方法就会调用这个方法,进行处理。所以你可以在这里调用私有方法。
    作用:动态添加方法,处理未实现
 */

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSLog(@"传入的方法名%@",NSStringFromSelector(sel));
    // [NSStringFromSelector(sel) isEqualToString:@"eat"];
    if (sel == NSSelectorFromString(@"run:")) {
        // eat
        // class: 给哪个类添加方法
        // SEL: 添加哪个方法
        // IMP: 方法实现 => 函数 => 函数入口 => 函数名
        // type: 方法类型
//        class_addMethod(self, sel,(IMP)aaa, <#const char * _Nullable types#>)
//        class_addMethod(self, sel, (IMP)aaa, "v@:@");
        

    }
    
    return [super resolveInstanceMethod:sel];

}

// 没有返回值,也没有参数。任何方法默认都有两个隐式参数,self,_cmd
// void,(id,SEL)
void aaa(id self, SEL _cmd, NSNumber *meter) {
    
    NSLog(@"跑了%@", meter);
    
}

/// 解析类方法
+ (BOOL)resolveClassMethod:(SEL)sel{
    NSLog(@"传入的方法名%@",NSStringFromSelector(sel));
    return NO;
}

@end
