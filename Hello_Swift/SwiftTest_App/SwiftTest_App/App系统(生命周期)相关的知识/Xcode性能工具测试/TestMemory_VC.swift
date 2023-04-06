//
//  TestMemory_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/21.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试App内存的VC
// MARK: - 笔记
/**
    1、静态内存分析(以前的MRC项目代码分析)：
            xcode -> Product -> Analyze //xcode就会对你的代码进行分析，提示，看是否有野指针之类的，适用于MRC的代码分析。
        1.1、静态内存分析是xcode对代码的逻辑分析，不需要运行代码，仅仅是代码层面的检查。
        1.2、适用于MRC和ARC项目的桥接，现在这些都很古老了，可以忽略了。
        1.3、在OC中，ARC只管理了Foundation的代码，并没有管理CoreFoundation框架的代码，即CF开头的那些类。
            MRC与ARC环境的切换：target -> build setting -> 搜索 automatic reference counting。
            swift使用了 类型重映射机制 ，可以直接使用CoreFoundation框架，swift已经管理了。
 
            桥接 Foundation框架 和 CoreFoundation框架：
            > MRC 环境下的桥接：
                》Foundation 到 CoreFoundation框架的数据类型转换。
                    // CFStringRef , 这种转换, 属于直接转换, 不会移交对象的内存管理权。
                        NSString *str = [[NSString alloc] init];
                        CFStringRef strRef = (CFStringRef)str;
 
                》CoreFoundation 到 Foundation框架的数据类型转换。
                    // 这种转换, 属于直接转换, 不会移交对象的内存管理权。
                        CFStringRef strRef2 = CFStringCreateWithCString(CFAllocatorGetDefault(), "123", kCFStringEncodingUTF8);
                        NSString *str2 = (NSString *)strRef2;
 
            > ARC 环境下的桥接：
                》Foundation 到 CoreFoundation框架的数据类型转换：
                    // (__bridge CFStringRef)  等同于 MRC下面的直接转换, 不会移交对象的内存管理权。
                        NSString *str = [[NSString alloc] init];
                        CFStringRef strRef = (__bridge CFStringRef)(str);
                    
                    // __bridge_retained 方式转换, 会移交对象的内存管理权。
                         CFBridgingRetain == __bridge_retained CFStringRef
                        CFStringRef strRef = (__bridge_retained CFStringRef)str;
                
                
                》CoreFoundation 到 Foundation框架的数据类型转换：
                    // __bridge NSString * 等同于 MRC下面的直接转换, 不会移交对象的内存管理权
                        CFStringRef strRef2 = CFStringCreateWithCString(CFAllocatorGetDefault(), "123", kCFStringEncodingUTF8);
                        NSString *str2 = (__bridge NSString *)(strRef2);
 
                    // __bridge_transfer 方式转换, 会移交对象的内存管理权。
                        CFBridgingRelease == __bridge_transfer NSString *
                        NSString *str2 = (__bridge_transfer NSString *)strRef2;
                
    2、内存分配：主要查看内存的分配情况和内存是否有释放。
        2.1、内存分配分析：点击 product --> profile --> 进入instrument --> Allocations--> 左上角选择真机 --> 点击红色录制按钮 --> 查看运行数据。
        2.2、内存泄漏： 进入instrument --> Leaks --> 左上角选择真机 --> 点击红色录制按钮 --> 查看运行数据。
 
    3、iOS程序的内存布局
        代码段：编译之后的代码
        
        数据段（__DATA）：
            字符串常量：比如NSString *str = @"123"
            已初始化数据：已初始化的全局变量、静态变量等
            未初始化数据：未初始化的全局变量、静态变量等
        
        栈：函数调用开销，比如局部变量。分配的内存空间地址越来越小。
        
        堆：通过alloc、malloc、calloc等动态分配的空间，分配的内存空间地址越来越大。
 
    4、从64bit开始，iOS引入了Tagged Pointer技术，用于优化NSNumber、NSDate、NSString等小对象的存储
        在没有使用Tagged Pointer之前， NSNumber等对象需要动态分配内存、维护引用计数等，NSNumber指针存储的是堆中NSNumber对象的地址值。
        使用Tagged Pointer之后，NSNumber指针里面存储的数据变成了：Tag + Data，也就是将数据直接存储在了指针中，当指针不够存储数据时，才会使用动态分配内存的方式来存储数据。
        
        objc_msgSend能识别Tagged Pointer，比如NSNumber的intValue方法，直接从指针提取数据，节省了以前的调用开销
        
        如何判断一个指针是否为Tagged Pointer？
            iOS平台，最高有效位是1（第64bit）
            Mac平台，最低有效位是1
 
    5、在iOS中，使用引用计数来管理OC对象的内存
        一个新创建的OC对象引用计数默认是1，当引用计数减为0，OC对象就会销毁，释放其占用的内存空间。
        调用retain会让OC对象的引用计数+1，调用release会让OC对象的引用计数-1。
        内存管理的经验总结：
            当调用alloc、new、copy、mutableCopy方法返回了一个对象，在不需要这个对象时，要调用release或者autorelease来释放它
            想拥有某个对象，就让它的引用计数+1；不想再拥有某个对象，就让它的引用计数-1
        
        可以通过以下私有函数来查看自动释放池的情况：  extern void _objc_autoreleasePoolPrint(void);

    6、iOS提供了2个拷贝方法
        属性上的copy标签指的是，当赋值给这个属性的时候，是通过copy，还是strong，还是mutableCopy的方式把参数值赋给属性。
        1.copy，不可变拷贝，产生不可变副本
        2.mutableCopy，可变拷贝，产生可变副本。是根据类名字的前缀是否有mutable进行copy的，标签只有copy标签。
        
        深拷贝和浅拷贝
        1.深拷贝：内容拷贝，产生新的对象
        2.浅拷贝：指针拷贝，没有产生新的对象
 
    7、weak指针原理：
         __weak和__unsafe_unretained指针不会对对象的引用计数产生影响，但是__weak在对象销毁后自动置自己为nil，而__unsafe_unretained则还是保留了原来的地址(坏地址)。
        weak指针会在对象的delloc方法中被置nil。
        // ARC是LLVM编译器和Runtime系统相互协作的一个结果。
            在ARC机制下，LLVM自动帮我们生产MRC下的释放代码，rumtime帮我们清楚weak指针。
 
    8、iOS在主线程的Runloop中注册了2个Observer
        第1个Observer监听了kCFRunLoopEntry事件，会调用objc_autoreleasePoolPush()
        第2个Observer
            监听了kCFRunLoopBeforeWaiting事件，会调用objc_autoreleasePoolPop()、objc_autoreleasePoolPush()
            监听了kCFRunLoopBeforeExit事件，会调用objc_autoreleasePoolPop()
        pop是把当前代码中未 来需要被释放的对象 放到 page栈中， push是把page栈中的对象释放。也就是过了这段代码之后，是下一段代码的push、pop了，之前的代码已经过去了。

 
 */

