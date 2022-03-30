//
//  Modal_SubVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 用于被模态压栈的VC

class Modal_SubVC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    
    
    
    //TODO: 1、在加载vc的view的时候调用
    override func loadView() {
        print("Modal_SubVC的\(#function)方法")
        super.loadView()
    }
    
    //TODO: 2、已经加载完毕VC自身的view的时候调用，一般在这里创建自定义的view。
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "模态VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    //TODO: 3、当view即将显示的时候调用
    override func viewWillAppear(_ animated: Bool) {
        print("Modal_SubVC的\(#function)方法")
        super.viewWillAppear(animated)
    }
    
    //TODO: 4、当VC的view即将布局子view的时候调用(每动态添加一次子view就会调用一次，是动态)
    override func viewWillLayoutSubviews() {
        print("Modal_SubVC的\(#function)方法")
        super.viewWillLayoutSubviews()
    }
    
    //TODO: 5、当VC的view已经布局子view的完成的时候调用(每动态添加一次子view就会调用一次，是动态)
    override func viewDidLayoutSubviews() {
        print("Modal_SubVC的\(#function)方法")
        super.viewDidLayoutSubviews()
    }
    
    //TODO: 6、当view已经显示的时候调用
    override func viewDidAppear(_ animated: Bool) {
        print("Modal_SubVC的\(#function)方法")
        super.viewDidAppear(animated)
    }
    
    //TODO: 7、当view将要消失在视野的时候调用
    override func viewWillDisappear(_ animated: Bool) {
        print("Modal_SubVC的\(#function)方法")
        super.viewWillDisappear(animated)
    }
    //TODO: 8、当view已经消失在视野的时候调用
    override func viewDidDisappear(_ animated: Bool) {
        print("Modal_SubVC的\(#function)方法")
        super.viewDidDisappear(animated)
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension Modal_SubVC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、
            print("     (@@  ")
            let modalVC = Modal_SubVC()
            modalVC.modalPresentationStyle = .pageSheet    ///被模态显示时的效果。
            modalVC.modalTransitionStyle = .flipHorizontal  ///切换的动画过渡的效果。
            self.present(modalVC, animated: true) {
                print("modal方式展示控制器的完成闭包")
            }
            break
        case 1:
            //TODO: 1、
            print("     (@@ ")
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
            print("     (@@ 取消自身的modal展示方式")
            self.dismiss(animated: true) {
                print("Modal_SubVC取消了modal展示 的闭包：\(#function)")
            }
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension Modal_SubVC{
   
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
extension Modal_SubVC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension Modal_SubVC {
    
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
extension Modal_SubVC: UICollectionViewDelegate {
    
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

