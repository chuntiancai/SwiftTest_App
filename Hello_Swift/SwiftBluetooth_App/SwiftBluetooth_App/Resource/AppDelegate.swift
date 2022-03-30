//
//  AppDelegate.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/1/18.
//  Copyright © 2021 com.mathew. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

        
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let _ = BleManager.shared   //初始化第一次调用中央设备的状态
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController.init(rootViewController: MainViewController())
        self.window?.makeKeyAndVisible()    //设置为主键
        return true
    }



}

