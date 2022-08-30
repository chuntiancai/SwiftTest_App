//
//  TestScrollViewGesture_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/24.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试UIScrollView手势的VC
// MARK: - 笔记
/**
    1、
 
 */

class TestScrollViewGesture_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //背景的view
    
    
    //MARK: 测试组件
    let scrView1 : VerScroll_ScrollView = {
        let sView = VerScroll_ScrollView()
        sView.backgroundColor = .red
        sView.contentSize = CGSize(width: 300, height: 1200)
        sView.bounces = false
        return sView
    }()
    
    let scrView2 : VerScroll_ScrollView2 = {
        let sView = VerScroll_ScrollView2()
        sView.backgroundColor = .blue
        sView.contentSize = CGSize(width: 200, height: 700)
        return sView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试UIScrollView手势的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestScrollViewGesture_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestScrollViewGesture_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试同一个方向滑动时，两个scrollView的手势和事件。
            print("     (@@ 0、测试同一个方向滑动时，两个scrollView的手势和事件。")
            let _ = bgView.subviews.map { $0.removeFromSuperview() }
            bgView.addSubview(scrView1)
            scrView1.btmScrollView = scrView2
            scrView1.snp.makeConstraints { make in
                make.top.equalTo(20)
                make.centerX.equalToSuperview()
                make.width.equalTo(300)
                make.bottom.equalToSuperview().offset(-40)
            }
            scrView1.addSubview(scrView2)
            scrView2.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(80)
                make.centerX.equalToSuperview()
                make.width.equalTo(240)
                make.height.equalTo(350)
            }
        case 1:
            //TODO: 1、打印ScrollView的Gesture信息
            print("     (@@ 1、打印ScrollView的Gesture信息")
            print(" scrView1的gesture是：\(scrView1.panGestureRecognizer) --- 代理delegate是：\(scrView1.panGestureRecognizer.delegate)")
            print(" scrView2的gesture是：\(scrView2.panGestureRecognizer) --- 代理delegate是：\(scrView2.panGestureRecognizer.delegate)")
        case 2:
            //TODO: 2、测试scrollview的动画效果
            print("     (@@ 2、测试scrollview的动画效果")
            UIView.animate(withDuration: 2.0) {
                self.scrView1.contentOffset = CGPoint(x: 0, y: 100)
            }
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
//MARK: - 测试的方法
extension TestScrollViewGesture_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestScrollViewGesture_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        /// 内容背景View，测试的子view这里
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
extension TestScrollViewGesture_VC {
    
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
extension TestScrollViewGesture_VC: UICollectionViewDelegate {
    
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



