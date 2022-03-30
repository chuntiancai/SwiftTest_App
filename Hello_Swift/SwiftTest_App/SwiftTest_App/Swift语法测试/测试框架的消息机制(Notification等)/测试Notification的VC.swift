//
//  测试Notification的VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/24.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//  测试Notification的VC

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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试Notification的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
        
        //MARK: 框架注册主题者、观察者
        NotificationCenter.default.addObserver(zhangsan, selector: #selector(Noti_person.acceptNews(note:)), name: NSNotification.Name.init("军事新闻"), object: newsCompany1)
        NotificationCenter.default.addObserver(lisi, selector: #selector(Noti_person.acceptNews(note:)), name: NSNotification.Name.init("娱乐新闻"), object: newsCompany2)
        
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestNotification_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、主题者通过框架发布通知
            print("     (@@  主题者通过框架发布通知")
            let news1 = Notification.init(name: NSNotification.Name.init("军事新闻"), object: newsCompany1, userInfo:["阿富汗政变":"阿富汗政变，美国跑路，留下烂摊子。","立陶宛":"立陶宛以卵击石，公开承认台湾驻扎，傻不拉几"])
            let news2 = Notification.init(name: NSNotification.Name.init("娱乐新闻"), object: newsCompany2, userInfo:["王力宏PUA":"王力宏塌台，是吴亦凡，罗志祥的结合体。","罗志祥时间管理者":"小猪多人运动，时间管理者，以一敌十，至死方休"])
            NotificationCenter.default.post(news1)
            NotificationCenter.default.post(news2)
            break
        case 1:
            //TODO: 1、移除观察者对指定通知的监听
            print("     (@@ 移除指定通知")
            NotificationCenter.default.removeObserver(zhangsan, name: NSNotification.Name.init("军事新闻"), object: newsCompany1)
            /// 移除观察者所有的监听
            NotificationCenter.default.removeObserver(zhangsan)
            
        case 2:
            //TODO: 2、
            print("     (@@ ")
        case 3:
            //TODO: 3、
            print("     (@@ ")
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
extension TestNotification_VC{
   
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

// MARK: - 笔记
/**
 
 */


