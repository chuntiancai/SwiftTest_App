//
//  TestOCCategory_VC+Test.h
//  SwiftTest_App
//
//  Created by mathew on 2023/1/9.
//  Copyright © 2023 com.mathew. All rights reserved.
//

#import "TestOCCategory_VC.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestOCCategory_VC (Test)

-(void)testCategory;
@property (copy,nonatomic) NSString * myName;   //测试通过关联对象添加属性，自己实现get/set方法。

@end

NS_ASSUME_NONNULL_END
