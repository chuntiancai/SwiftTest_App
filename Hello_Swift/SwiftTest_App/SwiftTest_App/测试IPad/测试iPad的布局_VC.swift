//
//  测试IPad的布局_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/24.
//  Copyright © 2022 com.mathew. All rights reserved.
//

//测试IPad布局的VC
// MARK: - 笔记
/**
    1、手工代码、Autoresizing、AutoLayout、UIStackView、SizeClass五种方案来布局IPad。
        1.1、SizeClass是响应式布局用来提供断点的。所谓断点，就是一个分界线，在这个分界线的两边，我们会采取不同的布局策略。
             目前在 iPhone 竖屏时，horizontalSizeClass都是Compact，其他情况比较复杂，参考官方文档，不展开赘述；
 
             在 iPad 上，全屏和横屏2/3分屏都是Regular；横屏1/2分屏时，只有 12.9 寸的 iPad 是Regular；除此之外的其他情况都是Compact。
 
        1.2、storyboard中的SizeClass，针对于某一个约束而言：
                storyboard文件 -> 右侧工具栏 -> attribute 面板 -> 最底部的installed栏 -> + 号 -> Add variation。
 
                这时就可以添加compact和regular布局的约束了。w：宽度，h：高度，c：compact(紧凑)，r：regular(宽松)。
 
                installed的意思是：该约束是否安装到当前的SizeClass模式下，如果安装，则安装，不安装则不安装。
 
                🌟注意：竖屏不一定是compact，也可以是reguar。


    2、ipad的window大小取决于启动图片Brand Asset 的大小，所以最后还是用Launch screen来做启动页面，启动图片已经被丢弃了。
 
    3、traitCollection属性：是UIView，UIViewController，UIWindow，UIWindowScene和UIScreen等的属性。
                          当UI发生变化的时候，UI变化的相关属性就会反应在这个traitCollection属性中，它是一个集合。
        3.1、Transition 是指 vc 将会变化时，变化的新属性集合会在 traitCollection 这个属性集合中。(UITraitCollection)
             traitCollection‌ 属性集合常用的属性有：纵横宽度的 sizeClass，是否是 darkMode 等属性。
             发生变化的时候，会回调VC的viewWillTransition方法和willTransition方法，所以你可以重写这两个方法。
 
        3.2、所谓Size Class，其实就是UITraitCollection中的horizontalSizeClass属性和verticalSizeClass属性。
 
    4、监听横竖屏切换的三种方式：
        4.1、一：通知：监听UIDevice.orientationDidChangeNotification通知。
        4.2、二：vc的view界面发生旋转时的回调方法，viewWillTransition方法。
        4.3、三：vc布局子view时的方法,viewWillLayoutSubviews方法。
        所以你可以根据横竖屏状态来设置不同的左右布局。
 
    5、UIPopoverController在iOS9已经被丢弃了，现在可以通过设置VC的modalPresentationStyle属性来进行模态显示。
        enum UIModalPresentationStyle :
            case fullScreen = 0     //全屏，会暂时presentation context底下的UI栈。
            case pageSheet = 1      //浮窗大小是系统根据系统字体大小确定的，不能修改大小
            case formSheet = 2      //浮窗，可以通过 vc 的 preferredContentSize 来指定实际大小。
            case currentContext = 3     //presented VC的宽高取决于presentation context的宽高。也会暂时移除presentation context的UI栈。
            case custom = 4     //需要自己实现相关的代理。UIViewControllerTransitioningDelegate。
            case overFullScreen = 5     //不会移除presentation context底下的UI栈。presentation context可能是presenting vc，也可能是rootVC。
            case overCurrentContext = 6     //不会移除presentation context底下的UI栈。
            case popover = 7    //需要自定义设置浮窗的source view和source rect，有个小箭头的样式。
            case none = -1      //仅用作返回值，表示没有在模态展示VC。
            case automatic = -2     //由系统决定是哪一种样式。
 
    6、UISplitViewController：主要用于在宽屏情况下并列显示多个视图。
        6.1、多种显示模式，用DisplayMode来表示：Master / Primary：两栏时，展示在左侧的单栏。Detail / Secondary：两栏时，展示在右侧的详细页面。
                简单概括：Bseide 意为并列显示，over 意为上层会覆盖下层的一个部分，Displace 意为上层会挤开下层。
        6.2、iOS14之前，UISplitViewController并列显示只支持两栏，iOS14及之后，支持并列多栏。
            iOS14:
                    1.SplitVC 会自动把所有的 childVC 用 navigationController 包住。
                      如果设置的时候没有提供 navigationController，SplitVC 会自动创建一个。
                      通过 SplitVC 的 children 属性可以找到 navigationController。
                    2.用 show(_:) 或者 hide(_:) 来展示或隐藏指定列。
                    3.用 setViewController(_:for:) 来设置 VC 应该展示在哪一列。
                    4.用 viewController(for:) 来获取指定列的 VC。

            iOS14之前：
                    1.传统风格的 SplitVC一般作为root VC。（只支持 master & detail 的显示，不支持更多栏）。
                    2.如果需要，应该手动为 master 和 detail 设置 navigationController 以实现路由跳转。
                    3.直接设置 viewControllers 属性，默认第一个为 master，第二个为 detail，会忽略更多（如果有）。
                    4.使用 show(_:sender:) 来在 master 中找到 navigationController 进行 push vc。
                    5.使用 showDetailViewController(_:sender:) 来 在 detail 中找到 navigationController 进行 push vc。


 
 */

