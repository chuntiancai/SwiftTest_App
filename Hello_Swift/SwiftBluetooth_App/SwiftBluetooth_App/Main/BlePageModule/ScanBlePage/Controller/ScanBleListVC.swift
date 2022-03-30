//
//  ScanBleListVC.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/1/19.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 扫描蓝牙外设的VC

import UIKit
import CoreBluetooth
/**
    布局是： 文本框 - 按钮 - tableview
 */
class ScanBleListVC: UIViewController {
    
    //MARK: 对外属性
    ///UI数据源
    public var cbPeriModelArr: [PeripheralModel] = [PeripheralModel](){
        didSet{//存放扫描到的外设
            cbPeriModelArr.sort { (model1, model2) -> Bool in
                if model1.firstRSSI != nil && model2.firstRSSI != nil {
                    return model1.firstRSSI!.int64Value > model2.firstRSSI!.int64Value
                }else {
                    return true
                }
                
            }
            listTableView.reloadData()
        }
    }
    
    
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
        self.title = "扫描蓝牙设备VC"
        self.view.backgroundColor = .white
        setNavigationBarUI()
        setTextFiledUI()
        setBtnViewUI()
        setTableViewUI()
        
    }
    
    
}

//MARK: - 设置UI
extension ScanBleListVC {
    
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
            make.top.equalToSuperview()
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
            make.top.equalToSuperview().offset(70)
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
            make.top.equalToSuperview().offset(70)
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
            make.top.equalToSuperview().offset(130)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    
    
}

//MARK: - 动作方法
@objc extension ScanBleListVC {
    ///  取消按钮的动作方法
    private func cancelAction(){
        print("点击了取消按钮")
        BleManager.shared.cancelConnect(peripheralID: "periID1")
    }
    
    ///  重新搜索按钮的动作方法
    private func scanAgainAction(){
        print("点击了重新搜索按钮")
        filterTextField.resignFirstResponder()  //收起键盘
        print("textfield的内容是：\(String(describing: filterTextField.text))")
        if filterTextField.text != nil {
            BleManager.shared.storeScanPeriModelCondition = {
                [weak self](peripheral: CBPeripheral,advertisementData: [String : Any],rssi: NSNumber)->Bool in
                
                let textStr = self?.filterTextField.text!
                if textStr != nil {
                    if textStr!.isEmpty {return true } //如果没有输入文本则为全部搜索
                    if peripheral.name == nil { return false}    //有输入文本,设备没有名字，则不存储
                    if peripheral.name!.contains(textStr!) {        //包含设备名字，则存储
                        return true
                    }else{
                        return false
                    }
                }else{
                    return true
                }
            }
        }
        ///扫描外设
        BleManager.shared.scanPeripherals( options: [CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber.init(value: false)])
        
        CHToast.showIndicatorToast(message: "正在扫描...",aShowTime: 2.0)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            print("3秒后停止扫描蓝牙")
            BleManager.shared.curCentralManger?.stopScan()
            self.cbPeriModelArr = BleManager.shared.scanPeerModelArr
        }
    }
    
    /// 下拉刷新的动作方法
    private func refreshCtrlAction(refreshCtrl: UIRefreshControl){
        
        print("点击了下拉刷新")
    }
}

//MARK: - 遵循table数据源协议，UITableViewDataSource
extension ScanBleListVC: UITableViewDataSource {
    
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
        cell.textLabel?.text = "\(indexPath.row)、" + (cbPeriModelArr[indexPath.row].peripheral.name ?? "")
        let firstRSSI_Str = cbPeriModelArr[indexPath.row].firstRSSI != nil ? "\(cbPeriModelArr[indexPath.row].firstRSSI! )" : ""
        cell.detailTextLabel?.text = firstRSSI_Str
        cell.accessoryType = .none
        return cell
    }
    
    ///点击了cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tmpPeriModel = self.cbPeriModelArr[indexPath.row]
        BleManager.shared.connect(peripheralID: "periID_1", tmpPeriModel.peripheral)  //连接
    }
    
}

//MARK: - 遵循table委托协议，UITableViewDelegate
extension ScanBleListVC: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if offset.y > 0 {
            refreshCtrl.endRefreshing() //结束刷新
        }
    }
    
    
}

//MARK: - 遵循text委托协议，
extension ScanBleListVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()    //辞去第一响应者，收回键盘
        return true
    }
    
}


