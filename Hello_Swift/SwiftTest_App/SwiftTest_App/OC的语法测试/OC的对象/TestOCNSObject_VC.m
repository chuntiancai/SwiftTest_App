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
                1、class_getInstanceSize 返回一个类的实例的大小(字节)。参数是类对象。这里是实例对象的自身大小(C语言的结构体内存对齐规则后的大小)。
                2、 malloc_size((__bridge const void *)(obj));获得指针所指向的分配内存的大小(字节)，参数是C语言指针，系统内存16字节对齐分配。
                3、iOS系统是小端模式读取内存的值。
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
