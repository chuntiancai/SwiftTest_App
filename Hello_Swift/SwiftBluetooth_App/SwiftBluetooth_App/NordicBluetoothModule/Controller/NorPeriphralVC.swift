//
//  NorPeriphralVC.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/2/3.
//  Copyright © 2021 com.mathew. All rights reserved.
//

import UIKit
import CoreBluetooth

class NorPeriphralVC: UIViewController {

    //MARK: 对外属性
    public var collDataArr = ["name","discoverServices","services","state",
                              "canSendWriteWithoutResponse","readRSSI","ancsAuthorized"]
    
    //MARK: 内部属性
    ///UI数据源
    
    
    ///UI组件
    private var baseCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "测试 Periphral 方法"
        
        setNavigationBarUI()
        setTopLogViewUI()
        setCollectionViewUI()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        setTopLogViewUI()
        NordicCommon.sharedLogView.appendText = "Welcome to NorPeriphralVC ！"
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }

}

//MARK: - 设计UI
extension NorPeriphralVC {
    
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
    
    /// 设计顶部的打印log的UI
    private func setTopLogViewUI(){
        if NordicCommon.sharedLogView.superview != nil {
            NordicCommon.sharedLogView.removeFromSuperview()
        }
        NordicCommon.sharedLogView.frame = CGRect(x:10, y:0, width:SCREEN_WIDTH - 20,height:220)
        NordicCommon.sharedLogView.layer.cornerRadius = 10.0
        
        self.view.addSubview(NordicCommon.sharedLogView)
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 80)
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:230, width:UIScreen.main.bounds.size.width,height:SCREEN_HEIGHT - 230),
                                             collectionViewLayout: layout)
        baseCollView.backgroundColor = UIColor.white
        baseCollView.delegate = self
        baseCollView.dataSource = self
        // register cell
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        self.view.addSubview(baseCollView)
    }
    
}


//MARK: - 遵循委托协议,UICollectionViewDelegate
extension NorPeriphralVC: UICollectionViewDelegate {
    
}

//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension NorPeriphralVC: UICollectionViewDataSource {
    
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
        /**
         ["name","discoverServices","services",
         "state","canSendWriteWithoutResponse","readRSSI","ancsAuthorized"]
         */
        let curPeriphral = NordicCommon.bleManager.curPeriphral
        switch indexPath.row {
        case 0:
            let name = curPeriphral?.name
            NordicCommon.sharedLogView.appendText = "@@ 调用curPeriphral?.name: \(String(describing: name))"
        case 1:
            NordicCommon.sharedLogView.appendText = "@@ 调用curPeriphral?.discoverServices"
            curPeriphral?.discoverServices(nil)
            break
        case 2:
            let services = curPeriphral?.services
            NordicCommon.sharedLogView.appendText = "@@ 调用curPeriphral?.services:\(String(describing: services))"
            break
        case 3:
            let state = curPeriphral?.state
            NordicCommon.sharedLogView.appendText = "@@ 调用curPeriphral?.state:\(String(describing: state?.rawValue))"
            break
        case 4:
            NordicCommon.sharedLogView.appendText = "@@ 调用curPeriphral?.canSendWriteWithoutResponse:" +
                                                    "\(String(describing: curPeriphral?.canSendWriteWithoutResponse))"
            break
        case 5:
            NordicCommon.sharedLogView.appendText = "@@ 调用curPeriphral?.readRSSI:\(String(describing: curPeriphral?.readRSSI()))"
            break
        case 6:
//            NordicCommon.sharedLogView.appendText = "@@ 调用curPeriphral?.ancsAuthorized:\(String(describing: curPeriphral?.ancsAuthorized))"
            break
      
        default:
            break
        }
    }
    
}


//MARK: - 工具方法
extension NorPeriphralVC{
    
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

