//
//  main.m
//  属性，方法练习
//
//  Created by Mathew Cai on 2021/2/6.
//  Copyright © 2021 com.mathew. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    int year;
    int month;
    int day;
} Date;


@interface Student : NSObject
{
    @public
    NSString *_name;
    Date _birthday;
}

- (void)say;

@end

@implementation Student

- (void)say
{
    NSLog(@"name = %@;  date = %@ ,year = %i, month = %i, day = %i", _name,_birthday, _birthday.year, _birthday.month, _birthday.day);
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"OC 的属性，方法练习");
        Student *stu = [Student new];
        [stu say];
    }
    return 0;
}
