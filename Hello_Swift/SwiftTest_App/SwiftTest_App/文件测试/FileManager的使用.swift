//
//  FileManager的使用.swift
//  HelloTest
//
//  Created by Mathew Cai on 2020/9/17.
//  Copyright © 2020 mathew. All rights reserved.
//

import Foundation
import UIKit


struct FileManagerTool{
    
//    1、您可以使用FileManager定位、创建、复制和移动文件和目录。
//    2、您还可以使用它来获取关于文件或目录的信息，或更改其某些属性。
//    3、可以使用 “ NSURL ” 或 “ NSString ” 对象 指定文件的位置。
//    4、FileManagerDelegate：移动、复制、链接或删除文件或目录，则可以将委托与文件管理器对象结合使用来管理这些操作。
//       委托必须遵守FileManagerDelegate协议。委托的角色是确认操作并在出现错误时决策是否继续执行。
//    5、FileManager对象应该使用单例模式：如果使用委托来接收关于移动、复制、删除和链接操作状态的通知，则应该创建FileManager对象的唯一实例
    
}

class FileMangerTest:NSObject {
    static let shared: FileMangerTest = FileMangerTest()    //单例
    private override init() {
        super.init()
        fileManger.delegate = self  //设置委托对象为自己（订阅者为自己）
    }
    let fileManger = FileManager.init()
}

//MARK: - 遵循FileManagerDelegate协议，在操作文件过程监听相应的操作通知
extension FileMangerTest: FileManagerDelegate {
    
}



