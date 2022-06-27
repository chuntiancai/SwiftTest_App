//
//  TestNSOperation_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/9.
//  Copyright © 2021 com.mathew. All rights reserved.
//

//测试的VC

import UIKit

class TestNSOperation_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    /// 测试组件
    let opQueue1 = OperationQueue.init()    // 默认是并发队列，测试队列的属性。
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "测试功能"
        
        setNavigationBarUI()
        setCollectionViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestNSOperation_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试Operation
            print("     (@@测试Operation")
            testOperation()
            break
        case 1:
            //TODO: 1、测试Operation的加锁
            print("     (@@测试Operation的加锁")
            testOperationLock()
        case 2:
            //TODO: 2、测试Operation队列的最大并发数，其他属性
            print("     (@@     测试Operation队列的最大并发数，其他属性")
            
            /// 设置最大并发数为1，从而实现串行的效果。但并不是只开了一条线程，只是让任务串行执行而已。设置为0的话，则不会执行。
            /// maxConcurrentOperationCount = -1 则表示线程开启个数不受限制。
            opQueue1.maxConcurrentOperationCount = 1
            /// 添加任务
            opQueue1.addOperation {
                for i in 0 ... 888 {
                    print("执行任务1 -- \(i) -- \(Thread.current)")
                    Thread.sleep(forTimeInterval: 0.001)
                }
            }
            opQueue1.addOperation {
                for i in 0 ... 8888 {
                    print("执行任务2 -- \(i) -- \(Thread.current)")
                    Thread.sleep(forTimeInterval: 0.001)
                }
            }
            opQueue1.addOperation {
                for i in 0 ... 8888 {
                    print("执行任务3 -- \(i)  -- \(Thread.current)")
                    Thread.sleep(forTimeInterval: 0.001)
                }
            }
            opQueue1.addOperation {
                for i in 0 ... 8888 {
                    print("执行任务4 -- \(i) -- \(Thread.current)")
                    Thread.sleep(forTimeInterval: 0.001)
                }
            }
            
        case 3:
            //TODO: 3、暂停任务队列
            print("     (@@ 暂停任务队列")
            /// 挂起任务，暂停任务，不能暂停正在执行的任务，只能暂停下一个到来的任务。所以当前任务会被执行完后再暂停。
            /**
                任务也有状态：正在执行，排队等候，执行完毕。
             */
            opQueue1.isSuspended = true //暂停任务
            opQueue1.isSuspended = false    //恢复任务队列
            opQueue1.cancelAllOperations()  // 取消队列中的所有任务
        case 4:
            //TODO: 4、测试Operation的start()方法
            print("     (@@ 测试Operation的start()方法")
            let op1 = SubOperation()
            op1.start() //自启动
            
            let op2 = SubOperation()
            OperationQueue().addOperation(op2)//通过队列启动
            
        case 5:
            print("     (@@ ")
            
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
extension TestNSOperation_VC{
    //MARK: 0、测试不断追加Operation，BlockOperation的使用
    /// swift 不可以使用NSInvocationOperation，不提供NSInvocationOperation的api
    /// 测试Operation
    func testOperation(){
        
        let op1 = BlockOperation.init{
            print("这是BlockOperation op1 的 block --Thread: \(Thread.current) ")
        }
        op1.queuePriority = .high   //设置在队列中的优先级，执行状态的优先级，决定并发的顺序，而非结束的顺序。
        op1.addExecutionBlock {
            print("这是BlockOperation op1 的add block 1 --Thread: \(Thread.current)")
        }
        let op2 = BlockOperation.init {
            print("这是BlockOperation op2 的 block --Thread: \(Thread.current)")
        }
        op2.queuePriority = .veryHigh
        op2.addExecutionBlock {
            print("这是BlockOperation op2 的add block 1 --Thread: \(Thread.current)")
        }
        /**
         ：添加依赖，在依赖的后面执行自己，但是这里报错，因为两个operation都没有加入队列吗？是的，需要加入队列
         ：不能循环依赖，循环依赖，则两个任务都不执行。
         ：可以跨队列依赖。
         */
        op1.addDependency(op2)
        
        let opQueue = OperationQueue.init() //Operation的队列，默认是并发队列
        opQueue.maxConcurrentOperationCount = 3 //队列中，任务的并发数，开启多少条线程，用户不可知
        opQueue.addOperation(op1)
        opQueue.addOperation(op2)
        
        //TODO: 自定义任务
        let subOp = SubOperation.init() //子类化Operation
        subOp.start()   //不用添加到队列，也可以自己执行
//        op1.start()   //这里是立马开启任务。
//        op2.start()
        opQueue.addOperation {
            print("这是opQueue,添加的block --Thread: \(Thread.current)")
        }
        
        OperationQueue.main.addOperation{
            print("这是主队列的block，-- Thread: \(Thread.current)")
        }
        
        let opBlock = BlockOperation.init(block: {
            print("测试没有加入队列的blockOperation是否可以单独执行-- Thread: \(Thread.current)")//可以单独执行，在主队列中执行
        })
        opBlock.start()
        
        let mainQ = OperationQueue.main //主队列
        mainQ.addOperation {
            print("在主队列中执行任务～")
        }
    }
    
