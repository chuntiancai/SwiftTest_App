//
//  测试KVO的VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/13.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试KVO的VC
// MARK: - KVO的原理
/**
    1、KVO的原理就是使用装饰者模式，利用动态，生产一个派生类作为装饰者，改派生类继承原来的类。
        装饰者内部有通过指针(superclass)指向原来的类对象，也对getter/setter方法进行了加强。
        1.当属性第一次被观察时，系统利用RuntimAPI动态生成一个派生类(该类的子类)，
        2.重写被观察属性的setter 方法。
        3.将isa指针指向派生类(装饰者)。
 
    2、所以KVO的核心就是对getter/setter方法进行了重写和加强。
 
 
 */


/**
    1、KVO用于监听对象的某个对象发生变化时，指定调用某个方法。(观察者模式)。也是通过keyPath进行操作。
       观察者自身要有定义接收主题消息的方法。
    2、KVO也可以监听得到私有变量的变化。
    3、苹果KVO的实现是，为主题者隐含生成一个子类，当主题者的属性发生变化时，该子类去调用观察者的监听方法。也就是子类完成观察者模式的操作。
       苹果会经常采用隐含子类的方式来实现一些模式，例如字典和数组的扩展也是。
    4、必须在析构方法中释放观察者。
 
    5、添加了KVO属性监听的对象，那么该对象的isa指针会重新指向一个中间对象，中间对象的superclass指针再指向原来的类对象，中间对象就处理了发布通知，调用监听者方法的逻辑。
        该中间对象(NSKVONotifying_XXX)是在程序运行过程runtime中，动态创建的。中间对象只用于寻找方法链表，找不到就直接原来类对象的逻辑。
        中间对象继承了被监听对象的类对象，会重写类对象里的一些方法。
        中间类对象重写了属性的set方法，去调用foundation框架的_NSSetXXXValueAndNotify方法，该方法重写了原来类对象的willChangeValueForKey和didChangeValueForKey方法，然后等属性的变量被改完之后，就去发布更新通知，是在重写didChangeValueForKey方法里去发布通知的，但是会校验willChangeValueForKey又没执行。
 
    6、直接通过指针修改成员变量，不会出发KVO，因为这是直接修改地址上的值，不会调用set方法。
 */

import Dispatch
class TestKVO_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    var personA = KVO_Person(PName: "zhangsan", PAge: 17)
    var personB = KVO_Person(PName: "lisi", PAge: 18)
    var kvo_Observer = KVO_Observer()
    var observerObj:NSKeyValueObservation?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试KVO功能"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
       
    }

    deinit {
        print("TestKVO_VC的析构方法\(#function)～")
        personA.removeObserver(kvo_Observer, forKeyPath: "name")
        personA.removeObserver(kvo_Observer, forKeyPath: "sex")
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestKVO_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、通过addObserver方法设置观察者，监听主题对象中的属性变化
            print("     (@@  通过addObserver方法设置观察者，监听主题对象中的属性变化")
            personA.addObserver(kvo_Observer, forKeyPath: "name", options: [.new,.old], context: nil)
            personA.addObserver(kvo_Observer, forKeyPath: "sex", options: [.new,.old], context: nil)
            personA.name = "张三三"
            personA.sex = "男"
            
            break
        case 1:
            //TODO: 1、通过闭包接收监听的消息
            print("     (@@ 1、通过闭包接收监听的消息")
            observerObj = personB.observe(\KVO_Person.name, options: .new) { (person, change) in
                print("闭包中的监听：\(person)---change:\(change)")
            }
            observerObj = personB.observe(\KVO_Person.sex, options: .new) { (person, change) in
                print("闭包中的性别监听：\(person)---change:\(change)")
            }
            personB.name = "李三四"
            personB.sex = "女"
        case 2:
            //TODO: 2、通过KVO监听私有变量
            print("     (@@ 通过KVO监听私有变量")
            personB.addObserver(kvo_Observer, forKeyPath: "age", options: [.new,.old], context: nil)
            personB.setValue("22", forKey: "age")
            print("修改私有变量后的personB:\(personB)")
        case 3:
            //TODO: 3、查看KVO方法调用。
            print("     (@@ 3、查看KVO方法调用。")
            let address = personA.method(for: Selector.init(("name")));
            print("age变量的地址：\(String(describing: address))")
        case 4:
            //TODO: 4、查看实例对象的方法列表
            /**
                1、只能获取到有 @objc 前缀的方法，也就是只能获取到OC方法，证明swift方法列表不在这里。
             */
            print("     (@@4、查看KVO方法调用。")
            var mCount:UInt32 = 0
            /// 指向数组的指针，数据的小标以元素类型单位为步长。
            let mListPtr:UnsafeMutablePointer<Method>? = class_copyMethodList(personA.classForCoder, &mCount)
            
            for index in 0 ..< mCount {
                ///获得方法指针
                let method:Method = mListPtr![Int(index)]
                
                ///获取方法结构体
                let mSelector:Selector = method_getName(method)
                
                ///获得方法名
                let mName:String = NSStringFromSelector(mSelector)
                
                print("获得的方法名是：\(mName)")
            }
            
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
            print("     (@@移除所有观察者")
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
extension TestKVO_VC{
    
   
    //MARK: 0、
    func test0(){
        
    }
    //MARK: 1、
    func test1(){
        
    }
    //MARK: 2、
    func test2(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestKVO_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestKVO_VC {
    
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
extension TestKVO_VC: UICollectionViewDelegate {
    
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

