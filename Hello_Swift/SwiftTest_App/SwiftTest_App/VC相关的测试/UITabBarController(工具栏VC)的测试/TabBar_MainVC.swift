//
//  TabBar_MainVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/4.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试UITabBarController的主VC

class TabBar_MainVC: UITabBarController {
    
    //MARK: 对外属性

    ///UI组件
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .magenta
        self.title = "测试功能"
        
        initTestViewUI()
    }

    ///该方法比主程序的main方法还要早调用，因为是把类的二进制代码加载进内存事就调用了，还没开始正式执行主程序。
    

}



//MARK: - 设置测试的UI
extension TabBar_MainVC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TabBar_MainVC {
    
}

