//
//  TestRunLoopVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/30.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试runloop的VC
//MARK: - 笔记
/**
    1、每一个线程维护一个runloop，如果不去获取，则没有runloop：
        runloop是一个对象，里面的主要源码是do-while循环。因为runloop一直do-while，所以线程就没有被销毁，但是如果线程没有runloop， 那么该线程执行完它的任务就被销毁了。runloop是apple设计的一种数据结构而已，也可以理解为一种机制，一种模式，随便你怎么叫。
        
        除了主线程，其他线程的runloop在线程内第一次获取时创建，在线程结束时销毁Thread.exit()。runloop也可以在运行时设置一个存在时间，时间到了自动销毁。
 
    2、runloop中所谓的运行模式(mode)：
        其实就是内部的成员数据结构，runloop只能在特定一种mode(模式)下运行，其实就是只能异步处理一种内部数据结构，也就是某一时刻只能处理一种运行模式， 但是多个运行模式可以切换。然后mode这种数据结构内部又有三种子数据结构，也就是所谓的source、timer、observer，而mode可以同时拥有多个source，也就表现出了一个mode(运行模式)可以处理多个source(事件源).
        
        (mode之间可以切换，也会自动切换，但是某一时刻只会在一种运行模式下执行)
            ：所以scrollView拖动的时候，由于runloop会切换在UITrackingRunLoopMode运行，而此时如果定时器本来是运行在kCFRynLoopDefaultMode模式的，那么定时器将会停止运行， 等到runloop切换(或自动)到kCFRynLoopDefaultMode时，定时器才会恢复运行。
        如果要切换mode，只能退出runloop，然后重新指定一个mode进入。
 
        系统默认注册了5个Mode,常用的有3个：
 
        kCFRynLoopDefaultMode：App的默认Mode,通常主线程是在这个Mode下运行

        UITrackingRunLoopMode：界面跟踪Mode,用于ScrollView追踪触摸滑动，保证界面滑动时不受其他Mode影响

        kCFRunLoopCommonModes：这是一个占位用的Mode，不是一种真正的Mode。相当于上面两个的抽象父类。

        UIInitializationRunLoopMode：在刚启动App时进入的第一个Mode，启动完成后不再使用

        GSEventReceiveRunLoopMode：接受系统事件的内部Mode，通常用不到

 
    3、mode中的source0与source1:
        官网说，其实不用太纠结，就是source1是内核调度(基于port)，source0是用户调度而已。但用户使用起来，不用太在意这两者的区别。直接用添加source事件就可以了。
        例如点击按钮这些事件，都是通过source传递到runloop的。
    
    4、CFRunLoopRef是用C语言写的Runloop，NSRunLoop是用OC语言写的runloop，而NSRunLoop是基于CFRunLoopRef的。NSRunLoop是foundation框架，CFRunLoopRef是Core Foundation框架里的(CF)。
 
    5、runloop的定时器不够精准，但是GCD的定时器是绝对精准的。
 
    6、runloop的自动释放池，池内其实就是timer，obsever，source这些对象的引用。在第一次启动runloop时，runloop就会创建一个释放池，当runloop最后一次销毁的时候，就会释放对象引用， 销毁释放池。
        休眠和唤醒的时候也会销毁和创建 释放池。
 
 */


