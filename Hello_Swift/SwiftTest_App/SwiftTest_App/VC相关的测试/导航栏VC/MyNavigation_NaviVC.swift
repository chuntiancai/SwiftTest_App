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
    1、自定义继承导航栏VC，你可以在这里复写管理push，pop放回按钮等.
    2、navigation controller不可以push容器VC，例如tab Bar VC ， navigation VC，但是可以present容器VC。
 */

class MyNavigation_NaviVC: UINavigationController {
    //MARK: 对外属性
    //TODO: 自己管理侧滑手势
    /**
        1、设置了leftbaritem之后，系统的侧滑手势就会失效，所以要自己来管理侧滑手势的动作方法。
        2、避免在根控制器中侧滑，导致app假死状态，所以需要加判断。
            控制手势 只有在非根控制器 才需要触发，不然会出现假死状态，因为你pop了根控制器。
        3、尽量不要修改系统的侧滑控制器，可以借用，但是不要修改咯。
     
        self.interactivePopGestureRecognizer?.delegate = self   ///弹出栈的手势
     */

    /// 是否全屏手势滑动出栈
    var isFullPopGesture:Bool = false{
        didSet{
            if let popGesture = self.interactivePopGestureRecognizer {
                /// 借用之前弹出手势的代理，可以打印一下之前的弹出手势看一下target，action这些是什么。
                if popPanGesture == nil {
                    popPanGesture = UIPanGestureRecognizer(target: popGesture.delegate, action: Selector(("handleNavigationTransition:")))
                    self.view.addGestureRecognizer(popPanGesture!)
                    popPanGesture!.delegate = self
                }
                popPanGesture?.isEnabled = isFullPopGesture
                popGesture.isEnabled = !isFullPopGesture    ///禁止之前的弹出手势
            }
        }
    }
    
    /// 是否自定义侧滑返回按钮
    var isDefLeftbarItem:Bool = false {
        didSet{
            if let popGesture = self.interactivePopGestureRecognizer {
                /// 借用之前弹出手势的代理，可以打印一下之前的弹出手势看一下target，action这些是什么。
                if popEdgeGesture == nil {
                    popEdgeGesture = UIScreenEdgePanGestureRecognizer(target: popGesture.delegate, action: Selector(("handleNavigationTransition:")))
                    popEdgeGesture!.delegate = self
                    popEdgeGesture!.edges = UIRectEdge.left
                    self.view.addGestureRecognizer(popEdgeGesture!)
                }
                /// 自定义返回按钮的样式
                popEdgeGesture?.isEnabled = isDefLeftbarItem
                popGesture.isEnabled = !isDefLeftbarItem    ///禁止之前的弹出手势
            }
        }
    }
    
    
    //MARK: 内部属性
    private var popPanGesture:UIPanGestureRecognizer?   /// 自定义的全屏侧滑返回手势
    private var popEdgeGesture:UIScreenEdgePanGestureRecognizer?     /// 自定义的侧滑返回手势
    
    /// 重写初始化方法，在这里设置全局的导航栏UI
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        /// 设置导航栏为不透明,默认是透明，会影响到布局。
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = .black   /// 小组件图片的透明通道的渲染颜色
        
        //TODO: 设置导航栏bar的Appearance
        /**
            1、Appearance属性影响的是整个navigationBar的类，而不是实例，所以是一个全局的属性。
            2、standardAppearance是普通的外观管理，scrollEdgeAppearance是当导航子vc里有scrollview时的外观管理。
                当scrollEdgeAppearance = nil时 ，如果当前界面中使用了 ScrollView ，当 ScrollView 向上滚动时，
                scrollEdgeAppearance 会默认使用 standardAppearance，此时的透明可能就无效。
         */
        if #available(iOS 13.0, *) {
            print("导航栏bar的standardAppearance：\(self.navigationBar.standardAppearance)")
            print("导航栏bar的scrollEdgeAppearance：\(String(describing: self.navigationBar.scrollEdgeAppearance))")
            let appearence = UINavigationBarAppearance()
            appearence.configureWithOpaqueBackground()  //在设置appearence的属性值前，必须先调用配置方法。
            appearence.backgroundEffect = nil       //基于 backgroundColor 或 backgroundImage 的磨砂效果
            appearence.backgroundImage = UIImage(named: "labi02")   //只是为磨砂效果提供素材而已。
            appearence.backgroundColor = UIColor.yellow.withAlphaComponent(0.5) //设置bar透明或者有backgroundImage时无效，因为在backgroundImage视图层次之下。

            appearence.shadowImage = nil    //设置为nil，则UIKit会默认提供一个shadow，但是如果shadowColor也是nil，则不再显示shadow。
            appearence.shadowColor = nil
            

            self.navigationBar.standardAppearance = appearence
            self.navigationBar.scrollEdgeAppearance = appearence

            self.navigationBar.setBackgroundImage(MyImageTool.getColorImg(alpha: 0.8), for: .default)
        }else{
            self.navigationBar.setBackgroundImage(UIImage(named: "labi02"), for: .default)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
   
    deinit{
        print("navigation VC 销毁了～ \(#function)")
    }
    
}
//MARK: - 复写栈管理方法
extension MyNavigation_NaviVC {
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        print("MyNavigation_NaviVC 的\(#function) 方法")
        //TODO: 自定义返回按钮，手势失效。
        /**
         1、把系统的返回按钮覆盖 -> 1.手势失效(1.手势被清空 2.可能是手势代理做了一些事情,导致手势失效)
         */
        if isDefLeftbarItem {
            if self.children.count > 0 {
                viewController.navigationItem.leftBarButtonItem = MyNaviTool.getUIBarButtonItem(img: UIImage(named: "naviBar_back")!, highImg: UIImage(named: "naviBar_back_click")!, target: self, action: #selector(self.back))
            }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MyNavigation_NaviVC 的\(#function) 方法")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

//MARK: - 遵循手势协议
extension MyNavigation_NaviVC : UIGestureRecognizerDelegate{
 
    /// 决定是否触发手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return self.children.count > 1
    }
}
