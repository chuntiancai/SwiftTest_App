//
//  TestRumtime_VC.m
//  SwiftTest_App
//
//  Created by mathew on 2022/5/27.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import "TestRumtime_VC.h"
#import "OCRuntime_Person.h"
#import "OCRuntime_Person+Property.h"
#import <objc/message.h>
#import "OCRuntime_StatusModel.h"
#import "OCRuntime_SubPerson.h"


//MARK: - 笔记
/**
    1、runtime的本质就是在运行阶段，通过消息机制的方式，去寻找方法的实现体。
        注意与 编译阶段 区分。
        在终端用clang -rewrite-objc main.m 命令，可以吧main.m文件编译成c++文件，也就是oc文件转换为c++文件。
        runtime的方法名都是有前缀的，谁的事情，谁开头，例如objc_ ,method_ , class_ 等前缀。
        关联属性并不是直接存储在类的实例变量中，而是存储在一个全局的、类似于字典的数据结构中，由运行时系统管理。
 
    2、OC调用方法的本质是，通过调用系统函数objc_msgSend，让 对象 向 方法映射表 发消息，让 方法映射表 寻找方法体并执行。
        
        在项目的Building setting 里设置严格检查objc_msgSend为NO，不然objc_msgSend方法没有参数提示。
 
        #import <objc/message.h>    //必须导入runtime的相关头文件
        //#import <objc/runtime.h>
        objc_msgSend(p, @selector(eat));
 
       同理，用类名调用类方法本质：让类对象发送消息
        objc_msgSend([Person class], @selector(move));
        
      SEL是方法结构体(C语言)。消息机制原理:对象根据方法编号SEL去映射表查找对应的方法实现。
      @selector(xxx) 返回的是SEL结构体。可以理解为语法表达式，或者理解为宏。
 
    3、Too many arguments to function call,报错，需要强制声明方法的参数。
        例如： method_invoke(p, curEat) 变成((void(*)(id, Method))method_invoke)(p, curEat); 加了强制声明前缀((void(*)(id, Method))。
              cmd+鼠标左键，去查看method_invoke的头文件，来确定函数的类型，从而确定前缀。
 
    4、runtime的使用场景：
        1.想修改系统方法的实现，而且这个实现也影响以前的代码，例如UIImage图片，加载图片时想添加个是否有该图片的判断。
          可以通过给UIImager添加分类实现。
          也可以通过在UIImage类的load方法中实现。
 
    5、swift没有load方法，可以通过initialize里面用dispatch_once_t 实现。
 
    6、SEL，IMP， Method,
        SEL是方法名选择择器，是描述方法名的对象，也就是方法名的结构体，内部哈希化了方法名字符串。
            > @slector() 是编译器给的语法糖,SEL底层有点类似char的结构。
            > 不同类的相同方法名，它们的SEL是一样的。
        IMP是函数指针，指向了方法体的首地址。
        Method是描述方法的结构体，里面包含了SEL和IMP。
        类对象里有个方法缓存成员：用于缓存最近调用的方法，类似OS的内存寻址缓存技术。（散列映射寻找方法缓存）
 
    7、 super关键字:仅仅是一个编译指示器,就是给编译器看的,不是一个指针，本质还是在当前对象里执行代码。
 */


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
            NSLog(@"测试获取runtime相关的系统方法。");
            OCRuntime_Person * p = [[OCRuntime_Person alloc] init];
