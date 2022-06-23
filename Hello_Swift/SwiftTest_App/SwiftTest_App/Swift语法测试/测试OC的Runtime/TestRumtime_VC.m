//
//  TestRumtime_VC.m
//  SwiftTest_App
//
//  Created by mathew on 2022/5/27.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import "TestRumtime_VC.h"
#import "OCRuntime_Person.h"
#import <objc/message.h>


@interface TestRumtime_VC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong) UICollectionView * baseCollView;
@property(nonatomic,strong) NSArray * collDataArr;

@end

@implementation TestRumtime_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试Rumtime_VC";
    self.view.backgroundColor = [[UIColor alloc] initWithRed: 199/255.0 green: 204/255.0 blue: 237/255.0 alpha:1.0];
    [self.view addSubview:self.baseCollView];

}
//MARK: - UICollectionViewDataSource & UICollectionViewDelegate 协议
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了OC的第%ld个item",(long)indexPath.row);
    switch (indexPath.row) {
        case 0:
            //TODO: 0、测试runtime相关的系统方法。
            /**
             1、performSelector可以调用私有方法。objc_msgSend当然也可以调用私有方法。
             
             2、方法调用的流程，也就是方法体寻找的过程：
                类对象：存放实例方法的映射列表。描述实例的信息。
                元类：存放类方法的映射列表。描述类的信息。
                1.通过isa指针去到对应的类对象查找。
                2.找到方法名，注册或转换成方法编号。（编号更快，因为数组寻址）
                3.根据方法编号，去找到方法地址。（页表寻址）
                4.根据方法地址去寻找方法体代码。
             
             3、动态添加方法，OC都是懒加载机制,只要一个方法实现了,就会马上添加到方法列表中。都是动态寻址。
                方法除了映射表，还有缓存表，调用的时候，会存入缓存表中。
                在步骤2中，如果在 方法映射表 中找不到方法的实现，那么就会调用 + (BOOL)resolveInstanceMethod:(SEL)sel 或+ (BOOL)resolveClassMethod:(SEL)sel 来处理这些没找到方法地址的方法。步骤2也就是消息发送阶段。
                所以你要重写+ (BOOL)resolveInstanceMethod:(SEL)sel 或+ (BOOL)resolveClassMethod:(SEL)sel方法。
             
             */
        {
            NSLog(@"测试runtime相关的系统方法。");
            OCRuntime_Person * p = [[OCRuntime_Person alloc] init];
//忽略警告，方法过期的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            
            //TODO: 获取方法体的结构
            Method curMove = class_getInstanceMethod([p class], @selector(move));
            ((void(*)(id, Method))method_invoke)(p, curMove);
            
            Method curEat = class_getInstanceMethod([p class], @selector(eat));
            ((void(*)(id, Method))method_invoke)(p, curEat);
            
            Method curSleeping = class_getClassMethod([OCRuntime_Person class], @selector(sleeping));
            ((void(*)(id, Method))method_invoke)([OCRuntime_Person class], curSleeping);
            
            //TODO:交换方法体的地址
            /// 可以在load的方法里面进行交换。
            method_exchangeImplementations(curMove, curEat);
            NSLog(@"交换方法后---");
            ((void(*)(id, Method))method_invoke)(p, curMove);
            ((void(*)(id, Method))method_invoke)(p, curEat);
            
            //TODO:发送调方法用消息。
            ((void(*)(id, SEL))objc_msgSend)(p, @selector(eat));
            ((void(*)(id, SEL,int,id))objc_msgSend)(p, @selector(run:and:),1000,@"10分钟");
            ((void(*)(id, SEL))objc_msgSend)(objc_getClass("OCRuntime_Person"), @selector(sleeping));
            
            
            ///TODO:  获取类的描述结构体。
            Class pClass = objc_getClass("OCRuntime_Person");
            ((void(*)(id, Method))method_invoke)(pClass, curSleeping);
            
            OCRuntime_Person * p2 = ((id(*)(id, SEL))objc_msgSend)(objc_getClass("OCRuntime_Person"), sel_registerName("alloc"));
            p2 = [p2 init];
            p2 = ((id(*)(id, SEL))objc_msgSend)(p2, sel_registerName("init"));
            [p2 performSelector:@selector(move)];
            
            //TODO: 测试动态解析方法。
            [p2 performSelector:@selector(playing)];
            
        }
#pragma clang diagnostic pop
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
        case 6:
            break;
        case 7:
            break;
        default:
            break;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OCTestCEll" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
       
    }
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
    label.text = self.collDataArr[indexPath.row];
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [cell addSubview:label];
    
    cell.layer.cornerRadius = 8;
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collDataArr.count;
}


//MARK: - get & set 方法
- (UICollectionView *)baseCollView{
    if (!_baseCollView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(60, 40);
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
        _baseCollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 160) collectionViewLayout:layout];
        [_baseCollView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"OCTestCEll"];
        _baseCollView.backgroundColor = [[UIColor alloc] initWithRed:240/255.0 green:240/255.0 blue:243/255.0 alpha:1.0];
        _baseCollView.layer.borderColor = [[[UIColor alloc] initWithRed:0 green:30/255.0 blue:60/255.0 alpha:1.0] CGColor];
        _baseCollView.layer.borderWidth = 1.0;
        _baseCollView.delegate = self;
        _baseCollView.dataSource = self;
    }
    return _baseCollView;
}

- (NSArray *)collDataArr{
    if (!_collDataArr) {
        _collDataArr = @[@"0、",@"1、",@"2、",@"3、",
                         @"4、",@"5、",@"6、",@"7、",
                         @"8、",@"9、",@"10、",@"11、"];
    }
    return _collDataArr;
}

@end

//MARK: - 笔记
/**
    1、runtime的本质就是在运行阶段，通过消息机制的方式，去寻找方法的实现体。
        注意与 编译阶段 区分。
    2、OC调用方法的本质是，通过调用系统函数objc_msgSend，让 对象 向 方法映射表 发消息，让 方法映射表 寻找方法体并执行。
        
        在项目的Building setting 里设置严格检查objc_msgSend为NO，不然objc_msgSend方法没有参数提示。
 
        #import <objc/message.h>
        objc_msgSend(p, @selector(eat));
 
       同理，用类名调用类方法本质：让类对象发送消息
        objc_msgSend([Person class], @selector(move));
        
      SEL是方法结构体(C语言)。消息机制原理:对象根据方法编号SEL去映射表查找对应的方法实现。
      @selector(xxx) 返回的是SEL结构体。可以理解为语法表达式，或者理解为宏。
 
    3、Too many arguments to function call,报错，需要强制声明方法的参数。
        例如： method_invoke(p, curEat) 变成((void(*)(id, Method))method_invoke)(p, curEat); 加了强制声明前缀((void(*)(id, Method))。
              cmd+鼠标左键，去查看method_invoke的头文件，来确定函数的类型，从而确定前缀。
 
    
 */