class TestMemory_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试App内存的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestMemory_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestMemory_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试内存的分配Allocations。
            /**
                1、内存分配分析：点击 product --> profile --> 进入instrument --> Allocations--> 左上角选择真机 --> 点击红色录制按钮 --> 查看运行数据。
                  Anonymous VM: 匿名虚拟内存，也就是OS中的虚拟内存，可能是借用硬盘的容量。
                  All Heap Allocations： 堆空间的内存占用。
             
                2、UIImage通过named来加载的话，图片会有缓存不会被释放, 在内存中, 只有一份，每次对该图片的使用都是引用缓存。
                  但是通过bundle的方式加载的话，图片不会有缓存，UIImageView消失，图片也会从内存中销毁。
                  
             */
            print("     (@@ 0、测试内存的分配。")
            let _ = self.bgView.subviews.map { $0.removeFromSuperview() }
            let imgView = UIImageView()
            self.bgView.addSubview(imgView)
            imgView.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            }
            
            let labiBundlePath = Bundle.main.path(forResource: "labi", ofType: "bundle")    //自定义的bundle的路径
            let labiBundle = Bundle.init(path: labiBundlePath!)//自定义的bundle
            let labiBigPath = labiBundle?.path(forResource: "labibig", ofType: "jpg", inDirectory: "labixiaoxinImage")
            imgView.image = UIImage.init(contentsOfFile: labiBigPath!)
            
        case 1:
            //TODO: 1、测试内存泄漏Leaks，循环引用，不释放。
            /**
                1、内存泄漏： xcode -> open developer tool -> 进入instrument --> Leaks --> 左上角选择真机 --> 点击红色录制按钮 --> 查看运行数据。
                   在Leaks工具中：
                                1.底部的Snapshots按钮，可以修改采样时间间隔。
                                2.在中间状态栏的Leaks中可以，选择Cycle & root查看循环引用。
                                3.这些按钮的位置会因为xcode的更新而变化，多点点，找找。
                2、出现内存泄漏的时候，会出现❌，然后就可以选择Cycle & root来查看循环引用。
             */
            print("     (@@ 1、测试内存泄漏Leaks，循环引用，不释放。")
            // person 和 curDog 会循环引用，不释放。
            let person = TestMemory_Person()
            let curDog = TestMemory_Dog()
            person.dog = curDog
            curDog.master = person
            
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
            print("     (@@")
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestMemory_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestMemory_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        /// 内容背景View，测试的子view这里面
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
extension TestMemory_VC {
    
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
extension TestMemory_VC: UICollectionViewDelegate {
    
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



