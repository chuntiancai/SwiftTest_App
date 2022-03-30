//
//  NordicBleManager.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/2/3.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 管理nordic的蓝牙单例

import Foundation
import CoreBluetooth

class NordicBleManager: NSObject {
    
    //MARK: 实例对象
    static let shared: NordicBleManager = NordicBleManager()    //管理单例
    let innerCentralManager:CBCentralManager = CBCentralManager.init(
                                            delegate: nil, queue: nil,
                                            options: [CBCentralManagerOptionShowPowerAlertKey:NSNumber.init(value: true)])
    //MARK: 对外提供的属性
    /// 中央设备
    public var centralManager: CBCentralManager {
        get{
            if innerCentralManager.delegate !== self {  //如果当前的中央对象的代理不是实例对象，则绑定
               innerCentralManager.delegate = self
            }
            return innerCentralManager
        }
    }
    
    /// 当前连接的外设
    public var curPeriphral:CBPeripheral?{
        didSet{
            if oldValue != nil {
                oldValue!.delegate = nil    //移除旧外设的代理
                connectedPeriphralSet.insert(oldValue!) //将以前连接过的外设插入到set集合中
//                centralManager.cancelPeripheralConnection(oldValue!) //取消原来的连接
            }
            curPeriphral?.delegate = self   //绑定新外设的代理为自己
           
        }
    }
    private var connectedPeriphralSet = Set<CBPeripheral>()    //暂存连接过的外设的集合
    
    private override init() {
        super.init()
        centralManager.delegate = self  //设置自己为监听蓝牙的委托者
    }
}



//MARK: - 遵循CBCentralManager委托协议，CBCentralManagerDelegate协议,中央设备角色
extension NordicBleManager: CBCentralManagerDelegate {
    
    //MARK: 中央设备状态发生变化的回调
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("     （@@中央设备状态发生变化 centralManagerDidUpdateState：\(central) --- state: \(central.state.rawValue)")
    }
    
    
    //MARK: 搜索到外设，每搜索到一台就调用一次该方法
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("     （@@中央设备搜索到外设，didDiscover peripheral：\(peripheral)")
        
    }
    
    
    //MARK: 与外设建立连接的回调
    /// 在这里去新建外设的对象
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("     （@@中央设备建立连接，didConnect peripheral：\(peripheral)")
        peripheral.delegate = self  //设置代理对象为自己
    }
    
    //MARK: App从后台恢复时，调用该方法告知恢复蓝牙中心设备
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("     （@@中央设备App从后台恢复，willRestoreState ：\(dict)")
    }
    
    //MARK: 连接外设失败
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("     （@@中央设备连接外设失败，didFailToConnect ：\(peripheral)")
    }
    
    
    //MARK: 与外设失去连接
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("     （@@中央设备与外设失去连接，didDisconnectPeripheral ：\(peripheral)")
    }
    
    //MARK:已连接的外设的ANCS的授权状态已更改
    ///已连接的外设的ANCS的授权状态已更改
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
         print("     （@@已连接的外设的ANCS的授权状态已更改，peripheral：\(peripheral)")
    }
    
    //MARK:发现在centralManager对象中注册过的连接事件
    /// 发现在centralManager对象中注册过的连接事件
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        print("     （@@发现在centralManager对象中注册过的连接事件，peripheral：\(peripheral)")
    }
    
    
}




//MARK: - 遵循CBPeripheral委托协议，CBPeripheralDelegate协议，外设角色
extension NordicBleManager: CBPeripheralDelegate{
    
    //MARK: 发现服务的回调，连接上外设就会回调该方法
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("     （@@ 外围设备发现服务，\(peripheral) \n --- didDiscoverServices ：\(String(describing: peripheral.services))")
    }

    
    //MARK: 发现服务的特征的回调
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("     （@@ 外围设备发现服务下的特征，didDiscoverCharacteristicsFor service：\(service)")
        
    }
      
      
    //MARK: 外设的服务 的特征 接收到数据的回调方法 , 外设更新值的回调
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("     （@@ 外围设备接收数据，didUpdateValueFor characteristic：\(characteristic)")
    }
    
    
    //MARK: 向外设发送数据后的回调
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("     （@@ 外围设备发送数据，didWriteValueFor characteristic：\(characteristic)")
    }
    
    //MARK: 发送不需要外设回复的数据时的回调
    ///数据已经发送出去
    public func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        print("     （@@ 外围设备发送不用回复的数据，toSendWriteWithoutResponse peripheral：\(peripheral)")
    }
    
    //MARK: 读取到的 RSSI 值，信号值
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print("     （@@ 外设回调RSSI值，\(peripheral)---didReadRSSI RSSI：\(RSSI)")
    }
}
