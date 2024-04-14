//
//  AppDelegate.swift
//  SwiftTest_App
//
//  Created by Mathew Cai on 2020/11/5.
//  Copyright © 2020 com.ctchTeamIOS. All rights reserved.
//
//MARK: - 笔记
/**
 APP的状态：
    1.未运行（Not running）
        程序没启动
 
    2.未激活（Inactive）
        程序在前台运行，不过没有接收到事件。
        一般每当应用要从一个状态切换到另一个不同的状态时，中途过渡会短暂停留在此状态。
        唯一在此状态停留时间比较长的情况是：当用户锁屏时，或者系统提示用户去响应某些（诸如电话来电、有未读短信等）事件的时候。
     
     3.激活（Active）
        程序在前台运行而且接收到了事件。这也是前台的一个正常的模式。
     
     4.后台（Backgroud）
        程序在后台而且能执行代码，大多数程序进入这个状态后会在在这个状态上停留一会。时间到之后会进入挂起状态。
        有的程序经过特殊的请求后可以长期处于 Backgroud 状态。
     
     5.挂起（Suspended）
        程序在后台不能执行代码。系统会自动把程序变成这个状态而且不会发出通知。当挂起时，程序还是停留在内存中的，当系统内存低时，
        系统就把挂起的程序清除掉，为前台程序提供更多的内存。
 
 */
import GrowingCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {   /// UIApplicationDelegate要求实现window
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        return window
    }()
    lazy var firstWindow:UIWindow = {
        return UIWindow()
    }()  //用于测试多个window

    
    //TODO: 在App启动时调用表示应用加载进程已经开始,常用来处理应用状态的存储和恢复
    /// - Parameters:
    ///   - application: 象征整个app的单例对象
    ///   - launchOptions: 是一个字典，你通过里面的key来获取value，判断value是否为空，从而知道app是怎么启动的：
    ///                     例如是: 用户点击图标启动的，蓝牙(本地)通知启动的，后台服务器的通知启动的，urlscheme启动。
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    //TODO:表示App将从未运行状态进入运行状态,用于对App的初始化操作
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
        
        //FIXME: 测试GrowingIO
//        Growing.start(withAccountId: "b8fb5c41cb38ae42")
//        Growing.start(withAccountId: "9907c51ef09823c8d5b98c511e30a866")
//        Growing.setEnableLog(true)
        
        /// 用于测试bugly
//        Bugly.start(withAppId: "aff906cba5")
        return true
    }
    
    //TODO: 控制屏幕是否可以旋转，每次设备旋转的时候，都会询问这个方法
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        print("@@ AppDelegate supportedInterfaceOrientationsFor ")
        return .all
    }
    
    //TODO: 当应用即将进入前台运行时调用
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    //TODO: 当应用即将进从前台退出时调用
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    //TODO: 当程序从后台将要重新回到前台（但是还没变成Active状态）时候调用
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    //TODO: 当应用开始在后台运行的时候调用
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    //TODO: 当前应用即将被终止，在终止前调用的函数。通常是用来保存数据和一些退出前的清理工作。
    ///     如果应用当前处在suspended，此方法不会被调用。 该方法最长运行时限为5秒，过期应用即被kill掉并且移除内存
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    //TODO: 如果是urlscheme启动的，则系统会回调该方法，你在这个方法里面操作。
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
        if (Growing.handle(url)) // 请务必确保该函数被调用
         {
             return true;
         }
        return false
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