class TestiPadLayout_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]
    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "测试iPad布局的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
        //监听横竖屏切换。
        NotificationCenter.default.addObserver(self, selector: #selector(changeScreenOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //vc的view界面发生旋转时回调
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("vc的view界面发生旋转时：\(size) -- \(coordinator)")
    }
    
    //vc布局子view时的方法
    override func viewWillLayoutSubviews() {
        print("vc布局子view时的方法:\(#function)")
    }
    
    required init?(coder: NSCoder) {
        print("TestiPadLayout_VC的:\(#function)方法~")
        super.init(coder: coder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestiPadLayout_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestiPadLayout_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试iPad的模态显示VC。
            print("     (@@ 0、测试iPad的模态显示VC。")
            let popVC = UIViewController()
            popVC.modalPresentationStyle = .popover
            popVC.popoverPresentationController?.sourceView = self.view
            popVC.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 300, width: 100, height: 100)
            popVC.popoverPresentationController?.passthroughViews = [self.view]   //已经pop出来之后，仍然可以与用户交互的view
            popVC.view.backgroundColor = .white
            self.present(popVC, animated: true)
            
        case 1:
            //TODO: 1、测试iOS14之前的UISplitViewController。
            print("     (@@ 1、测试iOS14之前的UISplitViewController。")
            
            let vc1 = TestSpilt_SubVC1()
            vc1.view.backgroundColor = .red
            let nav1 = UINavigationController(rootViewController: vc1)
            
            let vc2 = TestSpilt_SubVC2()
            vc2.view.backgroundColor = .blue
            let nav2 = UINavigationController(rootViewController: vc2)
            
            let spiltVC = UISplitViewController()
            //如果没有设置delegate，那么当Split View进入Portrait模式的时候左侧就会消失，你应该在角落里放一个小按钮，使用户可以点击它来让左侧出现
            spiltVC.delegate = self
            spiltVC.viewControllers = [nav1,nav2]
            
//            spiltVC.show(vc1, sender: nil)
//            spiltVC.show(vc2, sender: nil)
            spiltVC.preferredDisplayMode = .automatic
            
            let app = UIApplication.shared.delegate as! AppDelegate
            if app.firstWindow.rootViewController != nil {
                app.firstWindow.makeKeyAndVisible()
                return
            }
            app.firstWindow.rootViewController = spiltVC
            app.firstWindow.makeKeyAndVisible()

        case 2:
            //TODO: 2、
            print("     (@@ 2、")
        case 3:
            //TODO: 3、
            print("     (@@ 3、")
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
    
}
//MARK: - 动作方法
@objc extension TestiPadLayout_VC{
   
    //MARK: 0、横竖屏切换
    func changeScreenOrientation(){
        print("发生了横竖屏切换：\(#function)")
    }
    
}

//MARK: - 遵循分割VC的协议，UISplitViewControllerDelegate协议
extension TestiPadLayout_VC: UISplitViewControllerDelegate{
   
    //TODO: SplitVC的显示状态发生变化时调用，例如master VC将要隐藏时触发。
    /**
        1、你要监听横竖屏状态的变化，手动设置DisplayMode，不然横屏变竖屏的时候维持你设置preferredDisplayMode状态。
     */
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        print("UISplitViewControllerDelegate的：\(#function)方法～ model:\(displayMode.rawValue) --vc:\(svc)")
    }
    
    
}

//MARK: - 设置测试的UI
extension TestiPadLayout_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        /// 内容背景View，测试的子view这里面
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
}


//MARK: - 设计UI
extension TestiPadLayout_VC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 40)
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 0, right: 5)
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:200),
                                             collectionViewLayout: layout)
        
        baseCollView.backgroundColor = UIColor.cyan.withAlphaComponent(0.8)
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
        baseCollView.layer.borderWidth = 1.0
        baseCollView.layer.borderColor = UIColor.gray.cgColor
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestiPadLayout_VC: UICollectionViewDelegate {
    
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
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}



