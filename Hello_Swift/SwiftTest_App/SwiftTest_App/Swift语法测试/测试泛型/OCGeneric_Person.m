//
//  OCGeneric_Person.m
//  SwiftTest_App
//
//  Created by mathew on 2022/5/27.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import "OCGeneric_Person.h"

@implementation OCGeneric_Person

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"我已经初始化啦～");
    }
    return self;
}

+(id)person {
    return  [[self alloc] init];
}

@end
