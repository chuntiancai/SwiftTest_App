//
//  测试Modal下的safeInset_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2023/4/20.
//  Copyright © 2023 com.mathew. All rights reserved.
//
// 测试模态下展示的VC的安全内边距
//MARK: - 笔记
/**
    1、modal下导航栏的遮挡问题，其实与modal无关，主要是导航栏的isTranslucent属性默认是true，也就是默认是透明的。
        然后isTranslucent如果是透明的话，那么VC的view布局就从屏幕顶部开始。
        如果不是透明的话，那么VC的view的布局就从导航栏下方开始。
        然后isTranslucent属性又会受到导航栏的背景图片，背景颜色等的影响而自动修改为false等等，具体去看导航栏UI的笔记。
        注意一点就是，如果布局是从屏幕顶部开始，那么UIViewSafeAreaLayoutGuide的top会是导航栏的下方的高度，但这个仅仅是参考，并没有实质影响布局。
        
 */

class TestSafeInset_ModalVC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let brownView = UIView()   //测试的view可以放在这里面
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        self.title = "测试Modal内边距的子VC"
        setCollectionViewUI()
        initTestViewUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TestSafeInset_ModalVC 的 \(#function) 方法～")
    }
    
    override func viewSafeAreaInsetsDidChange() {
        print("TestSafeInset_ModalVC 的 \(#function) 方法～")
        print("view的：\(self.view.safeAreaLayoutGuide) \n-- \(view.safeAreaInsets)")
    }
    
    override func viewWillLayoutSubviews() {
        print("TestSafeInset_ModalVC的\(#function)方法")
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        print("TestSafeInset_ModalVC的\(#function)方法")
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("TestSafeInset_ModalVC的\(#function)方法")
        super.viewDidAppear(animated)
    }
    
    
    
}



//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestSafeInset_ModalVC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestSafeInset_ModalVC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、
            print("     (@@ 0、")
            
        case 1:
            //TODO: 1、
            print("     (@@ 1、")
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
            print("     (@@ 退出模态")
            self.dismiss(animated: true)
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestSafeInset_ModalVC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestSafeInset_ModalVC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        brownView.backgroundColor = .brown
        self.view.addSubview(brownView)
        brownView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(120)
            make.centerX.equalToSuperview()
        }
        
    }
    
}


//MARK: - 设计UI
extension TestSafeInset_ModalVC {
    
   
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 40)
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 0, right: 5)
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:300, width:UIScreen.main.bounds.size.width,height:200),
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
extension TestSafeInset_ModalVC: UICollectionViewDelegate {
    
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
