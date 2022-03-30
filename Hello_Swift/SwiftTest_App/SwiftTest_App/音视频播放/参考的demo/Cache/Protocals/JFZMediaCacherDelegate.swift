//
//  JFZMediaCacherDelegate.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/14.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//播放“缓存器”的代理协议，其实这是第二层缓存代理通知，第一层是JFZMediaCacheManager管理者通知代理者，第二层是缓存器JFZMediaCacher通知代理者


import Foundation

public protocol JFZMediaCacherDelegate: AnyObject {
    
    /// 缓存进度更新
    func cacher<LocationType>(_ cacher: JFZMediaCacher<LocationType>, cacheProgress progress: Float, of cache: JFZMediaCacheManager)
    
    /// 缓存开始
    func cacher<LocationType>(_ cacher: JFZMediaCacher<LocationType>, didStartCacheOf cache: JFZMediaCacheManager)
    
    /// 缓存完成
    func cacher<LocationType>(_ cacher: JFZMediaCacher<LocationType>, didFinishCacheOf cache: JFZMediaCacheManager)
    
    /// 缓存失败
    func cacher<LocationType>(_ cacher: JFZMediaCacher<LocationType>, didFailToCache cache: JFZMediaCacheManager)
}