class TestRunLoopVC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试用的组件
    private var mainLoopObserver:CFRunLoopObserver? // 主循环的观察者
    private var stayThread:Thread?  //测试常驻内存的线程
    private var lockCountNum:Int = 1    //测试线程加锁的数字
    private let lock:NSLock = NSLock()  //同步锁
    
    // MARK: 复写的方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "测试Runloop的功能"
        
        setNavigationBarUI()
        setCollectionViewUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TestRunLoopVC 的 touchesBegan")
        super.touchesBegan(touches, with: event)
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestRunLoopVC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO:0、打印当前的runloop，测试NSDefaultRunLoopMode 和 UITrackingRunLoopMode 运行模式
            print("     (@@ 打印当前的runloop，添加runloop定时器")
            let curLoop = RunLoop.current
            print(" 当前的RunLoop.current：\(curLoop)")
            print(" 当前的CFrunloop: \(String(describing: CFRunLoopGetCurrent()))")
            print(" 当前的runloop 的 currentMode：\(String(describing: curLoop.currentMode))")
            
            print("     (@@测试NSDefaultRunLoopMode 和 UITrackingRunLoopMode,在不TrackingUI事件时才添加图片")
            print("在不追踪UI事件的runloop模式下，添加图片")
            let imgView = UIImageView()
            imgView.tag = 10000
            imgView.backgroundColor = .brown
            imgView.contentMode = .scaleAspectFit
            self.view.addSubview(imgView)
            imgView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(120)
            }
            // swift performSelector 的使用
            imgView.perform(#selector(setter: imgView.image), with: UIImage(named: "hahaha"), afterDelay: 1, inModes: [.default])
            break
        case 1:
            //TODO: 1、为runloop添加Observer
            /**
             CFRunLoopObserver用于观察runloop的状态变化，例如启动，处理source，处理timer，休眠这些动作状态的变化。
             */
            
            print("\n ===》添加 观察main runloop的观察者：")
            if let observer = mainLoopObserver {
                /// 释放observer，使用完后需要手动释放掉
                CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observer, .defaultMode)
            }else{
                /// 创建监听两个状态beforeSources和beforeTimers 的 observers
                /**
                 参数一allocator：如何分配内存空间
                 参数二activities：要监听的runloop状态
                 参数三repeats：是否持续监听
                 参数四order：优先级，总是传0就可以了
                 参数五callout：状态改变时的回调闭包
                 参数六context：
                 */
                mainLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                           CFRunLoopActivity.beforeSources.rawValue | CFRunLoopActivity.beforeTimers.rawValue | CFRunLoopActivity.afterWaiting.rawValue,
                                                           true, 0,
                                                           {   /**
                                                            observer：观察者
                                                            activity：runloop的状态枚举，CFRunLoopActivity
                                                            info：
                                                            */
                                                            (observer, activity, info) in
                                                            print("--- abserver:\(String(describing: observer))\n--- activity:\(activity)\n--- info:\(String(describing: info))")
                                                            print("监听到RunLoop发生改变：\(activity)\n\n")
                                                            switch activity{
                                                            case .entry:    //即将进入runloop
                                                                break
                                                            case .beforeTimers: //即将处理timer事件
                                                                break
                                                            case .beforeSources:    //即将处理source事件
                                                                break
                                                            case .beforeWaiting:    //即将进入睡眠
                                                                break
                                                            case .afterWaiting: //即将被唤醒
                                                                break
                                                            case .exit: //即将退出runloop
                                                                break
                                                            case .allActivities:    //所有状态
                                                                break
                                                            default:
                                                                break
                                                            }
                                                           }, nil)
                /// 为当前的runloop添加observer
                CFRunLoopAddObserver(CFRunLoopGetCurrent(), mainLoopObserver, .defaultMode)
            }
            
        case 2:
            //TODO: 2、测试runloop把线程转换为常驻线程。
            print("测试常驻内存的runloop,创建线程stayThread：")
            if stayThread != nil {
                /// 销毁线程,只能线程内部自己销毁？
                /// thread.cancel()
                /// Thread.exit()   //调用该方法来销毁线程
            }else {
                stayThread = Thread.init(target: self, selector: #selector(stayThreadRunAction), object: nil)//创建线程
                ///线程进入就绪状态 -> 运行状态。当线程任务执行完毕，自动进入死亡状态
                stayThread?.start() //开始线程, 线程一启动，就会在线程thread中执行self的stayThreadRunAction方法
                
            }
            
        case 3:
            //TODO:3、 往常驻线程中添加任务
            print("     (@@ 往常驻线程中添加任务：")
            if let _ = stayThread {
                /// 所以该方法也可以用于线程间的通信啊，亲
                self.perform(#selector(stayThreadAddTaskAction), on: stayThread!, with: nil, waitUntilDone: false)
            }
            
        case 4:
            //TODO:4、线程加锁
            print("     (@@ 线程加锁")
            let thread1 = Thread.init(target: self, selector: #selector(addLockNumAction), object: nil)
            thread1.name = "Thead1--甲"
            let thread2 = Thread.init(target: self, selector: #selector(addLockNumAction), object: nil)
            thread2.name = "Thead2--乙"
            
            thread1.start()
            thread2.start()
        case 5:
            //TODO:5、测试runloop中的定时器
            print("     (@@ 添加定时器到runloop中")
            let myTimer = Timer.init(timeInterval: 2.0, target: self, selector: #selector(testRunLoopTimerAction), userInfo: nil, repeats: true)
            /// 添加到runloop的默认运行模式中。你也可以(或同时)添加到UI追踪模式，或者抽象模式--那就均可以工作。
            RunLoop.current.add(myTimer, forMode: .default)
            
            /// 该方法自动添加的runloop的default模式
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
                print("该方法自动添加的runloop的default模式")
            }
            
        case 6:
            //TODO: 6、开启子线程的runloop
            print("     (@@ 开启子线程的runloop")
            /// 主线程的runloop默认就已经创建并开启了，子线程的runloop需要手动开启
            Thread.detachNewThread {
                print("当前的线程：\(Thread.current)")
                let curRunloop = RunLoop.current
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
                    print("子线程中的timer")
                }
                curRunloop.run()    //运行runloop，run方法永远不会停止，会不断地循环执行。
                curRunloop.run(mode: .tracking, before: Date.init(timeIntervalSinceNow: 20))//指定runloop的运行模式，执行一次任务，runloop就退出，thread的任务就可以结束，可以stop。
            }
            
        case 7:
            print("     (@@")
        case 8:
            print("     (@@")
        case 9:
            print("     (@@")
        case 10:
            //TODO:10、移除子View，移除runloop观察者
            print("     (@@ 移除子View，移除runloop观察者")
            let imgView = self.view.viewWithTag(10000)
            imgView?.removeFromSuperview()
            if let observer = mainLoopObserver {
                // 释放observer，最后添加完需要释放掉
                CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observer, .defaultMode)
            }
        case 11:
            print("     (@@")
        case 12:
            print("     (@@")
        default:
            break
        }
    }
    
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
    
}

