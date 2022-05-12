//
//  TestSafeInset_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/5/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试VC、View的内边距和安全区域

class TestSafeInset_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    let subVC = TestSafeInset_SubVC()   //子VC，测试内边距
    let myLabel = UILabel()     //测试页边距的label
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试内边距和安全区域VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestSafeInset_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、修改导航栈中的VC的内边距对布局的影响
            /**
                1、如果viewController是在navigationController中, 那么应该先修改NavigationController的additionalSafeAreaInsets,然后再改变viewController 的additionalSafeAreaInsets， 才会有效的修改VC下的布局设置。
                    否则只是影响了View的safeAreaInsets而已，同时也对view的safeAreaLayoutGuide影响，但是并不会对view的位置做出调整。
             */
            print("     (@@  修改导航栈中的VC的内边距对布局的影响")
            self.additionalSafeAreaInsets = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0)
            
        case 1:
            //TODO: 1、修改常规VC的内边距对布局的影响
            /**
                1、内边距只是一个参考值，并没有对view的视图产生实际的影响，除非是在手动修改了frame的代码，或者约束条件之类的。
             */
            print("     (@@ 修改常规VC的内边距对布局的影响")
            subVC.additionalSafeAreaInsets = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0)
        case 2:
            //TODO: 2、测试导航栏VC下，VC的安全内边距对ScrollView的影响。TestSafeInset_SubVC2
            print("     (@@ 测试导航栏VC下，VC的安全内边距对ScrollView的影响。")
            let subVC2 = TestSafeInset_SubVC2()
            self.pushNext(viewController: subVC2)
        case 3:
            //TODO: 3、测试页边距，添加label
            /**
                1、修改页边距并不会影响什么，但是会毁掉VC的layoutMarginsDidChange()方法，从而影响了参考directionalLayoutMargins的约束，从而更新UI。
                    但是如果你的约束本来就没有参考到directionalLayoutMargins，那么就没什么变化，其实和safeAreaInsets的作用差不多咯。
                    View自身带有默认的directionalLayoutMargins，vc的view默认是(top:0,leading:16,bottom:34,trailing:16,),其他的view默认四边都是8pt。
                    directionalLayoutMargins的默认值会受到全屏和preservesSuperviewLayoutMargins的影响。
             */
            print("     (@@ 测试页边距，添加label")
            myLabel.layer.borderColor = UIColor.brown.cgColor
            myLabel.layer.borderWidth = 1.0
            myLabel.textAlignment = .center
            myLabel.numberOfLines = 0
            myLabel.text = "这是测试页边距的label,这是测试页边距的label,这是测试页边距的label,这是测试页边距的label。"
            myLabel.font = .systemFont(ofSize: 20)
            myLabel.textColor = .black
            myLabel.directionalLayoutMargins = NSDirectionalEdgeInsets.init(top: 10, leading: 15, bottom: 20, trailing: 15)
            self.view.addSubview(myLabel)
            myLabel.snp.makeConstraints { make in
                make.width.equalTo(240)
                make.center.equalToSuperview()
            }
            
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
            //TODO: 9、导航栈VC中添加子view看布局的效果
            print("     (@@ 导航栈VC中添加子view看布局的效果")
            let redView = UIView()
            redView.backgroundColor = .red
            self.view.addSubview(redView)
            redView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(40)
                make.width.equalTo(20)
                make.left.equalToSuperview()
            }
        case 10:
            //TODO: 10、子VC中添加子view看布局的效果
            print("     (@@ 子VC中添加子view看布局的效果")
            let redView = UIView()
            redView.tag = 1001
            redView.backgroundColor = .red
            subVC.view.addSubview(redView)
            redView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(40)
                make.width.equalTo(20)
                make.left.equalToSuperview()
            }
            
            let yellowView = UIView()
            yellowView.tag = 1002
            yellowView.backgroundColor = .yellow
            yellowView.frame = CGRect.init(x: 0, y: 0, width: 15, height: 50)
            subVC.view.addSubview(yellowView)
        case 11:
            //TODO: 11、在导航栈中的VC的内边距信息
            print("     (@@ 在导航栈中的VC的内边距信息")
            print("view的内边距：\(self.view.safeAreaInsets)")
        case 12:
            //TODO: 12、常规VC的内边距信息
            print("     (@@ 常规VC的内边距信息")
            print("子VC的view的内边距：\(subVC.view.safeAreaInsets)")
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestSafeInset_VC{
    
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
    
    //TODO: 导航栏高度,44
    func vg_navigationBarHeight() -> CGFloat {
        return 44.0
    }
    
    //TODO: 状态栏+导航栏的高度
    func vg_navigationFullHeight() -> CGFloat {
        return vg_statusBarSafeHeight() + vg_navigationBarHeight()
    }
    
    //TODO: 底部导航栏高度,49
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


//MARK: - 设置测试的UI
extension TestSafeInset_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        subVC.view.layer.borderWidth = 1.0
        subVC.view.layer.borderColor = UIColor.brown.cgColor
        self.addChild(subVC)
        self.view.addSubview(subVC.view)
        subVC.view.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(400)
            make.centerX.equalToSuperview()
        }
        
    }
    
}


