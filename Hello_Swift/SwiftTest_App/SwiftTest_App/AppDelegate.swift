//
//  AppDelegate.swift
//  SwiftTest_App
//
//  Created by Mathew Cai on 2020/11/5.
//  Copyright © 2020 com.ctchTeamIOS. All rights reserved.
//

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?   /// UIApplicationDelegate要求实现window
    var firstWindow:UIWindow = UIWindow()   //用于测试多个window

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor =  UIColor.init(red: 187/255.0, green: 174/255.0, blue: 180/255.0, alpha: 1.0)
        let mainVC = MainViewController()
        self.window?.rootViewController = UINavigationController.init(rootViewController: mainVC)
        self.window?.makeKeyAndVisible() //如果info.plist中有指定，则可以不调用这个方法，系统默认替你调用
        
        firstWindow.backgroundColor = UIColor.init(red: 135/255.0, green: 188/255.0, blue: 245/255.0, alpha: 1.0)   //用于测试的第二window
        
        /// 用于测试bugly
//        Bugly.start(withAppId: "aff906cba5")
        return true
    }
    
    /// 控制屏幕是否可以旋转，每次设备旋转的时候，都会询问这个方法
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        print("@@ AppDelegate supportedInterfaceOrientationsFor ")
        return .all
    }
    
    

}

