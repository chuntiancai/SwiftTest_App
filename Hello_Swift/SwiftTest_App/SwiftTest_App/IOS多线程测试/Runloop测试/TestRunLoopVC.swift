//
//  TestRunLoopVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/30.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试runloop的VC

import UIKit

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
            print("     (@@测试NSDefaultRunLoopMode 和 UITrackingRunLoopMode,在不TrackingUI事件时才添加图片")
            testNSDefaultRunLoopModeUITrackingRunLoopMode()
            break
        case 1:
            print("     (@@ 打印当前的runloop，添加runloop定时器")
            printCurRunloop()
        case 2:
            print("     (@@ 测试常驻内存的runloop")
            testStayMemoryRunloop()
        case 3:
            print("     (@@ 往常驻线程中添加任务：")
            if let _ = stayThread {
                /// 所以该方法也可以用于线程间的通信啊，亲
                self.perform(#selector(stayThreadAddTaskAction), on: stayThread!, with: nil, waitUntilDone: false)
            }
            
        case 4:
            print("     (@@ 线程加锁")
            let thread1 = Thread.init(target: self, selector: #selector(addLockNumAction), object: nil)
            thread1.name = "Thead1--甲"
            let thread2 = Thread.init(target: self, selector: #selector(addLockNumAction), object: nil)
            thread2.name = "Thead2--乙"
            
            thread1.start()
            thread2.start()
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
    
    //MARK: 测试常驻内存的runloop
    func testStayMemoryRunloop(){
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
        
    }
    
    //MARK: 测试NSDefaultRunLoopMode 和 UITrackingRunLoopMode
    private func testNSDefaultRunLoopModeUITrackingRunLoopMode(){
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
    }
    
    //MARK:  打印当前的runloop状态，添加定时器
    private func printCurRunloop(){
        let curLoop = RunLoop.current
        print(" 当前的RunLoop.current：\(curLoop)")
        print(" 当前的CFrunloop: \(String(describing: CFRunLoopGetCurrent()))")
        print(" 当前的runloop 的 currentMode：\(String(describing: curLoop.currentMode))")
        print("\n ===》添加定时器，观察main runloop的观察者：")
        if let observer = mainLoopObserver {
            // 释放observer，最后添加完需要释放掉
            CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observer, .defaultMode)
        }else{
            // 添加runloop的observer，监听两个状态beforeSources和beforeTimers
            mainLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.beforeSources.rawValue | CFRunLoopActivity.beforeTimers.rawValue | CFRunLoopActivity.afterWaiting.rawValue, true, 0, { abserver, activity, info in
                print("--- abserver:\(String(describing: abserver))\n--- activity:\(activity)\n--- info:\(String(describing: info))\n\n")
                print("监听到RunLoop发生改变---%zd",activity)
            }, nil)
            CFRunLoopAddObserver(CFRunLoopGetCurrent(), mainLoopObserver, .defaultMode)
        }
        
    }
    
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
        print("@@ 当前线程的 RunLoop.current:\(curLoop)")
        // 添加下边两句代码，就可以开启RunLoop，之后self.thread就变成了常驻线程，可随时添加任务，并交于RunLoop处理
        curLoop.add(Port(), forMode: .default)
        curLoop.run()
        
        print("测试是否开启了RunLoop，如果开启RunLoop，则来不了这里，因为RunLoop开启了循环。")
    }
    
    func stayThreadAddTaskAction(){
        print("当前线程中的runloop：\(RunLoop.current)\n")
        print("主线线程：\(Thread.main)\n")
        print("当前线程：\(Thread.current)\n")
        print("常驻内存线程的额外添加的任务")
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
        
        baseCollView.backgroundColor = UIColor.cyan
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
}
/**
    1、每一个线程维护一个runloop，如果不去获取，则没有runloop：
        runloop是一个对象，里面的主要源码是do-while循环。因为runloop一直do-while，所以线程就没有被销毁，但是如果线程没有runloop， 那么该线程执行完它的任务就被销毁了。runloop是apple设计的一种数据结构而已，也可以理解为一种机制，一种模式，随便你怎么叫。
 
    2、runloop中所谓的运行模式(mode)：
        其实就是内部的成员数据结构，runloop只能在特定一种mode(模式)下运行，其实就是只能异步处理一种内部数据结构，也就是某一时刻只能处理一种运行模式， 但是多个运行模式可以切换。然后mode这种数据结构内部又有三种子数据结构，也就是所谓的source、timer、observer，而mode可以同时拥有多个source，也就表现出了一个mode(运行模式)可以处理多个source(事件源)
 
    3、mode中的source0与source1:
        官网说，其实不用太纠结，就是source1是内核调度(基于port)，source0是用户调度而已。但用户使用起来，不用太在意这两者的区别。直接用添加source事件就可以了。
    
    4、CFRunLoopRef是用C语言写的Runloop，NSRunLoop是用OC语言写的runloop，而NSRunLoop是基于CFRunLoopRef的。NSRunLoop是foundation框架，CFRunLoopRef是Core foundation框架里的。
 
    5、
 
 */
