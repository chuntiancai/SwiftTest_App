//
//  OCTestViewController.m
//  SwiftTest_App
//
//  Created by mathew on 2022/5/27.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试OC语法的主VC

#import "OCTestViewController.h"
#import "SwiftTest_App-Swift.h"
#import "TestRumtime_VC.h"

@interface OCTestViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic,strong) UICollectionView * baseCollView;
@property(nonatomic,strong) NSArray * collDataArr;

@end

@implementation OCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.baseCollView];
    self.baseCollView.frame = CGRectMake(0, 32, [UIScreen mainScreen].bounds.size.width, 400);

}
//MARK: - UICollectionViewDataSource & UICollectionViewDelegate 协议
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了OC的第%ld个item",(long)indexPath.row);
    switch (indexPath.row) {
        case 0:
        {
            UIViewController * vc = [[TestRumtime_VC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    [cell addSubview:label];
    
    cell.layer.cornerRadius = 8;
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collDataArr.count;
}


//MARK: - get & set 方法
- (UIView *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        _titleLabel.text = @"测试OC的VC";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:22];
    }
    return _titleLabel;
}
- (UICollectionView *)baseCollView{
    if (!_baseCollView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(80, 60);
        _baseCollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 32, 400, 400) collectionViewLayout:layout];
        [_baseCollView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"OCTestCEll"];
        _baseCollView.backgroundColor = [UIColor whiteColor];
        _baseCollView.delegate = self;
        _baseCollView.dataSource = self;
    }
    return _baseCollView;
}

- (NSArray *)collDataArr{
    if (!_collDataArr) {
        _collDataArr = @[@"OC测试0",@"OC测试1",@"OC测试2",@"OC测试3",
                         @"OC测试4",@"OC测试5",@"OC测试6",@"OC测试7"];
    }
    return _collDataArr;
}



@end
