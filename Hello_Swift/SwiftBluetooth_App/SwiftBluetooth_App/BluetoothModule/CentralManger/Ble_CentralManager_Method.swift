//
//  BleManager_CentralManager.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/1/20.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 蓝牙中央设备管理类的相关方法

import Foundation
import CoreBluetooth

//MARK: - 中央管理类相关的自定义的工具方法，中央
extension BleManager{
    
    
    //MARK: 扫描外设
    /// 扫描到的外设会存进scanPeerModelArr数组当中
    /// - Parameters:
    ///   - peripheralID: 为你的外设设置ID，用于维护多外设管理
    ///   - withServices: 传入的CBUUID数组，nil则全部扫描
    ///   - options: 扫描的选项,为nil时这里设置默认同一个广播的服务为一次广播
    ///   - scanTime: 持续扫描的时间
    public func scanPeripherals(withServices: [CBUUID]? = nil, options: [String : Any]?=nil,_ scanTime: TimeInterval? = nil){
        /**
         设计1：
            设计一个全局的peripheralID，只能通过get，set方法访问，表征当前客户自定义的外设id。用于搜索到外设后存进去外设的字典中，搜不到外设则该id无效。
            所以要在get，set方法中维护好。
         */
        BleManager.shared.scanPeerModelArr.removeAll()  //先移除暂存的外设数组
        BleManager.shared.curCentralManger?.delegate = self  //绑定自身为被委托者
        ///检索手机本地连着的外设，添加到扫描的数组中
        outerSer: if withServices != nil {
            let retrPeriArr = BleManager.shared.curCentralManger?.retrieveConnectedPeripherals(withServices: withServices!)
            if retrPeriArr == nil { break outerSer} //跳出if代码块
            for curPeri in retrPeriArr! {
                let curPeriModel = PeripheralModel(peripheral: curPeri, advertisementData: nil, rssi: nil)
                self.scanPeerModelArr.append(curPeriModel)
            }
        }
        if options != nil {
            BleManager.shared.curCentralManger?.scanForPeripherals(withServices: withServices, options: options) //开始扫描
        }else {
            ///CBCentralManagerScanOptionAllowDuplicatesKey，是否允许持续扫描同一个广播，是则一个广播多次发射都扫描得到，否则即便广播发射多次也只当作一次处理
            let scanOptions: [String : Any] =  [CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber.init(booleanLiteral: true)]
            BleManager.shared.curCentralManger?.scanForPeripherals(withServices: withServices, options: scanOptions) //开始扫描
            
        }
        
        
        if scanTime != nil {     //设置到达定时后，停止扫描
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + scanTime!) {
                self.stopScan()
            }
        }
        
    }
    
    //MARK: 停止扫描外设
    public func stopScan(){
        BleManager.shared.curCentralManger?.stopScan()
    }
    
    //MARK: 连接外设
    /// - Parameters:
    ///   - peripheralID: 需要你命名的外设的ID
    ///   - peripheral: 需要去连接的外设
    ///   - options: 连接选项
    public func connect(peripheralID:String,_ peripheral: CBPeripheral, options: [String : Any]? = nil){
        //FIXME: 没有处理外设漏掉存进字典的情况
        self.toConnectPeripheralID = peripheralID  //设置需要去连接的设备的id，作为中央和外设的字典的key，两头的映射值，要很关键地维护好
        peripheral.delegate = self  //绑定外设的代理
        var tempPeri:CBPeripheral?
        var tempCentralM: CBCentralManager?
        var keyStr:String?  //存储外设对象的字典的key
        var periFlagModel:PeripheralModel?  //外设对象的model，用于存储进外设的model数组中，主要是为了存广播数据
        for curModel in scanPeerModelArr {  //从扫描数组中找到缓存的外设
            if curModel.peripheral == peripheral {
                print(" @@从扫描的数组中找到外设对象")
                periFlagModel = curModel
                break
            }
        }
        
        for (key,periM) in peripheralModelDict{     //从已经缓存的外设对象的字典中找外设
            if periM.peripheral == peripheral {
                print("@@ 从已经缓存的外设对象的字典中找外设")
                print(" @@ 当前的通信的外设是\(key)")
                keyStr = key
                tempPeri = peripheral
                break
            }
        }
        outer1: if keyStr != nil {  //从字典中找到缓存的外设对象，没有的话，则新建一个CBCentralManager和CBPeripheral的映射并存进数组
            tempCentralM = centrelDict[keyStr!]
            if tempCentralM != nil {
                print("  @@字典中找到中央设备的缓存")
                tempCentralM?.connect(tempPeri!, options: options)
                break outer1
            }else{  //找不到中央设备
                print(" @@字典中找到外设的缓存，但是找不到中央设备的缓存")
                let tCentralM = CBCentralManager.init(delegate: self, queue: nil,
                                                      options: [CBCentralManagerOptionShowPowerAlertKey:NSNumber.init(value: true),
                                                                CBCentralManagerOptionRestoreIdentifierKey:NSString.init(string: toConnectPeripheralID!)])
                centrelDict[keyStr!] = tCentralM
                centrelDict[keyStr!]?.delegate = self
                centrelDict[keyStr!]?.connect(peripheral, options: options)
            }
        }else{  //没有从字典中找到缓存的外设对象
            print(" @@没有从字典中找到缓存的外设对象")
            peripheral.delegate = self
            var curPeriModel:PeripheralModel!
            if periFlagModel != nil {
                curPeriModel = periFlagModel!
            }else{
                curPeriModel = PeripheralModel(peripheral: peripheral)
            }
            
            peripheralModelDict[peripheralID] = curPeriModel    //存进外设的字典中
            let tCentralM = CBCentralManager.init(delegate: self, queue: nil,
                                                  options: [CBCentralManagerOptionShowPowerAlertKey:NSNumber.init(value: true),
                                                            CBCentralManagerOptionRestoreIdentifierKey:NSString.init(string: toConnectPeripheralID!)])
            centrelDict[peripheralID] = tCentralM   //存进中央设备的字典中
            centrelDict[peripheralID]?.delegate = self
            centrelDict[peripheralID]?.connect(peripheral, options: options)
            
        }
        
    }
    
    //MARK: 取消连接指定的外设
    /// 取消连接指定的外设,只是取消当前App连接的外设，并不影响其他App的连接状态，但是都会调用当前App设置的代理方法
    /// - Parameter peripheralID: 被取消连接的外设,一开始你定义的ID
    /// - Returns: 是否找到相应的外设以及中央设备
    public func cancelConnect(peripheralID: String) -> Bool{
        let curCentral = centrelDict[peripheralID]
        if curCentral != nil{
            let curPeriM = peripheralModelDict[peripheralID]
            if curPeriM != nil {
                curCentral!.cancelPeripheralConnection(curPeriM!.peripheral)
                //FIXME: 没有考虑断连失败的情况
                peripheralModelDict.removeValue(forKey: peripheralID)   //移除保存的外设
                return true
            }else{
                print("@@ 没有找到外设")
                return false
            }
            
        }else {
            print("@@ 没有找到中央设备")
            return false
        }
        
    }
    
}





