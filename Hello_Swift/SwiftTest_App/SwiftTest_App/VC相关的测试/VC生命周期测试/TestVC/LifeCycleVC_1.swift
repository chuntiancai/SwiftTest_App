//
//  LifeCycleVC_1.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/26.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 被测试生命周期的VC

import UIKit

class LifeCycleVC_1: UIViewController {
    
    //测试UI
    let redBtn = UIButton()

    
    //MARK: 顺序0， 去寻找nib文件
    override var nibName: String?{
        get{
//            print("顺序0，LifeCycleVC_1 nibName")
            return super.nibName
        }
    }
    
    //MARK: 顺序1，加载View进内存，此时还没有加载，是去加载（VC自创建View，或者从nib文件中加载），懒加载
    override func loadView(){
        self.view = LifeCycleVC_View()
        print("顺序1，LifeCycleVC_1 的 \(#function)方法")
    }
    
    //MARK: 顺序2，VC 的view是否被加载进内存了
    override var isViewLoaded: Bool {
        get{
//            print("顺序2，LifeCycleVC_1 isViewLoaded:\(super.isViewLoaded)")
            return super.isViewLoaded
        }
    }
    
    //MARK: 顺序3，好像每设置一次VC的属性，都会先去寻找是否有父VC
    override var parent: UIViewController? {
        get{
//            print("顺序3，LifeCycleVC_1 parent:\(String(describing: super.parent))")
            return super.parent
        }
    }
    
    //MARK: 顺序4，View已经全部加载进内存了，在isViewLoaded与viewDidLoad之间还会多次访问parent， 猜测是去看看父VC的View是否也加载完毕，所有都加载完毕才算完毕。
    override func viewDidLoad() {
        super.viewDidLoad()
        print("顺序4，LifeCycleVC_1 的 \(#function)方法 -- \(self.view)")
        self.title = "LifeCycleVC_1"
        self.view.backgroundColor = .brown
        redBtn.addTarget(self, action: #selector(clickRedBtn(_:)), for: .touchUpInside)
        redBtn.backgroundColor = .red
        self.view.addSubview(redBtn)
        redBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(60)
        }
        
    }
    
    //MARK: 顺序4，当作为别人儿子时，会调用该方法，询问是不是作为presentedViewController，还是作为儿子
    override var presentedViewController: UIViewController?{
        get{
            print("顺序4，LifeCycleVC_1 presentedViewController：\(String(describing: super.presentedViewController))")
            return super.presentedViewController
        }
    }
    
    //MARK: 顺序5，自己的View将要显示，然后还是会多次访问isViewLoaded方法，但是不会再回调viewDidLoad方法
    override func viewWillAppear(_ animated: Bool) {
//        self.view.backgroundColor = .red
        print("顺序5，LifeCycleVC_1 的 \(#function)方法")
        super.viewWillAppear(animated)
    }
    //MARK: 顺序6，自己的View将要布局子view，这个逻辑或View的布局逻辑一样，当View中的子view的frame多次发生变化时，就多次调用。 然后就是同步调用viewDidLayoutSubviews
    override func viewWillLayoutSubviews() {
        print("顺序6，LifeCycleVC_1 的 \(#function)方法")
        super.viewWillLayoutSubviews()
    }
    //MARK: 顺序7，自己的View已经布局完子view，也就是所有的约束条件已经计算好了
    override func viewDidLayoutSubviews() {
        print("顺序7，LifeCycleVC_1 的 \(#function)方法")
        super.viewDidLayoutSubviews()
    }
    
    //MARK: 顺序8，这里View的所有View以及自身已经布局完毕，约束也计算好了，view已经显示到屏幕上了。
    override func viewDidAppear(_ animated: Bool) {
        print("顺序8，LifeCycleVC_1 的 \(#function)方法")
        super.viewDidAppear(animated)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("LifeCycleVC_1 的 \(#function)方法")
    }
   
    
    override func loadViewIfNeeded (){
        super.loadViewIfNeeded()
        print("LifeCycleVC_1 的 \(#function)方法")
    }
    override var viewIfLoaded: UIView? {
        get{
            print("LifeCycleVC_1 的 \(#function)方法")
            return super.viewIfLoaded
        }
    }
    
    //MARK: 用于与其他VC建立父子关系，但是还是要手动将其他VC的View添加到自己的View图层里，VC的层次与View的层次是独立的。 如果没有建立VC的层次关系，那么VC之间的事件不会传递。我试试VC绑定的View之间的事件传递,View之间依然会有事件传递，但是VC之间已经没有事件传递了， 所以View和VC是两个相对独立的传递机制。
    override func addChild(_ childController: UIViewController) {
        print("LifeCycleVC_1 的 \(#function)方法")
        super.addChild(childController)
    }
  
    override var nibBundle: Bundle?{
        get{
            print("LifeCycleVC_1 的 \(#function)方法")
            return super.nibBundle
        }
    }
    
