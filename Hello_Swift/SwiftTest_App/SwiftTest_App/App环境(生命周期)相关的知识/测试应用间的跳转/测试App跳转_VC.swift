//
//  测试App跳转_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/17.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试App跳转的VC
// MARK: - 笔记
/**
    1、设置 当前 APP 的scheme：
        1.xcode -> project -> target -> info -> urlType -> 加url scheme -> 记得代码调用时，是url scheme :// ,要加上://
          注意：配置scheme的时候不要写上://，但是代码的时候需要写上。
    2、在info.plist中设置可以跳转的其他App的白名单。
        info.plist -> LSApplicationQueriesSchemes<Array> -> item0 : SwiftNoteApp
 
    3、跳转到其他App的不同的界面：
        1.可以在当前App的target中配置多一个url scheme，也可以在其他app原来的scheme中加上host字段进行处理。
        2.在其他App的Appdeleagte中实现application(_:open:options:)代理方法，在这里分析url的host，作出相应的处理。
    
    4、常见的界面跳转Schme:
         记得要配置prefs的 URL type。已经被禁止，只能跳到设置页面了。
         
         About — prefs:root=General&path=About
         Accessibility — prefs:root=General&path=ACCESSIBILITY
         AirplaneModeOn— prefs:root=AIRPLANE_MODE
         Auto-Lock — prefs:root=General&path=AUTOLOCK
         Brightness — prefs:root=Brightness
         Bluetooth — prefs:root=General&path=Bluetooth
         。。。
 
    5、用第三方框架友盟SDK来集成社交分享。
      苹果原生的是social framework。
         
        
 
 */

class TestAppJump_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试App跳转的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestAppJump_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestAppJump_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试App间的跳转，openUrl。
            print("     (@@ 0、测试App间的跳转，openUrl。")
            // 打电话 tel://  发短信  sms:// http://
            // 如果想要跳转到不同的APP , 就是打开对应的 URL(scheme, )
            
            // http://www.520it.com/query?name=sz&age=18
            // http: 协议
            // host
            // path
            // query
            
            let url = URL(string: "https://www.12306.cn")
            print("url.scheme:",url!.scheme!, "url.host:",url!.host!, "url.path:",url!.path, "url.query:",url!.query ?? "")
            if UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.open(url!)
            }
            
            
//            let url = URL(string: "sms://10086")
//            UIApplication.shared.open(url!)
            
            
            // 1. 定义需要跳转到的APP 的scheme
            // 2. 直接打开对应的scheme
        case 1:
            //TODO: 1、跳转到自定义的App。
            print("     (@@ 1、跳转到自定义的App。")
            let url = URL(string: "SwiftNoteApp://")
            print("url.scheme:",url!.scheme ?? "" , "url.host:",url!.host ?? "" , "url.path:",url!.path, "url.query:",url!.query ?? "")
            if UIApplication.shared.canOpenURL(url!){
                print("能打开：\(url!)")
                UIApplication.shared.open(url!)
            }else{
                print("不能打开：\(url!)，或者没有安装")
            }
        case 2:
            //TODO: 2、跳转到自定义的App的其他页面。
            print("     (@@ 2、跳转到自定义的App的其他页面。")
            let url = URL(string: "SwiftNoteApp://PayVC")
            print("url.scheme:",url!.scheme ?? "" , "url.host:",url!.host ?? "" , "url.path:",url!.path, "url.query:",url!.query ?? "")
            if UIApplication.shared.canOpenURL(url!){
                print("能打开：\(url!)")
                UIApplication.shared.open(url!)
            }else{
                print("不能打开：\(url!)，或者没有安装")
            }
        case 3:
            //TODO: 3、跳转到系统常见的scheme页面 ,prefs:root=General&path=About
            /**
                1、iOS10之后已经禁用使用prefs这些私有url了，只能打开到设置页面，用UIApplication.openSettingsURLString
             */
            print("     (@@ 3、跳转到系统常见的scheme页面")
            let url = URL(string: UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(url!){
                print("能打开：\(url!)")
                UIApplication.shared.open(url!)
            }
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
extension TestAppJump_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestAppJump_VC{
    
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
extension TestAppJump_VC {
    
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
extension TestAppJump_VC: UICollectionViewDelegate {
    
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



