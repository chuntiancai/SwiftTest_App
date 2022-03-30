//
//  JFZMediaCacher.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/14.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 续播视频的缓存器，这了管理了多个视频源的缓存，而JFZMediaCacheManager则是管理具体一个视频源的缓存

import Foundation
import UIKit

///c：这个语法是，声明了一个范型，遵循JFZMediaCacheLocationDelegate协议，在类的定义里面，可以使用Location这个类型。
public class JFZMediaCacher<Location: JFZMediaCacheLocationDelegate> {
    
    /// 缓存记录文件路径
    private let cacheListPath: String
    
    /// 缓存记录，记录的是缓存视频的identifier
    public private(set) var cacheList: [String] {
        
        get {
            
            if let array = (NSArray(contentsOfFile: cacheListPath) as? [String]) {
                return Array(Set(array))
            } else {
                return []
            }
        }
        
        set {
            
            let array = Array(Set(newValue))
            (array as NSArray).write(toFile: cacheListPath, atomically: true)
        }
    }
    
    /// 正在进行的缓存
    public private(set) var currentCache: JFZMediaCacheManager?
    
    /// 暂停的缓存，未完成的缓存
    private var suspendedCaches: Set<JFZMediaCacheManager> = []
    
    public weak var delegate: JFZMediaCacherDelegate?   //缓存器的代理者，通知代理者缓存进度
    
    public init() {
        
        self.cacheListPath = Location.cacheListPath //这是一个类属性
//        print("Location:~~~:",Location.self)
//        print("Location.cacheListPath:~~~:",Location.cacheListPath)
        if !FileManager.default.fileExists(atPath: cacheListPath),
            !FileManager.default.createFile(atPath: cacheListPath, contents: nil, attributes: nil)
        {
            print("缓存列表文件创建失败")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopAllCaches), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    deinit {
        
        print("HYVideoCacher deinit")
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
    }
    
    /// 创建缓存，从已经存储的缓存里面拿缓存，如果没有，则创建缓存保存在currentCache 的属性中。还有一个是暂停缓存，是一个集合suspendedCaches
    ///
    /// - Parameters:
    ///   - location: 视频地址
    ///   - cacheImmediately: 是否马上开始
    /// - Returns: 如果缓存已完成，缓存的asset指向本地文件；如果视频未缓存，缓存的asset指向远程文件。
    public func makeCache(location: Location, cacheImmediately: Bool = false) -> JFZMediaCacheManager? {
        
        if let cache = self.currentCache {
            
            if cache.identifier == location.identifier {
                
                return currentCache
//                //不创建，直接返回当前缓存
//                if cacheImmediately {
//                    _ = cache.start()
//                } else {
//                    _ = cache.suspend()
//                }
//
//                return cache
            } else {
                //记录未缓存完成的视频
                suspendCache(cache)
            }
        }
        
        //创建新视频
        let cache: JFZMediaCacheManager
        ///根据identifier找出暂停的缓存视频，suspendedCaches是暂停播放的缓存视频
        let caches = suspendedCaches.filter { $0.identifier == location.identifier }
        
        if  let first = caches.first, let suspendingCache = suspendedCaches.remove(first) {
            
            //从暂停列表中取出需要缓存的视频
            cache = suspendingCache
        } else {
            
            //创建一个新视频的缓存
            cache = JFZMediaCacheManager(cacheLocation: location, cacheListPath: cacheListPath, delegate: self)
        }
        
        if cacheImmediately {
            _ = cache.start()
        }
        self.currentCache = cache
        
        return cache
    }
    
    /// 判断音视频是否已经缓存
    public func isUrlCached(url: String) -> Bool {
        if cacheList.contains(url.JFZmd5) {
            return true
        }
        return false
    }
    
    /// 开始视频缓存
    public func startCache(_ cache: JFZMediaCacheManager) {
        
        //TODO: 根据start()的结果作出相应提示和处理
        _ = cache.start()
        suspendedCaches.remove(cache)
    }
    
    /// 暂停视频缓存
    public func suspendCache(_ cache: JFZMediaCacheManager) {
        
        if cache.suspend() {
            suspendedCaches.insert(cache)
        }
    }
    
    /// 停止视频缓存，并清除临时数据
    public func stopCache(_ cache: JFZMediaCacheManager) {
        
        //TODO: 根据stop()的结果作出相应提示和处理
        _ = cache.stop()
        suspendedCaches.remove(cache)
    }
    
    /// 停止所有缓存，并清除临时数据
    @objc private func stopAllCaches() {
        
        for cache in suspendedCaches {
            stopCache(cache)
        }
    }
    
    /// 删除视频缓存（未启用）
    private func removeCache(_ cache: JFZMediaCacheManager) {
        
        //删除加密文件
        cache.deleteEncryptedFile()
        //删除未加密文件
        cache.deleteDecryptedFile()
        //删除缓存标记
        cacheList = cacheList.filter { $0 != cache.identifier }
    }
}

//MARK: - 直接对磁盘文件进行操作的方法
extension JFZMediaCacher {
    
    /// 删除视频缓存
    public func removeCache(located location: Location) {
        
        let cache = JFZMediaCacheManager(cacheLocation: location, cacheListPath: cacheListPath, delegate: self)
        removeCache(cache)
    }
}

//MARK: - 遵循缓存协议，接受外部调用JFZMediaCacheDelegate
extension JFZMediaCacher: JFZMediaCacheDelegate {
    
    /// 缓存进度更新
    func cache(_ cache: JFZMediaCacheManager, progress: Float) {
        print("JFZMediaCacher缓存器，缓存进度更新 Cacher～～：\(progress)")
        delegate?.cacher(self, cacheProgress: progress, of: cache)
    }
    
    /// 缓存开始
    func cacheDidStarted(_ cache: JFZMediaCacheManager) {
        print("JFZMediaCacher缓存器，~~缓存开始 Cacher～～")
        delegate?.cacher(self, didStartCacheOf: cache)
    }
    
    /// 缓存完成
    func cacheDidFinished(_ cache: JFZMediaCacheManager) {
        cacheList.append(cache.identifier)
        print("JFZMediaCacher缓存器，done 缓存完成 Cacher～～")
        delegate?.cacher(self, didFinishCacheOf: cache)
    }
    
    /// 缓存失败
    func cacheDidFailed(_ cache: JFZMediaCacheManager, withError error: Error?) {
        print("JFZMediaCacher缓存器，缓存失败 Cacher～～ failed")
        delegate?.cacher(self, didFailToCache: cache)
    }
}