//忽略警告，方法过期的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            
            //TODO: 获取方法体的结构，执行私有方法。
            Method curMove = class_getInstanceMethod([p class], @selector(move));
            ((void(*)(id, Method))method_invoke)(p, curMove);
            
            Method curEat = class_getInstanceMethod([p class], @selector(eat));
            ((void(*)(id, Method))method_invoke)(p, curEat);
            
            Method curSleeping = class_getClassMethod([OCRuntime_Person class], @selector(sleeping));
            ((void(*)(id, Method))method_invoke)([OCRuntime_Person class], curSleeping);
            
            
            //TODO: 交换方法体的地址
            /// 可以在load的方法里面进行交换。
            method_exchangeImplementations(curMove, curEat);
            NSLog(@"交换方法后---");
            ((void(*)(id, Method))method_invoke)(p, curMove);
            ((void(*)(id, Method))method_invoke)(p, curEat);
            
            
            //TODO: 发送方法调用消息(类或实例方法)。执行私有方法。多个参数。
            ((void(*)(id, SEL))objc_msgSend)(p, @selector(eat));
            ((void(*)(id, SEL,int,id))objc_msgSend)(p, @selector(run:and:),1000,@"10分钟");
            ((void(*)(id, SEL))objc_msgSend)(objc_getClass("OCRuntime_Person"), @selector(sleeping));
            
            
            //TODO: 获取类的描述结构体。
            Class pClass = objc_getClass("OCRuntime_Person");
            ((void(*)(id, Method))method_invoke)(pClass, curSleeping);
            
            OCRuntime_Person * p2 = ((id(*)(id, SEL))objc_msgSend)(objc_getClass("OCRuntime_Person"), sel_registerName("alloc"));
            p2 = [p2 init];
            p2 = ((id(*)(id, SEL))objc_msgSend)(p2, sel_registerName("init"));
            [p2 performSelector:@selector(move)];
            
        }

            break;
        case 1:
            //TODO: 1、测试在load里面交换方法体，或者说交换方法指针的指向地址
            NSLog(@"1、测试在load里面交换方法体 ");
        {
            OCRuntime_Person * p0 = [[OCRuntime_Person alloc] init];
            [p0 changeAAA:@"张三AAA "];
            NSLog(@"-------------执行BBB方法-------------");
            [p0 changeBBB:@"李四BBB "];
            
            //TODO: 测试动态解析、添加方法。
            NSLog(@" ---------测试动态添加方法--------- ");
            ///例如网页通过字符串调用app的方法。
            [p0 performSelector:@selector(playing:) withObject:@15];
            
            //TODO: 测试动态添加属性。关联对象。
            /**
                1、动态添加属性的本质是，让某个属性和某个对象产生关联。例如，让一个NSObject对象存储一个字符串。
                2、给系统的类添加属性的时候，就可以用到关联属性，也就是动态添加属性咯，其实是利用了分类，利用get，set方法和key-value存储实现这样的效果而已。
                3、关联属性并不是直接存储在类的实例变量中，而是存储在一个全局的、类似于字典的数据结构中，由运行时系统管理。
                    Objective-C 运行时系统维护了一个全局的 AssociationsManager 对象，它管理着所有的关联对象。
                    添加关联属性实际上是在这个全局对象中添加了一个条目，将源对象、关键字和关联对象关联起来。
                    关联属性的访问速度可能会略慢于直接访问实例变量，因为需要通过额外的查找操作来获取关联对象的值。
             */
            p0.nickName = @"小张张";
            NSLog(@"通过分类动态添加关联属性：%@",p0 .nickName);
        }
#pragma clang diagnostic pop
            break;
        case 2:
            //TODO: 2、字典转model。测试通过RunTime，用KVC机制 打印plist文件里的属性字符串，转字典后，再转换成model。
        {
            /// 1、找到plist文件，打印出plist文件里的属性字符串，然后复制粘贴到 你自定义的 模型类中，就不用一个一个地敲属性声明字符串了。
            // 获取文件全路径
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"OCRuntimeStatus.plist" ofType:nil];
            // 文件全路径
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
            // 打印属性字符串
            [self printPropertyCode:dict];
            
            //传入字典，创建model
            OCRuntime_StatusModel * model = [OCRuntime_StatusModel initWithDict:dict];
            
            NSLog(@"转换后的model：%@",model);
            
        }
            break;
        case 3:
            //TODO: 3、测试super关键字
        {
            OCRuntime_SubPerson * subPerson =  [[OCRuntime_SubPerson alloc] init];
            [subPerson testSuper];
            NSLog(@"  =========== 调用继承于父类的方法 =================== ");
            [subPerson testSuper2];
        }
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
//MARK: - 工具方法

/// 打印属性的声明代码
-(void) printPropertyCode: (NSDictionary *) dict {
    
    NSMutableString *codes = [NSMutableString string];
    // 遍历字典
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        
        NSString *code;
        if ([value isKindOfClass:[NSString class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;",key];
        } else if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
        } else if ([value isKindOfClass:[NSNumber class]]) {
             code = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",key];
        } else if ([value isKindOfClass:[NSArray class]]) {
             code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
             code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
        }

        // @property (nonatomic, strong) NSString *source;
        
        [codes appendFormat:@"\n%@\n",code];
        
    }];
    
    NSLog(@"打印属性字符串：%@",codes);
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


