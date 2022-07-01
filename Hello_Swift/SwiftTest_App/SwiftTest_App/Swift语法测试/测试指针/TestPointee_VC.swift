//
//  TestPointee_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/7.
//  Copyright © 2022 com.mathew. All rights reserved.
//

//MARK: - 笔记
/**
    1、    OC                     swift                         解释
       const T *            unsafePointer<T>             指针及所指向的内容都不可变
       T *                  unsafeMutablePointer         指针及所指向的内容都可变
       const void *         unsafeRawPointer             无类型指针，指向的值必须是常量（指向的内存区域未定）
       void *               unsafeMutableRawPointer      无类型指针，指向的内存区域未定，也叫通用指针（指向的内存区域未定）
 
        计算机指针的最小寻址单位是一个字节，8bit。指针的大小由编译器的位数来决定，编译器的位数决定的当前环境的最大寻址空间。
        
    
    2、print(MemoryLayout<Int>.alignment)    // 8 字节对齐
       print(MemoryLayout<Teacher>.size)     // 9 字节实际大小
       print(MemoryLayout<Teacher>.stride)   // 16 字节步长，一个对象占位的空间大小。
 
    3、指针指向对象分配的内存空间，不同的指针类型，指针偏移内存空间的的计数方式不一样。
        原生指针：
        类型指针：
        

 */

class TestPointee_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试指针的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestPointee_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试访问系统的类的私有属性名字
            print("     (@@  测试访问系统的类的私有属性名字")
            //code这里插入相关的代码
            /// 通过runtime机制，测试获取UIGestureRecognizer的所有属性(包括私有)
            /**
                目的：获取vc的interactivePopGestureRecognizer的target属性，然后我们新建一个GestureRecognizer来替换vc的interactivePopGestureRecognizer。
                1、通过runtime获取动态属性名字和类型之后，就可以通过KVC来赋值给私有属性了。
             */
            
            ///<_UIParallaxTransitionPanGestureRecognizer: 0x7feeea60c040; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7feeea70a720>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7feeea60a5f0>)>>
            let gesture: UIGestureRecognizer = self.navigationController!.interactivePopGestureRecognizer!
          
            var memCount:UInt32 = 0
            
            //1、获取属性的名字
            /// cls: 需要被获取成员属性的类
            /// outCount: 被获取类的成员属性的个数，该参数传入指针类型。
            let ivar: UnsafeMutablePointer<Ivar>? = class_copyIvarList(UIGestureRecognizer.self, &memCount)
            for i in 0 ..< memCount {
                
                let namePoint = ivar_getName(ivar![Int(i)])!
                let name = String(utf8String: namePoint)
                print("UIGestureRecognizer 的属性名：\(String(describing: name))")
            }
            /// 通过KVC获取到属性
            /**
                <__NSArrayM 0x600002d5e160>((action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fe80ec140d0>))
                发现是属性是一个数组，强制转换为数组，看得清晰一些，那么此时你可以通过xcode断点，点击左侧控制台，看到数组里面的元素是什么类型。
             */
            //2、获取属性的类型，发现是数组，继续深挖数组里面的元素。
            let targetArr:Array<Any> = gesture.value(forKeyPath: "_targets") as! Array<Any>
            print("获取到的target属性：\(targetArr)")
            for item in targetArr {
                print("targetArr 里的元素：\(item)")
            }
            
            // 3、 数组的元素，该元素是一个对象，有一个属性，属性名字是 _target , _target的类型是_UINavigationInteractiveTransition，所以这个属性就是我们的目标了。
            let targetObject:NSObject = targetArr[0] as! NSObject
            let target = targetObject.value(forKeyPath: "_target")
//            let target = targetObject
            
            
            let pan = UIPanGestureRecognizer.init(target: target, action: Selector.init(("handleNavigationTransition:")))
            self.navigationController?.view.addGestureRecognizer(pan)
            
            break
        case 1:
            //TODO: 1、测试对象与结构体的内存分配
            /**
                1、实例对象的大小、对齐、步长 都是8字节。
                2、结构体的对齐8，步长和实际大小，根据具体的分配来。 步长是一个对象占位的空间大小，不是实际填充的大小。
             */
            print("     (@@ 1、测试指针的类型，指针的内容。")
            let p0 = Point_Person()
            print("对象的对齐字节：\(MemoryLayout<Point_Person>.alignment)")
            print("对象的实际大小：\(MemoryLayout.size(ofValue: p0))")
            print("对象的步长：\(MemoryLayout<Point_Person>.stride)")
            
            let s0 = Point_Student(PName: "小学生", PAge: 5)
            print("结构体的对齐字节：\(MemoryLayout<Point_Student>.alignment)")
            print("结构体的实际大小：\(MemoryLayout.size(ofValue: s0))")
            print("结构体的步长：\(MemoryLayout<Point_Student>.stride)")
            
        case 2:
            //TODO: 2、测试原生指针。
            print("     (@@ 2、测试原生指针。")
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
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: nil, action: nil)
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
@objc extension TestPointee_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
    func panAction(_ sender:UIPanGestureRecognizer){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestPointee_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestPointee_VC {
    
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
extension TestPointee_VC: UICollectionViewDelegate {
    
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
    1、
 */
