//
//  LayoutConstants.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/1/19.
//  Copyright © 2021 com.mathew. All rights reserved.
//

import Foundation
import UIKit


// screen width
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

// screen height
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

// NAVIGATION_BAR_HEIGHT，导航栏高度，包含状态栏
let NAVIGATION_BAR_HEIGHT: CGFloat = isIphoneXSeries ? 88 : 64

struct ScreenSizeConstant {
    // screen width
    static let screenWidth = UIScreen.main.bounds.width
    // screen height
    static let screenHeight = UIScreen.main.bounds.height
    static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
}

struct InchConstant {
    // NAVIGATION_BAR_HEIGHT，包含状态栏
    static let NAVIGATION_BAR_HEIGHT: CGFloat = isIphoneXSeries ? 88 : 64
    
    // tabBarHeight
    static let tabBarHeight: CGFloat = isIphoneXSeries ? 49 + 34 : 49
    
    //statusBar_Height
    static let statusBarHeight: CGFloat = isIphoneXSeries ? 44 : 20
    
    //tabBarHeight
    static let upBarHeight: CGFloat = isIphoneXSeries ? 34 : 0
}

struct IphoneModel {
    // iPhone 5
    static let isIphone5 = ScreenSizeConstant.screenHeight == 568 ? true : false
    // iPhone 6
    static let isIphone6 = ScreenSizeConstant.screenHeight == 667 ? true : false
    // iphone 6P
    static let isIphone6P = ScreenSizeConstant.screenHeight == 736 ? true : false
}

//是否是IphoneX系列机型
var isIphoneXSeries: Bool {
    
    var iPhoneXSeries = false
    let window = UIApplication.shared.keyWindow ?? UIWindow()
    if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
        return iPhoneXSeries
    }
    
    if #available(iOS 11.0, *) {
        if window.safeAreaInsets.bottom > CGFloat(0) {
            iPhoneXSeries = true
            
        }
    }
    return iPhoneXSeries
    
}

var windowInsets: UIEdgeInsets {
    
    if #available(iOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    }
    return UIEdgeInsets.zero
       
}
