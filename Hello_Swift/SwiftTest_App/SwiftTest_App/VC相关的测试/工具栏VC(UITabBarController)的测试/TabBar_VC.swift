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
        self.title = "TabBar_VC"
        self.delegate = self
        //TODO: 替换tabBar为自己的tabBar
        /**
          如果用子类化的tabBar，该方法会有bug，会重新创建UITabBarButton，UITabBarButton不可控
         */
        print("TabBar_VC viewDidLoad tabar的子view：\(self.tabBar.subviews)")
        print("TabBar_VC \(#function) 是否有tabBar了：\(self.tabBar)")
        self.setValue(myTabBar, forKey: "tabBar")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TabBar_VC viewWillAppear tabar的子view：\(self.tabBar.subviews)")
    }
    
}



//MARK: - 遵循 UITabBarControllerDelegate 协议
extension TabBar_VC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        print("TabBar_VC UITabBarControllerDelegate 的 \(#function) 方法")
        return true
    }
    
    /// 当tabBarController选中了某个子控制器的时候调用（点击了tabBar里面按钮的时候）
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        print("TabBar_VC UITabBarControllerDelegate 的 \(#function) 方法")
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, willBeginCustomizing viewControllers: [UIViewController]){
        print("TabBar_VC UITabBarControllerDelegate 的 \(#function) 方法")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, willEndCustomizing viewControllers: [UIViewController], changed: Bool){
        print("TabBar_VC UITabBarControllerDelegate 的 \(#function) 方法")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController], changed: Bool){
        print("TabBar_VC UITabBarControllerDelegate 的 \(#function) 方法")
    }
    
    
    func tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask{
        print("TabBar_VC UITabBarControllerDelegate 的 \(#function) 方法")
        return .all
    }
    
    func tabBarControllerPreferredInterfaceOrientationForPresentation(_ tabBarController: UITabBarController) -> UIInterfaceOrientation{
        print("TabBar_VC UITabBarControllerDelegate 的 \(#function) 方法")
        return .portrait
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?{
        print("TabBar_VC UITabBarControllerDelegate 的 \(#function) 方法")
        return nil
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        print("TabBar_VC UITabBarControllerDelegate 的 \(#function) 方法")
        return nil
    }
    
}


//MARK: - 设计UI
extension TabBar_VC {
    
}

