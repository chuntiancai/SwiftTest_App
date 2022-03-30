//
//  JFZAudiovisualCommonEnum.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/14.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 播放器的相关枚举信息，网络状态枚举，播放状态枚举

import Foundation
//import Reachability
import UIKit


///网络状态
var JFZNetReach: Reachability = {
    let reach = Reachability.forInternetConnection()!
    
    // Set the blocks
    reach.reachableBlock = {
        (reach: Reachability?) -> Void in
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        DispatchQueue.main.async {
            print("REACHABLE!")
            
        }
    }
    
    reach.unreachableBlock = {
        (reach: Reachability?) -> Void in
        print("UNREACHABLE!")
    }
    
    reach.startNotifier()
    return reach
}()

enum JFZAudiovisualStatus {
    
    /// 准备
    case prepare
    /// 正在播放
    case playing
    /// 暂停
    case pause
    /// 释放播放器（销毁时使用）
    case stop
    
    /// 控制面板播放按钮图标
    var controlPlayImg: UIImage? {
        switch self {
        case .playing:
            return UIImage(named: "hy_video_ic_pause", in: JFZ_PLAYER_SOURCE_BUNDLE, compatibleWith: nil)
        case .pause:
            return UIImage(named: "hy_video_ic_play", in: JFZ_PLAYER_SOURCE_BUNDLE, compatibleWith: nil)
        default:
            return nil
        }
    }
}

