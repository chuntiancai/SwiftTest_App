//
//  JFZMediaCryptor.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/14.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 对视频进行加密解密，前999个byte取反

import Foundation


public struct JFZMediaCryptor {
    
    /// 加密视频，并创建副本
    public static func endecryptFile(from srcURL: URL, to dstURL: URL) -> Bool {
        
        guard FileManager.default.fileExists(atPath: srcURL.path) else {
            print("视频文件不存在，无法创建加密/解密视频")
            return false
        }
        
        do {
            try? FileManager.default.removeItem(at: dstURL)
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
            try endecryptFile(at: dstURL)
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    /// 直接对文件加密或解密
    public static func endecryptFile(at url: URL) throws {
        do {
            let fileHandle = try FileHandle(forUpdating: url)
            
            let length = fileHandle.seekToEndOfFile()
            let through = min(Int(length), 999)
            
            fileHandle.seek(toFileOffset: 0)
            var data = fileHandle.readData(ofLength: through)
            
            for i in stride(from: 29, through: 999, by: 31) {
                if data.count > i {
                    let eBytes = ~data[i]
                    data[i] = eBytes
                }
            }
            
            fileHandle.seek(toFileOffset: 0)
            fileHandle.write(data)
            fileHandle.closeFile()
            
        } catch let error {
            throw error
        }
        
    }
}

