//
//  JFZPlayerCacheStorage.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/14.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 缓存空间管理器

import Foundation

/// 存储空间
struct JFZPlayerCacheStorage {
    
    private static var dict: [FileAttributeKey : Any] {
        
        let path = NSHomeDirectory()
        
        do {
            let dict = try FileManager.default.attributesOfFileSystem(forPath: path)
            return dict
        } catch let error {
            print(error.localizedDescription)
            return [:]
        }
    }
    
    /// 总容量
    static var capacity: Float? {
        return (dict[FileAttributeKey.systemSize] as? NSNumber)?.floatValue ?? 0
    }
    
    /// 可用容量
    static var available: Float {
        return (dict[FileAttributeKey.systemFreeSize] as? NSNumber)?.floatValue ?? 0
    }
    
}

