//
//  TabBar_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/4.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试UITabBarController的VC
// MARK: - 笔记
/**
    1、需要在系统的tabBarButton添加到UITabBar上之前，把自己的SubTabBar替换成系统的UITabBar。不然的话，系统已经把tabBarButton放在之前的UITabBar上了。
    2、系统的tabBarButton是在UITabBarController的viewWillAppear方法中添加的。
    3、通过KVC修改tabBar属性。UITabBarButton是系统私有的类，没有暴露给用户使用，所以你是敲不出来的，只能通过反编译的方式，NSClassFromString(clsName)的方式获取类。
        还有一个方法是比较类的字符串，NSStringFromClass(type(of: subView))；
        这里有个问题，UITabBarButton会被销毁替换，而且无法控制，在子VC布局的时候，会影响UITabBarButton的位置销毁等等的，所以该方法不可取。
 */

class TabBar_VC: UITabBarController {
    
    //MARK: 对外属性

    ///UI组件
    let myTabBar = SubTabBar()
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .magenta
        self.title = "测试功能"
        print("viewDidLoad tabar的子view：\(self.tabBar.subviews)")
        initTestViewUI()
        //TODO: 替换tabBar为自己的tabBar
        /**
          如果用子类化的tabBar，该方法会有bug，会重新创建UITabBarButton，UITabBarButton不可控
         */
//        self.setValue(myTabBar, forKey: "tabBar")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear tabar的子view：\(self.tabBar.subviews)")
    }
    
}



//MARK: - 设置测试的UI
extension TabBar_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TabBar_VC {
    
}

