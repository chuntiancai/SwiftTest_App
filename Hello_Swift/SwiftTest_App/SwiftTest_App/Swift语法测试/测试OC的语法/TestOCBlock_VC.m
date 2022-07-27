//
//  TestOCBlock_VC.m
//  SwiftTest_App
//
//  Created by mathew on 2022/7/19.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试OC的block语法
#import "TestOCBlock_VC.h"
#import "SwiftTest_App-Swift.h"

//MARK: - 笔记
/**
    1、// block定义:三种方式 = ^(参数){};
          总结：block的声明需要写出block的名字，block的定义不能写block的名字。
               block的声明只能写出参数的类型，block的定义需要写出参数的类型和写名字。
               block的声明里有多个参数用逗号分开，block的定义也是。
               block的定义，用^表示是block。
 
        // 第一种
        void(^block1)() = ^{
            NSLog(@"调用了block1");
        };
        
        // 第二种 如果没有参数,参数可以隐藏,如果有参数,定义的时候,必须要写参数,而且必须要有参数变量名
        void(^block2)(int) = ^(int a){
            
        };
        
        // 第三种 block返回可以省略,不管有没有返回值,都可以省略
        int(^block3)() = ^int{
            return 3;
        };
        
        
        // block类型:int(^)(NSString *)
        int(^block4)(NSString *) = ^(NSString *name){
            return 2;
        };
 
        // block的调用
        block(参数);
 
        // block的快捷键，敲inlineblock
 
    2、OC的block是一个oc对象。
       block的内存管理：
            总结:只要block没有引用外部局部变量,block放在全局区。
            
            如何判断当前文件是MRC,还是ARC
                1.dealloc 能否调用super,只有MRC才能调用super
                2.能否使用retain,release.如果能用就是MRC

            MRC(人工管理内存)了解开发常识:1.MRC没有strong,weak,局部变量对象就是相当于基本数据类型
                                     2.MRC给成员属性赋值,一定要使用set方法,不能直接访问下划线成员属性赋值
            MRC:管理block
                    1、只要Block引用外部局部变量,block放在栈里面。因为会随方法栈的执行完毕，而去释放内存，便于管理。
                    2、@property (nonatomic, copy) void(^block)();
                      block只能使用copy,不能使用retain,使用retain,block还是在栈里面，而方法栈执行完之后会释放内存，而retain保留了指针，会导致访问坏指针报错。 使用copy会把block复制到堆内存里面。
 
            ARC管理原则:只要一个对象没有被强指针修饰就会被销毁,默认局部变量对象都是强指针,存放到堆里面。
                      1、只要block引用外部局部变量,block放在堆里面。
                      2、@property (nonatomic, copy) void(^block)();
                         block使用strong，最好不要使用copy。因为用strong和copy的效果是一样的，但是copy还有一个判断类型、复制内存的过程，没啥必要，因为结果都是绑定对象的引用。
 
    3、当由方法内部决定是什么时候执行block的时候，就把block写成参数，由外部提供执行代码，由方法内部决定执行时机。
 */

typedef int(^blockType)(void); //也可以通过别名的方式

@interface TestOCBlock_VC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong) UICollectionView * baseCollView;
@property(nonatomic,strong) NSArray * collDataArr;
//MARK: block的声明
@property(nonatomic,strong) void(^block1)(void);
@property(nonatomic,strong) blockType block2; //也可以通过别名的方式,不建议，跳来跳去

@end

