//
//  TestNavibarUI_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/2.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试VC的导航栏对view布局的影响,测试edgesForExtendedLayout属性、automaticallyAdjustsScrollViewInsets属性
// MARK: - 笔记
/**
    1、edgesForExtendedLayout设置了vc的view的布局开始参考点，但是要结合安全区域的内边距来判断、要结合self.navigationController?.navigationBar.isTranslucent的透明度来判断，如果导航栏透明度是透明，则按照edgesForExtendedLayout有效，否则edgesForExtendedLayout无效，还是按照从导航栏下方开始布局。
 
    2、UIBarItem : NSObject
        UIBarItem 类是一个可以放置在 Bar 之上的所有小控件类的抽象类。
      
      UIBarButtonItem : UIBarItem
        类似 UIButton 。放在 UINavigationBar 或者 UIToolbar 上。
        重点属性: customView
      
      UINavigationItem : NSObject
        包含了当前页面导航栏上需要显示的全部信息
        title、prompt、titleView、leftBarButtonItem、rightBarButtonItem、backBarButonItem
        UIViewController 有一个 navigationItem 属性，通过这个属性可以来设置导航栏上的布局。
 
      UINavigationBar : UIView
        管理一个存放 UINavigationItem 的栈
 
    小结:
        设置导航栏上按钮的布局，使用 UIViewController 的 navigationItem 属性来设置其二级 leftBarButtonItem 、 rightBarButtonItem、backBarButonItem、leftBarButtonItems、rightBarButtonItems
        设置导航栏的背景色就设置 self.navigationController.navigationBar
    注意:
        backBarButtonItem 就是我们平时使用的返回箭头后面的按钮，我们通常会设置其 title 为 nil ，这个按钮自带返回事件。如果我们设置了 leftBarButtonItem 或者 leftBarButtonItems ，backBarButonItem 将会失效。
    
    3、如果要隐藏导航栏，可以self.navigationController?.navigationBar.isHidden = true，但是在disappear方法，记得设置为false， 因为这个影响的是整个navigationController。你也可以在自己定义的返回上一层方法中设置回false。
 
    4、导航栏的内容由栈顶控制器来决定，栈里面的vc和导航栏是同一层次的视图，由navigationVC来管理，都隶属于navigationVC。只是sdk中，vc提供了接口来操作导航栏的内容。
       所以vc的接口是间接操作了navigationVC的导航栏。
 
    5、self.navigationController?.navigationBar用于设置全局的bar，self.navigationItem用于设置当前页面的bar。
 
    6、要设置导航栏透明，则需要同时设置navigationBar.isTranslucent = true，并且赋值给导航栏背景图片一个空图片navigationBar.setBackgroundImage(UIImage(), for: .default)。当背景图片设置为nil时，系统会为你自动生成一张白色的半透明图片作为背景图片。
      导航栏的标题控件设置透明度无效，但是可以通过设置label的textcolor来实现透明效果。

    7、如果设置了导航栏的leftBarButtonItems返回按钮，则会没有滑动返回的手势，所以你需要设置self.navigationController?.interactivePopGestureRecognizer.delegate = nil，把手势的代理给去掉，但是这时候有一个问题，就是第一个进入的导航栈的VC不能出栈，但是你已经把手势代理去掉了，所以还是存在这个手势，所以你要在根VC的时候还原interactivePopGestureRecognizer.delegate代理为导航栏VC原来的代理。
 
    8、iOS 13 之后，要用navigationBar.standardAppearance、scrollEdgeAppearance属性, scrollEdgeAppearance用于导航栏下方是scrollview时的情况，默认会根据偏移做调整。
 
 */

