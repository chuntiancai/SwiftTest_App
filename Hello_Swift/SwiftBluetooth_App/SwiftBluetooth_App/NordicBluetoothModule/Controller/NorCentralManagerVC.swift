//
//  NorCentralManagerVC.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/2/3.
//  Copyright © 2021 com.mathew. All rights reserved.
//

import UIKit
import CoreBluetooth

class NorCentralManagerVC: UIViewController {

    //MARK: 对外属性
    public var collDataArr = ["isScanning","item1","item2","item3",
                              "item4","item5","item6","item7",
                              "item8","item9","item10","item11",
                              "item12","item13","item14","item15"]
    
    //MARK: 内部属性
    ///UI数据源
    
    
    ///UI组件
    private var baseCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "测试 Central Manager 方法"
        
        setNavigationBarUI()
        setTopLogViewUI()
        setCollectionViewUI()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        setTopLogViewUI()
        NordicCommon.sharedLogView.appendText = "Welcome to NorCentralManagerVC ！"
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }

}

//MARK: - 设计UI
extension NorCentralManagerVC {
    
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
extension NorCentralManagerVC: UICollectionViewDelegate {
    
}

//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension NorCentralManagerVC: UICollectionViewDataSource {
    
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
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
    
}


//MARK: - 工具方法
extension NorCentralManagerVC{
    
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

