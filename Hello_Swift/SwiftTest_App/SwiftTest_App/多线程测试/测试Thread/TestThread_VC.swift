//
//  TestThread_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/30.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试多线程的VC

class TestThread_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    var totalCount:Int = 0  //用于测试线程的资源争夺
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试线程的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestThread_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、获取主线程、当前线程
            print("     (@@ 获取主线程、当前线程")
            let mainThread = Thread.main    //主线程
            let curThread = Thread.current  //当前线程
            let isMain = curThread.isMainThread //判断是否主线程
            print("主线程：\(mainThread) -- 当前线程：\(curThread) -- \(isMain)")
            //TODO:通过c语言来创建线程(很旧)
            var myPthread = pthread_t(nil)
            let myPthread2 = pthread_t(nil)
            /**
             参数1:线程对象，传递地址进去
             参数2:线程的属性，可以传nil
             参数3:返回指针的闭包(函数的指针)，如果你不知道怎么写闭包，可以复制参数到代码空白区，根据提示写。
             参数4:是参数3闭包的参数。
             */
            pthread_create(&myPthread, nil, { rawPoint in
                print("pthread 执行的任务-- \(Thread.current)")
                return nil
            }, nil)
            let isEq = pthread_equal(myPthread, myPthread2)
            print("判断两个pthread是否相等：\(isEq)")
            
            //TODO:OC语言封装的线程
            let nsThread = Thread.init {
                print("Thread的前身是NSTrhead---\(Thread.current)")
            }
            nsThread.start()    //开始线程
            
            //分离出来的子线程，其实就是一个线程闭包，直接执行，不用调用start方法
            Thread.detachNewThread {
                print("通过分离出来的子线程---\(Thread.current)")
            }
            
            //TODO: perform方法其实也是开启子线程，但这个是默认是主线程，你也可以设置为后台线程。
            self.performSelector(inBackground: #selector(performAction(_:)), with: "哈哈哈")
            
            break
        case 1:
            //TODO: 1、测试线程的生命周期、状态
            print("     (@@ 1、测试线程的生命周期、状态")
            let myThread = Thread.init {
                print("线程执行--> 主动进入阻塞两秒 -- \(Date())")
                Thread.sleep(forTimeInterval: 2.0)  //主动阻塞献策
                print("主动退出线程")
                Thread.exit()   //主动结束当前线程的生命，就是退出线程
                print("线程任务执行完毕--> 进入死亡状态 -- \(Date())")
            }
            /// 启动线程，其实就是让线程从 新建状态--> 就绪状态
            myThread.start()
        case 2:
            //TODO: 2、测试线程的锁、线程安全问题
            /**
                1、线程的访问资源冲突的问题，就是多个线程在执行任务的时候需要对同一个资源做操作，于是加锁，锁有唯一性(可能是硬件层面实现)， 于是就保护了对资源的唯一访问。（资源是指内存区域，而不是某个属性或者方法，因为内存是所有程序存在的前提，就都可能是。）
                
                2、
             */
            print("     (@@ 2、测试线程的锁、线程安全问题")
            totalCount = 100
            let t1 = Thread.init { [self] in self.totalCountAction("t1") }
            let t2 = Thread.init { [self] in self.totalCountAction("t2") }
            let t3 = Thread.init { [self] in self.totalCountAction("t3") }
            t1.start()
            t2.start()
            t3.start()
            
        case 3:
            //TODO: 3、测试线程之间的通信
            print("     @@ 3、测试线程之间的通信")
            let beginTime = CFAbsoluteTimeGetCurrent()  //获取当前的绝对时间
            print("开始时间：\(beginTime)")
            self.performSelector(inBackground: #selector(performAction1(_:)), with: "t1")
            
        case 4:
            //TODO: 4、测试自定义的Thread
            print("     (@@ 测试自定义的Thread")
            let myThread = SubThread()
            myThread.start()    //启动线程。
        
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
@objc extension TestThread_VC{
   
    func performAction(_ str:String){
        print("通过perform方法创建的子线程：\(Thread.current)")
    }
    
    /// 测试线程加锁
    func totalCountAction(_ name:String){
        while true {
            for _ in 0 ... 99909 { }    //做空转操作，目的是为了增加线程争夺cpu的概率
            /// 1、加锁的位置必须是线程共享的资源，也就是共同访问的内存区域，也就是共同执行的代码段。
            /// 2、加锁是要牺牲性能，锁的本身必须是唯一的对象。
            /// 3、加锁的结果是：多个线程同步地访问这段内存区域。
            /// 4、加锁之后必须解锁，要释放锁代码，不然会报错。
            objc_sync_enter(self)
            if totalCount > 0 {
                totalCount -= 1
            }else{
                objc_sync_exit(self)
                break
            }
            objc_sync_exit(self)
            print(" \(name) 卖出了一张票，还剩：\(totalCount)")
        }
    }
    
    /// 测试线程间的通信
    func performAction1(_ name:String){
        print(" \(name) 执行 \(#function) 方法 -- \(Thread.current)")
        self.performSelector(onMainThread: #selector(performAction2(_:)), with: "t2", waitUntilDone: false)
        for _ in 0 ... 9009 { }   //空转操作
        print(" \(name) 执行完毕")
    }
    func performAction2(_ name:String){
        print(" \(name) 执行 \(#function) 方法 -- \(Thread.current)")
    }
    
}


//MARK: - 设置测试的UI
extension TestThread_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestThread_VC {
    
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
extension TestThread_VC: UICollectionViewDelegate {
    
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

//MARK: - 笔记
/**
    1、主线程的作用：
        显示\刷新UI界面。
        处理UI事件。(例如：点击事件、滚动事件、拖拽事件等等)
        
    2、当线程的任务执行完毕之后，线程就被释放了(生命结束)。
        系统也是维护了一个线程池，cpu从线程池里面调度就绪状态的线程，线程也依然有新建，就绪，阻塞，运行，死亡这些状态，和操作系统的概念是一样的。
 
 
 */