class TestNavibarUI_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试VC的导航栏"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        self.additionalSafeAreaInsets = UIEdgeInsets.init(top: -vg_navigationFullHeight(), left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

}
//MARK: - 设置测试的UI
extension TestNavibarUI_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestNavibarUI_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、设置导航栏透明
            /**
                1、navigationBar.isTranslucent、vc.extendedLayoutIncludesOpaqueBars、vc.edgesForExtendedLayout属性：
                    
                   优先级：navigationBar.isTranslucent --> vc.extendedLayoutIncludesOpaqueBars --> vc.edgesForExtendedLayout
             
                   isTranslucent属性：默认是true。
                                     没有手动设置它的值时，当你设置bar的背景图片透明通道是非透明时，自动变成false。
                                     没有手动设置它的值时，当你设置的图片alpha透明值小于1.0时，自动变成true。
                                     当你手动设置为true时，设置bar图片非透明时，UIKit会自动为你添加一张有透明度的图片，即alpha值小于1的背景图片。
                                     当你手动设置为false时，设置bar图片alpha小于1.0 时，UIKit会自动为你添加一张不透明的图片，即alpha=1的背景图片。
                                     
                                     所以，当你设置为true，而且提供透明度的图片时，才可以达到透明的效果。只有该值为true时，extendedLayoutIncludesOpaqueBars的值才有效。
             
                   extendedLayoutIncludesOpaqueBars属性：决定了在isTranslucent为true的情况下，edgesForExtendedLayout是否有效。
                              意思是延伸vc的View的布局时包含不包含不透明的Bar,是用来指示vc的View布局的延伸包不包括导航栏。
                              而当我们设置一张不透明的图片作为导航栏背景时,该属性就会自动变成false,然后就从导航栏下方开始布局。
                              所以这也是一个标识器的作用，并没有实际改变UI布局。
             
                   edgesForExtendedLayout属性：默认是.all,也就是vc的view延伸到屏幕四边布局，top是屏幕顶部，bottom是屏幕底部，all是到屏幕所有。
                                              []是空，  即不延伸到屏幕四边。
                                    这是一个位移枚举，可以设置多个值。决定了VC的view的起始点。
                                    当isTranslucent为true时，该属性才有效。UIKit会根据isTranslucent的值提供默认的背景图。
                                    当你移除这个属性的某个边缘值时，UIKit同时也会在其他 系统条栏UI 的这个边缘上，不再按照着这个边缘来参考布局。
                                    
                                    
                
                   
                
                2、可以通过navigationBar.isHidden属性直接隐藏导航栏，到时候又出来就可以了。
                    
             */
            print("测试设置导航栏的UI")
            self.navigationController?.navigationBar.isTranslucent = true
            self.extendedLayoutIncludesOpaqueBars = true
            self.edgesForExtendedLayout = [.all]
            self.navigationController?.navigationBar.setBackgroundImage(getColorImg(alpha: 0.2,UIColor.cyan), for: .default)
            
            /**
             ///这样可以去掉导航栏的下划线
             self.navigationController?.navigationBar.shadowImage = UIImage()
             self.navigationController?.navigationBar.isHidden = false
             */
            
            
            //设置子页面的navigation bar的返回按钮样式
            let backItem = UIBarButtonItem(title: "回去", style: .plain, target: self, action: #selector(clickBack(sender:)))
            self.navigationItem.backBarButtonItem = backItem
    //        self.navigationController?.navigationBar.backgroundColor = .red
            
            // 设置当前页面的返回按钮
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "左按钮", style: .plain, target: self, action: #selector(clickBack(sender:)))
            break
        case 1:
            //TODO: 1、测试导航栏的navigationBar.standardAppearance属性，iOS13之后添加。
            /**
             1、standardAppearance: 竖屏时导航栏外观。 scrollView滑动时显示standardAppearance。
                compactAppearance: 横屏时导航栏外观。
                scrollEdgeAppearance: 描述当关联的UIScrollView到达与导航栏邻接的边缘时导航栏的外观。 scrollView处于顶部时显示scrollEdgeAppearance。
​                还可以通过UINavigationBarAppearance对象中的属性设置自定义baritem的外观。
             ​   
                UINavigationBarAppearance还可以设置标题的富文本模式，毛玻璃效果，阴影等效果。
             
                但是修改导航栏的背景和透明度，还是得以navigationBar.isTranslucent为准，navigationBar.isTranslucent的优先级最高。
             
             2、UINavigationBarAppearance的backgroundEffect、backgroundImage、backgroundColor三个属性，都是为磨砂效果服务的。
                backgroundColor的层次在backgroundImage之下，backgroundImage只有在isTranslucent为true时，才显示。
             
                UINavigationBarAppearance的backgroundImage和backgroundColor属性的优先级高于navigationBar.setBackgroundImage。而且appearence.backgroundImage和appearence.backgroundColor是合成展示的，如果appearence.backgroundImage不透明，因为backgroundImage的优先级更高， 所以就直接显示backgroundImage，但是如果backgroundImage是有透明度的，那么就是合成backgroundImage和backgroundColor为一张图片，然后展示合成的图片。
             
                优先级：appearence.backgroundImage > appearence.backgroundColor > navigationBar.setBackgroundImage
             
             3、赋值新对象给navigationBar.standardAppearance是在下一个页面跳转时才会生效，所以要直接修改navigationBar.standardAppearance的属性。
                第一次赋值新对象是马上生效，第二次之后都是下一个跳转页面才生效了。
             */
            print("     (@@ 测试导航栏的standardAppearance属性")
            
            self.navigationController?.navigationBar.isTranslucent = true
            
            if #available(iOS 13.0, *) {
                let appearence = UINavigationBarAppearance()
                appearence.configureWithTransparentBackground()  //在设置appearence的属性值前，必须先调用配置方法。
                appearence.backgroundEffect = nil       //基于 backgroundColor 或 backgroundImage 的磨砂效果
                appearence.backgroundImage = UIImage(named: "labi01")   //只是为磨砂效果提供素材而已。
                appearence.backgroundColor = UIColor.yellow.withAlphaComponent(0.5) //设置bar透明或者有backgroundImage时无效，因为在backgroundImage视图层次之下。

                appearence.shadowImage = nil    //设置为nil，则UIKit会默认提供一个shadow，但是如果shadowColor也是nil，则不再显示shadow。
                appearence.shadowColor = nil

                navigationController?.navigationBar.standardAppearance = appearence
                navigationController?.navigationBar.scrollEdgeAppearance = appearence
                
                self.navigationController?.navigationBar.setBackgroundImage(getColorImg(alpha: 0.9,UIColor.black), for: .default)
                
            } else {
                // Fallback on earlier versions
                print("iOS13之前还是直接用isTranslucent和shadowImage组合")
            }
            
        case 2:
            //TODO: 2、测试UINavigationBarAppearance不会马上更新背景的问题
            print("     (@@ 测试UINavigationBarAppearance不会马上更新背景的问题")
            /**
                1、赋值新对象给navigationBar.standardAppearance是在下一个页面跳转时才会生效，所以要直接修改navigationBar.standardAppearance的属性。
                    第一次赋值新对象是马上生效，第二次之后都是下一个跳转页面才生效了。
             */
            if #available(iOS 13.0, *) {
