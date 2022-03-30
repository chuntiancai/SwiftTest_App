//
//  File的常见操作.swift
//  HelloTest
//
//  Created by Mathew Cai on 2020/9/17.
//  Copyright © 2020 mathew. All rights reserved.
//

import Foundation
import UIKit

struct MyFileOperation{
    
    //MARK: - 1、遍历文件
    func iteratorFiles(){
        
        ///(1）首先我们获取用户文档目录路径
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        print("documnet 目录url：",url)
        
        ///(2）对指定路径执行浅搜索，返回指定目录路径下的文件、子目录及符号链接的列表
        let contentsOfPath = try? manager.contentsOfDirectory(atPath: url.path)
        print("contentsOfPath: \(contentsOfPath ?? ["0_0"])")
        
        ///(3）类似上面的，对指定路径执行浅搜索，返回指定目录路径下的文件、子目录及符号链接的列表
        let contentsOfURL = try? manager.contentsOfDirectory(at: url,
                                                             includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        print("contentsOfURL: \(String(describing: contentsOfURL))")
        
        ///(4）深度遍历，会递归遍历子文件夹（但不会递归符号链接）
        let enumeratorAtPath = manager.enumerator(atPath: url.path)
        print("enumeratorAtPath: \(String(describing: enumeratorAtPath?.allObjects))")
        
        ///(5）类似上面的，深度遍历，会递归遍历子文件夹（但不会递归符号链接）
        let enumeratorAtURL = manager.enumerator(at: url, includingPropertiesForKeys: nil,
                                                 options: .skipsHiddenFiles, errorHandler:nil)
        print("enumeratorAtURL: \(String(describing: enumeratorAtURL?.allObjects))")
        
        ///(6）深度遍历，会递归遍历子文件夹（包括符号链接，所以要求性能的话用enumeratorAtPath）
        let subPaths = manager.subpaths(atPath: url.path)
        print("subPaths: \(String(describing: subPaths))")
    }
    
    //MARK: - 2，判断文件或文件夹是否存在
    func fileExit(){
        ///判断文件是否存在
        let fileManager = FileManager.default
        let filePathStr:String = NSHomeDirectory() + "/Documents/hangge.txt"
        let exist = fileManager.fileExists(atPath: filePathStr)
        print("文件是否存在：\(exist)")
        
        var isDirExist:ObjCBool = ObjCBool.init(false)
        ///判断目录是否存在
        let dirExist = fileManager.fileExists(atPath: filePathStr, isDirectory: &isDirExist)
        print("目录是否存在：\(dirExist) --- isDirectory: \(isDirExist)")
        
    }
    
    //MARK: - 3，创建文件夹
    func createDiretory(){
        
        let fileManager = FileManager.default
        
        ///方式1：通过字符串路径创建文件夹
        let myDirectory:String = NSHomeDirectory() + "/Documents/myFolder/Files"
        //withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
        try! fileManager.createDirectory(atPath: myDirectory,
                                         withIntermediateDirectories: true, attributes: nil)
        
        ///方式2：通过URL创建目录
        ///在文档目录下新建folder目录
        let urlForDocument = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let baseUrl = urlForDocument[0] as NSURL
        let folder:URL? = baseUrl.appendingPathComponent("folder", isDirectory: true)
        
        print("文件夹的URL: \(String(describing: folder))")
        let exist = fileManager.fileExists(atPath: folder!.path)
        if !exist {
            try! fileManager.createDirectory(at: folder!, withIntermediateDirectories: true,
                                         attributes: nil)
        }
    }
    
    //MARK: - 4，将对象写入文件
    func writeObjToFile(){
        ///可以通过write(to:)方法，可以创建文件并将对象写入，对象包括String，NSString，UIImage，NSArray，NSDictionary等。
        
        ///(1）把String保存到文件，都是通过String进行操作就可以了
        let filePath:String = NSHomeDirectory() + "/Documents/hangge.txt"
        let info = "欢迎来到hange.com"
        try! info.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        
        ///(2）把图片保存到文件路径下
        let filePath2 = NSHomeDirectory() + "/Documents/hangge.png"
        let image = UIImage(named: "apple.png")
        let data:Data = image!.pngData()!
        try? data.write(to: URL(fileURLWithPath: filePath2))
        
        ///(3）把NSArray保存到文件路径下
        let array = NSArray(objects: "aaa","bbb","ccc")
        let filePath3:String = NSHomeDirectory() + "/Documents/array.plist"
        array.write(toFile: filePath3, atomically: true)
        
        ///(4）把NSDictionary保存到文件路径下
        let dictionary:NSDictionary = ["Gold": "1st Place", "Silver": "2nd Place"]
        let filePath4:String = NSHomeDirectory() + "/Documents/dictionary.plist"
        dictionary.write(toFile: filePath4, atomically: true)
    }
    
    //MARK: - 5，创建文件
    func createFile(){
        //在文档目录下新建test.txt文件
         let manager = FileManager.default
         let urlForDocument = manager.urls( for: .documentDirectory,
                                            in:.userDomainMask)
        let fileBaseUrl = urlForDocument[0]
        
        let file = fileBaseUrl.appendingPathComponent("createFile.txt")
        //let file = fileBaseUrl.appendingPathComponent("folder/new.txt")
        print("文件URL: \(file)")
        let exist = manager.fileExists(atPath: file.path)
        if !exist {
            let data = Data(base64Encoded:"ABCdefgh123456" ,options:.ignoreUnknownCharacters)
            let createSuccess = manager.createFile(atPath: file.path,contents:data,attributes:nil)
            print("文件创建结果: \(createSuccess)")
        }
        
    }
    
    //MARK: - 6，复制文件
    func copyFile(){
        ///(1）方法1
        let fileManager = FileManager.default
        let homeDirectory = NSHomeDirectory()
        let srcPath = homeDirectory + "/Documents/hangge.txt"
        let toPath = homeDirectory + "/Documents/copyed.txt"
        try! fileManager.copyItem(atPath: srcPath, toPath: toPath)
        
        ///(2）方法2
        /// 定位到用户文档目录
         let manager = FileManager.default
         let urlForDocument = manager.urls( for:.documentDirectory, in:.userDomainMask)
         let url = urlForDocument[0]
        // 将test.txt文件拷贝到文档目录根目录下的copyed.txt文件
        let srcUrl = url.appendingPathComponent("test.txt")
        let toUrl = url.appendingPathComponent("copyed.txt")
        try! manager.copyItem(at: srcUrl, to: toUrl)
    }
    
    //MARK: - 7，移动文件
    func moveFile(){
        
        ///(1）方法1
        let fileManager = FileManager.default
        let homeDirectory = NSHomeDirectory()
        let srcUrl71 = homeDirectory + "/Documents/hangge.txt"
        let toUrl71 = homeDirectory + "/Documents/moved/hangge.txt"
        try! fileManager.moveItem(atPath: srcUrl71, toPath: toUrl71)
        //(2）方法2
        // 定位到用户文档目录
        let manager = FileManager.default
        let urlForDocument = manager.urls( for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0]
        let srcUrl72 = url.appendingPathComponent("test.txt")
        let toUrl72 = url.appendingPathComponent("copyed.txt")
        // 移动srcUrl中的文件（test.txt）到toUrl中（copyed.txt）
        try! manager.moveItem(at: srcUrl72, to: toUrl72)
    }
    
    //MARK: - 8，删除文件
    func deleteFile(){
        //（1）方法1
        let fileManager = FileManager.default
        let homeDirectory = NSHomeDirectory()
        let srcUrl81 = homeDirectory + "/Documents/hangge.txt"
        try! fileManager.removeItem(atPath: srcUrl81)
        
        /// （2）方法2
        /// 定位到用户文档目录
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0]
        let toUrl82 = url.appendingPathComponent("copyed.txt")
        // 删除文档根目录下的toUrl路径的文件（copyed.txt文件）
        try! manager.removeItem(at: toUrl82)
    }
    
