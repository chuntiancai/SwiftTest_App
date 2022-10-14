//
//  本地推送_singleton.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/12.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// MARK: 笔记
/**
    1、因为UserNotification的代理需要在app启动前的时候就要设置好，所以这里设置了本地通知代理对象为单例。
    2、遵循 UNUserNotificationDelegate 协议的类可以作为 UserNotification 的代理，接收并处理用户输入、如何处理推送等。
        Apple 提示我们需要在 App 完成启动之前完成代理的设置，令 AppDelegate 遵遁 UNUserNotificationDelegate 即可，并在 application(_:didFinishLaunchingWithOptions:) 中设置代理为 self。
 */
class LocalNotificationSingle:NSObject{
    
    static let shared:LocalNotificationSingle = LocalNotificationSingle()
    weak var notiDelegate:UNUserNotificationCenterDelegate?
    private override init() {
        
    }
}


//MARK: - 遵循本地通知的协议，UNUserNotificationCenterDelegate协议
extension LocalNotificationSingle:UNUserNotificationCenterDelegate{
   
    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        print("本地推送通知的代理方法：\(#function) ~")
        notiDelegate?.userNotificationCenter?(center, willPresent: notification, withCompletionHandler: completionHandler)
        //TODO: 允许运行弹窗通知
        completionHandler([.alert,.badge])
    }

    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
    // 当用户从锁屏点击通知、划掉通知、或者点击通知列表中的任意一个时，就会调用该方法。
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        print("本地推送通知的代理方法：\(#function) ~ \(response.actionIdentifier)")
        notiDelegate?.userNotificationCenter?(center, didReceive: response, withCompletionHandler: completionHandler)
    }


    
    // The method will be called on the delegate when the application is launched in response to the user's request to view in-app notification settings. Add UNAuthorizationOptionProvidesAppNotificationSettings as an option in requestAuthorizationWithOptions:completionHandler: to add a button to inline notification settings view and the notification settings view in Settings. The notification will be nil when opened from Settings.
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?){
        print("本地推送通知的代理方法：\(#function) ~")
        if #available(iOS 12.0, *) {
            notiDelegate?.userNotificationCenter?(center, openSettingsFor: notification)
        }
    }
    
}

