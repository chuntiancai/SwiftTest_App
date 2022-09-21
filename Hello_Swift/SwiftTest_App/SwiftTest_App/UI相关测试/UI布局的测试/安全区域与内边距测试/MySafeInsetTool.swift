//
//  MySafeInsetTool.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/9/21.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 获取安全区域相关信息的工具方法

class MySafeInsetTool{
    
    //TODO: 顶部安全区高度
    static func safeDistanceTop() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.top
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.top
        }
        return 0;
    }
    
    //TODO: 底部安全区高度
    static func safeDistanceBottom() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0;
    }
    
    //TODO: 顶部状态栏高度（包括安全区）
    static func statusBarSafeHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    //TODO: 导航栏高度,44
    static func navigationBarHeight() -> CGFloat {
        return 44.0
    }
    
    //TODO: 状态栏+导航栏的高度
    static func navigationFullHeight() -> CGFloat {
        return statusBarSafeHeight() + navigationBarHeight()
    }
    
    //TODO: 底部导航栏高度,49
    static func tabBarHeight() -> CGFloat {
        return 49.0
    }
    
    //TODO: 底部导航栏高度（包括安全区）
    static func tabBarFullHeight() -> CGFloat {
        return tabBarHeight() + safeDistanceBottom()
    }
    
}
