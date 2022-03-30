//
//  PeriDemoVC.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/1/25.
//  Copyright © 2021 com.mathew. All rights reserved.
//

import UIKit
import CoreBluetooth

class PeriDemoVC: UIViewController {

    //MARK: 对外属性
    public var collDataArr = ["连接外设",
                              "断开外设",
                              "用新的central链接外设",
                              "用新的cental断开外设",
                              "查看外设的状态",
                              "查看旧central的状态",
                              "查看新central的状态",
                              "扫描蓝牙外设"]
    
    //MARK: 内部属性
    ///UI数据源
    public var cbPeripheralArr: [CBPeripheral] = [CBPeripheral](){
        didSet{
            listTableView.reloadData()
        }
    }
    private var curM1 : CBCentralManager!
    private var curM2 : CBCentralManager!
    private var curPeripheral:CBPeripheral!
    
    ///UI组件
    private var baseCollView: UICollectionView!
    private var listTableView:UITableView!
    private var filterTextField: UITextField = UITextField() //过滤名称
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "测试central和peripheral"
        setCentralManager()
        
        setNavigationBarUI()
        setCollectionViewUI()
        setListTableViewUI()
    }


}

//MARK: - 设置UI
extension PeriDemoVC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        
        //去掉导航栏的下划线，导致子页面的布局是从导航栏下方开始，即snpkit会以导航栏下方为零坐标
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false    //去掉透明，即去掉毛玻璃效果
        
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
//        layout.headerReferenceSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: 130)
        layout.itemSize = CGSize.init(width: 80, height: 80)
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:SCREEN_HEIGHT),
                                             collectionViewLayout: layout)
        baseCollView.backgroundColor = UIColor.white
        baseCollView.delegate = self
        baseCollView.dataSource = self
        // register cell
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        baseCollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalToSuperview()
        }
        
    }
    
    /// 设置底部的tableview的UI
    private func setListTableViewUI(){
        
        ///设置文本的UI
        filterTextField.delegate = self
        filterTextField.borderStyle = .roundedRect
        filterTextField.textAlignment = .left
        self.view.addSubview(filterTextField)
        filterTextField.snp.makeConstraints { (make) in
            make.top.equalTo(baseCollView.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(60)
        }
        
        ///设置table的UI
        listTableView = UITableView.init(frame: self.view.bounds, style: .plain)
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.backgroundColor = .white
        listTableView.bounces = true
        
        self.view.addSubview(listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.top.equalTo(baseCollView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func setCentralManager(){
         curM1 = CBCentralManager.init(delegate: self, queue: nil,
                                         options: [CBCentralManagerOptionShowPowerAlertKey:NSNumber.init(value: true),
                                                   CBCentralManagerOptionRestoreIdentifierKey:NSString.init(string: "central_1")])
         curM2 = CBCentralManager.init(delegate: self, queue: nil,
                                          options: [CBCentralManagerOptionShowPowerAlertKey:NSNumber.init(value: true),
                                                    CBCentralManagerOptionRestoreIdentifierKey:NSString.init(string: "central_2")])
        curM1.delegate = self
        curM2.delegate = self
    }
    
}


//MARK: - 遵循collection view 委托协议,UICollectionViewDelegate
extension PeriDemoVC: UICollectionViewDelegate {
    
}

//MARK: - 遵循collection view数据源协议,UICollectionViewDataSource
extension PeriDemoVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collDataArr.count
    }
    
    ///设置cell的UI
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView_Cell_ID", for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        cell.backgroundColor = .lightGray
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: cell.frame.size.width-20, height: cell.frame.size.height));
        label.numberOfLines = 0
        label.textColor = .white
        cell.layer.cornerRadius = 8
        label.text = collDataArr[indexPath.row];
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        cell.contentView.addSubview(label)
        
        return cell
    }
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0: //连接外设
            print("旧连")
            curPeripheral = cbPeripheralArr[indexPath.row]
            curPeripheral.delegate = self
            curM1.connect(curPeripheral, options: nil)
        case 1: //旧断
            print("旧断开外设")
            curM1.cancelPeripheralConnection(curPeripheral)
            break
        case 2: //新连接
            print("新连接")
            curPeripheral.delegate = self
            curM2.connect(curPeripheral, options: nil)
            break
        case 3: //"用新的cental断开外设"
            print("用新的cental断开外设")
            curM2.cancelPeripheralConnection(curPeripheral)
            break
        case 4: //"查看外设的状态"
            print("看外设的状态：\(curPeripheral)---state:\(curPeripheral.state)")
            break
        case 5: //"查看旧central的状态"
            print("查看旧central的状态:\(curM1.state)")
            break
        case 6: //"查看新central的状态"
            print("查看旧central的状态:\(curM2.state)")
            break
        case 7: //"扫描蓝牙外设"
            curM1.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber.init(booleanLiteral: true)])
            break
        default:
            break
          
        }
    }
    
}


//MARK: - 工具方法
extension PeriDemoVC{
    
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

//MARK: - 遵循table数据源协议，UITableViewDataSource
extension PeriDemoVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cbPeripheralArr.count
    }
    
    /// 设置cell的UI
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///若通过代码指定cell的样式，则tableview不可以先登记cell
        var tempCell : UITableViewCell? = nil
        tempCell = tableView.dequeueReusableCell(withIdentifier: "tbViewCell_ID")
        if tempCell == nil {
            tempCell = UITableViewCell.init(style: .value1, reuseIdentifier: "tbViewCell_ID")
        }
        let cell: UITableViewCell = tempCell!       //展示外设的名字和信号
        cell.textLabel?.text = "\(indexPath.row)、" + (cbPeripheralArr[indexPath.row].name ?? "")
        cell.accessoryType = .none
        return cell
    }
    
    ///点击了cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - 遵循table委托协议，UITableViewDelegate
extension PeriDemoVC: UITableViewDelegate {
    
}
//MARK: - 遵循text委托协议，
extension PeriDemoVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()    //辞去第一响应者，收回键盘
        return true
    }
    
}

//MARK: - 遵循中央设备的委托协议
extension PeriDemoVC: CBCentralManagerDelegate{
    
    //MARK: 中央设备状态发生变化的回调
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("     （@@中央设备状态发生变化 centralManagerDidUpdateState：\(central)")
    }
    
    
    //MARK: 搜索到外设，每搜索到一台就调用一次该方法
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("     （@@中央设备搜索到外设，didDiscover peripheral：\(peripheral)")
        if filterTextField.text != nil {
            if peripheral.name?.hasPrefix(filterTextField.text!) ?? false{
                print(" @@ 名称过滤条件符合")
                self.cbPeripheralArr.append(peripheral)
            }
            
        }else{
            print(" @@ 没有名称过滤条件")
        }
    }
    
    
    //MARK: 与外设建立连接的回调
    /// 在这里去新建外设的对象
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("     （@@中央设备建立连接，didConnect peripheral：\(peripheral)")
        
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
    }
    
    //MARK:发现在centralManager对象中注册过的连接事件
    /// 发现在centralManager对象中注册过的连接事件
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
    }
    
}

//MARK: - 遵循外设的委托协议
extension PeriDemoVC: CBPeripheralDelegate{
    
    //MARK: 发现服务的回调，连接上外设就会回调该方法
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("     （@@ 外围设备发现服务，didDiscoverServices ：\(peripheral)")
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
    
}
