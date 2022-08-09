//
//  TestOCBlock_VC.h
//  SwiftTest_App
//
//  Created by mathew on 2022/7/19.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestOCBlock_VC : UIViewController

/// 返回值是一个block，block的返回值是TestOCBlock_VC,block的参数是 两个NSString

-( TestOCBlock_VC *(^)(NSString * name, NSString * nickName) ) blockLink;

@end

NS_ASSUME_NONNULL_END
