//
//  NordicCommon.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/2/3.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// Nordic 测试demo的公共资源管理类,这里设计的都是全局唯一的实例对象

import Foundation
import CoreBluetooth

/// 这里设计的都是全局唯一的实例对象
class NordicCommon: NSObject {
    
    //MARK: UI相关
    ///打印交互命令的log view
    static let sharedLogView: CHLogView = CHLogView()
    
    //MARK: 蓝牙相关
    /// 蓝牙管理类单例
    static let bleManager: NordicBleManager = NordicBleManager.shared
    /// 蓝牙中心设备
    static let centralManager: CBCentralManager = NordicBleManager.shared.innerCentralManager
    
}
