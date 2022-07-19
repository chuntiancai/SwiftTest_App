//
//  测试Notification的VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/24.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//  测试Notification的VC
// MARK: - 笔记

import Foundation
/**
    1、观察者(订阅者)在框架注册。主题者通过框架发布通知，把自己注册成通知实例，然后利用框架把通知发布出去。
    2、在哪个线程中发布的通知，那么接受通知的方法就会在哪个线程中执行，与注册所在的线程没半毛钱关系。
        但是你要注意，异步线程发布的通知，无法确定是什么时候发布的通知。
        所以你最好就在注册的时候说明要在哪个线程执行，但是这个只有block的通知有这个功能。
        所以你只能在通知的执行方法里，切换线程。
 */


class TestNotification_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    /// 主题发布者，通知发布者
    var newsCompany1 = Noti_Subject(PName: "今日头条", PAge: 5)
    var newsCompany2 = Noti_Subject(PName: "新浪新闻", PAge: 8)
    
    /// 主题观察者，通知接收者
    private var zhangsan = Noti_person(PName: "张三", PAge: 17)
    private var lisi = Noti_person(PName: "李四", PAge: 18)
    private var wangwu = Noti_person(PName: "王五", PAge: 19)
    private var blockNSObject:NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试Notification的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
        
       
        
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestNotification_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、观察者(订阅者)在框架注册。
            print("     (@@ 框架注册订阅者、观察者")
            NotificationCenter.default.addObserver(zhangsan, selector: #selector(Noti_person.acceptNews(note:)), name: NSNotification.Name.init("军事新闻"), object: newsCompany1)
            NotificationCenter.default.addObserver(lisi, selector: #selector(Noti_person.acceptNews(note:)), name: NSNotification.Name.init("娱乐新闻"), object: newsCompany2)
            
            // Name:通知名称
            // object:谁发出的通知（主题者）
            // queue:决定block在哪个线程执行,nil:在发布通知的线程中执行
            // usingBlock:只要监听到通知,就会执行这个block
            // 注意:一定要记得移除
            blockNSObject = NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "block通知"), object: nil, queue: nil) { noti in
                print("通过block执行通知到达时的任务：\(noti) --- \(Thread.current)")
            }
        case 1:
            //TODO: 1、主题者 在框架 发布通知
            /**
                1、主题者通过框架发布通知，把自己注册成通知实例，然后利用框架把通知发布出去。
             */
            print("     (@@  主题者通过框架发布通知")
            let news1 = Notification.init(name: NSNotification.Name.init("军事新闻"), object: newsCompany1, userInfo:["阿富汗政变":"阿富汗政变，美国跑路，留下烂摊子。","立陶宛":"立陶宛以卵击石，公开承认台湾驻扎，傻不拉几"])
            let news2 = Notification.init(name: NSNotification.Name.init("娱乐新闻"), object: newsCompany2, userInfo:["王力宏PUA":"王力宏塌台，是吴亦凡，罗志祥的结合体。","罗志祥时间管理者":"小猪多人运动，时间管理者，以一敌十，至死方休"])
            NotificationCenter.default.post(news1)
            NotificationCenter.default.post(news2)
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "block通知")))
            break
        case 2:
            //TODO: 2、移除观察者对指定通知的监听
            print("     (@@ 2、移除指定通知")
            NotificationCenter.default.removeObserver(zhangsan, name: NSNotification.Name.init("军事新闻"), object: newsCompany1)
            /// 移除观察者所有的监听
            NotificationCenter.default.removeObserver(zhangsan)
            /// block通知的移除
            if blockNSObject != nil {
                NotificationCenter.default.removeObserver(blockNSObject!)
            }
            
        case 3:
            //TODO: 3、测试通知在多线程中的注册。
            print("     (@@ 3、测试通知在多线程中的注册。")
            DispatchQueue.global().async {
                print("异步队列注册：\(Thread.current)")
                NotificationCenter.default.addObserver(self, selector: #selector(self.test0(_:)), name: Notification.Name.init(rawValue: "test0的通知"), object: nil)
            }
            print("主队列注册：\(Thread.current)")
            NotificationCenter.default.addObserver(self, selector: #selector(self.test1(_:)), name: Notification.Name.init(rawValue: "test1的通知"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.test2(_:)), name: Notification.Name.init(rawValue: "test2的通知"), object: nil)
            
        case 4:
            //TODO: 4、测试通知在多线程中的发布。
            print("     (@@ 4、测试通知在多线程中的发布。")
            /// 在主队列中发布
            NotificationCenter.default.post(Notification.init(name: Notification.Name.init(rawValue: "test0的通知")))
            NotificationCenter.default.post(Notification.init(name: Notification.Name.init(rawValue: "test1的通知")))
            /// 在异步队列中发布
            DispatchQueue.global().async {
                print("异步队列发布：\(Thread.current)")
                NotificationCenter.default.post(Notification.init(name: Notification.Name.init(rawValue: "test2的通知")))
            }
        case 5:
            //TODO: 5、测试通知在多线程中的执行。
            print("     (@@ 5、测试通知在多线程中的执行。")
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
@objc extension TestNotification_VC{
   
    //MARK: 0、
    func test0(_ noti: Notification){
        print("\(#function)接受到的通知：\(noti) --- \(Thread.current)")
    }
    //MARK: 1、
    func test1(_ noti: Notification){
        print("\(#function)接受到的通知：\(noti) --- \(Thread.current)")
    }
    //MARK: 2、
    func test2(_ noti: Notification){
        print("\(#function)接受到的通知：\(noti) --- \(Thread.current)")
    }
    
}


//MARK: - 设置测试的UI
extension TestNotification_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestNotification_VC {
    
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
extension TestNotification_VC: UICollectionViewDelegate {
    
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



