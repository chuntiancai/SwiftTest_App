//
//  TestUITabBarController_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/10.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试UITabBarController的VC

class TestUITabBarController_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    let tabVC = TabBar_MainVC.init()   ///工具栏VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试UITabBarController的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestUITabBarController_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、在第二window中添加TabBarController
            print("     (@@  在第二window中添加TabBarController")
            let app = UIApplication.shared.delegate as! AppDelegate
            if app.firstWindow.rootViewController != nil {
                app.firstWindow.makeKeyAndVisible()
                return
            }
            let naviVC = UINavigationController(rootViewController: Tabar_SubVC1())
            naviVC.view.backgroundColor = .brown
            ///UITabBarController默认选中第一个子VC
            tabVC.addChild(naviVC)  //第1个VC，导航栏控制器VC
            
            tabVC.addChild(Tabar_SubVC2())//第2个VC
            
            let naviVC3 = UINavigationController(rootViewController: Tabar_SubVC3())
            tabVC.addChild(naviVC3)//第3个VC，导航栏控制器VC
            
            let subVC4 = Tabar_SubVC4()//第4个VC
            
            subVC4.tabBarItem.title = "subVC4"  //要在这里设置好tabBarItem.title才会在工具栏中显示标题，不然标题是懒加载出VC的标题。
            tabVC.addChild(subVC4)
            tabVC.selectedIndex = 1 //从零开始计算
            
            
//            app.firstWindow.becomeKey()
            
            app.firstWindow.rootViewController = tabVC
            app.firstWindow.makeKeyAndVisible()
            
        case 1:
            //TODO: 1、
            print("     (@@  ")
        case 2:
            //TODO: 2、
            print("     (@@ ")
        case 3:
            //TODO: 3、
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
//MARK: - 测试的方法
extension TestUITabBarController_VC{
   
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
extension TestUITabBarController_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestUITabBarController_VC {
    
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
extension TestUITabBarController_VC: UICollectionViewDelegate {
    
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
    1、一般的使用是在UITabBarController中容纳多个UINavigationController，注意UINavigationController不可以push UINavigationController。
    2、UITabBarController底部的工具栏是UITabBar,有若干个UITabBarButton组成(有多少个子VC，就有多少个按钮)。 UITabBarButton里面显示什么内容，是由当前对应的子vc的tabBarItem属性决定。
    3、主流的框架结构是：底层是一个UITabBarController，然后UITabBarController每一个子VC都是UINavigationController。
 
 */