//                let appearence = UINavigationBarAppearance()
                let appearence = navigationController!.navigationBar.standardAppearance
                appearence.configureWithTransparentBackground()  //在设置appearence的属性值前，必须先调用配置方法。
                appearence.backgroundImage = getColorImg(alpha: 0.5,UIColor.green)    //只是为磨砂效果提供素材而已。
                appearence.backgroundColor = UIColor.brown.withAlphaComponent(0.3)
                
            } else {
                // Fallback on earlier versions
                print("iOS13之前还是直接用isTranslucent和shadowImage组合")
            }
        case 3:
            //TODO: 3、
            print("     (@@")
        case 4:
            //TODO: 4、
            print("     (@@")
        case 5:
            //TODO: 5、
            print("     (@@")
        case 6:
            //TODO: 6、设置导航栏bar里面的item
            print("     (@@ 设置导航栏bar里面的item")
            let titleView = UILabel()
            titleView.layer.cornerRadius = 10
            titleView.layer.borderWidth = 1.0
            titleView.layer.borderColor = UIColor.red.cgColor
            titleView.text = "导航栏的标题view"
            self.navigationItem.titleView = titleView
            titleView.sizeToFit()
            
        /**
         /// 隐藏导航栏返回按钮的标题，把默认的返回按钮的标题向上偏移。不知道为什么无效。
         self.navigationController?.navigationItem.backBarButtonItem?.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -100), for: .default)
         */
        //            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        case 7:
            //TODO: 7、测试导航栏VC左滑返回手势。把 只能左边缘滑动 改为 整个区域左滑 都有效。测滑手势。
            print("     (@@ 测试导航栏VC测滑返回手势。")
            /**
                1、系统自带的左滑返回是一个_UIParallaxTransitionPanGestureRecognizer手势识别器。
                <_UIParallaxTransitionPanGestureRecognizer: 0x7f9b82e08180; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7f9b82e0bba0>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7f9b82e10330>)>
                2、我们去修改这个默认的左滑手势。但是手势的target是私有属性，所以必须通过KVC来找到target。
                    但是我们不知道target的属性名，所以就必须通过OC的runtime机制，但是runtime只能动态获取当前类的成员属性，其父或子类的成员属性不能获得。
                3、但是自定义手势的话，可能会导致根VC的左滑动也生效，但是根VC是不予许出栈的，所以要在根VC的时候，禁止滑动，非根VC的时候，允许滑动退出。
         
            */
            /// 通过runtime机制，测试获取UIGestureRecognizer的所有属性(包括私有)
            /**
                目的：获取vc的interactivePopGestureRecognizer的target属性，然后我们新建一个GestureRecognizer来替换vc的interactivePopGestureRecognizer。
                1、通过runtime获取动态属性名字和类型之后，就可以通过KVC来赋值给私有属性了。
             */
            
            ///<_UIParallaxTransitionPanGestureRecognizer: 0x7feeea60c040; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7feeea70a720>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7feeea60a5f0>)>>
            let gesture: UIGestureRecognizer = self.navigationController!.interactivePopGestureRecognizer!
          
            var memCount:UInt32 = 0
            
            //1、获取属性的名字
            /// cls: 需要被获取成员属性的类
            /// outCount: 被获取类的成员属性的个数，该参数传入指针类型。
            let ivar: UnsafeMutablePointer<Ivar>? = class_copyIvarList(UIGestureRecognizer.self, &memCount)
            for i in 0 ..< memCount {
                let namePoint = ivar_getName(ivar![Int(i)])!
                let name = String(utf8String: namePoint)
                print("UIGestureRecognizer 的属性名：\(String(describing: name))")
            }
            /// 通过KVC获取到属性
            /**
                <__NSArrayM 0x600002d5e160>((action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fe80ec140d0>))
                发现是属性是一个数组，强制转换为数组，看得清晰一些，那么此时你可以通过xcode断点，点击左侧控制台，看到数组里面的元素是什么类型。
             */
            //2、获取属性的类型，发现是数组，继续深挖数组里面的元素。
            let targetArr:Array<Any> = gesture.value(forKeyPath: "_targets") as! Array<Any>
            print("获取到的target属性：\(targetArr)")
            for item in targetArr {
                print("targetArr 里的元素：\(item)")
            }
            
            // 3、 数组的元素，该元素是一个对象，有一个属性，属性名字是 _target , _target的类型是_UINavigationInteractiveTransition，所以这个属性就是我们的目标了。
            let targetObject:NSObject = targetArr[0] as! NSObject
            let target = targetObject.value(forKeyPath: "_target")
