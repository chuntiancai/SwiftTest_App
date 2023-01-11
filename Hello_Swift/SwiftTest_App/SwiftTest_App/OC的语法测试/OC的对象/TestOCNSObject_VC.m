//
//  TestOCNSObject_VC.m
//  SwiftTest_App
//
//  Created by mathew on 2023/1/10.
//  Copyright © 2023 com.mathew. All rights reserved.
//
#import "TestOCNSObject_VC.h"
#import "SwiftTest_App-Swift.h"
#import <objc/runtime.h>
#import "OCObject_Person.h"

//MARK: - 笔记
/**
    1、OC对象的本质：OC的面向对象都是基于C\C++的数据结构实现的。 oc语言源码：https://opensource.apple.com/source/objc4/
        OC语言 --> C/C++语言 --> 汇编语言 --> 机器语言。
       
        1> 用到了C语言的结构体来实现面向对象的概念。
            //NSObject的c语言底层源码就是一个结构体，Class是一个指针。
            struct NSObject_IMPL {
                Class isa;  //如果结构体只有一个成员，那么该成员变量的地址就是当前结构体的首地址，也就是该变量的地址赋值给OC的对象指针。
            };
 
        2> iphone手机是arm64bit的cpu，系统是ios，内存分配对齐是16个字节。在64bit的处理器中，指针占8个字节。在32位中，占4个字节。就是字长的大小，用于寻址空间。
 
        3> 一个NSObject自身的大小是8个字节，占用的内存空间是16个字节，因为内存是以16个字节对齐分配，NSObject里没有其他成员变量，只有一个isa指针成员。
            
 
    2、将OC代码转换为C\C++代码。
        C\C++代码在不同的系统平台运行，会有不同的偏好，所以转换为C\C++文件的时候，最好指定系统平台。例如：window、mac、iOS、linux。
        终端命令：clang  -arch  arm64  -rewrite-objc  OC源文件  -o  输出的CPP文件
                xcrun  -sdk  iphoneos  clang  -arch  arm64  -rewrite-objc  OC源文件  -o  输出的CPP文件      //输出与iphoneos系统平台兼容的C++文件。
                        xcrun：xcode run的意思，也就是xcode的工具。 -sdk是指定平台。iphonesos系统pint台。
                        clang：编译器指令，-arch指定架构。arm64架构。-rewrite-objc重写oc代码的意思。
        xcode将要编译的文件选择：工程 --> Target --> buiding phases --> compile sources --> 里面就是需要编译的源代码文件了。
 
    3、OC中对象的种类：
    
        CPU --> 查看类的源代码 --> 根据源代码生成元类对象、类对象 --> 元类对象存储类方法、类对象存储实例对象的相关信息 --> 别的地方初始化实例对象 -->
        类对象根据自身存储的信息生成实例对象  --> CPU开辟空间给实例对象存储东西。
        
        1> 实例对象(instance)
            通过类描述信息alloc出来的对象，每次alloc都会分配内存产生新的instance对象。
            实例对象内存空间存储的东西是：成员变量(isa指针、基本数据类型、结构体)，不存储方法体的内存。
            所以子类的实例对象的内存空间，其实是会存储父类的成员变量的内存的，因为成员变量相对实例来讲，是唯一的内存空间。
 
        2> 类对象(class)
            OC语言为源代码的类描述信息定义了一个类对象，类对象的指令代码在内存中，就是根据自身的描述信息去叫系统alloc出实例对象。
            类对象内存空间存储的是：isa指针、实例对象方法体代码的内存、成员变量描述信息的内存、协议信息的内存、类成员变量的内存等等。
                                反正就是实例对象共享的代码、只需要存储一份的代码都在类对象里。
            NSObject的class方法无论调用多少次，都是返回当前的类对象。
    
        3> 元类对象(meta-class)
            描述数据的数据，就叫做元数据。
            元类对象设计的目的，是让所有类继承于NSObject，有一个共同的超类，定义对象概念的最基础的属性和行为。
            元类对象存储的是描述类对象的信息，元类对象和类对象的内存结构是一样的，只是用途不一样。
            元类对象内存空间存储的是：isa指针、superclass指针、类方法信息等等，但是其他指针基本是都是Null，主要用于存储类方法信息的内容。
            通过方法object_getClass(id  _Nullable obj)来获取类对象的元类对象，参数是类对象。
 
        4> 无论是父类还是子类，都有自己的 instance、class、meta-class。

                        
 */


@interface TestOCNSObject_VC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong) UICollectionView * baseCollView;
@property(nonatomic,strong) NSArray * collDataArr;

