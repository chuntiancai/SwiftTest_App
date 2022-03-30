//
//  BleManager.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/1/20.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 蓝牙管理的单例，我现在想做的是管理多个中央和多个外设

import Foundation
import CoreBluetooth

class BleManager: NSObject {
    
    //MARK: 对外属性
    static var shared:BleManager = BleManager()//对外提供的单例
    public var curCentralManger: CBCentralManager? {    //当前连接的中心设备，用get，set方法，目的是为了维护多个中央设备。
        /**
         设计1:
            这里只能通过get方法获取到字典中拥有的CBCentralManager，至于CBCentralManager的存储，就只能通过该方法的单例去扫描，扫描到了就自动存储，扫描不到就没有。
         问题点1:
            第一次调用的状态修改，还没解决，现在就放在appdelegate初始化先
         问题点2:
            我想根据外设的id找到对应的中央
            答：中央在字典中的存放根据外设的id作为key保存，通过外设的key来找到中央设备。
         */
        get{
            if toConnectPeripheralID == nil {
                print(" (@@用户没有设置toConnectPeripheralID，返回临时的中央对象")
                if centrelDict["tempCentral"] != nil { return centrelDict["tempCentral"] }  //返回一个临时的中央设备
                let curM = CBCentralManager.init(delegate: self, queue: nil,
                                                 options: [CBCentralManagerOptionShowPowerAlertKey:NSNumber.init(value: true),
                                                           CBCentralManagerOptionRestoreIdentifierKey:NSString.init(string: "tempCentral")])
                curM.delegate = self
                centrelDict["tempCentral"] = curM
                return centrelDict["tempCentral"]
            }else{
                if centrelDict[toConnectPeripheralID!] != nil {
                    return centrelDict[toConnectPeripheralID!]!
                }else{
                    let curM = CBCentralManager.init(delegate: self, queue: nil,
                                                     options: [CBCentralManagerOptionShowPowerAlertKey:NSNumber.init(value: true),
                                                               CBCentralManagerOptionRestoreIdentifierKey:NSString.init(string: toConnectPeripheralID!)])
                    centrelDict[toConnectPeripheralID!] = curM  //存储中央设备进字典
                    centrelDict[toConnectPeripheralID!]?.delegate = self   //设置中央设备的代理
                    return centrelDict[toConnectPeripheralID!]!
                }
            }
        }
        
    }
//    private var innerCentralManager:CBCentralManager!
    /**
     public var curPeripheral: CBPeripheral?{    //当前连接的外设
         didSet {
             
             curPeripheral?.delegate = self  //绑定当前类为外设的被委托者
             if curPeripheral == nil { return }
             
             if oldValue != nil {    //断开原来设备的连接
                 if oldValue != curPeripheral {
                     self.curCentralManger?.cancelPeripheralConnection(oldValue!)
                     if curPeripheralModel != nil {curPeripheralModel = nil }    //将封装的外设model置nil
                 }else{
                     return
                 }
             }
             
             var tempPeriModel = PeripheralModel(peripheral: curPeripheral!) //设置当前封装的外设model,标志器
             for periModel in self.scanPeerModelArr {
                 if curPeripheral == periModel.peripheral { //如果在缓存数组中能找到,存储为当前封装的外设model
                     tempPeriModel = periModel
                     break
                 }
             }
             curPeripheralModel = tempPeriModel
         }
     }
     public var curPeripheralModel:PeripheralModel?  //当前封装的外设model,标志器
     */
    
    
    
    //MARK: 标志器
    public var toConnectPeripheralID:String?{      //用户自定义的需要去连接的外设ID，相当于给自己的设备起名字
        set{
            /**
             设计1:
                设计一个全局的peripheralID，只能通过get，set方法访问，表征当前用户自定义的外设id。用于搜索到外设后存进去外设的字典中，搜不到外设则该id无效。
                所以要在get，set方法中维护好。
             */
            innerToConnectPeripheralID = newValue
        }
        get{
            if innerToConnectPeripheralID != nil {
                return innerToConnectPeripheralID!
            }else {
               return nil
            }
        }
    }
    private var innerToConnectPeripheralID:String?     //管理类内部的维护的当前去连接外设的ID，用于做标志器
    
    ///缓存 扫描到的外设 的条件 ，过滤条件
    public var storeScanPeriModelCondition:((_ peripheral: CBPeripheral, _ advertisementData: [String : Any], _ rssi: NSNumber)->Bool)?
    internal var scanPeerModelArr:[PeripheralModel] = [PeripheralModel]() //扫描到的封装了的外设数组，也是作为标志器
    
    //MARK: 内部属性
    var centrelDict:[String:CBCentralManager] = [String:CBCentralManager]()    //内部维护的多个中央设备的字典
    var peripheralModelDict:[String:PeripheralModel] = [String:PeripheralModel]()    //内部维护的多个外设的字典
    
    private override init() {
        /**
         在调用CBCentralManager的方法时，必须先设置CBCentralManager的状态，而状态是第一次初始化时是调用代理方法查询设置的，所以第一次调用方法，而且刚初始化时，CBCentralManager还没有状态，必须等代理方法执行完之后才有
         
         设计思路：
            设计1: 后面可以预设十个CBCentralManager，相当于维护线程池那样，就不会有延迟的状态，而且还提高性能
         */
        super.init()
        let bleAuth = CBManager.authorization   //查询系统的蓝牙权限
        print("查询系统的蓝牙权限:\(bleAuth.rawValue)")
        ///创建中央设备时，请求系统允许访问蓝牙，是否保存当前CentralManager唯一
        curCentralManger?.delegate = self
        print("创建curCentralManger的初始化方法：\(curCentralManger?.state)")
        
    }
    
}


//MARK: - 管理蓝牙单例相关的自定义工作方法，操作private属性
extension BleManager{
    
    //MARK：维护中央设备的字典
    /// 添加中央设备进字典
    private func addCentralManager(_ centralManger:CBCentralManager){
        
    }
    /// 获取中央设备
    private func getCentralManager(){
        
    }
    /// 从字典中删除中央设备
    /// - Parameter centralManger: 需要被删除的中央设备
    private func removeCentralManager(_ centralManger:CBCentralManager){
        
    }
    
    //MARK: 维护外设的字典
    
    /// 取消缓存外设的条件
    public func cancelStorePeriCondition(){
        if storeScanPeriModelCondition != nil {
            storeScanPeriModelCondition = nil
        }
    }
    
}