@implementation TestOCBlock_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试OC_block_VC";
    self.view.backgroundColor = [[UIColor alloc] initWithRed: 199/255.0 green: 204/255.0 blue: 237/255.0 alpha:1.0];
    [self.view addSubview:self.baseCollView];

}
//MARK: - UICollectionViewDataSource & UICollectionViewDelegate 协议
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了OC的第%ld个item",(long)indexPath.row);
    switch (indexPath.row) {
        case 0:
            //TODO: 0、测试定义bolck的三种方式
            NSLog(@"0、测试定义bolck的三种方式");
        {
            // 第一种
            void(^block1)(void) = ^{
                NSLog(@"执行了block1");
            };
            
            // 第二种 如果没有参数,参数可以隐藏,如果有参数,定义的时候,必须要写参数,而且必须要有参数变量名
            void(^block2)(int) = ^(int a){
                NSLog(@"执行了block1，参数：%d",a);
            };
            
            // 第三种 block返回可以省略,不管有没有返回值,都可以省略
            int(^block3)(void) = ^int{
                NSLog(@"执行了block3");
                return 3;
            };
            
            
            // block类型:int(^)(NSString *)
            int(^block4)(NSString *) = ^int(NSString *name){
                NSLog(@"执行了block4,参数：%@",name);
                return 4;
            };
            
            /// block的执行
            block1();
            block2(2);
            int res3 = block3();
            int res4 = block4(@"李四");
            NSLog(@"block3返回值：%d, block4返回值：%d",res3,res4);
            
        }
            break;
        case 1:
            //TODO: 1、测试block的循环引用，weak self
            NSLog(@"1、");
        {
            /**
             typeof(int *) a,b;
             等价于：
             int a,b;
             */
            ///__weak TestOCBlock_VC weakSelf = self
            __weak typeof(self) weakSelf = self;    ///typeof(self)相当于TestOCBlock_VC，这里就相当于声明了一个弱引用的TestOCBlock_VC变量
            _block1 = ^{
                /**
                    1、相对于block1而言，因为weakSelf是外部的变量，直接引用的话weakSelf会生成_block1对象的成员变量，所以_block1对象是对weakSelf进行了一个强引用。
                    2、而__strong typeof(weakSelf) strongSelf = weakSelf; 相当于在block里面声明了一个局部变量，相当于方法栈的局部变量，执行完就释放了。
                 */
                ///  __strong TestOCBlock_VC strongSelf = weakSelf;
                __strong typeof(weakSelf) strongSelf = weakSelf;    /// 在block声明了一个强引用的TestOCBlock_VC变量，block执行完之后，便释放strongSelf，因为strongSelf是局部变量。
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSLog(@"打印strongSelf：%@",strongSelf);
                });
            };
        }
            
            break;
        case 2:
            //TODO: 2、测试block的变量传递
            NSLog(@"2、测试block的变量传递");
        {
            /**
                1、局部变量，在定义block时，传进去给block代码块里面的值就已经复制了，是值传递。
                2、如果是静态局部变量，全局变量，那么就是指针传递。static int a = 3
             */
            int a = 3;
            void(^curBlock)(void) = ^{
                NSLog(@"闯进去block的值：%d",a);
            };
            a = 5;
            curBlock(); //结果是3
        }
            break;
        case 3:
            //TODO: 3、测试block作为返回值,链式编程。
            /// 返回值是一个block，block的返回值是TestOCBlock_VC,block的参数是 两个NSString
            NSLog(@"3、测试block作为返回值,链式编程。");
        {
            self.blockLink(@"哈",@"啦").blockLink(@"哈哈",@"啦啦").blockLink(@"哈哈哈",@"啦啦啦");
            
            /// 链式编程的写法。
            TestOCBlock_VC * (^curBlock)(NSString *, NSString *) = ^TestOCBlock_VC * (NSString * name,NSString * nickName){
                NSLog(@"curBlock的第一个参数是：%@ 第二个参数是：%@\n",name,nickName);
                return self;
            };
            curBlock(@"写",@"法");
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
//MARK: - 测试的方法

//TODO: 测试block的链式编程
/// 返回值是一个block，block的返回值是TestOCBlock_VC,block的参数是 两个NSString
- (TestOCBlock_VC * (^)(NSString * , NSString * ))blockLink{
    
    TestOCBlock_VC * (^curBlock)(NSString *, NSString *) = ^TestOCBlock_VC * (NSString * name,NSString * nickName){
        NSLog(@"block的第一个参数是：%@ 第二个参数是：%@\n",name,nickName);
        return self;
    };
    return curBlock;
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

