//
//  TestGCD_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/30.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试GCD的VC

import UIKit

class TestGCD_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = " 测试GCD的功能"
        
        setNavigationBarUI()
        setCollectionViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestGCD_VC: UICollectionViewDataSource {
    
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
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        
        case 0:
            //TODO: 0、测试GCD串行队列
            print("     (@@测试GCD串行队列")
            //串行队列只开启一条后台线程给队列的异步执行使用，同步的话，也是只使用主线程，因为它是串行的，没必要开启多条线程，浪费资源
            print("当前的线程是：\(Thread.current)")
            let serialQ = DispatchQueue.init(label: "创建的串行GCD队列", qos: .default, autoreleaseFrequency: .inherit, target: nil)
            /// 任务肯定默认就是添加到队列的末尾吖，不然怎么叫做队列
            serialQ.async {
                print("  @@串行队列执行的异步block任务1，当前的线程是：\(Thread.current)")
            }
            print("测试GCD串行队列:顺序1")
            serialQ.async {
                print("  @@串行队列执行的异步block任务2，当前的线程是：\(Thread.current)")
            }
            print("测试GCD串行队列:顺序2")
            serialQ.async {
                print("  @@串行队列执行的异步block任务3，当前的线程是：\(Thread.current)")
            }
            print("测试GCD串行队列:顺序3")
            serialQ.async {
                print("  @@串行队列执行的异步block任务4，当前的线程是：\(Thread.current)")
            }
            print("测试GCD串行队列:顺序4")
            
            serialQ.sync {  //同步会阻塞当前线程
                print("  @@串行队列执行的 同步block任务1，当前的线程是：\(Thread.current)")
            }
            print("测试GCD串行队列:顺序5")
            serialQ.sync {
                print("  @@串行队列执行的 同步block任务2，当前的线程是：\(Thread.current)")
            }
            
        case 1:
            //TODO: 1、创建并行队列，测试workItem
            print("     (@@创建并行队列，测试workItem")
            print("当前的线程是：\(Thread.current)")
            let concurrentQ = DispatchQueue.init(label: "创建的并行GCD队列",attributes: .concurrent)
            let workItem1 = DispatchWorkItem {
                print("并行的workItem1，绑定的线程是：\(Thread.current)")
            }
            let workItem2 = DispatchWorkItem {
                print("并行的workItem2，绑定的线程是：\(Thread.current)")
            }
            let workItem3 = DispatchWorkItem {
                print("并行的workItem3，绑定的线程是：\(Thread.current)")
            }
            let workItem4 = DispatchWorkItem {
                print("并行的workItem4，绑定的线程是：\(Thread.current)")
            }
            concurrentQ.async(execute: workItem1)
            concurrentQ.async(execute: workItem2)
            concurrentQ.async(execute: workItem3)
            concurrentQ.async(execute: workItem4)
            concurrentQ.sync {
                print("并行GCD的同步1, 并行队列绑定的线程是：\(Thread.current)")
            }
            print("测试并行队列 顺序1")
            concurrentQ.sync {
                print("并行GCD的同步2, 并行队列绑定的线程是：\(Thread.current)")
            }
            concurrentQ.sync {
                print("并行GCD的同步3, 并行队列绑定的线程是：\(Thread.current)")
            }
            concurrentQ.sync {
                print("并行GCD的同步4, 并行队列绑定的线程是：\(Thread.current)")
            }
            print("测试并行队列 end")
            
        case 2:
            //TODO: 2、测试GCD队列、任务间的通信
            print("     (@@测试GCD队列、任务间的通信")
            let serialQ1 = DispatchQueue.init(label: "GCD串行队列1")
            let serialQ2 = DispatchQueue.init(label: "GCD串行队列2")
            
            let workItem1 = DispatchWorkItem.init {
                print("测试通信的workItem1")
                
            }
            let workItem2 = DispatchWorkItem.init {
                print("测试通信的workItem2")
                /// 在workItem中，如果用到线程，一般都用异步，避免忙等死锁
                DispatchQueue.global().async(execute: workItem1)
            }
            /// 同队列，用异步执行通信
            serialQ1.async {
                print("GCD串行队列1的block1--begin")
                serialQ1.async(execute: workItem1)
                print("GCD串行队列1的block1--end")
            }
            
            /// 不同队列，可异步也可以同步执行进行通信
            serialQ2.async {
                print("GCD串行队列1的block2--begin")
                serialQ1.sync(execute: workItem2)
                print("GCD串行队列1的block2--end")
            }
            
        case 3:
            //TODO: 3、测试DispatchGroup，GCD队列组
            print("     (@@测试DispatchGroup，GCD队列组")
            print("测试GCD队列组，DispatchGroup")
            let concurrentQ1 = DispatchQueue.init(label: "GCD并行队列1",attributes: .concurrent)
            let concurrentQ2 = DispatchQueue.init(label: "GCD并行队列2",attributes: .concurrent)
            let gcdGroup1 = DispatchGroup()
            
            /// 验证了，队列可以部分任务在组里，并非全部都要在组里
            concurrentQ1.async {
                print("GCD并行队列1 没有加入到组里的block1")
            }
            concurrentQ1.async {
                print("GCD并行队列1 没有加入到组里的block2")
            }
            concurrentQ1.async {
                print("GCD并行队列1 没有加入到组里的block3")
            }
            /// 队列加入到组里
            concurrentQ1.async(group: gcdGroup1) {  //这是个带有默认参数的方法
                print("GCD并行队列1 加入到组里的block1")
            }
            concurrentQ1.async {
                print("GCD并行队列1 没有加入到组里的block4")
            }
            print("testGCD_Group方法的顺序1")
            
            //异步，组内的所有任务执行完毕之后，执行该闭包。
            gcdGroup1.notify(queue: DispatchQueue.global()) {
                print("GCD队列任务组，监听到组内的任务已经执行完，然后执行这里的闭包，去通知全局并行队列～")
            }
            /// 验证在组的notify代码之后，队列再加入组，有没有影响。答：没有影响，编译器会优化，因为这时还是硬代码。
            concurrentQ2.async(group: gcdGroup1) {
                print("GCD并行队列2 加入到组里的block1 验证在组的notify代码之后，队列再加入组，有没有影响")
            }
            
            gcdGroup1.enter()   //该语句为标记开始语句，表示该代码下方的队列任务都加入到群组里，同理肯定有对应的标记结束语句。
            concurrentQ2.async(group: gcdGroup1) {
                print("GCD并行队列2 加入到组里的block2")
                gcdGroup1.leave()   //标记添加结束的语句。
            }
            concurrentQ2.async(group: gcdGroup1) {
                print("GCD并行队列2 加入到组里的block3")
                gcdGroup1.leave()   //标记添加结束的语句。
            }
            
            gcdGroup1.wait()    //阻塞当前线程，直到组内的任务执行完毕
            print("testGCD_Group方法--end")
        case 4:
            //TODO: 4、测试主队列
            print("     (@@测试主队列")
            let mainQ = DispatchQueue.main  //主队列
            mainQ.async {
                print("主队列的异步block1")
            }
            let globalConcurrentQ = DispatchQueue.global()  //全局并行队列
            globalConcurrentQ.async {
                print("全局并发队列的异步block1")
            }
        case 5:
            //TODO: 5、测试队列的挂起，一般是队列1去 挂起或恢复 队列2。
            print("     (@@ 5、测试队列的挂起，与恢复")
            let group = DispatchGroup()
            let queue1 = DispatchQueue(label: "com.apple.request", attributes: .concurrent)
            let queue2 = DispatchQueue(label: "com.apple.response", attributes: .concurrent)
            
            queue2.suspend()//队列挂起
            
            print("testGCD_suspend方法，顺序0")
            //异步执行
            queue1.async(group: group) {
                print("  @@q1模拟开始请求数据，当前线程: \(Thread.current)")
                sleep(5)//模拟网络请求，睡5秒
                print("  @@q1模拟数据请求完成，当前线程: \(Thread.current)，然后恢复队列2")
                queue2.resume()//网络数据请求完成，恢复队列，进行数据处理
            }
            
            //异步执行
            queue2.async(group: group) {
                print("  @@q2模拟开始数据处理，当前线程: \(Thread.current)")
                sleep(5)//模拟数据处理，睡5秒
                print("  @@q2模拟数据处理完成，当前线程: \(Thread.current)")
            }
            
            print("testGCD_suspend方法，顺序1")
            
            //切换到主队列监听，刷新UI
            group.notify(queue: DispatchQueue.main) {
                print("   @@队列任务已经全部完成，队列组发布完成通知，当前线程: \(Thread.current)")
            }
            
            print("testGCD_suspend方法，顺序2")
        case 6:
            print("     (@@测试队列和队列任务的屏障")
            //TODO: 6、测试队列和队列任务的屏障（栅栏函数）
            /// 屏障是指当前任务屏障后面的任务，先让前面的任务执行完，再执行后面的任务，就是你先走，我断后
            let concurrentQ = DispatchQueue.init(label: "测试屏障并行队列1",  attributes: .concurrent)
            
            let wItem1 = DispatchWorkItem.init {
                print("测试屏障的workItem1")
                for num in 0...10 {
                    print("wItem1 --> \(num)")
                }
            }
            let wItem2 = DispatchWorkItem.init {
                print("测试屏障的workItem2")
                for num in 0...5 {
                    print("wItem2 --> \(num)")
                }
            }
            let wItem3 = DispatchWorkItem.init {
                print("测试屏障的workItem3")
                for num in 0...10 {
                    print("wItem3 --> \(num)")
                }
            }
            /// 设置屏障，即初始化参数flag的值为.barrier
            let wItem4 = DispatchWorkItem.init(flags: .barrier) {
                print("测试屏障的workItem4，该item设置了屏障，flag参数为.barrier")
                for num in 0...10 {
                    print("wItem4 --> \(num) +++++++++++++++++++++++++++")
                }
            }
            let wItem5 = DispatchWorkItem.init {
                print("测试屏障的workItem5")
                for num in 0...10 {
                    print("wItem5 --> \(num)")
                }
            }
            let wItem6 = DispatchWorkItem.init {
                print("测试屏障的workItem6")
                for num in 0...10 {
                    print("wItem6 --> \(num)")
                }
            }
            let wItem7 = DispatchWorkItem.init {
                print("测试屏障的workItem7")
                for num in 0...10 {
                    print("wItem7 --> \(num)")
                }
            }
            concurrentQ.async(execute: wItem1)
            concurrentQ.async(execute: wItem2)
            concurrentQ.async(execute: wItem3)
            concurrentQ.async(execute: wItem4)
            concurrentQ.async(execute: wItem5)
            concurrentQ.async(execute: wItem6)
            concurrentQ.async(execute: wItem7)
            
        case 7:
            print("     (@@ 7、测试队列任务的信号量")
            //TODO: 7、测试队列任务的信号量
            let semaphore = DispatchSemaphore.init(value: 1)    //初始化信号量为5，也就是资源数，资源为0时则等待
            let concurrentQ1 = DispatchQueue.init(label: "并行队列1", attributes: .concurrent)
            var testNum = 0
            for num in 1...20 {
                concurrentQ1.async {
                    semaphore.wait()    //获取信号量 -1
                    testNum += 1
                    print("异步读取同一个变量：testNum：\(testNum)")
                    semaphore.signal()  //释放信号量 +1
                }
            }
        case 8:
            print("     (@@测试DispatchQoS调度优先级")
            //TODO: 8、测试DispatchQoS调度优先级
            /**
             gcd的队列，或者队列中的任务都可以单独设置调度优先级,优先级是一个参考标准，并不是绝对按照优先级来，只是有了优先权
             userInteractive: 与用户交互相关的任务，要最重视，优先处理，保证界面最流畅
             userInitiated: 用户主动发起的任务，要比较重视
             default: 默认任务，正常处理即可
             utility: 用户没有主动关注的任务
             background: 不太重要的维护、清理等任务，有空能处理完就行
             unspecified: 别说身份了，连身份证都没有，能处理就处理，不能处理也无所谓的
             */
            let conQ1 = DispatchQueue.init(label: "Q1", qos: .userInitiated, attributes: .concurrent)
            let conQ2 = DispatchQueue.init(label: "Q2", qos: .default, attributes: .concurrent)
            let item11 = DispatchWorkItem.init(qos: .default) {
                for num in 0...999{
                    print("item1_1--\(num)")
                }
            }
            let item12 = DispatchWorkItem.init(qos: .userInteractive) {
                for num in 0...999{
                    print("item1_2--\(num)")
                }
            }
            let item13 = DispatchWorkItem.init(qos: .background) {
                for num in 0...999{
                    print("item1_3--\(num)")
                }
            }
            let item14 = DispatchWorkItem.init(qos: .utility) {
                for num in 0...999{
                    print("item1_4--\(num)")
                }
            }
            let item21 = DispatchWorkItem.init(qos: .userInitiated) {
                for num in 0...999{
                    print("item2_1--\(num)")
                }
            }
            let item22 = DispatchWorkItem.init(qos: .userInteractive) {
                for num in 0...999{
                    print("item2_2--\(num)")
                }
            }
            let item23 = DispatchWorkItem.init(qos: .default) {
                for num in 0...999{
                    print("item2_3--\(num)")
                }
                
            }
            let item24 = DispatchWorkItem.init(qos: .utility) {
                for num in 0...999{
                    print("item2_4--\(num)")
                }
            }
            conQ1.async(execute: item11)
            conQ1.async(execute: item12)
            conQ1.async(execute: item13)
            conQ1.async(execute: item14)
            conQ2.async(execute: item21)
            conQ2.async(execute: item22)
            conQ2.async(execute: item23)
            conQ2.async(execute: item24)
            
        case 9:
            //TODO: 9、GCD的快速迭代
            print("     (@@ GCD的快速迭代")
            /// 并发执行
            /// iterations: 迭代次数。
            /// 迭代执行的闭包。
            DispatchQueue.concurrentPerform(iterations: 100) { index in
                print("遍历索引：\(index) -- \(Thread.current)")
            }
            
        case 10:
            //TODO: 10、
            print("     (@@")
        case 11:
            //TODO: 11、
            print("     (@@")
        case 12:
            //TODO: 12、
            print("     (@@")
        default:
            break
        }
    }
    
    
    
}