    //MARK: 1、测试Operation的加锁
    /// 测试Operation的加锁问题
    func testOperationLock(){
        let lock = NSLock()
        var comNum = 100
        func decOne(){
            lock.lock()
            comNum -= 1
            print("现在测comNUm的值是：\(comNum)")
            lock.unlock()
        }
        let opQueue1 = OperationQueue.init()
        opQueue1.maxConcurrentOperationCount = 1    //设置最大并发数
        opQueue1.addOperation {
            while comNum > 0  {
                decOne()
                print("opQueue1 Block 1 对comNum减一,comNUm:\(comNum) --Thread: \(Thread.current)")
            }
        }
        let opQueue2 = OperationQueue.init()
        opQueue2.maxConcurrentOperationCount = 1
        opQueue2.addOperation {
            while comNum > 0 {
                decOne()
                print("opQueue2 block 1 对comNum减一,comNUm:\(comNum) --Thread: \(Thread.current)")
            }
        }
        
        let opQueue3 = OperationQueue.init()
        opQueue3.maxConcurrentOperationCount = 1
        opQueue3.addOperation {
            while comNum > 0 {
                decOne()
                print("opQueue3 block 1 对comNum减一,comNUm:\(comNum) --Thread: \(Thread.current)")
            }
        }
        

    }
    
    
}


//MARK: - 动作方法，工具方法
@objc extension TestNSOperation_VC{
    
    /// 测试被NSInvocationOperation调用的动作方法1
    func invokeFun1(){
        print(" @@ 测试被NSInvocationOperation调用的动作方法1")
    }
    
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}


//MARK: - 设计UI
extension TestNSOperation_VC {
    
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

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestNSOperation_VC: UICollectionViewDelegate {
    
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

//MARK: - 笔记
/**
    NSOperation、NSOperationQueue 是基于 GCD 更高一层的封装，完全面向对象。所以GCD中的概念对于NSOperation中也是通用的，只是提供了更多， 更便捷的接口给用户使用。
 
    1、Operation对应GCD中的workItem，只是Operation具有更灵活的操作性，譬如设置并发数，被子类化等等。OperationQueue对应的就是DispatchQueue，也有主队列之分，也是在主线程和其他线程中执行之分，Operation没有指定OperationQueue的话，默认在主线程中执行。
 
    2、NSOperation 是个抽象类，可以自定子类，也可以用系统提供的子类： NSInvocationOperation、 NSBlockOperation。有点类似线程Thread的操作， 要调用start方法。有就绪，执行这些状态。
 
    3、NSOperation是线程池概念，可以设置NSOperationQueue的并发数来实现串行效果maxConcurrentOperationCount 控制的不是并发线程的数量， 而是一个队列中同时能并发执行的最大操作数。而且一个操作也并非只能在一个线程中运行。默认情况下为-1，表示不进行限制，可进行并发执行。
 
    4、NSOperation的依赖，就是决定任务的执行先后顺序。依赖于谁，就是谁执行完了，再轮到我执行。
 
    5、这里的队列是并发执行的，对于添加到队列中的“操作”，首先进入准备就绪的状态（依赖完成后，我才进入就绪），然后进入就绪状态的“操作”的开始执行顺序（非结束执行顺序）由操作之间相对的优先级决定（优先级是操作对象自身的属性）。
 
    6、暂停和取消（包括操作的取消和队列的取消）并不代表可以将当前的操作立即取消，而是当当前的操作执行完毕之后不再执行新的操作。暂停和取消的区别就在于：暂停操作之后还可以恢复操作，继续向下执行；而取消操作之后，所有的操作就清空了，无法再接着执行剩下的操作。
 
    7、NSOperation可以独立执行，不需要加入到任何队列，调用start()方法即可，默认加入到主队列，肯定也是可以加入到队列中，让队列决定执行吖～
 
 */
