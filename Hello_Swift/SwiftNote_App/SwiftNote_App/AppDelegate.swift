//
//  AppDelegate.swift
//  SwiftNote_App
//
//  Created by Mathew Cai on 2020/11/5.
//  Copyright © 2020 com.ctchTeamIOS. All rights reserved.
//

//import GrowingCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController.init(rootViewController: MainViewController())
        self.window?.makeKeyAndVisible()    //设置为主键
//        Growing.start(withAccountId: "b8fb5c41cb38ae42")
//        Growing.start(withAccountId: "9907c51ef09823c8d5b98c511e30a866")
//        Growing.setEnableLog(true)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    

    //TODO: 处理应用间的跳转。
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("别的App申请跳转到当前App：\(#function) 方法")
        print("方法参数：url: \(url) -- options: \(options)")
        
        
        
        if (Growing.handle(url)) // 请务必确保该函数被调用
         {
             return true;
         }
        
        // 定义协议的过程
        // 就是穿什么值过来, 做不同的操作
        guard let host = url.host else { return true}
        
        // 1. 获取跳转的控制器
        let nav = window?.rootViewController as? UINavigationController
        nav?.popToRootViewController(animated: false)
        
        //            nav?.topViewController
        let vc = nav?.children[0]
        print("当前VC是：\(String(describing: vc))")
        
        
        
        if host == "PayVC" {
            print("跳转到打款页面VC")
            nav?.pushViewController(AddPaymentClipVC(), animated: true)
        }
        
        return true
    }
  


}

