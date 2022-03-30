//
//  PeripheralModel.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/1/20.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//  包含peripheral、rssi、advertisementData的外设的封装model

import CoreBluetooth

struct PeripheralModel {
    
    var peripheral:CBPeripheral //外设
    var advertisementData: [String : Any]?   //广播的字典
    var firstRSSI:NSNumber?   //信号值，初始化时一般是第一次扫描到的信号值
    
    init(peripheral:CBPeripheral,advertisementData: [String : Any]? = nil,rssi:NSNumber? = nil) {
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.firstRSSI = rssi
    }
}
