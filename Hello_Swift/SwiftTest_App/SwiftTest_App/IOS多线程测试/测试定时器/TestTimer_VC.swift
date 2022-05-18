//
//  TestTimer_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/5/18.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试定时器的VC

class TestTimer_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    private var timer:Timer?
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试定时器的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    deinit {
        print("TestTimer_VC 的 \(#function) 析构方法～")
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestTimer_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试Timer
            /**
                1、通过init初始化的Timer必须添加到runloop中才可以执行。Timer不会自动销毁，会一直存在于内存当中，必须手动销毁。
                2、通过Timer.scheduledTimer的类方法创建的timer，默认自动添加到runloop中。
                3、在代码块里的timer没有意义，因为代码块执行完它就被释放掉了。没有人保留它的引用。所以也就没有占内存。
             */
            print("     (@@  测试Timer")
            ///通过构造器初始化timer
            timer = Timer.init(fire: .distantPast, interval: 2.0, repeats: true, block: { curTimer in
                print("timer 的 block 方法：\(#function)")
            })
            /// 添加到runloop的默认运行模式中。你也可以(或同时)添加到UI追踪模式，或者抽象模式--那就均可以工作。
            RunLoop.current.add(timer!, forMode: .default)
            
            
            /// 该方法自动添加的runloop的default模式
//            let curTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
//                print("该方法自动添加的runloop的default模式")
//            }
        case 1:
            //TODO: 1、测试NSTimer定时器。
            print("     (@@ 测试NSTimer定时器")
        case 2:
            //TODO: 2、测试GCD定时器，绝对精准。
            print("     (@@ 测试GCD定时器，绝对精准。")
        case 3:
            //TODO: 3、
            print("     (@@ ")
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
@objc extension TestTimer_VC{
   
    //MARK: 0、timer的动作方法
    func timerAction(){
        print("\(#function) timer的动作方法")
    }
    //MARK: 1、gcd_timer的动作方法
    func gcdTimerAction(){
        print("\(#function) gcd_timer的动作方法")
    }
    
}


//MARK: - 设置测试的UI
extension TestTimer_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestTimer_VC {
    
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
extension TestTimer_VC: UICollectionViewDelegate {
    
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
    1、
 
 */

