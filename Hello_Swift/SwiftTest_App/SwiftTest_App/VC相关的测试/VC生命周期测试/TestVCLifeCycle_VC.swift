//
//  TestVCLifeCycle_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/23.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试VC的生命周期
//MARK: - 笔记
/**
 
 
 */


class TestVCLifeCycle_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    
    //MARK: 复写的方法
    //TODO: 1、在加载vc的view的时候调用
    ///         会先去xib里面找，如果找到就用xib的，如果没找到，则创建一个空白的view绑定vc。当第一次访问vc的view的时候，就会回调该方法。
    override func loadView() {
        print("TestVCLifeCycle_VC的\(#function)方法")
        super.loadView()
    }
    
    //TODO: 2、已经加载完毕VC自身的view的时候调用，一般在这里创建自定义的子view。
    ///         也就是loadview执行完之后，就执行该方法。
    override func viewDidLoad() {
        print("TestVCLifeCycle_VC的\(#function)方法")
        super.viewDidLoad()
        self.edgesForExtendedLayout = .bottom
        self.view.backgroundColor = .white
        self.title = "测试VC的生命周期"
        
        setNavigationBarUI()
        setCollectionViewUI()
    }
    
    //TODO: 3、当view即将显示的时候调用
    override func viewWillAppear(_ animated: Bool) {
        print("TestVCLifeCycle_VC的\(#function)方法")
        super.viewWillAppear(animated)
    }
    
    //TODO: 4、当VC的view即将布局子view的时候调用(每动态添加一次子view就会调用一次，是动态)
    /**
     就是当自身的view，或者子view的位置或大小发生变化时，就会回调该方法。
     
     1.当视图控制器的根视图的frame或bounds发生变化时，比如旋转屏幕导致视图大小改变。
     2.当添加或移除子视图时，尤其是在addSubview后，如果改变了子视图的大小或位置。
     3.在滚动UIScrollView时，如果滚动导致了视图的重新布局。
     4.直接调用setNeedsLayout或layoutIfNeeded方法后，如果这些方法导致了布局的更新。
     
     */
    override func viewWillLayoutSubviews() {
        print("TestVCLifeCycle_VC的\(#function)方法")
        super.viewWillLayoutSubviews()
    }
    
    //TODO: 5、当VC的view已经布局子view的完成的时候调用(每动态添加一次子view就会调用一次，是动态)
    override func viewDidLayoutSubviews() {
        print("TestVCLifeCycle_VC的\(#function)方法")
        super.viewDidLayoutSubviews()
    }
    
    //TODO: 6、当view已经显示的时候调用
    override func viewDidAppear(_ animated: Bool) {
        print("TestVCLifeCycle_VC的\(#function)方法")
        super.viewDidAppear(animated)
    }
    
    //TODO: 7、当view将要消失在视野的时候调用
    override func viewWillDisappear(_ animated: Bool) {
        print("TestVCLifeCycle_VC的\(#function)方法")
        super.viewWillDisappear(animated)
    }
    //TODO: 8、当view已经消失在视野的时候调用
    override func viewDidDisappear(_ animated: Bool) {
        print("TestVCLifeCycle_VC的\(#function)方法")
        super.viewDidDisappear(animated)
    }
    
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("TestVCLifeCycle_VC的\(#function)方法")
    }
    
    override func addChild(_ childController: UIViewController) {
        print("TestVCLifeCycle_VC addChild")
        super.addChild(childController)
    }

}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestVCLifeCycle_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            print("     (@@添加一个VC")
            let curVC = LifeCycleVC_1()
            curVC.view.backgroundColor = .blue
            curVC.view.tag = 10086
            self.view.addSubview(curVC.view)
            curVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.width.equalTo(100)
            }
            self.addChild(curVC)
            print("创建一个VC完毕")
//            let curVC2 = UIViewController()
//            curVC2.view.backgroundColor = .yellow
//            self.view.addSubview(curVC2.view)
//            curVC2.view.snp.makeConstraints { make in
//                make.centerY.equalToSuperview().offset(60)
//                make.left.equalToSuperview()
//                make.height.width.equalTo(100)
//            }
//            self.addChild(curVC2)
            break
        case 1:
            print("     (@@移除一个VC")
//            for curVC in self.children {
//                print("遍历子VC：\(curVC)")
//                if curVC.isKind(of: LifeCycleVC_1.self){
//                    print("找到子VC：\(curVC)")
//                    curVC.removeFromParent()
//                }
//            }
            print("     (@@已经移除了VC")
            let curView = self.view.viewWithTag(10086)
            curView?.removeFromSuperview()
//            curView?.isHidden = true
            
            print("     (@@已经移除了View")
            break
        case 2:
            print("     (@@ push一个VC")
            self.pushNext(viewController: LifeCycleVC_1())
            
        case 3:
            print("     (@@旋转view")
            break
        case 4:
            print("     (@@ 复原view的矩阵变换")
            break
            
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

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestVCLifeCycle_VC: UICollectionViewDelegate {
    
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


//MARK: - 设计UI
extension TestVCLifeCycle_VC {
    
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
//MARK: - 工具方法
extension TestVCLifeCycle_VC{
    
    
}

//MARK: - 笔记
/**
    1、
 
 */