//            let target = targetObject
            let pan = UIPanGestureRecognizer.init(target: target, action: Selector.init(("handleNavigationTransition:")))
            self.navigationController?.view.addGestureRecognizer(pan)
            /// 禁用系统的手势
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
            
            /**
            一个更简单获取target对象的方法：
            let target = self.navigationController!.interactivePopGestureRecognizer!.delegate
            */
        case 8:
            print("     (@@")
        case 9:
            //TODO: 9、测试添加view之后的布局，查看内边距
            /**
                1、navigationController会根据navigationBar.isTranslucent、vc.edgesForExtendedLayout属性值 动态来调整子View(VC的view)的frame(上下移动)。
                    同时修改除了ScroolView之外的所有View的safeAreaInsets，但是safeAreaInsets仅供参考，没有实际的布局动作，布局动作是其他函数操作的。
             */
            print("     (@@  测试设置导航栏后添加view之后的布局，查看内边距")
            let inset = self.view.safeAreaInsets
            let view = UIView()
            view.backgroundColor = .red
            self.view.addSubview(view)
            view.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalTo(20)
                make.height.equalTo(160)
                make.left.equalToSuperview().offset(20)
            }
            print("内边距：\(inset)")
        case 10:
            //TODO: 10、退出当前VC
            print("     (@@退出当前VC")
            self.navigationController?.popViewController(animated: true)
        case 11:
            //TODO: 11、还原导航栏透明的属性
            print("     (@@ 还原导航栏透明的属性")
            self.navigationController?.navigationBar.isTranslucent = true
            self.extendedLayoutIncludesOpaqueBars = true
            self.navigationController?.navigationBar.setBackgroundImage(getColorImg(alpha: 0.0) , for: .default)
        case 12:
            //TODO: 12、测试状态栏、导航栏、window安全边距
            print("     (@@ 测试状态栏、导航栏、工具栏、window安全边距")
            print("状态栏安全高度：   \(vg_statusBarSafeHeight())")
            print("导航栏高度：   \(vg_navigationBarHeight())")
            print("状态栏安全高度 + 导航栏高度：   \(vg_navigationFullHeight())")
            print("顶部安全区高度：   \(vg_navigationFullHeight())")
            print("window安全边距:  \(String(describing: UIApplication.shared.windows.first?.safeAreaInsets))")
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestNavibarUI_VC{
    
    //TODO: 顶部安全区高度
    func vg_safeDistanceTop() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.top
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.top
        }
        return 0;
    }
    
    //TODO: 底部安全区高度
    func vg_safeDistanceBottom() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0;
    }
    
    //TODO: 顶部状态栏高度（包括安全区）
    func vg_statusBarSafeHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    //TODO: 导航栏高度
    func vg_navigationBarHeight() -> CGFloat {
        return 44.0
    }
    
    //TODO: 状态栏+导航栏的高度
    func vg_navigationFullHeight() -> CGFloat {
        return vg_statusBarSafeHeight() + vg_navigationBarHeight()
    }
    
    //TODO: 底部导航栏高度
    func vg_tabBarHeight() -> CGFloat {
        return 49.0
    }
    
    //TODO:底部导航栏高度（包括安全区）
    func vg_tabBarFullHeight() -> CGFloat {
        return vg_tabBarHeight() + vg_safeDistanceBottom()
    }
    
    /// 点击了自定义的返回方法
    @objc func clickBack(sender: UIBarButtonItem){
        print("点击了\(#function)方法")
        self.navigationController?.popViewController(animated: true)
    }
}





