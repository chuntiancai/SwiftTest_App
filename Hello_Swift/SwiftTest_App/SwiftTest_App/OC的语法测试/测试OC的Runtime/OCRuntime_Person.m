//
//  OCRuntime_Person.m
//  SwiftTest_App
//
//  Created by mathew on 2022/5/27.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import "OCRuntime_Person.h"
#import <objc/runtime.h>

//MARK: - 笔记
/**
    1、任何方法默认都有两个隐式参数,self,_cmd。
      self表示方法所在的元类或者实例对象，_cmd表示方法本身(方法编号)。
 */

@implementation OCRuntime_Person

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%s", __func__);
    }
    return self;
}

//MARK:  测试交换方法
+ (void)load{
    /**
        当加载类的代码进内存时，会调用load的方法，只会调用一次，因为只会加载一次类的代码进内存而已，不然还想要多少次？
        swift没有load方法，可以通过initialize里面用dispatch_once_t 实现。
     */
    
    
    ///获取A方法的结构体
    Method AMethod = class_getInstanceMethod(self, @selector(changeAAA:));
    ///获取B方法的结构体
    Method BMethod = class_getInstanceMethod(self, @selector(changeBBB:));
    
    /// 交换方法的映射地址
    method_exchangeImplementations(AMethod, BMethod);
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

//TODO: 方法的组成
// 没有返回值,也没有参数。任何方法默认都有两个隐式参数,self,_cmd
// void,(id,SEL)
void aaa(id self, SEL _cmd, NSNumber *meter) {
    NSLog(@"aaa方法中的self：%@ , _cmd参数：%@",self, NSStringFromSelector(_cmd));
    NSLog(@"playing: 变成了aaa跑了%@", meter);
}

//TODO: 交换方法前exchangeAAA
-(void)changeAAA: (NSString *) name{
    NSLog(@"%s这是changeAAA方法：%@",__func__,name);
}

//TODO: 交换方法后exchangeBBB
-(void)changeBBB: (NSString *) name{
    NSLog(@"%s这是changeBBB方法：%@",__func__,name);
    ///因为在load里面已经更换了方法映射地址，所以这里如果要调用changeAAA的方法提的话，需要用changeBBB的方法名。
    [self changeBBB:@"在BBB里面调用BBB"];
}

//TODO: 动态解析实例方法。
/**
    解析实例方法。去看Objective-C Runtime Programming Guide文档。
    任何方法默认都有两个隐式参数,self,_cmd
    什么时候调用:只要一个对象调用了一个未实现的方法就会调用这个方法,进行处理。所以你可以在这里调用私有方法。
    作用:动态添加方法,处理未实现
 */

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSLog(@"动态解析实例方法，传入的方法名%@",NSStringFromSelector(sel));
    // [NSStringFromSelector(sel) isEqualToString:@"eat"];
    //TODO: 动态添加方法。例如网页通过字符串调用app的方法。
    if (sel == NSSelectorFromString(@"playing:")) {
        // eat
        // class: 给哪个类添加方法
        // SEL: 添加哪个方法
        // IMP: 方法实现 => 函数 => 函数入口 => 函数名
        // type: 方法类型
        /// 不知道怎么写，就去developer去找objectc的文档，找到该方法，然后在方法描述里再找到runtime编程指南，然后再看动态方法篇章、或者Messaging篇章的隐藏参数章节。
        /// 关于"v@:@"这些const char * _Nullable types 字符串表示的类型，看Type Encodings章节。
        //class_addMethod(self, sel,(IMP)aaa, const char * _Nullable types)
        
        /**
         v ： 表示void
         @ ：表示方法的第一个隐含参数self
         : ：表示方法名选择器SEL
         @ ：表示参数NSNumber
         */
        class_addMethod(self, sel, (IMP)aaa, "v@:@");   //这个就表接收到方法名为 playing 的调用信息，然后去执行(IMP)aaa的方法体，就相当于添加了playing方法。
        
        
        /// 表示已经处理了该方法调用信息。
        return  YES;

    }
    
    return [super resolveInstanceMethod:sel];

}

//TODO: 动态解析类方法。
+ (BOOL)resolveClassMethod:(SEL)sel{
//    NSLog(@"动态解析类方法，传入的方法名%@",NSStringFromSelector(sel));
    return [super resolveClassMethod:sel];
}

//TODO: 测试super关键字
- (void)testSuper
{
    // 如果是在 OCRuntime_SubPerson 中通过super来调用，那么这里的self指的是OCRuntime_SubPerson，打印结果是SubPerson Person  SubPerson Person
     NSLog(@"在OCRuntime_Person中的打印：%@ %@ %@ %@",[self class], [self superclass], [super class], [super superclass]);
}

//TODO: 测试子类实例显示调用 继承于父类的方法。
- (void)testSuper2
{
    //
     NSLog(@"在OCRuntime_Person中的打印：%@ %@ %@ %@",[self class], [self superclass], [super class], [super superclass]);
}

@end
