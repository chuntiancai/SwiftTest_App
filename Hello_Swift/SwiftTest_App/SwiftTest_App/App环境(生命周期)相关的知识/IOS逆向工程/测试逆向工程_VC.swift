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
       计算机的22端口，默认是用于提供ssh服务的。
 
    4、Mac上有个usbmuxd程序(开机自启动)，可以将mac的数据通过usb传输到iPhone上。
        usbmuxd路径：/System/Library/PrivateFrameworks/MobileDevice.framework/Versions/A/Resources/usbmuxd
        mac登录到本地的10010端口 --> usbmuxd程序将本地10010端口映射到本地22端口 --> 通过USB连接到手机的22端口。
        使用usbmuxd的相关工具包 (tcprelay.py)可以实现通过本地10010端口映射本地22端口，要保持运行状态。
 
    5、sh脚本：创建sh文件 -> 在文件中输入linux命令(换行即可)  —> 终端：sh 你的.sh文件
            //这样就可以执行这个sh文件脚本了，用source命令、bash命令也可以执行。
            ssh和sh没有任何关系，ssh是一个关于安全的传输协议，sh是shell的简称，是脚本。
            sh、bash命令：开启一个子线程来执行脚本，执行完脚本仍停留在主线程的环境，不会切换到子线程的目录中。
            source命令：进入到shell脚本里的环境去执行脚本。source命令可以用一个点来代替，也可以叫做点命令。
            
            搜索如何在linux终端输入中文。
            
    6、Cycript是ObjectC ++ 、ES6(JavaScript)、java等语法的混合物，也是一个脚本语言。Cycript是由saurik(越狱创始人)推出的一款脚本语言。
              就是专门用于写iOS越狱代码的一种脚本语言。可以用来更方便地探索、调试、修改 Mac/iOS的app。
              Cycript也开发成了一个脚本工具，可以运行在iOS或者mac上。Cycript需要开启运行在iOS系统上。
              通过Cycript脚本，可以连接到app的进程中，进行对app的调试。
              在iOS终端上：ps指令查看在运行的进程 -> cycript -P app的进程id(或名字) -> 连接到app的进程上 -> cycript命令进行调试。
 
    7、Mach-O文件类型：
        1.开发到安装的过程：iOS系统中的可执行文件就是Mach-O格式的一种，这是所有源代码编译之后的可执行文件，当然不包括图片、plist等这些资源文件。
            资源文件是放在Mach-O描述的对应路径下，然后Mach-O文件通过寻址的方式来加载这些资源文件。
            编译--> 链接 --> 签名 --> xxx.app文件。
            xxx.app文件 --> 压缩 --> xxx.ipa文件。
            xxx.ipa文件就是一个安装包，可以安装在iOS系统上，手机上安装软件就是解压缩ipa文件的过程。
            Mach-O格式的文件类型有好几种。
            xnu是mac系统的内核源码，里面有定义mach-o文件的类型。xnu的源码编译之后就是系统内核了，直接运行在硬件上。
            Mach-O文件的类型：
                .o文件：目标文件。
                .a文件：静态库文件。其实就是若干个.o文件组合成。
                .dyld、.framework文件：也是符合Mach-O标准的文件。
                .dSYM文件：存储了编译源码后的文件的符号信息之类的文件，例如方法名之类的。
        2.代码的编译过程：
            OC源码文件 --> 汇编语言文件 --> 机器语言文件(Mach-O文件)。
            机器指令一一对于汇编指令，但是汇编指令并不是一一对应OC代码，而是一对多。
        3.dyld shared cache： 动态库共享缓存。
            1、iOS系统的动态库大都打包到这个缓存里面了，app在运行的过程中，内存回到该缓存中寻找需要的代码。
                iPhone CPU ARM处理器的指令集：
                        1.架构不一样，指令集也不一样，这是肯定的啊。所有指令集都是向下兼容的。
                        2.armv6、armv7、armv7s：在iPhone5及之前的处理器。
                        3.armv64：iPhone5s及之后的处理器。
            2、源代码中，可以通过bundle去加载手机系统的动态库，传入动态库dyld的路径即可通过bundle去加载了。
                在mac\ios中，是使用了usr\lib\dyld程序来加载动态库。dyld的源码是开源的，可以到网上找一下。
        4.一个xcode工程，可以生成很多目标文件，也就是可执行文件，也就是属于Mach-O类型的文件。
        5.Mach-O文件的基本结构：
            (1)由四个部分组成：Header （头部）、LoadCommands （加载命令）、Data （数据段 segment）、Loader Info （链接信息）
                Header （头部）：   该文件的CPU架构类型、文件类型等信息。
                LoadCommands （加载命令）：    该文件在虚拟内存中的逻辑架构、布局。用于告诉loader如何设置并加载二进制数据。
                Data （数据段 segment）： 存放数据：代码、字符常量、类、方法等。
                                        可以拥有多个 LoadCommands 中定义的segment，每个segment可以有零到多个section。每个段都有一段虚拟地址映射到进程的地址空间。
            (2)通过linux的otool指令可以查看Mach-O文件的特定部分和段的内容。
                lipo命令用于处理多架构的Mach-O文件。
                file命令，查看Mach-O文件。
                去github下载MachOView工具，可以可视化看Mach-O的文件架构。
        6.可执行的Mach-O文件是通过dyld程序来加载进内存的。
 
    8、通用二进制文件(Universal Binary)：同时使用于多种CPU架构的二进制文件。
        $(ARCHS_STANDARD)：xcode内置的环境变量，不同xcode版本，该变量的值不一样。
 
    二、脱壳
    1、加壳：ipa包上传到App Store后，App Store会对ipa包进行加壳之后，再供用户下载。加壳相当于对app的可执行文件进行了加密。
            对可执行文件的代码进行加密，外面套了一层壳程序，壳程序也是可执行文件，只是用于解密目标的可执行文件。dyld是把壳程序加载进了内存。
            壳程序
    2、脱壳：摘掉可执行文件的壳程序。还原出本来的可执行文件。有硬脱壳和动态脱壳的方法。
            硬脱壳：直接执行解密算法，还原可执行文件。
            动态脱壳：从内存中取出运行中的可执行文件。
 
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
