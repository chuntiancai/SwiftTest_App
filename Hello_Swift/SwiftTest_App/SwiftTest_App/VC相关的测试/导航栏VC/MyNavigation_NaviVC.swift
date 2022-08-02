//
//  MyNavigation_NaviVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/2.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试用的，导航栏VC
//MARK: - 笔记
/**
    1、自定义继承导航栏VC，你可以在这里复写管理push，pop放回按钮等
 */

class MyNavigation_NaviVC: UINavigationController {
    
    /// 重写初始化方法，在这里设置全局的导航栏UI
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        //TODO: 设置导航栏bar的Appearance
        /**
            1、Appearance属性影响的是整个navigationBar的类，而不是实例，所以是一个全局的属性。
            2、standardAppearance是普通的外观管理，scrollEdgeAppearance是当导航子vc里有scrollview时的外观管理。
         */
        if #available(iOS 13.0, *) {
            print("导航栏bar的standardAppearance：\(self.navigationBar.standardAppearance)")
            print("导航栏bar的scrollEdgeAppearance：\(String(describing: self.navigationBar.scrollEdgeAppearance))")
            let appearence = UINavigationBarAppearance()
            appearence.configureWithOpaqueBackground()  //在设置appearence的属性值前，必须先调用配置方法。
            appearence.backgroundEffect = nil       //基于 backgroundColor 或 backgroundImage 的磨砂效果
            appearence.backgroundImage = UIImage(named: "labi01")   //只是为磨砂效果提供素材而已。
            appearence.backgroundColor = UIColor.yellow.withAlphaComponent(0.5) //设置bar透明或者有backgroundImage时无效，因为在backgroundImage视图层次之下。

            appearence.shadowImage = nil    //设置为nil，则UIKit会默认提供一个shadow，但是如果shadowColor也是nil，则不再显示shadow。
            appearence.shadowColor = nil

            navigationController?.navigationBar.standardAppearance = appearence
            navigationController?.navigationBar.scrollEdgeAppearance = appearence
            
            self.navigationController?.navigationBar.setBackgroundImage(MyImageTool.getColorImg(alpha: 0.8), for: .default)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        print("MyNavigation_NaviVC 的\(#function) 方法")
        //譬如在这里自定义返回按钮
        if self.children.count > 0 {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "naviBar_back"),
                                                                              style: .plain, target: self, action: #selector(self.back))
        }
        super.pushViewController(viewController, animated: animated)
    }
    
}

//MARK: VC的生命周期方法
extension MyNavigation_NaviVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MyNavigation_NaviVC 的\(#function) 方法")
    }
    
}

//MARK: 动作方法
@objc extension MyNavigation_NaviVC {
    
    func back() {
        print("MyNavigation_NaviVC 的 \(#function) 方法")
        self.popViewController(animated: true)
    }
    
}
