//
//  JFZPlayerCommonViewDelegate.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/13.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 播放页面的代理协议，给遵循者回调一些播放行为

import Foundation

protocol JFZPlayerCommonViewDelegate: NSObjectProtocol {
    
    /** 全屏状态改变*/
    func changeFullScreen(isFull: Bool)
    
    /** 全屏锁定*/
    func fullScreenLock(isLock: Bool)
    
    /** 展示控制台*/
    func showControlPanel()
    
    /** 隐藏控制台*/
    func hideControlPanel()
    
    /** 流量提醒*/
    func flowRemind()
    
    /** 流量模式下播放缓存视频*/
    func playingCachedVideo()
    
    /** 开始播放*/
    func startPlayer()
    
    /** 播放暂停*/
    func pausePlayer()
    
    /** 结束播放*/
    func stopPlayer()
    
    /** 缓存开始*/
    func startCache()
    
    /** 缓存进行中*/
    func inCaching(progress: Float)
    
    /** 缓存完成*/
    func completeCache()
    
    /** 缓存失败*/
    func faildCache()
    
}

extension JFZPlayerCommonViewDelegate {
    func changeFullScreen(isFull: Bool){}
    func fullScreenLock(isLock: Bool){}
    func showControlPanel(){}
    func hideControlPanel(){}
    func flowRemind(){}
    func playingCachedVideo(){}
    func startPlayer(){}
    func pausePlayer(){}
    func stopPlayer(){}
    func startCache(){}
    func inCaching(progress: Float){}
    func completeCache(){}
    func faildCache(){}
}

