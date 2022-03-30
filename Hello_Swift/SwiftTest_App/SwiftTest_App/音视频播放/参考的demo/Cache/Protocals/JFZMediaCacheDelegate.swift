//
//  JFZMediaCacheDelegate.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/14.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 播放“缓存”的代理协议，缓存过程的告知代理方法

import Foundation

protocol JFZMediaCacheDelegate: AnyObject {
    
    /// 缓存进度更新
    func cache(_ cache: JFZMediaCacheManager, progress: Float)
    
    /// 缓存开始
    func cacheDidStarted(_ cache: JFZMediaCacheManager)
    
    /// 缓存完成
    func cacheDidFinished(_ cache: JFZMediaCacheManager)
    
    /// 缓存失败
    func cacheDidFailed(_ cache: JFZMediaCacheManager, withError error: Error?)
}

