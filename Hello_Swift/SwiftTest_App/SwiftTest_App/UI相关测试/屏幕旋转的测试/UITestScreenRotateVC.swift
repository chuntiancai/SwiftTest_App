//
//  UITestScreenRotateVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/28.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试屏幕旋转，设备方向的VC
//MARK: - 笔记
/**
    1、如果手机上已经设置了锁定按钮，那么代码这里将会监听不到设备方位的变化。
        iPhone 默认竖屏展示, 当系统屏幕旋转开关未锁定时, 就可以自由的转动, 值得注意的是iPhone 不支持旋转到 Upside Down 方向，ipad支持。
 
    2、设置项目支持的方位的方式：
        方式一：项目 -> TARGET -> General -> Deployment Info。
        方式二：实现Appdelegate 的supportedInterfaceOrientationsForWindow 方法。
                优先级：Appdelegate方法 > TARGET 配置。
 
    3、shouldAutorotate属性和supportedInterfaceOrientations属性控制VC的屏幕旋转。
        代码可以在三个位置控制屏幕访方向，代码生效优先级依次是 AppDelegate>UITabBarController>UINavigationController>UIViewController
 
    4、横竖屏的坐标系
        App开启横/竖屏切换：
              开启横竖屏时，当屏幕为横屏时，系统window界面会以横屏的左上角为坐标系原点；当屏幕为竖屏时window界面会以竖屏的左上角为坐标系原点。
              横竖屏切换，坐标系切换。
                                           
         App关闭横/竖屏切换：
             关闭横竖屏时，当屏幕为横屏时，系统window界面会以横屏的左上角为坐标系原点；当屏幕为竖屏时window界面会以竖屏的左上角为坐标系原点。
             横竖屏切换，坐标系不会切换，系统会以屏幕的初时坐标系为坐标原点。
 
    5、 UIKit处理屏幕旋转的流程
        UIKit的响应应屏幕旋转的流程如下：
            1、设备旋转的时候，UIKit接收到旋转事件。
            2、UIKit通过AppDelegate通知当前程序的window。
            3、Window会知会它的rootViewController，判断该view controller所支持的旋转方向，完成旋转。
            4、如果存在弹出的view controller的话，系统则会根据弹出的view controller，来判断是否要进行旋转。

       UIViewController实现屏幕旋转如下：
 　　   在响应设备旋转时，我们可以通过UIViewController的方法实现更细粒度的控制，当view controller接收到window传来的方向变化的时候，流程如下：

 　　     1、首先判断当前viewController是否支持旋转到目标方向，如果支持的话进入流程2，否则此次旋转流程直接结束。
 　　     2、调用 willRotateToInterfaceOrientation:duration: 方法，通知view controller将要旋转到目标方向。
 　　        如果该viewController是一个container view controller的话，它会继续调用其content view controller的该方法。
 　　        这个时候我们也可以暂时将一些view隐藏掉，等旋转结束以后在现实出来。
 　　     3、window调整显示的view controller的bounds，由于view controller的bounds发生变化，将会触发 viewWillLayoutSubviews 方法。
 　　        这个时候self.interfaceOrientation和statusBarOrientation方向还是原来的方向。
 　　     4、接着当前view controller的 willAnimateRotationToInterfaceOrientation:duration: 方法将会被调用。
 　　        系统将会把该方法中执行的所有属性变化放到动animation block中。
 　　     5、执行方向旋转的动画。
 　　     6、最后调用 didRotateFromInterfaceOrientation: 方法，通知view controller旋转动画执行完毕。这个时候我们可以将第二步隐藏的view再显示出来。
 　　     
 　　 6、设备的变化方向和当前屏幕界面的方向定义是不一样的。
 　　    设备方向UIDevice.current.orientation强调的是手机设备方向的变化。
 　　    当前屏幕界面的方向preferredInterfaceOrientationForPresentation，是指当前屏幕的方向。
 */

