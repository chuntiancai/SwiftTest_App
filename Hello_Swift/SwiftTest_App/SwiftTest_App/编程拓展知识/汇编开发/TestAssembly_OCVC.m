//
//  TestAssembly_OCVC.m
//  SwiftTest_App
//
//  Created by mathew on 2023/1/4.
//  Copyright © 2023 com.mathew. All rights reserved.
//
// 测试汇编代码的VC
#import "TestAssembly_OCVC.h"
#import "SwiftTest_App-Swift.h"
#import "testArm.h"

//MARK: - 笔记
/**
    1、因为swift无法编写内联汇编代码，所以只能用oc来进行测试。
    2、汇编文件是以.asm结尾的，可以缩写为.s文件。
    3、寄存器相关的lldb命令：
        register read rax //读取rax寄存器的值
        register write rax 23   //写入立即数23到rax寄存器。
        x/数量-格式-字节大小 内存地址                //读取内存中的值
            x/3xw 0x00000000fe150e
            x/4xg      --b,h,w,g对应1,2,4,8个字节；x代表十六进制
 
        3.1、LLDB常用指令：
            帮助指令：help + <命令> + <命令动作>
            表达式指令，可以在执行中添加OC执行语句：expression + OC语句
                    例如：expr (void) NSLog(@"balhbalh")，&0,&1这样的符号,是指对象的一个引用. 在控制台上可以用这个符号来操作对应的对象。
                    p指令也可以实现expr的效果。po指令可以实现 expr -O -- 执行语句 的效果。
            打印堆栈信息的指令，thread backtrace 或者 bt 指令。
                    frame表示栈帧，一帧表示一个函数调用。0表示最新的执行帧。
            函数返回的指令：thread return + 返回值。 直接改变当前方法调用的返回值，不再执行断点后面的代码。
            查看方法体里变量的指令：frame variable + [变量名]。直接查看当前方法栈帧里变量的值。
            继续(continue)：执行完当前断点，继续当前进程。指令：thread continue、continue、c。
            步入(step in)：断点进入到方法体里执行。(单步)指令：thread step-in、step、s。
            步出(step out)：执行完当前的方法体，并执行到断点之后的位置。thread step-out、finish。
            步过(step over)：直接执行完当前的方法语句，执行到下一行语句前。thread step-over、next、n。
                            si、ni和s、n类似，只是si、ni是汇编指令级别的单步。instruction level，指令级别。
            打断点：breakpoint set -n 某方法。设置关于这个方法的符号断点，在调用这个方式时，程序都会暂停。
                    例如：br set -n touchesBegan:withEvent:
                br l。列出当前工程的所有断点信息.
                br set -r 正则表达式。通过正则表达式来打断点。
                breakpoint command add -F "python文件名"."python方法名" n。给第n个断点添加导入的 python 文件中的方法调用。执行完脚本后停止在断点位置。

            内存断点：一旦有代码修改了监听的内存位置，断点停止在修改内存的代码处。
                watchpoint set variable 变量名。监听改变量的内存地址，并且打上内存断点。

            模块查找：image list。查看当前app运行时，执行的模块(镜像)。
                    image lookup -t 某个类型。查看某个类型的信息。例如：image lookup -t UIView。
                    image lookup -a 内存地址。查看某个内存地址对应的源码。程序崩溃的时候，很有用。
                    image lookup -a 符号或者函数名。查找某个符号或者函数的所有源码位置。
        
 */

void assemblyHaha(void){
    printf("这是assemblyHaha哈哈函数");
}

@interface TestAssembly_OCVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong) UICollectionView * baseCollView;
@property(nonatomic,strong) NSArray * collDataArr;

@end

@implementation TestAssembly_OCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试OC汇编的VC";
    self.view.backgroundColor = [[UIColor alloc] initWithRed: 199/255.0 green: 204/255.0 blue: 237/255.0 alpha:1.0];
    [self.view addSubview:self.baseCollView];

}
//MARK: - UICollectionViewDataSource & UICollectionViewDelegate 协议
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了OC的第%ld个item",(long)indexPath.row);
    switch (indexPath.row) {
        case 0:
            //TODO: 0、
            NSLog(@"0、");
        {
//            testArmFunc();
//            int res = testArmAdd(6, 2);
//            NSLog(@"汇编加法的返回值:%d",res);
        }
            break;
        case 1:
            //TODO: 1、
            NSLog(@"1、");
        {
            
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

