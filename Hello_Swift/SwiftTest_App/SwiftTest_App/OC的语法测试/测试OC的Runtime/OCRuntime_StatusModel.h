//
//  OCRuntime_StatusModel.h
//  SwiftTest_App
//
//  Created by mathew on 2022/7/6.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCRuntime_StatusModel : NSObject

@property (nonatomic, strong) NSString *source;

@property (nonatomic, assign) NSInteger reposts_count;

@property (nonatomic, strong) NSArray *pic_urls;

@property (nonatomic, strong) NSString *created_at;

@property (nonatomic, assign) NSInteger attitudes_count;

@property (nonatomic, strong) NSString *idstr;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) NSInteger comments_count;

@property (nonatomic, strong) NSDictionary *user;

/// 声明自定义的构造器。
+(instancetype)initWithDict: (NSDictionary *) dict;

@end

NS_ASSUME_NONNULL_END