class UITestScreenRotateVC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    
    //MARK: 复写方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "测试屏幕旋转的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        observeDeviceOreintation()
        setTestViewUI()
    }
    
    /// 偏好显示的设备方向(想要显示的方向)
    /// 偏好的屏幕方向 - 只会在 presentViewController:animated:completion时被调用
    /// preferredInterfaceOrientationForPresentation 需要返回 supportedInterfaceOrientations 中支持的方向，不然会发生'UIApplicationInvalidInterfaceOrientation'崩溃.
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get{
            switch preferredInterfaceOrientationForPresentation {
            case .unknown:
                print("屏幕界面方向未知")
            case .portrait:
                print("屏幕界面方向正竖屏")
            case .portraitUpsideDown:
                print("屏幕界面方向反竖屏")
            case .landscapeLeft:
                print("屏幕界面方向左横屏，home键在左")
            case .landscapeRight:
                print("屏幕界面方向未右横屏，home键在右")
            }
            return .portrait
        }
    }
    
    /// 当前VC支持设备方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get{
            print("@@UITestScreenRotateVC supportedInterfaceOrientations ")
            return [.portrait]
        }
    }

    /// 不支持旋转，在设备方向改变时，只会调用根VC(导航VC) 或者模态显示的VC 的这个方法，其他VC不会被调用该方法。
    /** 是否自动旋转，shouldAutorotate返回 YES 表示跟随系统旋转。
    - iOS16.0已过期, 不会再调用.
    - iOS16.0 之前, 先调用supportedInterfaceOrientations 确定支持的屏幕方向, 再调用shouldAutorotate 是否自动旋转, 来确定控制器方向.
    - iOS16.0 之前, preferredInterfaceOrientationForPresentation 并未调用.
    - iOS16.0 之前, return NO 之后, 当前控制器都支持屏幕旋转了
    */
    override var shouldAutorotate: Bool{
        get{
            print("@@UITestScreenRotateVC shouldAutorotate ")
            return false
        }
        
    }
    /// 这个是自定义的标志
    private var isFullScreen:Bool = false { //隐藏状态栏
        didSet{
            setNeedsStatusBarAppearanceUpdate() //更新状态栏的显示，回调prefersStatusBarHidden方法
        }
    }
    
    /// 是否显示状态栏
    override var prefersStatusBarHidden: Bool {
        get{
            if isFullScreen {
                return true
            }else{
                return false
            }
        }
    }
    
    /// 该方法会询问当前VC是否旋转
    override class func attemptRotationToDeviceOrientation() {
        print("@@UITestScreenRotateVC attemptRotationToDeviceOrientation ")
        super.attemptRotationToDeviceOrientation()
    }

    deinit {
        print("UITestScreenRotateVC 的 \(#function) 方法～")
        NotificationCenter.default.removeObserver(self)
        //关闭设备监听
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension UITestScreenRotateVC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            print("     (@@")
            let batteryOreint = UIApplication.shared.statusBarOrientation   //电池方向
            let deviceOreint = UIDevice.current.orientation     //设备方向
            UIApplication.shared.statusBarOrientation = .landscapeLeft
            break
        case 1:
            print("     (@@landscapeLeft")
            UIDevice.current.setValue(UIDeviceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            
        case 2:
            print("     (@@landscapeRight")
            UIDevice.current.setValue(UIDeviceOrientation.landscapeRight.rawValue, forKey: "orientation")
        case 3:
            print("     (@@")
            UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
        case 4:
            print("     (@@")
        case 5:
            print("     (@@")
        case 6:
            print("     (@@")
        case 7:
            print("     (@@")
        case 8:
            print("     (@@")
        case 9:
            print("     (@@")
        case 10:
            print("     (@@")
        case 11:
            print("     (@@")
        case 12:
            print("     (@@")
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collDataArr.count
    }
    
    ///设置cell的UI
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView_Cell_ID", for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        cell.backgroundColor = .lightGray
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: cell.frame.size.width-20, height: cell.frame.size.height));
        label.numberOfLines = 0
        label.textColor = .white
        cell.layer.cornerRadius = 8
        label.text = collDataArr[indexPath.row];
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        cell.contentView.addSubview(label)
        
        return cell
    }
    
}

//MARK: - 测试辅助方法
extension UITestScreenRotateVC{
    
    //TODO: 开启监听设备方向
    private func observeDeviceOreintation(){
        //感知设备方向 - 开启监听设备方向
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        //添加通知，监听设备方向改变
        NotificationCenter.default.addObserver(self, selector: #selector(self.observeOrientationAction),
                                               name: UIDevice.batteryStateDidChangeNotification, object: nil)
        
        //关闭设备监听
        //UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
}

//MARK: - 动作方法
@objc extension UITestScreenRotateVC{
    
    // 监听到设备方向的变化
    /**
        
    */
    private func observeOrientationAction(){
        let device = UIDevice.current
        switch device.orientation{
        case .portrait:
            print( "UITestScreenRotateVC 面向设备保持垂直，Home键位于下部")
        case .portraitUpsideDown:
            print( "UITestScreenRotateVC 面向设备保持垂直，Home键位于上部")
        case .landscapeLeft:    // 向左旋转
            print( "UITestScreenRotateVC 面向设备保持水平，设备顶部在左侧，也就是Home在右侧")
        case .landscapeRight:    // 向右旋转
            print( "UITestScreenRotateVC 面向设备保持水平，设备顶部在右侧，也就是Home在左侧")
        case .faceUp:
            print( "UITestScreenRotateVC 设备平放，设备顶部在上")
        case .faceDown:
            print( "UITestScreenRotateVC 设备平放，设备顶部在下")
        case .unknown:
            print( "UITestScreenRotateVC 方向未知")
        default:
            print( "UITestScreenRotateVC default")
        }
    }
    
}


//MARK: - 工具方法
@objc extension UITestScreenRotateVC{
    
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}


//MARK: - 设计UI
extension UITestScreenRotateVC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        
        self.edgesForExtendedLayout = .bottom   //设置从导航栏底部开始显示UI
        
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
//        layout.headerReferenceSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: 130)
        layout.itemSize = CGSize.init(width: 80, height: 80)
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:SCREEN_HEIGHT/2),
                                             collectionViewLayout: layout)
        baseCollView.backgroundColor = UIColor.cyan
        baseCollView.delegate = self
        baseCollView.dataSource = self
        // register cell
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
    
    /// 设置测试的UI
    private func setTestViewUI(){
        let rView = TestScreenRotateView()
        rView.backgroundColor = .brown
        self.view.addSubview(rView)
        rView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension UITestScreenRotateVC: UICollectionViewDelegate {
    
}
