//
//  Person_Property.h
//  OC_syntax_CmdLine
//
//  Created by mathew2 on 2021/4/15.
//  Copyright © 2021 com.mathew. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface Person_Property : NSObject
/**
 不可变class（如，NSString） ：
    1、copy  （浅拷贝） 返回本身
    2、mutableCopy   （深拷贝）创建新的可变对象（如，创建一个NSMutableString对象，地址跟原对象不同）
 可变class（如，NSMutableString）：
    1、copy  （深拷贝） 创建新的不可变对象（如，创建一个NSTaggedPointerString对象，地址跟原对象不同 ）
    2、mutableCopy   （深拷贝） 创建新的可变对象（如，创建一个NSMutableString对象，地址跟原对象不同 ）
     

 */
@property (copy,nonatomic) NSMutableArray * pArray;

@end

NS_ASSUME_NONNULL_END