//MARK: - 设计UI
extension TestSafeInset_VC {
    
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
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:15, width:UIScreen.main.bounds.size.width,height:200),
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
extension TestSafeInset_VC: UICollectionViewDelegate {
    
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
    1、UIView的safeAreaInsets只是一个存储属性，用于给其他控件或者属性作为参考，它本身只是一个标识器的作用，并不改变布局。
      设置VC的additionalSafeAreaInsets属性，会同步修改VC层次中所有层次的View的safeAreaInsets属性(ScrollView除外)，safeAreaInsets修改之后， 会影响到View的safeAreaLayoutGuide属性。
      safeAreaLayoutGuide属性: 常用于自动布局约束，safeAreaLayoutGuide 用于描述插入边距后，view的剩余可布局空间。 例如内边距是(top:20,letf:20,bottom:0,right:0)， 那么safeAreaLayoutGuide就是一个矩形(x:20,y:20,width:剩余宽度，height:剩余高度), 如果内边距大于View本身的bounds，那么safeAreaLayoutGuide的宽度不会是负数， 而是（20 - 超出的宽度），也就是边缘对齐。
 
       影响链：vc.additionalSafeAreaInsets --> viewSafeAreaInsetsDidChange() --> view.safeAreaLayoutGuide --> view.safeAreaLayoutGuide
    
    2、内边距的生命周期：viewWillAppear --> viewSafeAreaInsetsDidChange() --> viewWillLayoutSubviews() --> viewDidLayoutSubviews() --> viewDidAppear()。
      
       所以，每一次修改了vc的additionalSafeAreaInsets属性之后，都会回调viewSafeAreaInsetsDidChange() --> viewWillLayoutSubviews() --> viewDidLayoutSubviews()系列方法，因为Scrollview的contentInset又是参考safeAreaInsets属性的，所以修改了additionalSafeAreaInsets后 影响到了safeAreaInsets属性， 从而影响到了Scrollview的 contentInset属性，所以影响到了scrollView的内容布局。
       
       所以，修改UIView的safeAreaInsets单纯来讲只是修改了一个属性值而已，并不会影响当前View的布局，只是一些系统的控件(例如ScrollView)参考了这个safeAreaInsets属性，才会 产生影响而已，而且这影响我猜测是系统在viewSafeAreaInsetsDidChange()方法回调的时候做了某些操作。
    
    3、如果viewController是在navigationController中, 那么应该先修改NavigationController的additionalSafeAreaInsets,然后再改变viewController 的additionalSafeAreaInsets， 才会有效的修改VC下的布局设置。
        我猜是 因为NavigationController是在viewSafeAreaInsetsDidChange()回调方法中 做导航栏布局的约束，而不是在当前的VC中。 这就解析了vc.edgesForExtendedLayout属性的作用，就是影响了NavigationController的相关布局操作。
 

 
 
 */

