//
//  JFZPlayerConstant.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/13.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 全局常量的配置

import Foundation
import UIKit

/// 资源文件
let JFZ_PLAYER_SOURCE_BUNDLE = Bundle.init(path: Bundle.main.path(forResource: "JFZPlayer", ofType: "bundle")! + "/Icons")

/// 屏幕宽度
let JFZ_SCREEN_WIDTH = UIScreen.main.bounds.size.width

/// 屏幕高度
let JFZ_SCREEN_HEIGHT = UIScreen.main.bounds.size.height

/// 是否为X系列手机
var JFZ_IS_IPHONEX: Bool {
    guard #available(iOS 11.0, *) else {
        return false
    }
    
    return UIApplication.shared.windows[0].safeAreaInsets.bottom > 30
}