    //MARK: - 9，删除目录下所有的文件
    func deleteAllFilesInDirecory(){
        //（1）方法1：获取所有文件，然后遍历删除
         let fileManager = FileManager.default
        let myDirectory91 = NSHomeDirectory() + "/Documents/Files"
        let fileArray:[String]? = fileManager.subpaths(atPath: myDirectory91)
        for fn in fileArray!{
            try! fileManager.removeItem(atPath: myDirectory91 + "/\(fn)")
        }
        ///（2）方法2：删除目录后重新创建该目录
        let myDirectory92 = NSHomeDirectory() + "/Documents/Files"
        try! fileManager.removeItem(atPath: myDirectory92)
        try! fileManager.createDirectory(atPath: myDirectory92, withIntermediateDirectories: true,
                                         attributes: nil)
    }
    
    
    //MARK: - 10，读取文件
    func readFile(){
        let manager = FileManager.default
        let urlsForDocDirectory = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let docPath = urlsForDocDirectory[0]
        let file = docPath.appendingPathComponent("test.txt")
        
        ///方法1
        let readHandler = try! FileHandle(forReadingFrom:file)
        let data10 = readHandler.readDataToEndOfFile()
        let readString = String(data: data10, encoding: String.Encoding.utf8)
        print("文件内容1: \(String(describing: readString))")
        
        ///方法2
        let data2 = manager.contents(atPath: file.path)
        let readString2 = String(data: data2!, encoding: String.Encoding.utf8)
        print("文件内容2: \(String(describing: readString2))")
    }
    
