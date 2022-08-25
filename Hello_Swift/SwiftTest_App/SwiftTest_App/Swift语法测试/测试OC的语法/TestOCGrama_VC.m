//
//  TestOCGrama_VC.m
//  SwiftTest_App
//
//  Created by mathew on 2022/7/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试OC语法的VC

#import "TestOCGrama_VC.h"
#import "SwiftTest_App-Swift.h"

//MARK: - 笔记
/**
    1、宏 是预编译（编译之前处理)阶段，把 宏 替换成 宏定义的字符串，不会做编译检查，是直接的字符串替换。可以用宏定义函数方法等。宏会影响编译速度，因为替换要花时间。
        在宏的参数名前加 # 号： 替代之后就是在参数两边加上双引号。注意：双引号是C语言的字符串，再加上个@符号才是OC的字符串。
        ## 号：替代之后就是在拼参数
    2、const 用来限制类型为常量(只读)，指针指向的地址不可变、变量的内容不可以变。
        // 两种方式一样
        const int *p1; // *p1：常量 p1:变量
        int const *p1; // *p1：常量 p1:变量
    
        // const修饰指针变量p1
        int * const p1; // *p1:变量 p1:常量 ； 地址上的内容可变，指针指向的地址不可变。
    
        // 第一个const修饰*p1 第二个const修饰 p1
        // 两种方式一样
        const int * const p1; // *p1：常量 p1：常量
        int const * const p1;  // *p1：常量 p1：常量
 
    3、static 延迟局变量生命周期(只会创建一份内存，只会执行一次)，app结束的时候才释放静态变量。注意，全局静态变量只有当前文件可见，全局普通变量，app全局可见。
    4、extern 到外部去查找全局变量(静态或者普通)。先在当前文件找，找不到就去外部找。只能用于声明，不能用于定义。
    5、全局变量，一般不定义在类的文件中，而是额外创建一个文件，专门用来定义全局变量，在工程里的.h,.m文件默认都会被添加进编译。
    6、weak和assgin的区别
        ARC:才有weak
        weak:__weak 弱指针,不会让引用计数器+1,如果指向对象被销毁,指针会自动清空
        assgin:__unsafe_unretained修饰,也不会让引用计数器+1,但是如果指向对象被销毁,指针不会清空，需要手动清空，是MRC的历史遗留。
                所以assign并不保留对实例的引用，也不销毁指针，所以在方法栈中通过assgin保留对象的引用，会导致坏地址访问报错。但是可用于基本类型，因为是值传递。
    
    7、@class关键字 用在A.h文件中，在头部声明@class A ，目的是告诉编译器，当前正在A.h文件里，如果A.h文件中有协议是用到A的话，先不用管，等后面真正用到协议的时候，再引进A.h文件给协议使用。
        是为了在A.h文件中使用A类而声明的关键字。
 */


static int age = 20;    /// static修饰全局变量

@interface TestOCGrama_VC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong) UICollectionView * baseCollView;
@property(nonatomic,strong) NSArray * collDataArr;

@end

@implementation TestOCGrama_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试OC的语法";
    self.view.backgroundColor = [[UIColor alloc] initWithRed: 199/255.0 green: 204/255.0 blue: 237/255.0 alpha:1.0];
    [self.view addSubview:self.baseCollView];

}
//MARK: - UICollectionViewDataSource & UICollectionViewDelegate 协议
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了OC的第%ld个item",(long)indexPath.row);
    switch (indexPath.row) {
        case 0:
            //TODO: 0、测试 宏、static、const、extern 关键字的区别。
            NSLog(@"0、测试 宏、static、const、extern 关键字的区别。");
        {
            extern int age;
            NSLog(@"extern的使用 %d",age);
        }
            break;
        case 1:
            //TODO: 1、测试静态局部变量对全局的影响
            /**
                1、static修饰的局部变量，static所在的代码之后执行一次。
             */
            NSLog(@"1、");
        {
            // static修饰局部变量
            static int age = 5; //这句代码只会执行一次，下次进入，直接跳过。age的生命周期已经演延长到全局。
            age++;
            NSLog(@"1、测试静态局部变量对全局的影响： %d",age);
        }
            break;
        case 2:
            //TODO: 2、测试static局部变量只会创建一份内存
        {
            static int age;
            NSLog(@"2、测试静态局部变量对全局的影响： %d",age);
        }
            break;
        case 3:
            //TODO: 3、测试assign和weak的区别。
        {
            static int age;
            NSLog(@"2、测试静态局部变量对全局的影响： %d",age);
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
