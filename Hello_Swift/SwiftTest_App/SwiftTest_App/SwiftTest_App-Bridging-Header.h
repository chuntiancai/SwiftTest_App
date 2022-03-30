//
//  SwiftTest_App-Bridging-Header.h
//  SwiftTest_App
//
//  Created by mathew on 2021/7/15.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// oc桥接头文件

#ifndef SwiftTest_App_Bridging_Header_h
#define SwiftTest_App_Bridging_Header_h

#import <CommonCrypto/CommonCrypto.h>
//MARK: swift使用OC的库
#import "Reachability.h"
#import "MJRefresh.h"
#import <Bugly/Bugly.h>
//#import "NSData+ImageContentType.h"

#endif /* SwiftTest_App_Bridging_Header_h */

/**
    1、Swift中要使用OC的类，就需要把OC的头文件暴露在该桥接文件中。Swift中用到哪个OC类，就需要在桥接文件中import该OC类的头文件。
    2、OC想要调用Swift类的方法，就需要在源文件里面引入头文件：#import ”Product Module Name-Swift.h”,其中Product Module Name替换成项目名称(SwiftTest_App-Swift.h)
    3、
 */
