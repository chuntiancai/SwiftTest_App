//
//  TestGetPhoneSystemInfo_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/12/8.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试获取手机系统的信息

import UIKit

class TestGetPhoneSystemInfo_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    var utsName = utsname()
    let window = UIApplication.shared.windows.first    //window数组中的第一个window
    let testView = UIView() //测试导航栏的高度
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试获取手机系统的信息VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestGetPhoneSystemInfo_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、打印app信息
            print("     (@@  打印app信息～")
            print("iOS系统版本：\(UIDevice.current.systemVersion)") //iOS的系统版本
            print("系统model：\(UIDevice.current.model)")  //是iphone还是ipad什么的。
            
//            print("获取到的utsName:\(utsName)") //手机型号等信息
            uname(&utsName) //我也不知道为什么一定要调用这个函数
//            print("调用uname()函数之后的utsName:\(utsName)")
            let machineMirror = Mirror(reflecting: utsName.machine) //Mirror 用魔法去返回一个基于其中的实际子元素的 Children 集合，类似oc的MethodSwizzle
            let machine = machineMirror.children.reduce("") { machine, element in    //高阶函数，合并集合里面的元素
                guard let value = element.value as? Int8, value != 0 else { return machine }
                return machine + String(UnicodeScalar(UInt8(value))) //UInt8转换为字符串
            }
            print("utsName.machine的字符串信息：\(machine)")
            
            
            
            /// app的info.plist文件，工程配置文件，字典对象。你在xcode里用源码方式打开info.plist文件，然后就可以找到字典的key了。
            let infoDict:[String : Any] = Bundle.main.infoDictionary!
            print("APP的版本号：\(String(describing: infoDict["CFBundleShortVersionString"]))")
            break
        case 1:
            //TODO: 1、获取window的内边距，和安全区域尺寸
            print("     (@@ 获取window的内边距")
            print("window的内边距是：\(String(describing: window?.safeAreaInsets))")
            let tabVC = UITabBarController()
            print("状态栏的高度：\(UIApplication.shared.statusBarFrame)")
            print("导航栏的高度：\(String(describing: self.navigationController?.navigationBar.frame))")
            print("view的安全区域safeAreaInsets的高度：\(self.view.safeAreaInsets)")
            print("window的安全区域safeAreaInsets的高度：\(String(describing: window?.safeAreaInsets))")
            print("tabBar的高度：\(tabVC.tabBar.frame)")
            
        case 2:
            //TODO: 2、
            print("     (@@ ")
           
        case 3:
            //TODO: 3、获取本机的ip地址
            print("     (@@ 获取ip地址")
            var addresses = [String]()
            var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
            if getifaddrs(&ifaddr) == 0 {
                var ptr = ifaddr
                while (ptr != nil) {
                    /**
                        pointee是指针 指向区域 存储的值，也就是 内存地址上 存储的值。因为现在指针指向的类型是ifaddrs类型(结构体)，所以值就是ifaddrs的实例。
                     */
                    let flags = Int32(ptr!.pointee.ifa_flags)   //取出ifaddrs实例的ifa_flags成员值。
                    /**
                        ifa_addr是 ifaddrs结构体的成员，ifa_addr是sockaddr类型，所以下面的addr是sockaddr的实例。
                     */
                    var addr = ptr!.pointee.ifa_addr.pointee
                    
                    if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                        if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String(validatingUTF8:hostname) {
                                    addresses.append(address)
                                }
                            }
                        }
                    }
                    
                    /**
                        这是一个链表，所以这是寻找下一个ifaddrs结构体。
                     */
                    ptr = ptr!.pointee.ifa_next
                }
                freeifaddrs(ifaddr)
            }
            print("获取到的IP地址：\(addresses)")
            
        case 4:
            print("     (@@ 获取指定URL的ip地址")
            //  获取所有的IP Adress
            let host = CFHostCreateWithName(nil,"www.jfz.com" as CFString).takeRetainedValue()
            CFHostStartInfoResolution(host, .addresses, nil)
            var success: DarwinBoolean = false
            if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray? {
                for case let theAddress as NSData in addresses {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                                   &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                        let numAddress = String(cString: hostname)
                        print("获取指定URL的ip地址: \(numAddress)")
                    }
                }
            }
            
        case 5:
            print("     (@@")
            var address: String?
            
            // get list of all interfaces on the local machine
            var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
            guard getifaddrs(&ifaddr) == 0 else {
                break
            }
            guard let firstAddr = ifaddr else {
                break
            }
            for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
                
                let interface = ifptr.pointee
                
                // Check for IPV4 or IPV6 interface
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    // Check interface name
                    let name = String(cString: interface.ifa_name)
                    if name == "en0" {
                        
                        // Convert interface address to a human readable string
                        var addr = interface.ifa_addr.pointee
                        var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostName)
                    }
                }
            }
            
            freeifaddrs(ifaddr)
            print(" 获取ip地址：\(String(describing: address))")
        case 6:
            print("     (@@ 查看内网服务器的出口IP")
            let url = URL.init(string: "http://ifconfig.me/ip")!
            do {
                let ip  = try String.init(contentsOf: url)
                print("通过url获取本机ip地址：\(ip)")
            } catch let error {
                print("通过url获取本机ip地址错误：\(error)")
            }
            
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
extension TestGetPhoneSystemInfo_VC{
    
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
extension TestGetPhoneSystemInfo_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestGetPhoneSystemInfo_VC {
    
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
extension TestGetPhoneSystemInfo_VC: UICollectionViewDelegate {
    
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

