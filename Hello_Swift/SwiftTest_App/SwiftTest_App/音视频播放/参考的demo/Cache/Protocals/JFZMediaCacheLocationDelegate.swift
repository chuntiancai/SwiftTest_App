//
//  JFZMediaCacheLocationDelegate.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/14.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 缓存路径的代理协议

import Foundation

public protocol JFZMediaCacheLocationDelegate {
    
    var identifier: String { get }
    
    //远程URL。一般远程URL需要鉴权才能播放。如果远程URL可以直接播放，authenticatedURL和originalURL可以一样。
    var authenticatedURL: URL { get }
    var originalURL: URL { get }
    
    //本地URL。一般本地文件储存时需要加密，播放时再解密。如果本地文件不需要加密，storageURL和playURL可以一样。
    //扩展名必须为HCMediaCache.preferredLocalPathExtension方法返回的值，否则文件将无法缓存或播放。
    var storageURL: URL { get }
    var playURL: URL { get }
    
    var mediaType: JFZMediaType { get }
    
    /// 缓存列表存放路径
    static var cacheListPath: String { get }
    
    init(remoteURL: URL, mediaType: JFZMediaType)
}
