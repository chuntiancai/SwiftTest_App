//
//  TestScreenRotateView.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/28.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试屏幕旋转的View

import UIKit

class TestScreenRotateView: UIView {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    var deviceOrientationObserver: NSKeyValueObservation?

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        observeDeviceOreintation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("TestScreenRotateView 销毁方法")
        //关闭监听设备方向
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
}

//MARK: - 逻辑方法
extension TestScreenRotateView{
    /// 开启监听设备方向
    private func observeDeviceOreintation(){
        print("开启监听设备的方向")
        //感知设备方向 - 开启监听设备方向，无论是否在AppDelegate中禁用了旋转，都会发出该通知
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        //添加通知，监听设备方向改变
        NotificationCenter.default.addObserver(self, selector: #selector(self.observeOrientationAction),
                                                 name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
}

//MARK: - 动作方法
@objc extension TestScreenRotateView{
    /// 监听到设备方向的变化
    private func observeOrientationAction(){
        let device = UIDevice.current
        switch device.orientation{
        case .portrait:
            print( "TestScreenRotateView .portrait，垂直，设备顶部在上")
        case .portraitUpsideDown:
            print( "TestScreenRotateView 面向设备保持垂直，设备顶部在下")
        case .landscapeLeft:
            print( "TestScreenRotateView 面向设备保持水平，设备顶部在左侧")
        case .landscapeRight:
            print( "TestScreenRotateView 面向设备保持水平，设备顶部在右侧")
        case .faceUp:
            print( "TestScreenRotateView 设备平放，设备顶部在上")
        case .faceDown:
            print( "TestScreenRotateView 设备平放，设备顶部在下")
        case .unknown:
            print( "TestScreenRotateView 方向未知")
        default:
            print( "TestScreenRotateView default")
        }
    }
}

//MARK: -
extension TestScreenRotateView{
    
}

//MARK: -
extension TestScreenRotateView{
    
}

