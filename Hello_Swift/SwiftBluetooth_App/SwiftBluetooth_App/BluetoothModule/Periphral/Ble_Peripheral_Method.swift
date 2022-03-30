//
//  Ble_Peripheral.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/1/20.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 外设类的相关方法

import Foundation
import CoreBluetooth

//MARK: - 外设管理类相关的自定义的工具方法，外设
extension BleManager{
    
}


//MARK: - 遵循CBPeripheral委托协议，CBPeripheralDelegate协议，外设角色
extension BleManager: CBPeripheralDelegate{
    
    //MARK: 发现服务的回调，连接上外设就会回调该方法
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("     （@@ 外围设备发现服务，didDiscoverServices ：\(peripheral)")
        for (key,periM) in peripheralModelDict{
            if periM.peripheral == peripheral {
                print(" @@ 当前的通信的外设是\(key)")
            }
        }
    }

    
    //MARK: 发现服务的特征的回调
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("     （@@ 外围设备发现服务下的特征，didDiscoverCharacteristicsFor service：\(service)")
        for (key,periM) in peripheralModelDict{
            if periM.peripheral == peripheral {
                print(" @@ 当前的通信的外设是\(key)")
            }
        }
        
    }
      
      
    //MARK: 外设的服务 的特征 接收到数据的回调方法 , 外设更新值的回调
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("     （@@ 外围设备接收数据，didUpdateValueFor characteristic：\(characteristic)")
        for (key,periM) in peripheralModelDict{
            if periM.peripheral == peripheral {
                print(" @@ 当前的通信的外设是\(key)")
            }
        }
    }
    
    
    //MARK: 向外设发送数据后的回调
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("     （@@ 外围设备发送数据，didWriteValueFor characteristic：\(characteristic)")
        for (key,periM) in peripheralModelDict{
            if periM.peripheral == peripheral {
                print(" @@ 当前的通信的外设是\(key)")
            }
        }
    }
    
    //MARK: 发送不需要外设回复的数据时的回调
    ///数据已经发送出去
    public func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        print("     （@@ 外围设备发送不用回复的数据，toSendWriteWithoutResponse peripheral：\(peripheral)")
        for (key,periM) in peripheralModelDict{
            if periM.peripheral == peripheral {
                print(" @@ 当前的通信的外设是\(key)")
            }
        }
    }
    
}
