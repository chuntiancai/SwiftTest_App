//
//  测试逆向工程_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/11/17.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试逆向工程的VC
// MARK: - 笔记
/**
    1、所谓iOS的逆向工程就是从app的应用，逆向分析出app的源码，用了那些函数，那些库之类的。
        这就需要获取到iOS的系统权限，也就是需要越狱，但是现在越狱好像没什么市场了，先看着呗。
    2、iOS和mac os都是基于Darwin内核的(苹果的一个基于Unix的开源系统内核)，所以iOS中同样支持终端的命令操作。
        所以你可以看到系统底层库，有一个叫Darwin。
        所以你也可以通过命令行操作iPhone，但是需要通过mac远程登录到iPhone上。
 
    3、SSH：安全外壳协议，为远程登录提供安全保障的协议。基于TCP通信协议。
       OpenSSH：SSH协议的免费开源实现，就是一个软件\程序\或者说工具。iPhone需要越狱。
       SSL：Secure Socket Layer 网络安全协议，主要是用于保障网络传输的安全，在传输层。
       OpenSSL：SSL的开源实现，也就是工具。
       OpenSSH是依赖于OpenSSL的实现，即OpenSSL是OpenSSH实现的基础。
       计算机的22端口，是用于提供ssh服务的。
 
 */

class TestReverse_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试逆向工程的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestReverse_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestReverse_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、判断当前手机是否越狱。
            print("     (@@ 0、判断当前手机是否越狱。")
            //1、 通过判断手机是否安装了Cydia.app来判断，也就是Cydia.app的路径是否存在。
            
            /// 常见越狱文件,通过判断路径是否存在。
            let pathArray = ["/Applications/Cydia.app",
                             "/Library/MobileSubstrate/MobileSubstrate.dylib",
                             "/bin/bash",
                             "/usr/sbin/sshd",
                             "/etc/apt"]
            for pathStr in pathArray {
                let isExist = FileManager.default.fileExists(atPath: pathStr);
                print("\(pathStr)存在：\(isExist)")
            }
         
            /// 能否读取读取系统所有的应用名称。
            let isAll = FileManager.default.fileExists(atPath: "/User/Applications/");
            print("能否读取读取系统所有的应用名称:\(isAll)")
            
            /// swift使用C语言
            var stat_info: stat = stat()
            ///使用stat系列函数检测Cydia等工具
            let statResult = stat("/Applications/Cydia.app", &stat_info)
                print("stat函数的结果是：\(statResult)")
            
            /// 读取环境变量
            let checkInsertLib:UnsafeMutablePointer<CChar>? = getenv("DYLD_INSERT_LIBRARIES");
            print("getenv系统函数返回的结果是：\(String(describing: checkInsertLib))")
        case 1:
            //TODO: 1、
            print("     (@@ 1、")
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
extension TestReverse_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestReverse_VC{
    
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
extension TestReverse_VC {
    
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
extension TestReverse_VC: UICollectionViewDelegate {
    
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
