//
//  TestSafeInset_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/5/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试VC、View的内边距和安全区域
// MARK: - 笔记
/**
    1、UIView的safeAreaInsets只是一个存储属性，用于给其他控件或者属性作为参考，它本身只是一个标识器的作用，并不改变布局。
      设置VC的additionalSafeAreaInsets属性，会同步修改VC层次中所有层次的View的safeAreaInsets属性(ScrollView除外)，safeAreaInsets修改之后， 会影响到View的safeAreaLayoutGuide属性。
 
      safeAreaLayoutGuide属性: 常用于自动布局约束，safeAreaLayoutGuide 用于描述插入边距后，view的剩余可布局空间。
                              和safeAreaInsets是一体的，用于互补说明safeAreaInsets。
                              所以safeAreaLayoutGuide可以看作一个虚拟的占位view。
        
      例如safeAreaInsets是(top:25,letf:20,bottom:0,right:0)， 那么safeAreaLayoutGuide就是一个矩形(x:20,y:25,width:剩余宽度，height:剩余高度), 如果内边距大于View本身的bounds，那么safeAreaLayoutGuide的宽度不会是负数， 而是（20 - 超出的宽度），也就是边缘对齐。
 
       影响链：vc.additionalSafeAreaInsets --> viewSafeAreaInsetsDidChange() --> view.safeAreaLayoutGuide --> view.safeAreaLayoutGuide
    
    2、内边距的生命周期：viewWillAppear --> viewSafeAreaInsetsDidChange() --> viewWillLayoutSubviews() --> viewDidLayoutSubviews() --> viewDidAppear()。
      
       所以，每一次修改了vc的additionalSafeAreaInsets属性之后，都会回调viewSafeAreaInsetsDidChange() --> viewWillLayoutSubviews() --> viewDidLayoutSubviews()系列方法，因为Scrollview的contentInset又是参考safeAreaInsets属性的，所以修改了additionalSafeAreaInsets后 影响到了safeAreaInsets属性， 从而影响到了Scrollview的 contentInset属性，所以影响到了scrollView的内容布局。
       
       所以，修改UIView的safeAreaInsets单纯来讲只是修改了一个属性值而已，并不会影响当前View的布局，只是一些系统的控件(例如ScrollView)参考了这个safeAreaInsets属性，才会 产生影响而已，而且这影响我猜测是系统在viewSafeAreaInsetsDidChange()方法回调的时候做了某些操作。
    
    3、如果viewController是在navigationController中, 那么应该先修改NavigationController的additionalSafeAreaInsets,然后再改变viewController 的additionalSafeAreaInsets， 才会有效的修改VC下的布局设置。
        我猜是 因为NavigationController是在viewSafeAreaInsetsDidChange()回调方法中 做导航栏布局的约束，而不是在当前的VC中。 这就解析了vc.edgesForExtendedLayout属性的作用，就是影响了NavigationController的相关布局操作。
 

 
 */

