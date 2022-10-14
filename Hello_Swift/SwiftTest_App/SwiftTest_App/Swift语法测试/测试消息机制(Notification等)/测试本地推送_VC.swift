//
//  测试本地推送_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//

//测试本地通知推送的VC
// MARK: - 笔记
/**
    1、遵循 UNUserNotificationDelegate 协议的类可以作为 UserNotification 的代理，接收并处理用户输入、如何处理推送等。
        Apple 提示我们需要在 App 完成启动之前完成代理的设置，所以要在 application(_:didFinishLaunchingWithOptions:) return前中设置UNUserNotificationDelegate代理。
 
    2、和WKWebView一样，也需要在代理方法的参数闭包中允许通知。
    3、iOS10之后，使用UserNotification框架。UserNotification框架中的核心类列举如下：
        UNNotificationCenter：通知管理中心，单例，通知的注册，接收通知后的回调处理等，是UserNotification框架的核心。
        UNNotification：通知对象，其中封装了通知请求。
        UNNotificationSettings：通知相关设置。
        UNNotificationCategory：通知模板。
        UNNotificationAction：用于定义通知模板中的用户交互行为。
        UNNotificationRequest：注册通知请求，其中定义了通知的内容和触发方式。
        UNNotificationResponse：接收到通知后的回执。
        UNNotificationContent：通知的具体内容。
        UNNotificationTrigger：通知的触发器，由其子类具体定义。
        UNNotificationAttachment：通知附件类，为通知内容添加媒体附件。
        UNNotificationSound：定义通知音效。
        UNPushNotificationTrigger：远程通知的触发器，UNNotificationTrigger子类。
        UNTimeInervalNotificationTrigger：计时通知的触发器，UNNotificationTrigger子类。
        UNCalendarNotificationTrigger：周期通知的触发器，UNNotificationTrigger子类。
        UNLocationNotificationTrigger：地域通知的触发器，UNNotificationTrigger子类。
        UNNotificationCenterDelegate：协议，其中方法用于监听通知状态。
 
 */

class TestLocalNotification_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试本地通知推送"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestLocalNotification_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestLocalNotification_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、申请可以发布本地通知的权限
            print("     (@@ 0、创建并发布本地通知。")
            let _ = self.bgView.subviews.map { $0.removeFromSuperview() }
            /**
             UNAuthorizationOptionBadge   = (1 << 0),   //允许更新app上的通知数字
             UNAuthorizationOptionSound   = (1 << 1),   //允许通知声音
             UNAuthorizationOptionAlert   = (1 << 2),   //允许通知弹出警告
             UNAuthorizationOptionCarPlay = (1 << 3),   //允许车载设备接收通知
             */
            
            // 首先在app delegate中设置UNUserNotificationCenter.current()的代理对象。
            //1、检查用户权限，因为如果用户手动关闭权限，去申请的话是无效的。
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if #available(iOS 12.0, *) {
                    guard (settings.authorizationStatus == .authorized) ||
                            (settings.authorizationStatus == .provisional) else { return }
                }

                if settings.alertSetting == .enabled {
                    // Schedule an alert-only notification.
                } else {
                    // Schedule a notification with a badge and sound.
                }
            }
            // 1、申请权限
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.alert,.sound,]) {
                ( isGranted:Bool, error:Error?) -> Void in
                //在block中会传入布尔值granted，表示用户是否同意
                print("是否允许授权：\(isGranted) -- error:\(String(describing: error))")
            }
            
            
            
            
        case 1:
            //TODO: 1、创建并发布本地通知。
            print("     (@@ 1、创建并发布本地通知。")
            // 2、获取到用户权限后，使用UserNotification创建普通的本地通知
            // 2.1 设置通知的必选项、配置
            
            //通知内容类
            let notiContent:UNMutableNotificationContent = UNMutableNotificationContent()
            //设置通知请求发送时 app图标上显示的数字
            notiContent.badge = 2;
            //设置通知的内容
            notiContent.body = "这是iOS10的新通知内容：普通的iOS通知";
            //默认的通知提示音
            notiContent.sound = UNNotificationSound.default
            //设置通知的副标题
            notiContent.subtitle = "这里是副标题";
            //设置通知的标题
            notiContent.title = NSString.localizedUserNotificationString(forKey: "Hello", arguments: nil)
            //设置从通知激活app时的launchImage图片
            notiContent.launchImageName = "labi00";
            //设置5S之后执行
            let notiTrigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
            
            
            //创建通知请求对象
            let notiRequest:UNNotificationRequest = UNNotificationRequest.init(identifier: "ctchLocalNotification", content: notiContent, trigger: notiTrigger)
            
            //添加通知请求到通知中心。
            UNUserNotificationCenter.current().add(notiRequest) { (err:Error?) -> Void in
                print("添加通知请求到通知中心有无错误：\(String(describing:err ))")
            }
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


//MARK: - 设置测试的UI
extension TestLocalNotification_VC{
    
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
extension TestLocalNotification_VC {
    
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
extension TestLocalNotification_VC: UICollectionViewDelegate {
    
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

