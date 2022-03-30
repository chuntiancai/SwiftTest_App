//
//  NewsMainVCViewController.m
//  OC_Test_App
//
//  Created by mathew2 on 2021/3/18.
//

#import "NewsMainVC.h"

@interface NewsMainVC ()

@end

@implementation NewsMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.grayColor;
    UIView * redView = [UIView new];
    redView.frame = CGRectMake(50, 100, 100, 200);
    redView.bounds = CGRectMake(10, 10, 100, 100);
    redView.layer.borderColor = UIColor.blackColor.CGColor;
    redView.layer.borderWidth = 2;
    redView.backgroundColor = UIColor.redColor;
    UIView * blueView = [UIView new];
    blueView.frame = CGRectMake(0, 0, 60, 60);
    blueView.bounds = CGRectMake(0, 0, 300, 60);
    blueView.layer.borderColor = UIColor.yellowColor.CGColor;
    blueView.layer.borderWidth = 1;
    blueView.backgroundColor = UIColor.blueColor;
    blueView.clipsToBounds = true;
    [redView addSubview:blueView];
    [self.view addSubview: redView];
    
}


@end