class TestSafeInset_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    lazy var bgView : UIView = { //测试的view可以放在这里面
        let curView = UIView()
        curView.layer.borderColor = UIColor.red.cgColor
        curView.layer.borderWidth = 3.0
        /// 内容背景View，测试的子view这里面
        self.view.addSubview(curView)
        curView.snp.makeConstraints { make in
            make.top.equalTo(self.baseCollView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        return curView
    }()
    
    //MARK: 测试组件
    lazy var subVC : TestSafeInset_SubVC = {    //子VC，测试内边距
        let vc = TestSafeInset_SubVC()
        vc.view.layer.borderWidth = 1.0
        vc.view.layer.borderColor = UIColor.brown.cgColor
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.view.snp.makeConstraints { make in
            make.top.equalTo(self.baseCollView.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(400)
            make.centerX.equalToSuperview()
        }
        return vc
    }()
    
    lazy var myLabel : UILabel = {  //测试页边距的label
        let label = UILabel()
        label.layer.borderColor = UIColor.brown.cgColor
        label.layer.borderWidth = 1.0
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "这是测试页边距的label,这是测试页边距的label,这是测试页边距的label,这是测试页边距的label。"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试内边距和安全区域VC"
        
        print("在viewDidLoad方法里：")
        printSafeInsetInfo()
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
        
        
    }
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        print("\n安全区发生了变化：")
        print("view的safeAreaLayoutGuide属性：\(self.view.safeAreaLayoutGuide)\n -- view的safeAreaInsets属性:\(self.view.safeAreaInsets)")
        print("view的frame：\(self.view.frame) -- navi的view的frame：\(self.navigationController?.view.frame) \n")
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("\nviewWillLayoutSubviews时的view： \(view.safeAreaLayoutGuide)\n -- view的safeAreaInsets属性:\(self.view.safeAreaInsets)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("\nviewDidLayoutSubviews时的view：\(view.safeAreaLayoutGuide)\n -- view的safeAreaInsets属性:\(self.view.safeAreaInsets)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\n 在viewWillAppear中view的frame：\(self.view.frame) --view的safeAreaLayoutGuide属性：\(self.view.safeAreaLayoutGuide)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\n 在viewDidAppear中view的frame：\(self.view.frame) -- navi的view的frame：\(self.navigationController?.view.frame)")
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
                1、修改页边距并不会影响什么，但是会回调VC的layoutMarginsDidChange()方法，从而影响了参考directionalLayoutMargins的约束，从而更新UI。
                    但是如果你的约束本来就没有参考到directionalLayoutMargins，那么就没什么变化，其实和safeAreaInsets的作用差不多咯。
                    View自身带有默认的directionalLayoutMargins，vc的view默认是(top:0,leading:16,bottom:34,trailing:16,),其他的view默认四边都是8pt。
                    directionalLayoutMargins的默认值会受到全屏和preservesSuperviewLayoutMargins的影响。
             */
            print("     (@@ 3、测试页边距，添加label")
            myLabel.directionalLayoutMargins = NSDirectionalEdgeInsets.init(top: 10, leading: 15, bottom: 20, trailing: 15)
            self.view.addSubview(myLabel)
            myLabel.snp.makeConstraints { make in
                make.width.equalTo(240)
                make.center.equalToSuperview()
            }
        case 4:
            // TODO: 4、测试UIView的safeAreaLayoutGuide和safeAreaInsets
            /**
                safeAreaLayoutGuide就是一个虚拟的view。
                1、设置VC的additionalSafeAreaInsets属性，会同步修改VC层次中所有层次的View的safeAreaInsets属性(ScrollView除外)，safeAreaInsets修改之后， 会影响到View的safeAreaLayoutGuide属性。
             
                2、safeAreaLayoutGuide属性: 常用于自动布局约束，safeAreaLayoutGuide 用于描述插入边距后，view的剩余可布局空间。
                                           和safeAreaInsets是一体的，用于互补说明safeAreaInsets。
                                           所以safeAreaLayoutGuide可以看作一个虚拟的占位view。
             
                3、例如safeAreaInsets是(top:25,letf:20,bottom:0,right:0)，那么safeAreaLayoutGuide就是一个 矩形(x:20,y:25,width:剩余宽度，height:剩余高度)。
                  如果内边距大于View本身的bounds，那么safeAreaLayoutGuide的宽度不会是负数， 而是（20 - 超出的宽度），也就是边缘对齐。
             
                影响链：vc.additionalSafeAreaInsets --> viewSafeAreaInsetsDidChange() --> view.safeAreaLayoutGuide --> view.safeAreaLayoutGuide
             
                4、safeAreaLayoutGuide也可以使用snpkit属性。
             
                5、UIWindow的safeAreaInsets和VC.view的safeAreaInsets。
                    导航根vc对子vc的view的frame做了状态栏和导航栏偏移的适配，直接修改frame的值原点。
                    导航vc的view的safeAreaLayoutGuide默认状态下是减去了状态栏+导航栏+底部虚拟栏的高度的虚拟view，但是safeAreaInsets的top是零，只是bottom和window的safeAreaInsets保持一致。
                    window的safeAreaInsets默认是加了状态栏和底部虚拟栏的高度作为内间距。
             */
            print("     (@@ 测试vc.view的safeAreaLayoutGuide和safeAreaInsets")
            
            printSafeInsetInfo()    //打印safeInset信息
            
            bgView.snp.remakeConstraints { make in
                make.top.equalTo(self.baseCollView.snp.bottom)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                make.width.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        case 5:
            // TODO: 5、测试layoutMargin。
            /**
                layoutMargin也只是一个参考属性，仅仅起标识作用，不会改变UI布局。
                1、layoutMargin是布局约束对象，主要用于描述子view在父view中的间距，用于给父子view之间的约束做参考。
             
                2、layoutMargin的优先级 小于 safeAreaInsets，也就是先safeAreaInsets后layoutMargin。
                    因为约束布局本来就是参考safeAreaInsets的。
             
                3、directionalLayoutMargins属性也是约束布局对象，主要是为了适配阿拉伯那边从右到左的阅读习惯，也就是将UIEdgeInsets结构的left和right调整为NSDirectionalEdgeInsets结构的leading和trailing。
             
                4、preservesSuperviewLayoutMargins是指子view是否继承父view的layoutMargin的值，如果是，那么孙子view就可以拿子view的layoutMargin来参考，如果不是，那么子view的layoutMargin默认是零。
                    如果继承了父view的layoutMargin，但是自己又手动设置了，那么。孙子view会取“手动设置layoutMargins值”与”在父视图Margin范围内区域“的最大值。
             
                5、insetsLayoutMarginsFromSafeArea默认是true，默认实际的布局时的layoutMargin是safeAreaInsets和layoutMargin的累加，设置insetsLayoutMarginsFromSafeArea为false之后，真正布局时就不再累加，而是单纯的手动设置的layoutMargin的值。
            
             */
            print("     (@@ 5、测试layoutMargin。")
            let _ = bgView.subviews.map{ $0.removeFromSuperview()}
            print("view的layoutMargin:\(view.layoutMargins)")
            print("bgview的layoutMargin:\(bgView.layoutMargins)")
            
            
            let yellowView : UIView = UIView()
            yellowView.layer.borderWidth = 2.0
            yellowView.layer.borderColor = UIColor.yellow.cgColor
            bgView.addSubview(yellowView)
            yellowView.snp.makeConstraints { make in
                make.topMargin.equalToSuperview()
                make.leftMargin.equalToSuperview().offset(20)
                make.rightMargin.equalToSuperview()
                make.bottomMargin.equalToSuperview()
            }
            
            
        case 6:
            print("     (@@6、获取相关安全区的高度信息")
            print("底部安全区的高度：\(MySafeInsetTool.safeDistanceBottom())")
            
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
    
    //TODO: 打印SafeInset的相关信息
    func printSafeInsetInfo(){
        //VC的安全边距偏移。
        let vcAddInset = self.additionalSafeAreaInsets
        
        // UIView的完全边距
        let viewSafeLayoutGuide = self.view.safeAreaLayoutGuide
        let viewSafeInset = self.view.safeAreaInsets
        
        // UIWindow的安全边距
        let app = UIApplication.shared.delegate as! AppDelegate
        let windowSafeLayoutGuide = app.window!.safeAreaLayoutGuide
        let windowSafeInset = app.window!.safeAreaInsets
        
        // screen
        
        let printStr = """
                        vc:
                        vcAddInset-- :\(vcAddInset)
                    
                        vc.view:
                        viewSafeLayoutGuide-- :\(viewSafeLayoutGuide)
                        viewSafeInset--: \(viewSafeInset)
                    
                        window:
                        windowSafeLayoutGuide--:\(windowSafeLayoutGuide)
                        windowSafeInset--:\(windowSafeInset)"
                    """
        print(printStr)
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



