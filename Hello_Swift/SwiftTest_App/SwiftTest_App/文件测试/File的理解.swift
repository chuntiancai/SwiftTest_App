//
//  FileTool.swift
//  HelloTest
//
//  Created by Mathew Cai on 2020/9/17.
//  Copyright © 2020 mathew. All rights reserved.
//

import Foundation

struct FileTool {
    
    
    
//MARK:-     沙盒的结构分布（沙盒是app在手机上的根目录）：
//    沙盒是表示整个app的存储空间，沙盒里的home目录和bunle是同一级别的文件夹。xocde工程程目录下的文件会存放在沙盒的bundle目录中。
    
//    1、AppName.app：包含了所有的资源文件和可执行文件
//    2、Documents：保存应用运行时生成的需要持久化的数据，iTunes同步设备时会备份该目录（常用这个）
//    3、tmp：保存应用运行时所需要的临时数据，使用完毕后再将相应的文件从该目录删除。
//           应用没有运行，系统也可能会清除该目录下的文件，iTunes不会同步备份该目录
//    4、Library/Cache：保存应用运行时生成的需要持久化的数据，iTunes同步设备时不备份该目录。一般存放体积大、不需要备份的非重要数据
//    5、Library/Preference：保存应用的所有偏好设置，IOS的Settings应用会在该目录中查找应用的设置信息。iTunes同步设备时会备份该目录
//    6、设置Application supports iTunes file sharing的值为YES，才可以在itunes查看App的文件
    
//    所以，你只需要使用Foundation中的高级api(如FileManager和FileHandle)与文件交互，可以利用苹果文件系统自动提供的新行为，而不需要更改代码。
//    这样就足够你使用了。
    
//    关于对文件的读写操作，直接在NSData和NSString对象的方法中有封装，传入URL对象作为参数即可，要对字节进行操作的话，就可以用到fileHandle
    
    
//MARK:-  二、关于Bundle：
//    1、Bundle是处于沙盒的根目录，我们无法操作沙盒的根目录，但是api有提供Bundle的目录路径，以供我们操作。
//        Bundle路径代表的是xcode中的工程目录，也就是xcode工程目录中的代码，资源这些被打包后，都放在沙盒的Bundle目录中。
//        所以沙盒的Bundle目录中包含了编译后的可执行文件，info.plist文件，assets文件，你存放的其他文件(mp3,图片，文本等等)，等等。
//        编译后，xcode中的文件目录层级结构，全部解开都放在Bundle目录中，也就是Bundle中不保留xcode的目录结构，而是直接全部放一起。
//        如果你想要在Bundle中保留Xcode中的文件目录结构，那么你就要在xcode中创建自己的bundle包，在自己的bundle包里放自己的文件，
//        然后沙盒的Bundle目录就会保留这个自定义的bundel包层次。
//        api提供的Bundle跟路径(注意，不是沙盒的跟路径)，是Bundle.main，是一个对象。你所有在Xcode工程目录下的文件，都在这个对象中管理，你也可以通过这个对象来获取bundle的路径。
    
    
    
    
    /// 关于文件路径获取的一些方法
    static func testFilePath(){
        
        //MARK: 1、获取filemanger的单例
        let fileManager = FileManager.default
        /// 1、获得沙盒的根路径
        let home1 = NSHomeDirectory() as NSString;     //oc的获取方式
        print("----->HomePath:\(home1)--\(fileManager)")
        
        //FileManager.SearchPathDirectory：表示当前app的目录结构的枚举，并没有定义tmp的case
        //FileManager.SearchPathDomainMask：表示文件所在区域的枚举，例如用户区域，本地区域，云区域
        
        //MARK:  2、获得Documents目录，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath1 = home1.appendingPathComponent("/Documents")       //也是NSString对象
        let docPath2: [NSString] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                       FileManager.SearchPathDomainMask.allDomainsMask, true) as [NSString]
        print("------->DocumentsPath1:\(docPath1)")
        print("--------->DocumentsPath2:\(docPath2)")
        
        //MARK: 3、获取Library 目录
        let libraryPath1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory,
                                                               FileManager.SearchPathDomainMask.userDomainMask, true)
        let libraryPath2 = NSHomeDirectory() + "/Library"
        print("------->libraryPaths:\(libraryPath1)")
        print("--------->>libraryPaths2:\(libraryPath2)")
        
        //MARK: 4、获取临时数据的目录tmp
        
        let tmpPaths1 = NSHomeDirectory() + "/Tmp"
        print("------->tmpPaths1:\(tmpPaths1)")
        
        //MARK: 5、获得沙盒下的缓存目录Library/Cache
        //该目录用于存放应用程序专用的支持文件，保存应用程序再次启动过程中所需要的信息
        let cachePaths1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                              FileManager.SearchPathDomainMask.userDomainMask, true)
        let cachePaths2 = NSHomeDirectory() + "/Library/Caches"
        print("------->cachePaths1:\(cachePaths1)")
        print("--------->>cachePaths2:\(cachePaths2)")
        
        //MARK: 6、获取bundle的路径
        let bundlePath = Bundle.main.bundlePath //主bundle
        let labiBundlePath = Bundle.main.path(forResource: "labi", ofType: "bundle")    //自定义的bundle的路径
        let labiBundle = Bundle.init(path: labiBundlePath!)//自定义的bundle
        let labi01Path = labiBundle?.path(forResource: "labixiaoxin01", ofType: "jpg", inDirectory: "labixiaoxinImage/labi01")
        let img = UIImage.init(contentsOfFile: labi01Path!)
        print("bundle的路径:\(bundlePath) -- 自定义bundle:\(String(describing: labiBundle)) -- 获取bundle里的图片：\(img)")
        
        /// 3、获取文本文件路径
        //        let filePath = docPath.stringByAppendingPathComponent("data.plist");
        
        
    }
    
    
}