//MARK: - 遵循CBCentralManager委托协议,管理中央设备角色，CBCentralManagerDelegate协议
extension BleManager: CBCentralManagerDelegate {
    
    //MARK: 中央设备状态发生变化的回调
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("     （@@中央设备状态发生变化 centralManagerDidUpdateState：\(central)")
        for (key,centralM) in centrelDict{
            if centralM == central {
                print(" @@ 当前的通信的中央设备是\(key)")
            }
        }
    }
    
    
    //MARK: 搜索到外设，每搜索到一台就调用一次该方法
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("     （@@中央设备搜索到外设，didDiscover peripheral：\(peripheral)")
        for (key,centralM) in centrelDict{
            if centralM == central {
                print(" @@ 当前的通信的中央设备是\(key)")
            }
        }
        let periModel = PeripheralModel(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI)
        
        if storeScanPeriModelCondition != nil { //缓存外设的条件，过滤条件
            let storeFlag = storeScanPeriModelCondition!(peripheral, advertisementData, RSSI)
            if storeFlag == false {
                print("     (@@ 预设缓存外设条件不成立")
                return
            }else {
                print("     (@@ 预设缓存外设条件成立!!!!")
            }
        }
        self.scanPeerModelArr.append(periModel)
        
    }
    
    
    //MARK: 与外设建立连接的回调
    /// 在这里去新建外设的对象
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        self.curPeripheral = peripheral
        print("     （@@中央设备建立连接，didConnect peripheral：\(peripheral)")
        for (key,centralM) in centrelDict{
            if centralM == central {
                print(" @@ 当前的通信的中央设备是\(key)")
            }
        }
        peripheral.delegate = self  //设置外设的代理为单例
        var curPeri: CBPeripheral?
        for curP_Model in peripheralModelDict.values {//从已经缓存的外设的字典中拿值出来
            let curP = curP_Model.peripheral
            if peripheral.identifier == curP.identifier {
                curPeri = peripheral
                print(" (@@ 从已经缓存的外设的字典中拿外设出来")
                break
            }
        }
        
        if curPeri == nil { //第一次存储外设的到缓存的字典里面去
            print("     (@@ 第一次存储外设 到 缓存外设的字典里面去")
            var periModel = PeripheralModel(peripheral: peripheral, advertisementData: nil, rssi: nil)
            for curP_Model in scanPeerModelArr {
                let curP = curP_Model.peripheral
                if peripheral.identifier == curP.identifier {   //identifier是当前app唯一识别该外设的id，无论外设
                    print("    (@@ 在扫描的数组中找到PeripheralModel")
                    periModel = curP_Model
                    break
                }
            }
            peripheralModelDict[toConnectPeripheralID!] = periModel
        }
        
        
    }
    
    //MARK: App从后台恢复时，调用该方法告知恢复蓝牙中心设备
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("     （@@中央设备App从后台恢复，willRestoreState ：\(dict)")
        for (key,centralM) in centrelDict{
            if centralM == central {
                print(" @@ 当前的通信的中央设备是\(key)")
            }
        }
    }
    
    //MARK: 连接外设失败
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("     （@@中央设备连接外设失败，didFailToConnect ：\(peripheral)")
        for (key,centralM) in centrelDict{
            if centralM == central {
                print(" @@ 当前的通信的中央设备是\(key)")
            }
        }
    }
    
    
    //MARK: 与外设失去连接
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("     （@@中央设备与外设失去连接，didDisconnectPeripheral ：\(peripheral)")
        for (key,centralM) in centrelDict{
            if centralM == central {
                print(" @@ 当前的通信的中央设备是\(key)")
            }
        }
    }
    
    //MARK:已连接的外设的ANCS的授权状态已更改
    ///已连接的外设的ANCS的授权状态已更改
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
        for (key,centralM) in centrelDict{
            if centralM == central {
                print(" @@ 当前的通信的中央设备是\(key)")
            }
        }
    }
    
    //MARK:发现在centralManager对象中注册过的连接事件
    /// 发现在centralManager对象中注册过的连接事件
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        for (key,centralM) in centrelDict{
            if centralM == central {
                print(" @@ 当前的通信的中央设备是\(key)")
            }
        }
    }
    
}
