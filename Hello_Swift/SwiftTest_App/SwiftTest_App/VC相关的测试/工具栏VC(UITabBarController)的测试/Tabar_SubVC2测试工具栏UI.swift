//
//  Tabar_SubVC2.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/10.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试UITabBarController的子VC
// MARK: - 笔记
/**
    1、tabBarItem默认会以当前VC的title为准，如果你在VC加载前设置了title，那么在没切换到当前VC时，显示你加载前设置的title。
        如果切换到当前的vc时，如果你没在viewDidload的时候设置tabBarItem的title，那么就以vc的title作为tabBarItem的title，如果有设置，则用你现在设置的tabBarItem的title，
        也就是viewdidload之后，当前VC加载之前设置的tabBarItem的title是无效的。navigationVC也是有tabBarItem的。
 
    2、tabBar上按钮的(标题和图片)渲染颜色，选中之后，默认会被渲染上默认的颜色(蓝色)，你可以修改整个tabBar类的 appearance，也可以设置图片的渲染模式为Original。
        
 */

class Tabar_SubVC2: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        self.title = "测试Tabar_SubVC2"
        
        setNavigationBarUI()
        setCollectionViewUI()
        // 设置工具栏的UI
        self.tabBarItem.title = "SubVC2"

        
        
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension Tabar_SubVC2: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Tabar_SubVC2 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试tabbar工具栏UI。
            print(" (@@  0、测试tabbar工具栏UI。")
            let tabVC = self.tabBarController
            let tabBar = tabVC?.tabBar
            tabBar?.isTranslucent = false
            tabBar?.backgroundColor = UIColor.orange
//            tabBar?.backgroundImage = UIImage()
            let appearence = UITabBar.appearance()
            print("获取到的tabbarVC 是：\(tabVC) -- tabbar是：\(tabBar) -- appearence：\(appearence)")
        case 1:
            //TODO: 1、设置当前VC的tabBarItem的样式，按钮高亮
            /**
                1、系统的TabBar上按钮状态只有选中,没有高亮状态 => 不能用系统tabBarButton => 普通按钮有高亮状态。
                2、tabBar上按钮的位置是由系统确定的，我们自己不能决定。所以只能自定义tabBar
             */
            print("     (@@ 1、设置当前VC的tabBarItem的样式")
            
            /// 设置标题
            self.tabBarItem.title = "工具栏UI"
            self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black.cgColor], for: .selected)
            
            ///设置icon
            self.tabBarItem.image = UIImage(named: "tab_planet")
            self.tabBarItem.selectedImage =  UIImage(named: "tab_planet_selected")
            
            ///提醒数字
            self.tabBarItem.badgeValue = "七"
            
        case 2:
            //TODO: 2、通过appearance全局设置UITabBarItem类的样式。
            /**
                1、appearance对设置时机有要求。通常需要在UIWindow的viewlayout之前。错过了时机后，设置是没有效果的。也就是不影响之前的外观，只影响设置之后的外观。
                    你可以通过移除view又添加view的方式，使得appearence生效。
                2、
             */
            print("     (@@ 2、通过appearance全局设置UITabBarItem类的样式。")
            let barItem = UITabBarItem.appearance()
            barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white.cgColor], for: .selected)
        case 3:
            //TODO: 3、
            print("     (@@ ")
        case 4:
            //TODO: 4、
            print("     (@@ ")
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
            //TODO: 10、设置自定义的整个底部工具栏UI了，TabBar
            print("     (@@ 10、设置自定义的底部工具了，TabBar")
            //设置自定义的底部工具了，TabBar
            let mytabBar = TestBtmTabBar_View()
            var barItemAarr = [UITabBarItem]()
            for i in 0 ..< 4 {
                let item = UITabBarItem()
                item.image = UIImage(named: "labi0\(i+1)")
                item.selectedImage = UIImage(named: "labi0\(i+4)")
                barItemAarr.append(item)
            }
            mytabBar.itemArr = barItemAarr
            
            self.tabBarController?.tabBar.removeFromSuperview()
            self.tabBarController?.view.addSubview(mytabBar)
            mytabBar.frame = self.tabBarController?.tabBar.frame ?? CGRect.zero
        case 11:
            //TODO: 11、
            print("     (@@")
        case 12:
            //TODO: 12、
            print("     (@@ 退出第二window")
            let app = UIApplication.shared.delegate as! AppDelegate
            app.firstWindow.resignKey()
            app.firstWindow.rootViewController = nil
//            for subView in app.firstWindow.subviews {
//                subView.removeFromSuperview()
//            }
            app.window?.makeKeyAndVisible()
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension Tabar_SubVC2{
   
    //MARK: 0、
    func test0(){
        
    }
    //MARK: 1、
    func test1(){
        
    }
    //MARK: 2、
    func test2(){
        
    }
    
}


//MARK: - 设置测试的UI
extension Tabar_SubVC2{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension Tabar_SubVC2 {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        
        ///布局从导航栏下方开始
        self.edgesForExtendedLayout = .bottom
        
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 40)
        
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
extension Tabar_SubVC2: UICollectionViewDelegate {
    
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

// MARK: - 笔记
/**
 
 */
