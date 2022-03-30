//
//  JFZAudioVideoModel.swift
//  SwiftTest_App
//
//  Created by chuntiancai on 2021/7/18.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 播放器的数据源model，配置model，才可以播放，根据url的后缀是否视频文件，文件格式在videoTypeEnum枚举类型里，后期可再拓展
import UIKit

struct JFZAudioVideoModel {
    /// 视频文件类型
    enum videoTypeEnum:String {
        case avi = ".avi"
        case wmv = ".wmv"
        case mpg = ".mpg"
        case mpeg = ".mpeg"
        case mov = ".mov"
        case rm = ".rm"
        case ram = ".ram"
        case swf = ".swf"
        case flv = ".flv"
        case mp4 = ".mp4"
        case rmvb = ".rmvb"
    }
    
    /// 音视频标题
    var fileName: String?
    
    /// 音频/视频，类型
    var fileClass: String = "VIDEO"
    
    /// 视频ID
    var fileId:String?
    
    /// 视频地址
    var fileUrl: String = ""{
        didSet{
            if let index = fileUrl.lastIndex(of: ".") {   //判断是否是mp4文件
                let typeStr = fileUrl[index...]
                if let _ = videoTypeEnum(rawValue: String(typeStr)) {
                    self.isVideo = true
                }
            }
        }
    }
    
    /// 是否是视频类型
    var isVideo:Bool = false
    
    /// 封面图片URL字符串
    var imageUrlStr:String?
    
    /// 播放进度
    var progress:CGFloat?
    
    /// 创建时间
    var createrTime:String?
    
    /// 视频总时长
    var duration:CGFloat?
    
    /// 是否断点续播（默认true）
    var playContinue: Bool = true
    
    init(fileName: String? = nil, fileClass: String = "VIDEO", fileId: String? = nil,  fileUrl: String = "", imageUrlStr: String? = nil,  progress: CGFloat? = nil, createrTime: String? = nil, duration: CGFloat? = nil,  playContinue: Bool = true) {
        self.fileName = fileName
        self.fileClass = fileClass
        
        self.fileId = fileId
        self.fileUrl = fileUrl
        if let index = fileUrl.lastIndex(of: ".") {   //判断是否是mp4文件
            let typeStr = fileUrl[index...].lowercased()
            if let _ = videoTypeEnum(rawValue: String(typeStr)) {
                self.isVideo = true
            }
        }
        self.imageUrlStr = imageUrlStr
        self.progress = progress
        self.createrTime = createrTime
        self.duration = duration
        self.playContinue = playContinue

    }
}
