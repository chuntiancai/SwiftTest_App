//
//  ViewController.swift
//  SwiftTest_App
//
//  Created by Mathew Cai on 2020/11/5.
//  Copyright © 2020 com.fendaTeamIOS. All rights reserved.
//

import UIKit

let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class MainViewController: UIViewController {

    //MARK: 对外属性
    
    
    //MARK: 内部属性
    private var collDataArr = ["公共测试","公共测试1","公共测试2","公共测试3","公共测试4","公共测试5","公共测试6","公共测试7"]
    
    ///UI组件
    private var baseCollView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "测试App"
        setNavigationBarUI()
        setCollectionViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("MainViewController点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            pushNext(viewController: TestURLSession_VC())
        case 1:
            pushNext(viewController: FileTest_VC())
            break
        case 2:
            
            self.navigationItem.backBarButtonItem = nil
            let storyBoard = UIStoryboard.init(name: "FSCalendarTest", bundle: nil)
            let mainStoryVC = storyBoard.instantiateViewController(withIdentifier: "FSCalendar_SB_VC_ID")
            pushNext(viewController: mainStoryVC)
            break
        case 3:
            //TODO: 3、
            pushNext(viewController: TestSnapkit_VC())
        case 4:
            //TODO: 4、UI相关测试
            pushNext(viewController: UIButtonTest_MainVC())
        case 5:
            //TODO: 5、多线程测试
            pushNext(viewController: TestNSOperation_VC())
        case 6:
            //TODO: 6、VC相关的测试
            pushNext(viewController: TestSubVC_MainVC())
        case 7:
            //TODO: 7、网络相关的测试
            pushNext(viewController: TestURLSession_VC())
        default:
            break
        }
    }
    
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
    
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
}


//MARK: - 工具方法
extension MainViewController{
    
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}


//MARK: - 设计UI
extension MainViewController {
    
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
        
    }
}