//MARK: - 工具方法
extension TestGCD_VC{
    
    
}
//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestGCD_VC: UICollectionViewDelegate {
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}

//MARK: - 设计UI
extension TestGCD_VC {
    
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



//MARK: - 笔记
/**
    1、GCD是 “宏伟的中枢调度器”：
        其实就是apple提供的框架，使用 队列和任务这两种数据结构 来解藕 线程与任务之间的关系。其实和OS中的线程调度的概念大同小异，只是更一层地封装， 提供一下API给用户使用而已。它并不是线程池，而是根据用户的使用来决定要新建线程，还是调度原有的线程来执行新的任务，视用户的使用决定。
 
    2、GCD中的任务：
        是相对线程中的任务而言的，并不直接就是线程中的任务，而是GCD决定怎么把GCD的任务追加到线程的任务中，而不是简单地追加的线程的任务中。所以，GCD中的队列和任务都是由GCD自己来管理和分配，是相对独立于线程中的任务的。是相对独立，不是完全独立。
 
    3、GCD中的队列：
        是GCD自己的数据结构，GCD的队列是用来存储GCD的任务的，但GCD的任务怎么被关联到实际的线程中，就看用户调用了什么样的方法和接口了。所以有并行队列和串行队列，这和OS中的概念是一样的，就是任务在队列中是并行还是串行的意思。
        并行队列：并行是指队列中的任务是并行的，队列是指队列中的任务是顺序开启的，也就是每个任务的结束时间没有先后之分，但是开启就是按照顺序开启的。
        串行队列：也就是一个任务执行完才开启下一个任务，就是串行的意思咯。
 
    4、同步和异步：
        所谓的同步和异步，就是当代码遇到了sync这些标志符号，是阻塞当前线程还是不阻塞当前线程，一种看符号办事的策略而已。
        sync: 阻塞当前线程，也就是当前线程必须等我sync名下的任务执行完，当前线程才可以继续执行。至于sync名下的任务被谁执行，看情况而定。
        async: 不阻塞当前线程，就是当前线程跳过我async名下的任务，只需要开启一下我async名下的任务就可以了，你就继续走你的代码，我async被开启后，怎么来执行，    那是async所需要关心的了，反正不关你当前线程的事。
 
    5、GCD中任务添加到队列：
        所有任务都是添加到队列尾的，不然怎么叫做队列。也正是因为这样，就会产生等待死锁问题。因为同步需要等待被添加的任务执行完，但是被添加的任务又是在队列尾，需要等待前面的任务执行，或者被前面的任务触发。但是前面的任务刚好和你队尾的任务是同一个队列，并且还是使用同步的策略的话，哦呵，那就我等你，你等我了。
        就是当前任务的代码里面包含了添加和开启队尾任务的代码，并且是同步策略。于是就矛盾了，于是就死锁了，所以就不要乱写代码咯。
   
    6、GCD中的线程：
        程序员不能为GCD中的队列及任务指定线程，线程的分配由GCD自身的机制决定，这里就有点类似于线程池的概念了。程序员只需要关心怎么用GCD中的队列和GCD中的任务就可以，关于具体的线程的创建，程序员不必关心，需要关心的是GCD机制下，任务是怎么执行的就可以了，不必关心GCD的任务具体和哪个具体线程绑定。
        6.1、其实如果是用到sync符号，绑定的线程就是当前线程，因为阻塞的是当前线程嘛。
        6.2、串行队列只开启一条后台线程给队列的异步执行使用，同步的话，也是只使用主线程，因为它是串行的，没必要开启多条线程，浪费资源。
 
    7、GCD中的队列任务组：
        所谓的队列任务组，就是多个队列的任务为一组，也可以多个队列的多个任务为一组，就不一定整个队列都在组里。等一组的队列执行完之后，组对象会发出通知，这时你可以指定通知谁。所以就是：1、是队列自己把一些任务加入到组里的，不是组来要队列的任务的。2、是组对象的方法来监听加入组内的队列任务有没有执行完，然后去通知指定队列的。
 
    8、死锁的原因：
        GCD死锁的原因主要是队列的特性和sync执行机制之间的逻辑冲突，队列要求任务先进先出，但是队列任务又可以嵌套，而sync又会阻塞当前线程，就导致了嵌套的任务与等待被前嵌套的任务互相等待，嵌套(加到队列末尾)等待被嵌(先入队列)，然后就走不到队列尾，所以就死锁。
 
 */

