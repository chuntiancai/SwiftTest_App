//
//  ViewController.swift
//  SwiftTest_App
//
//  Created by Mathew Cai on 2020/11/5.
//  Copyright © 2020 com.fendaTeamIOS. All rights reserved.
//

let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class MainViewController: UIViewController {

    //MARK: 内部属性
    private var collDataArr = ["Swift 测试0","Swift 测试1","Swift 测试2","Swift 测试3","Swift 测试4","Swift 测试5","Swift 测试6","Swift 测试7"]
    private let ocMainViewVC = OCMainViewController()
    
    ///UI组件
    private var baseCollView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
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
            pushNext(viewController: TestTableViewLayout_VC())
        case 1:
            pushNext(viewController: TestUIPageControl_VC())
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
            pushNext(viewController: TestUIButton_MainVC())
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
        
        cell.backgroundColor = UIColor(red: 250/255.0, green: 80/255.0, blue: 65/255.0, alpha: 1.0)
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: cell.frame.size.width-20, height: cell.frame.size.height));
        label.numberOfLines = 0
        label.textColor = .white
        cell.layer.cornerRadius = 8
        label.text = collDataArr[indexPath.row];
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
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
//        self.edgesForExtendedLayout = .all
        
        if #available(iOS 13.0, *) {
            
            if let appearence = navigationController?.navigationBar.standardAppearance {
                appearence.configureWithOpaqueBackground()  //在设置appearence的属性值前，必须先调用配置方法。设置透明背景，或者非透明背景。
                appearence.backgroundEffect = nil       //基于 backgroundColor 或 backgroundImage 的磨砂效果
                appearence.shadowImage = nil    //设置为nil，则UIKit会默认提供一个shadow，但是如果shadowColor也是nil，则不再显示shadow。
                appearence.shadowColor = nil

                navigationController?.navigationBar.scrollEdgeAppearance = appearence
            }
            
            
        } else {
            // Fallback on earlier versions
            print("iOS13之前还是直接用isTranslucent和shadowImage组合")
        }
        
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
//        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH,
                                                           height:SCREEN_HEIGHT / 3),collectionViewLayout: layout)
        baseCollView.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        self.view.addSubview(baseCollView)
        
        self.addChild(ocMainViewVC)
        self.view.addSubview(ocMainViewVC.view)
        ocMainViewVC.view.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
}