//MARK: - 测试用的方法
extension TestRunLoopVC {
    
   
    
    
    
}

// MARK: - 测试用的动作方法
@objc extension TestRunLoopVC {
    
    /// 线程锁数字加一的动作方法
    func addLockNumAction(){
        
        print("当前的线程是：\(Thread.current)")
        // 死循环，避免线程死亡
        while true {
            
            ///添加互斥锁
            lock.lock()
            if self.lockCountNum < 50 {
                self.lockCountNum += 1
                print("当前的数字是：\(self.lockCountNum) --- \(Thread.current)")
            }else{
                print("当前的线程已经输完数字：\(self.lockCountNum) --- \(Thread.current)")
                break
            }
            lock.unlock()
        }
        
    }
    
    /// 常驻内存线程的任务
    func stayThreadRunAction(){
        print("获取当前线程的runloop，如果没有，则系统为你创建----stayThreadRunAction---线程的run方法。。。")
        let curLoop  = RunLoop.current
//        print("@@ 当前线程的 RunLoop.current:\(curLoop)")
        // 添加下边两句代码，就可以开启RunLoop，之后self.thread就变成了常驻线程，可随时添加任务，并交于RunLoop处理
        curLoop.add(Port(), forMode: .default)
        /// runloop run了之后，如果一开始就没有事件(source,timer,obsever)，那么runloop就会马上退出，有事件才会有休眠这些状态。
        ///curLoop.run()
        curLoop.run(until: Date.init(timeIntervalSinceNow: 5))  //5秒后退出runloop
        
        print("测试是否开启了RunLoop，如果开启RunLoop，则来不了这里，因为RunLoop开启了循环。")
    }
    
    func stayThreadAddTaskAction(){
        print("当前线程中的runloop：\(RunLoop.current)\n")
        print("主线线程：\(Thread.main)\n")
        print("当前线程：\(Thread.current)\n")
        print("常驻内存线程的额外添加的任务")
    }
    
    /// 测试runloop timer的动作方法
    func testRunLoopTimerAction(){
        print("测试runloop timer的动作方法 \(#function)")
        print("当前runloop的运行模式：\(String(describing: RunLoop.current.currentMode))")

    }
    
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestRunLoopVC: UICollectionViewDelegate {
    
}

//MARK: - 工具方法
extension TestRunLoopVC{
    
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}


//MARK: - 设计UI
extension TestRunLoopVC {
    
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