//MARK: - 设计UI
extension TestNavibarUI_VC {
    
    // MARK: 设置导航栏的UI
    private func setNavigationBarUI(){
        
        
    }
    
    //TODO: 根据颜色来生成图片，颜色图片
    func getColorImg(alpha:CGFloat,_ color:UIColor = .orange) -> UIImage {
        let alphaColor = color.withAlphaComponent(alpha).cgColor
        /// 描述图片的矩形
        let rect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)
        /// 开启位图的上下文
        UIGraphicsBeginImageContext(rect.size)
        /// 获取位图的上下文
        let context = UIGraphicsGetCurrentContext()
        
        /// 使用color填充上下文
        context?.setFillColor(alphaColor)
        
        /// 渲染上下文
        context?.fill(rect)
        /// 从上下文中获取图片
        let colorImg = UIGraphicsGetImageFromCurrentImageContext()
        
        
        ///结束上下文
        UIGraphicsEndImageContext()
        return colorImg!
        
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 40)
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:10, width:UIScreen.main.bounds.size.width,height:200),
                                             collectionViewLayout: layout)
        
        baseCollView.backgroundColor = UIColor.cyan.withAlphaComponent(0.8)
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
//        baseCollView.layer.borderWidth = 1.0
//        baseCollView.layer.borderColor = UIColor.gray.cgColor
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        baseCollView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalToSuperview()
        }
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestNavibarUI_VC: UICollectionViewDelegate {
    
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


