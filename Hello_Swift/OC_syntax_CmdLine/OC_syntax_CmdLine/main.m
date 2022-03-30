//
//  main.m
//  OC_syntax_CmdLine
//
//  Created by Mathew Cai on 2021/2/6.
//  Copyright © 2021 com.mathew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person_Property.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, OC World!");
        Person_Property * p = [Person_Property new];
        p.pArray = [NSMutableArray arrayWithObjects:@"a",@"b",@"c",nil];
        [p.pArray addObject:@"haha"];
        
        NSLog(@"pArray--%@",p.pArray);
        
    }
    return 0;
}