    override var storyboard: UIStoryboard?{
        get{
            print("LifeCycleVC_1 的 \(#function)方法")
            return super.storyboard
        }
    }

    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        print("LifeCycleVC_1 的 \(#function)方法")
        super.performSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("LifeCycleVC_1 的 \(#function)方法")
        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("LifeCycleVC_1 的 \(#function)方法")
        super.prepare(for: segue, sender: sender)
    }

    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, sender: Any?) -> Bool {
        print("LifeCycleVC_1 的 \(#function)方法")
        if #available(iOS 13.0, *) {
            return super.canPerformUnwindSegueAction(action, from: fromViewController, sender: sender)
        } else {
            // Fallback on earlier versions
            return false
        }
    }
   
    override func allowedChildrenForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        print("LifeCycleVC_1 的 \(#function)方法")
        return super.allowedChildrenForUnwinding(from: source)
    }
    
    override func childContaining(_ source: UIStoryboardUnwindSegueSource) -> UIViewController? {
        print("LifeCycleVC_1 的 \(#function)方法")
        return super.childContaining(source)
    }

    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        print("LifeCycleVC_1 的 \(#function)方法")
        super.unwind(for: unwindSegue, towards: subsequentVC)
    }

    
    //MARK: 顺序9，VC的view将要从图层移除时，调用该方法。之后会调用多次parent和isViewLoaded方法。猜测是处理父VC的逻辑， 这里也可以做一些改变状态栏之类的动作，之后会在viewDidDisappear中完成这些效果的动作。
    override func viewWillDisappear(_ animated: Bool) {
        print("LifeCycleVC_1 的 \(#function)方法")
        super.viewWillDisappear(animated)
    }
    
    //MARK: 顺序10，VC的view已经从图层中移除完毕时，回调该方法。该方法的调用与VC的父子关系是独立的，即VC的层次关系不影响该方法的回调。
    override func viewDidDisappear(_ animated: Bool) {
        print("LifeCycleVC_1 的 \(#function)方法")
        super.viewDidDisappear(animated)
        print("LifeCycleVC_1 的 测滑手势：\(self.navigationController?.interactivePopGestureRecognizer?.state)")
    }

    override func didReceiveMemoryWarning(){
        print("LifeCycleVC_1 的 \(#function)方法")
        super.didReceiveMemoryWarning()
    }

    
    
    override var isBeingPresented: Bool{
        get{
            return super.isBeingPresented
        }
    }
    
    override var isBeingDismissed: Bool{
        get{
            return super.isBeingDismissed
        }
    }
    
    override var isMovingToParent: Bool{
        get{
            return super.isMovingToParent
        }
    }
    
    override var isMovingFromParent: Bool{
        get{
            return super.isMovingFromParent
        }
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
    }
    
    
    /**
     @property(nullable, nonatomic,readonly) UIViewController *presentingViewController API_AVAILABLE(ios(5.0))(){}

    
     @property(nonatomic,assign) BOOL definesPresentationContext API_AVAILABLE(ios(5.0))(){}

     
     @property(nonatomic,assign) BOOL providesPresentationContextTransitionStyle API_AVAILABLE(ios(5.0))(){}

     
     @property (nonatomic) BOOL restoresFocusAfterTransition API_AVAILABLE(ios(10.0))(){}
     

     
     @property(nonatomic,assign) UIModalTransitionStyle modalTransitionStyle API_AVAILABLE(ios(3.0))(){}

     
     @property(nonatomic,assign) UIModalPresentationStyle modalPresentationStyle API_AVAILABLE(ios(3.2))(){}

     
     @property(nonatomic,assign) BOOL modalPresentationCapturesStatusBarAppearance API_AVAILABLE(ios(7.0)) API_UNAVAILABLE(tvos)(){}

     
     @property(nonatomic, readonly) BOOL disablesAutomaticKeyboardDismissal API_AVAILABLE(ios(4.3))(){}

    
     @property (nonatomic) CGSize preferredContentSize API_AVAILABLE(ios(7.0))(){}

     
     @property(nonatomic, readonly) UIStatusBarStyle preferredStatusBarStyle API_AVAILABLE(ios(7.0)) API_UNAVAILABLE(tvos)(){}
     @property(nonatomic, readonly) BOOL prefersStatusBarHidden API_AVAILABLE(ios(7.0)) API_UNAVAILABLE(tvos)(){}
     @property(nonatomic, readonly) UIStatusBarAnimation preferredStatusBarUpdateAnimation API_AVAILABLE(ios(7.0)) API_UNAVAILABLE(tvos)(){}

    
     override func setNeedsStatusBarAppearanceUpdate API_AVAILABLE(ios(7.0)) API_UNAVAILABLE(tvos)(){}

     - (nullable UIViewController *)targetViewControllerForAction:(SEL)action sender:(nullable id)sender API_AVAILABLE(ios(8.0))(){}

     
     override func showViewController:(UIViewController *)vc sender:(nullable id)sender API_AVAILABLE(ios(8.0))(){}

     
     override func showDetailViewController:(UIViewController *)vc sender:(nullable id)sender API_AVAILABLE(ios(8.0))(){}

     
     @property (nonatomic, readonly) UIUserInterfaceStyle preferredUserInterfaceStyle API_AVAILABLE(tvos(11.0)) API_UNAVAILABLE(ios) API_UNAVAILABLE(watchos)(){}

     override func setNeedsUserInterfaceAppearanceUpdate API_AVAILABLE(tvos(11.0)) API_UNAVAILABLE(ios) API_UNAVAILABLE(watchos)(){}

     
     @property (nonatomic) UIUserInterfaceStyle overrideUserInterfaceStyle API_AVAILABLE(tvos(13.0), ios(13.0)) API_UNAVAILABLE(watchos)(){}
     */
    
    

}

@objc extension LifeCycleVC_1{
    
    func clickRedBtn(_ sender:UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

//MARK: - 笔记
/**
    1、如果vc是栈中间的VC，那么直接poptoroot时，栈中间的VC的viewDidDisappear这些方法不会被调用。被pop和push时，vc的这些viewDidDisappear方法会被调用，然后测滑手势也会调用这些方法。
 */
