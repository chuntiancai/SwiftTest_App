//
//  OCGeneric_Person.h
//  SwiftTest_App
//
//  Created by mathew on 2022/5/27.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
    1、泛型是在接口的类名字后的<>里面声明的，是一种未确定的状态，在初始化类的时候，传入泛型的具体类型。
    2、 协变和逆变，用于父子类型转换。主要是用于属性，而不是类。
        泛型:__covariant:协变, 子类转父类，时不会报警告。
            __contravariant:逆变 父类转子类，时不会报警告。
    3、__kindof关键字用于说明当前类相当于父类，避免警告。
 */
@interface OCGeneric_Person<__covariant MyType >: NSObject

@property(nonatomic,strong) MyType myLanguage;    //不一定是对象，所以不能用 *
+(__kindof OCGeneric_Person *)person;

@end

NS_ASSUME_NONNULL_END

//MARK: - 笔记
/**
    1、
 */
