//
//  OCRuntime_StatusModel.m
//  SwiftTest_App
//
//  Created by mathew on 2022/7/6.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import "OCRuntime_StatusModel.h"

@implementation OCRuntime_StatusModel

+ (instancetype)initWithDict: (NSDictionary *) dict {
    OCRuntime_StatusModel * model = [[OCRuntime_StatusModel alloc] init];
    
    //TODO: KVC:把字典中所有值给模型的属性赋值。系统自带的方法。
    [model setValuesForKeysWithDictionary:dict];
    
    return  model;
    /**
     // 拿到每一个模型属性,去字典中取出对应的值,给模型赋值
     // 从字典中取值,不一定要全部取出来
     // MJExtension:字典转模型 runtime:可以把一个模型中所有属性遍历出来
     // MJExtension:封装了很多层
     item.pic_urls = dict[@"pic_urls"];
     item.created_at = dict[@"created_at"];
     
     // KVC原理:
     // 1.遍历字典中所有key,去model中查找有没有对应的属性
     [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
 
     // 2.去model中查找有没有对应属性 KVC
     // key:source value:来自即刻笔记
     // [item setValue:@"来自即刻笔记" forKey:@"source"]
     [item setValue:value forKey:key];
 
     }];
     */

    
}

//TODO: 重写系统方法? 1.想给系统方法添加额外功能 2.不想要系统方法实现
// 系统根据dict的key 找不到model相应的属性声明时，就会调用这个方法,系统默认执行报错。
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    /*
        [item setValue:@"来自即刻笔记" forKey:@"source"]:
        1.首先去模型中查找有没有setSource,找到,直接调用赋值 [self setSource:@"来自即刻笔记"]
        2.去模型中查找有没有source属性,有,直接访问属性赋值  source = value
        3.去模型中查找有没有_source属性,有,直接访问属性赋值 _source = value
        4.找不到,就会直接报错 setValue:forUndefinedKey:报找不到的错误
     */
    
    //oc打印方法
    NSLog(@"%s %d %s %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
   
}

- (NSString *)description{
    NSString *des = [NSString stringWithFormat:@"<%s: %p>",object_getClassName(self),self];
    NSString *modelStr = [NSString stringWithFormat:@": %@",_source];
    NSString *retStr = [des stringByAppendingString:modelStr];
    return retStr;
}






@end
