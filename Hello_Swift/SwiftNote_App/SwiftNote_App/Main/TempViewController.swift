//
//  TempViewController.swift
//  SwiftNote_App
//
//  Created by Mathew Cai on 2020/11/5.
//  Copyright © 2020 com.ctchTeamIOS. All rights reserved.
//

import UIKit
import SnapKit

//一些布局颜色信息
struct TempViewControllerConstant {
    static let viewHeight = UIScreen.main.bounds.width * (130/375.0)    //View的高度
    static let viewWidth = UIScreen.main.bounds.width * (56/375.0)    //View的宽度
    
    //颜色信息
    static let contentViewHeight = UIScreen.main.bounds.width * (65/375.0)    //View的宽度
    static let contentViewWidth = UIScreen.main.bounds.width * (28/375.0)    //View的宽度
}

class TempViewController: UIViewController {
    
    //MARK: - 对外属性
    
    //MARK: - 内部属性
    
    //MARK: - 复写方法
    
    
    //基本的滑动视图，其他view都是添加到这个scrollview上的
    private let baseScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initDisaplayData()
        initDisaplayView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    private func initDisaplayView(){
        self.view.backgroundColor = .gray
        setNavigationBarUI()
        setBaseScrollViewUI()
        
    }
    
    private func initDisaplayData(){
        
    }

}
// MARK: - 设置页面的UI
extension TempViewController {
    
    //设置导航栏的UI ------------------------------------
    private func setNavigationBarUI(){
        //设置导航栏右侧的item
        let rightItem = UIBarButtonItem.init(image: UIImage(named: "explain"), style: .plain,target: self, action: #selector(tapTheNavRightItem))
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    //设置基本的scroll view，其他view都是添加到这个scroll view 上
    private func setBaseScrollViewUI(){
        
        baseScrollView.delegate = self
        baseScrollView.showsVerticalScrollIndicator = false
        baseScrollView.bounces = false    //禁止回弹效果
        
        let contentSize = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * (812.0/375.0))
        baseScrollView.contentSize = contentSize
        self.view.addSubview(baseScrollView)
        baseScrollView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - 遵循scroll view的delegates协议
extension TempViewController: UIScrollViewDelegate {
    
}


// MARK: - 内部的工具方法
extension TempViewController {
    
    //一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        //一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

// MARK: - oc方法，动作方法
@objc extension TempViewController {
    
    //点击了导航栏右侧的item
    func tapTheNavRightItem(){
        print("点击了导航栏右侧的item")
    }
}

// MARK: - 对外的访问方法
extension TempViewController {
    
}
