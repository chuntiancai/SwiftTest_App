//
//  JFZDefaultVideoCacheLocation.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/14.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 缓存路径的代理者，处理缓存路径

import Foundation

struct JFZDefaultVideoCacheLocation: JFZMediaCacheLocationDelegate {
    
    /// 缓存的列表
    static var cacheListPath: String = JFZPlayerFileDirectory.VideoCache.cachesPlist
    
    /// 缓存呢标志
    var identifier: String
    /// 鉴权地址（需鉴权可修改）
    var authenticatedURL: URL
    /// 原始地址
    var originalURL: URL
    
    var storageURL: URL
    
    var playURL: URL
    
    let mediaType: JFZMediaType
    
    init(remoteURL: URL, mediaType: JFZMediaType, authenticationFunc: ((URL) -> URL)? = nil) {
        self.init(remoteURL: remoteURL, mediaType: mediaType)
        
        
        if let authenticationFunc = authenticationFunc {
            self.authenticatedURL = authenticationFunc(remoteURL)
        }
    }
    
    // , authenticationFunc: ((URL) -> URL)? = nil
    init(remoteURL: URL, mediaType: JFZMediaType) {
        
        let videoDirectory = JFZPlayerFileDirectory.VideoCache.videoDirectory
        
        func playURL(originalURL: URL, identifier: String) -> URL {
            
            let fileName = (identifier + "_decrypted").JFZmd5
            let filePath = videoDirectory + "/" + fileName + "." + originalURL.pathExtension
            return URL(fileURLWithPath: filePath)
        }
        
        func storageURL(originalURL: URL, identifier: String) -> URL {
            
            let fileName = identifier
            let filePath = videoDirectory + "/" + fileName + "." + originalURL.pathExtension
            return URL(fileURLWithPath: filePath)
        }
        
        self.identifier = remoteURL.absoluteString.JFZmd5
        
        self.originalURL = remoteURL
        
        self.authenticatedURL = remoteURL
        
        self.storageURL = storageURL(originalURL: remoteURL, identifier: identifier)
        self.playURL = playURL(originalURL: remoteURL, identifier: identifier)
        
        self.mediaType = mediaType
        
        if !FileManager.default.fileExists(atPath: videoDirectory) {
            try? FileManager.default.createDirectory(atPath: videoDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    
}

