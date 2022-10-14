//
//  AppDelegate.swift
//  SwiftTest_App
//
//  Created by Mathew Cai on 2020/11/5.
//  Copyright © 2020 com.ctchTeamIOS. All rights reserved.
//

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {   /// UIApplicationDelegate要求实现window
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        return window
    }()
    lazy var firstWindow:UIWindow = {
        return UIWindow()
    }()  //用于测试多个window

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window?.backgroundColor =  UIColor.init(red: 187/255.0, green: 174/255.0, blue: 180/255.0, alpha: 1.0)
        let mainVC = MainViewController()
        self.window?.rootViewController = UINavigationController.init(rootViewController: mainVC)
        self.window?.makeKeyAndVisible() //如果info.plist中有指定，则可以不调用这个方法，系统默认替你调用
        
        firstWindow.backgroundColor = UIColor.init(red: 135/255.0, green: 188/255.0, blue: 245/255.0, alpha: 1.0)   //用于测试的第二window
        
        //TODO: 测试本地通知推送
        UNUserNotificationCenter.current().delegate = LocalNotificationSingle.shared;
        
        // launchOptions: 如果app 不是通过正常启动(点击应用程序的图标启动), 都会把对应的一些信息参数, 放到这个字典里面。譬如本地通知的一些信息。
        if launchOptions != nil { showLaunchOptionsText(launchOptions) }
        
        /// 用于测试bugly
//        Bugly.start(withAppId: "aff906cba5")
        return true
    }
    
    //TODO: 控制屏幕是否可以旋转，每次设备旋转的时候，都会询问这个方法
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        print("@@ AppDelegate supportedInterfaceOrientationsFor ")
        return .all
    }
    
    

}

//MARK: 用于测试的方法
extension AppDelegate {
    
    // 展示launchOptions的参数
    func showLaunchOptionsText( _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        print("App启动时的参数：\(String(describing: launchOptions))")
        
        let textView = UITextView(frame: CGRect(x: 20, y: 160, width: 300, height: 300))
        textView.backgroundColor = UIColor.cyan
        textView.text = launchOptions?.description
        window?.rootViewController?.view.addSubview(textView)
        
        // 如果是用户点击了本地通知启动的app，会在UNUserNotificationCenterDelegate的didReceiveNotificationResponse方法中回调, 那你就可以在代理方法中做一些用户点击了本地通知之后的一些业务逻辑处理.
        // [UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]
        
    }
    
}
