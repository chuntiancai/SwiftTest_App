//
//  TestNaviVC_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/7/12.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试导航栏VC的VC
// MARK: - 笔记
/**
    1、UIBarItem : NSObject
            UIBarItem 类是一个可以放置在 Bar 之上的所有小控件类的抽象类。
        
        UIBarButtonItem : UIBarItem
            类似 UIButton 。放在 UINavigationBar 或者 UIToolbar 上。
            重点属性: customView
        
        UINavigationItem : NSObject
            包含了当前页面导航栏上需要显示的全部信息。是UIBarButtonItem的容器。
            title、prompt、titleView、leftBarButtonItem、rightBarButtonItem、backBarButonItem
            UIViewController 有一个 navigationItem 属性，通过这个属性可以来设置导航栏上的布局。
        
        UINavigationBar : UIView
            管理一个存放 UINavigationItem 的栈
        
        小结:
            设置导航栏上按钮的布局，使用 UIViewController 的 navigationItem 属性来设置其二级 leftBarButtonItem 、       rightBarButtonItem、backBarButonItem、leftBarButtonItems、rightBarButtonItems
            设置导航栏的背景色就设置 self.navigationController.navigationBar
        注意:
            backBarButtonItem 就是我们平时使用的返回箭头后面的按钮，我们通常会设置其 title 为 nil ，这个按钮自带返回事件。如果我们设置了 leftBarButtonItem 或者 leftBarButtonItems，backBarButonItem 将会失效。
 
    2、如果直接将UIBarButtonItem的自定义view设置为button，则会默认扩大button的点击范围，可以再加个view来承载button解决。
 
 */

class TestNaviVC_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试导航栏VC的VC"
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestNaviVC_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、设置当前VC的UINavigationItem的各个item属性。
            /**
                1、设置导航栏的左侧按钮会把返回按钮给覆盖掉，可以设置多个左侧按钮，左侧按钮的尺寸大小根据图片自适应，个数多的时候会把title往右移。
                    个数过多的时候会自适应调整btn之间的间距，但是最左最右的外边距始终保持不压缩。
             
                2、titleView的frame也会被压缩，不会超出边界，如果你实在想超出边界，可以考虑titleview里嵌入一个子view。
             
                3、设置导航栏的背景图片会影响到导航栏的透明，可以参考导航栏UI的布局测试。
                    优先级：appearence.backgroundImage > appearence.backgroundColor > navigationBar.setBackgroundImage
             
                4、backBarButtonItem是设置下一个页面的返回按钮，所以如果你想咋当前页面控制返回按钮，还是用leftBarButtonItem属性吧。
             */
            print("     (@@ 0、设置当前VC的UINavigationItem的各个item属性。")
            /// 左侧按钮
            let leftBtnArr = [getUIBarButtonItem(img: UIImage(named: "naviBar_game")!, clickImg: UIImage(named: "naviBar_game_click")!,
                                                 target: self, action: #selector(self.clickLeftItem(_:))),
                              getUIBarButtonItem(img: UIImage(named: "naviBar_coin")!,clickImg: UIImage(named: "naviBar_coin_click")!,
                                                 target: self, action: #selector(self.clickLeftItem(_:)))]
            self.navigationItem.leftBarButtonItems = leftBtnArr
            
            /// 右侧按钮
            let rightBtnArr = [
                               getUIBarButtonItem(img: UIImage(named: "naviBar_coin")!,clickImg: UIImage(named: "naviBar_coin_click")!,
                                                  target: self, action: #selector(self.clickLeftItem(_:))),
                               getUIBarButtonItem(img: UIImage(named: "naviBar_game")!, clickImg: UIImage(named: "naviBar_game_click")!,
                                                  target: self, action: #selector(self.clickLeftItem(_:)))]
            self.navigationItem.rightBarButtonItems = rightBtnArr
            
            /// 标题
            let label = UILabel()
            label.text = "导航栏标题"
            label.frame = CGRect(x: 0, y: 0, width: 600, height: 200)
            label.textColor = UIColor.brown
            label.layer.borderWidth = 1.0
            label.layer.borderColor = UIColor.gray.cgColor
            self.navigationItem.titleView = label
            
            
        case 1:
            //TODO: 1、测试滑动返回手势
            /**
                1、当设置了leftBarButtonItem时，因为覆盖了原来的backItem，会清空掉返回手势，导致滑动返回手势无效。
                2、分析:把系统的返回按钮覆盖 -> 1.手势失效(1.手势被清空 2.可能是手势代理做了一些事情,导致手势失效)
             */
            print("     (@@ 1、测试滑动返回手势")
            let app = UIApplication.shared.delegate as! AppDelegate
            if app.firstWindow.rootViewController != nil {
                app.firstWindow.makeKeyAndVisible()
                return
            }
            let subVC1 = MyNavigation_SubVC1()
            let naviVC = MyNavigation_NaviVC(rootViewController: subVC1)
            app.firstWindow.rootViewController = naviVC
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
            //TODO: 12、退出当前vc
            print("     (@@ 12、退出当前vc")
            self.navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
@objc extension TestNaviVC_VC{
   
    //TODO: 0、获取UIBarButtonItem的工具方法
    func getUIBarButtonItem(img:UIImage, clickImg:UIImage, target:NSObject ,action:Selector) -> UIBarButtonItem{
        
        let btn  = UIButton()
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.setImage(img, for: .normal)
        btn.setImage(clickImg, for: .highlighted)
        btn.layer.borderColor = UIColor.brown.cgColor
        btn.layer.borderWidth = 1.0
        let barItem = UIBarButtonItem(customView: btn)
        return barItem
    }
    
    func clickLeftItem(_ btn:UIButton){
        print("点击了左侧按钮:\(btn)")
    }
    
}


//MARK: - 设置测试的UI
extension TestNaviVC_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestNaviVC_VC {
    
    
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
extension TestNaviVC_VC: UICollectionViewDelegate {
    
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

