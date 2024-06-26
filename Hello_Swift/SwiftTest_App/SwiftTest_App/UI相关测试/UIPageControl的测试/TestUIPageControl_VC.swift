//
//  TestUIPageControl_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/7/20.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试滑动小圆点的VC
// MARK: - 笔记

import UIKit
/**
    1、
 
 */

class TestUIPageControl_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    /// 继承UIPageControl的pageCtrl
    lazy var pageCtrl : UIPageControl = {
        let ctrl = UIPageControl()
        ctrl.layer.borderWidth = 1.0
        ctrl.layer.borderColor = UIColor.brown.cgColor
        ctrl.numberOfPages = 3
        return ctrl
    }()
    
    lazy var pageCtrvlView : TestPageControl_View = {
        let ctrl = TestPageControl_View()
        ctrl.layer.borderWidth = 1.0
        ctrl.layer.borderColor = UIColor.brown.cgColor
        ctrl.numberOfPages = 10
        
        return ctrl
    }()
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试UIPageControl_VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestUIPageControl_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试自定义的pageCotrolView
            print("     (@@ 0、测试自定义的pageCotrolView")
            if pageCtrvlView.currentPage >= pageCtrvlView.numberOfPages - 1  {
                pageCtrvlView.currentPage -= 1
            }else if pageCtrvlView.currentPage <= 0 {
                pageCtrvlView.currentPage += 1
            }else{
                pageCtrvlView.currentPage += 1
            }
            
        case 1:
            //TODO: 1、
            print("     (@@ 1、测试pageCotrolView -1 ")
            pageCtrvlView.currentPage = 0
        case 2:
            //TODO: 2、
            print("     (@@ 2、")
        case 3:
            //TODO: 3、
            print("     (@@ 3、")
        case 4:
            print("     (@@")
        case 5:
            print("     (@@")
        case 6:
            print("     (@@")
        case 7:
            print("     (@@")
        case 8:
            print("     (@@")
        case 9:
            print("     (@@")
        case 10:
            print("     (@@")
        case 11:
            print("     (@@")
        case 12:
            print("     (@@")
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestUIPageControl_VC{
   
    //MARK: 0、
    func test0(){
        
        
    }
    
}


//MARK: - 设置测试的UI
extension TestUIPageControl_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
//        self.view.addSubview(pageCtrl)
//        pageCtrl.snp.makeConstraints { make in
//            make.top.equalTo(baseCollView.snp_bottom).offset(40)
//            make.centerX.equalToSuperview()
//            make.height.equalTo(60)
//            make.width.equalTo(200)
//        }
        
        self.view.addSubview(pageCtrvlView)
        pageCtrvlView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp_bottom).offset(60)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(200)
        }
    }
    
}


//MARK: - 设计UI
extension TestUIPageControl_VC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 40)
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 0, right: 5)
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:200),
                                             collectionViewLayout: layout)
        
        baseCollView.backgroundColor = UIColor.cyan.withAlphaComponent(0.8)
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
        baseCollView.layer.borderWidth = 1.0
        baseCollView.layer.borderColor = UIColor.gray.cgColor
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestUIPageControl_VC: UICollectionViewDelegate {
    
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
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

