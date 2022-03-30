//
//  ScanNordicVC.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/2/3.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 扫描nordic蓝牙外设的VC（DFU模式）

import UIKit
import CoreBluetooth
/**
    布局是： 文本框 - 按钮 - tableview
 */
class ScanNordicVC: UIViewController {
    
    //MARK: 对外属性
    ///UI数据源
    private var cbPeriModelArr: [CBPeripheral] = [CBPeripheral](){
        didSet{//存放扫描到的外设
            listTableView.reloadData()
        }
    }
    private var periRssiArr:[NSNumber] = [NSNumber]()
    
    //MARK: 内部属性
    ///UI组件
    private var filterTextField: UITextField = UITextField() //过滤名称
    private var cancelBtn:UIButton = UIButton() //取消按钮
    private var scanAgainBtn:UIButton = UIButton()  //重新搜索按钮
    
    private var refreshCtrl: UIRefreshControl = UIRefreshControl()  //tableview
    private lazy var listTableView:UITableView = { //展示外设的tableview
        let tView = UITableView.init(frame: self.view.bounds, style: .plain)
        return tView
    }()
    
    
    
    //MARK: 复写父类的方法
    override func viewDidLoad() {
        self.title = "扫描Nordic蓝牙设备VC"
        self.view.backgroundColor = .white
        NordicBleManager.shared.innerCentralManager.delegate = self
        setNavigationBarUI()
        setTextFiledUI()
        setBtnViewUI()
        setTableViewUI()
        
    }
    
    
}

//MARK: - 设置UI
extension ScanNordicVC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        //设置导航栏右侧的item
        let rightItem = UIBarButtonItem.init(image: UIImage(), style: .plain,target: self, action: nil)
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置文本的UI
    private func setTextFiledUI(){
        filterTextField.delegate = self
        filterTextField.borderStyle = .roundedRect
        filterTextField.textAlignment = .left
        self.view.addSubview(filterTextField)
        filterTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(NAVIGATION_BAR_HEIGHT)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(60)
        }
    }
        
    /// 设置两个按钮的UI
    private func setBtnViewUI(){
        ///取消按钮
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelBtn.backgroundColor = .gray
        cancelBtn.layer.cornerRadius = 10
        self.view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(70 + NAVIGATION_BAR_HEIGHT)
            make.left.equalToSuperview().offset(40)
            make.height.equalTo(60)
            make.width.equalTo(100)
        }
        
        ///取消按钮
        scanAgainBtn.setTitle("重新搜索", for: .normal)
        scanAgainBtn.addTarget(self, action: #selector(scanAgainAction), for: .touchUpInside)
        scanAgainBtn.backgroundColor = .gray
        scanAgainBtn.layer.cornerRadius = 10
        self.view.addSubview(scanAgainBtn)
        scanAgainBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(70 + NAVIGATION_BAR_HEIGHT)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(60)
            make.width.equalTo(100)
        }
    }
    
    /// 设置tableview的UI
    private func setTableViewUI(){
        ///设置下拉刷新控件的属性
        refreshCtrl.attributedTitle = NSAttributedString.init(string: "刷新中...")
        refreshCtrl.addTarget(self, action: #selector(refreshCtrlAction(refreshCtrl:)), for: .valueChanged)
//        listTableView.refreshControl = refreshCtrl
        
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.backgroundColor = .white
        listTableView.bounces = true
        
        self.view.addSubview(listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(130 + NAVIGATION_BAR_HEIGHT)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    
    
}

//MARK: - 动作方法
@objc extension ScanNordicVC {
    ///  取消按钮的动作方法
    private func cancelAction(){
        print("点击了取消按钮")
        NordicBleManager.shared.innerCentralManager.delegate = NordicBleManager.shared.self
        self.dismiss(animated: true, completion: nil)
    }
    
    ///  重新搜索按钮的动作方法
    private func scanAgainAction(){
        print("点击了重新搜索按钮")
        self.cbPeriModelArr.removeAll() //移除暂存的外设
        self.periRssiArr.removeAll()
        filterTextField.resignFirstResponder()  //收起键盘
        print("textfield的内容是：\(String(describing: filterTextField.text))")
        
        ///扫描外设
        NordicBleManager.shared.innerCentralManager.scanForPeripherals(
            withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber.init(value: false)])
        
        CHToast.showIndicatorToast(message: "正在扫描...",aShowTime: 3.0)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            print("3秒后停止扫描蓝牙")
            NordicBleManager.shared.innerCentralManager.stopScan()
        }
    }
    
    /// 下拉刷新的动作方法
    private func refreshCtrlAction(refreshCtrl: UIRefreshControl){
        
        print("点击了下拉刷新")
    }
}