@end

@implementation TestOCNSObject_VC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"测试OC对象的VC";
    self.view.backgroundColor = [[UIColor alloc] initWithRed: 199/255.0 green: 204/255.0 blue: 237/255.0 alpha:1.0];
    [self.view addSubview:self.baseCollView];
    
}
//MARK: - UICollectionViewDataSource & UICollectionViewDelegate 协议
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了OC的第%ld个item",(long)indexPath.row);
    switch (indexPath.row) {
        case 0:
            //TODO: 0、测试常用的C语言函数。
            /**
                1、class_getInstanceSize 返回一个类的实例自身的大小(字节)。参数是类对象。(C语言的结构体内存对齐规则后的大小)。运行阶段。
                2、malloc_size((__bridge const void *)(obj));获得指针所指向的动态分配内存的大小(字节)，参数是C语言指针，系统内存16字节对齐分配。
                3、sizeof(expression-or-type)是计算数据类型自身大小的运算符，在编译阶段确认(C语言内存对齐规则)。iOS系统是小端模式读取内存的值。参数是类对象。
                4、objc_getClass(const char * _Nonnull name)根据参数字符串返回对应的类对象。
                   object_getClass(id  _Nullable obj)方法返回类对象的元类对象，参数是类对象。实例对象-->类对象-->元类对象-->NSObject(基类)的元类对象。
                5、OC指针转换为C指针，需要在OC指针前加上(__bridge const XXX *)语句，强制类型转换。
             */
            NSLog(@"0、测试常用的C语言函数。");
        {
            NSObject *obj = [[NSObject alloc] init];
            
            //1、class_getInstanceSize 返回一个类的实例的大小(字节)。参数是类对象。这里是实例对象的自身大小。
            NSInteger instanceSize = class_getInstanceSize([NSObject class]);
            NSLog(@"NSObject类的实例对象大小是：%zd",instanceSize);
            
            //2、获得指针所指向的内存的大小(字节)，参数是C语言指针指针。这里指的是内存分配的大小，16字节对齐分配。
            //   OC指针转换为C语言指针，在OC指针前加上(__bridge const void *)语句，强制类型声明。
            NSInteger mallocSize = malloc_size((__bridge const void *)(obj));
            NSLog(@"指针所指向的内存的大小是：%zd",mallocSize);
            
            //3、C语言函数sizeof是计算数据类型自身的大小，在编译阶段确认，而非动态内存分配时确认。(所占空间根据C语言规则占用)
            NSInteger personSize = sizeof([OCObject_Person class]);
            NSLog(@"C语言函数sizeof的大小：%zd",personSize);
            
            
            
        }
            break;
        case 1:
            //TODO: 1、测试OC对象的本质。
            /**
                1、oc对象可以强转换为C语言结构体，因为对象的本质就是C语言的结构体。
                2、OC指针转换为C语言指针的时候，记得桥接(__bridge struct XXX *)。
             */
            NSLog(@"1、测试OC对象的本质。");
        {
            // OCObject_Person类的底层C语言源码就是这个样子。
            struct OCObject_Person_IMPL {
                Class isa;
                int _no;    //4字节
                int _age;   //4字节
            };
            OCObject_Person * person = [[OCObject_Person alloc] init];
            person -> _no = 1;
            person -> _age = 18;
            
            struct OCObject_Person_IMPL * personIMPL = (__bridge struct OCObject_Person_IMPL *)(person);   //OC指针桥接为C指针。
            NSLog(@"oc对象强转换为C语言结构体，_no:%d , _age:%d ",personIMPL->_no,person->_age);
        }
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
        _baseCollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 160) collectionViewLayout:layout];
        [_baseCollView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"OCTestCEll"];
        _baseCollView.backgroundColor = [[UIColor alloc] initWithRed:255/255.0 green:254/255.0 blue:243/255.0 alpha:1.0];
        _baseCollView.layer.borderColor = [[[UIColor alloc] initWithRed:0 green:30/255.0 blue:60/255.0 alpha:1.0] CGColor];
        _baseCollView.layer.borderWidth = 1.0;
        _baseCollView.delegate = self;
        _baseCollView.dataSource = self;
    }
    return _baseCollView;
}

- (NSArray *)collDataArr{
    if (!_collDataArr) {
        _collDataArr = @[@"测试0",@"测试1",@"测试2",@"测试3",
                         @"测试4",@"测试5",@"测试6",@"测试7",
                         @"测试8",@"测试9",@"测试10",@"测试11"];
    }
    return _collDataArr;
}



@end
