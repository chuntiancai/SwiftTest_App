//
//  TestNSCache_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/30.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试功能NSCache_VC

class TestNSCache_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    private var cache = NSCache<AnyObject, AnyObject>()  //测试缓存的类
    private var imgView = UIImageView() //展示缓存图片的imgview
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试功能NSCache_VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    override func didReceiveMemoryWarning() {
        print("接收到内存警告时，建议释放缓存")
        cache.removeAllObjects()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestNSCache_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、添加数据进缓存
            print("     (@@  添加数据进缓存")
            for i in 0...6 {
                let img = UIImage(named: "labi0\(i)")
                if let imgData = img?.jpegData(compressionQuality: 1) {
                    cache.setObject(imgData as AnyObject, forKey: "labi00\(i)" as AnyObject)
                    print("存数据--labi0\(i) --大小：\(MemoryLayout.size(ofValue: imgData))")
                }
            }
            
            break
        case 1:
            //TODO: 1、检查缓存
            print("     (@@ 检查缓存")
            let opQue = OperationQueue()
            opQue.maxConcurrentOperationCount = 1
            opQue.addOperation {
                [weak self] in
                for i in 0...6 {
                    if let imgData = self?.cache.object(forKey: "labi00\(i)" as AnyObject) as? Data {
                        print("缓存BLock--:\(Thread.current)")
                        let img = UIImage(data: imgData)
                        OperationQueue.main.addOperation {
                            self?.imgView.image = img
                        }
                        sleep(2)    //睡眠2秒
                    }else {
                        print("labi00\(i)资源不存在")
                    }
                }
            }
            
        case 2:
            //TODO: 2、清除缓存
            print("     (@@ 清除缓存")
            cache.removeAllObjects()
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
//MARK: - 遵循NSCacheDelegate协议
extension TestNSCache_VC:NSCacheDelegate{
   
    //TODO: 即将回收对象时，会调用该方法
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        print("将要回收的对象是：\(obj) --大小：\(MemoryLayout.size(ofValue: obj))")
    }
}


//MARK: - 设置测试的UI
extension TestNSCache_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        //TODO: 初始化NSCache类，设置属性。
        cache.totalCostLimit = 5    //成本，内存不够，会删除掉之前的缓存对象，先进后出
        cache.countLimit = 5    //存的对象个数。
        cache.delegate = self   //代理
        
        self.view.addSubview(imgView)
        imgView.layer.borderWidth = 1.0
        imgView.layer.borderColor = UIColor.brown.cgColor
        imgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.width.equalTo(350)
            make.height.equalTo(300)
            make.centerX.equalToSuperview()
        }
        
    }
    
}


//MARK: - 设计UI
extension TestNSCache_VC {
    
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
extension TestNSCache_VC: UICollectionViewDelegate {
    
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
    1、NSCache是苹果提供的专门管理缓存的缓存类，当内存很低的时候，NSCache会自动释放，NSCache是线程安全的，NSCache的Key对Value对象是强引用，而而不是copy。所以Value对象只会被存一次，因为是保留了强引用。
    2、NSCache的主要属性是：name:名字,delegate：代理,totalCostLimit：最大容量,countLimit：最大对象个数。
    3、NSCache的使用和字典差不多，只是多了内存管理机制。
    4、内存不够，会回收掉之前的缓存对象，先进后出。
 */