//MARK: - 遵循table数据源协议，UITableViewDataSource
extension ScanNordicVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cbPeriModelArr.count
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
        cell.textLabel?.text = "\(indexPath.row)、" + (cbPeriModelArr[indexPath.row].name ?? "")
        cell.detailTextLabel?.text = "\(periRssiArr[indexPath.row])"
        cell.accessoryType = .none
        return cell
    }
    
    ///点击了cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        NordicBleManager.shared.innerCentralManager.connect(cbPeriModelArr[indexPath.row], options: nil)
        CHToast.showIndicatorToast(message: "正在连接外设:\(String(describing: cbPeriModelArr[indexPath.row].name))" as NSString,aShowTime: 10.0)
    }
    
}

//MARK: - 遵循table委托协议，UITableViewDelegate
extension ScanNordicVC: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if offset.y > 0 {
            refreshCtrl.endRefreshing() //结束刷新
        }
    }
    
    
}

//MARK: - 遵循text委托协议，
extension ScanNordicVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()    //辞去第一响应者，收回键盘
        return true
    }
    
}

//MARK: - 遵循CBCentralManager委托协议，CBCentralManagerDelegate协议,中央设备角色
extension ScanNordicVC: CBCentralManagerDelegate {
    
    //MARK: 中央设备状态发生变化的回调
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("     （@@ Nordic Scan VC 中央设备状态发生变化 centralManagerDidUpdateState：\(central)--\(central.state.rawValue)")
    }
    
    
    //MARK: 搜索到外设，每搜索到一台就调用一次该方法
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("     （@@ Nordic Scan VC 中央设备搜索到外设，didDiscover peripheral：\(peripheral)")
        var storeFlag = false
        let textStr = self.filterTextField.text
        outer: if textStr != nil {
            if textStr!.isEmpty {   //如果没有输入文本则为全部搜索
                storeFlag =  true
                break outer //跳出if
            }
            if peripheral.name == nil {  //有输入文本,设备没有名字，则不存储
                storeFlag = false
                break outer //跳出if
            }
            if peripheral.name!.contains(textStr!) {        //包含设备名字，则存储
                storeFlag = true
            }else{
                storeFlag = false
            }
        }else{
            storeFlag = true
        }
        if storeFlag {
            self.cbPeriModelArr.append(peripheral)
            self.periRssiArr.append(RSSI)
        }
        
    }
    
    
    //MARK: 与外设建立连接的回调
    /// 在这里去新建外设的对象
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("     （@@ Nordic Scan VC 中央设备建立连接，didConnect peripheral：\(peripheral)")
        NordicBleManager.shared.curPeriphral = peripheral
        NordicCommon.sharedLogView.appendText = "@@ Nordic Scan VC 中央设备建立连接 didConnect peripheral：\(peripheral)"
        CHToast.hideIndicatorToast()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: App从后台恢复时，调用该方法告知恢复蓝牙中心设备
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("     （@@ Nordic Scan VC 中央设备App从后台恢复，willRestoreState ：\(dict)")
    }
    
    //MARK: 连接外设失败
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("     （@@ Nordic Scan VC 中央设备连接外设失败，didFailToConnect ：\(peripheral)")
    }
    
    
    //MARK: 与外设失去连接
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("     （@@ Nordic Scan VC 中央设备与外设失去连接，didDisconnectPeripheral ：\(peripheral)")
    }
    
    //MARK:已连接的外设的ANCS的授权状态已更改
    ///已连接的外设的ANCS的授权状态已更改
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
         print("     （@@ Nordic Scan VC 已连接的外设的ANCS的授权状态已更改，peripheral：\(peripheral)")
    }
    
    //MARK:发现在centralManager对象中注册过的连接事件
    /// 发现在centralManager对象中注册过的连接事件
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        print("     （@@ Nordic Scan VC 发现在centralManager对象中注册过的连接事件，peripheral：\(peripheral)")
    }
    
}
