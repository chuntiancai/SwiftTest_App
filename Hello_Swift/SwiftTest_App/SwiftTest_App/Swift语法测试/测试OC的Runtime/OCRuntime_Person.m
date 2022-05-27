//
//  OCRuntime_Person.m
//  SwiftTest_App
//
//  Created by mathew on 2022/5/27.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import "OCRuntime_Person.h"


@implementation OCRuntime_Person
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%s", __func__);
    }
    return self;
}

-(void)move{
    NSLog(@"OCRuntime_Person 移动啦～");
    
}

-(void)eat{
    NSLog(@"OCRuntime_Person 吃饭啦～");
}

-(void)run: (NSInteger) meter and:(NSString *) minute {
    NSLog(@"OCRuntime_Person 跑了%ld米～, %@ 的时间",meter,minute);
}

+(void)sleeping{
    NSLog(@"OCRuntime_Person 睡觉啦～");
}

@end