    //MARK: - 11，在任意位置写入数据到文件
    func writeDataToFile(){
        let manager = FileManager.default
        let urlsForDocDirectory = manager.urls(for:.documentDirectory, in:.userDomainMask)
        let docPath = urlsForDocDirectory[0]
        let file11 = docPath.appendingPathComponent("test.txt")
        let string = "添加一些文字到文件末尾"
        let appendedData = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let writeHandler = try? FileHandle(forWritingTo:file11)
        writeHandler!.seekToEndOfFile()
        writeHandler!.write(appendedData!)
    }
    
    //MARK: - 12，文件权限判断
    func judgeFile(){
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let docPath = urlForDocument[0]
        let file12 = docPath.appendingPathComponent("test.txt")
        let readable = manager.isReadableFile(atPath: file12.path)
        print("可读: \(readable)")
        let writeable = manager.isWritableFile(atPath: file12.path)
        print("可写: \(writeable)")
        let executable = manager.isExecutableFile(atPath: file12.path)
        print("可执行: \(executable)")
        let deleteable = manager.isDeletableFile(atPath: file12.path)
        print("可删除: \(deleteable)")
    }
    
    //MARK: - 13，获取文件属性（创建时间，修改时间，文件大小，文件类型等信息）
    func getFileAttributes(){
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let docPath = urlForDocument[0]
        let file13 = docPath.appendingPathComponent("test.txt")
        let attributes = try? manager.attributesOfItem(atPath: file13.path) //结果为Dictionary类型
        print("attributes: \(attributes!)")
        //从 attributes 中获取具体的属性：
        print("创建时间：\(attributes![FileAttributeKey.creationDate]!)")
        print("修改时间：\(attributes![FileAttributeKey.modificationDate]!)")
        print("文件大小：\(attributes![FileAttributeKey.size]!)")
    }
    
    //MARK: - 14，文件/文件夹比较 内容
    func compareFiles(){
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let docPath = urlForDocument[0]
        let contents = try! manager.contentsOfDirectory(atPath: docPath.path)
        //下面比较用户文档中前面两个文件是否内容相同（该方法也可以用来比较目录）
        let count = contents.count
        if count > 1 {
            let path1 = docPath.path + "/" + (contents[0] as String)
            let path2 = docPath.path + "/" + (contents[1] as String)
            let equal = manager.contentsEqual(atPath: path1,andPath:path2)
            print("path1：\(path1)")
            print("path2：\(path2)")
            print("比较结果： \(equal)")
        }
    }
    
}
