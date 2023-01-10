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
 
 */
//MARK: - Mach-O文件类型
/**
     一、Mach-O文件类型：
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
 
            工具：MachOview软件--可以可视化查看Mach-O文件。
 
         6.可执行的Mach-O文件是通过dyld程序来加载进内存的。

     二、通用二进制文件(Universal Binary)：同时使用于多种CPU架构的二进制文件。
         $(ARCHS_STANDARD)：xcode内置的环境变量，不同xcode版本，该变量的值不一样。
 */

//MARK: - 脱壳
/**
    二、脱壳
    1、加壳：ipa包上传到App Store后，App Store会对ipa包进行加壳之后，再供用户下载。加壳相当于对app的可执行文件进行了加密。
            对可执行文件的代码进行加密，外面套了一层壳程序，壳程序也是可执行文件，只是用于解密目标的可执行文件。dyld是把壳程序加载进了内存的。
            封装了我们的可执行文件的程序就叫壳程序。
            linux命令：
                     otool -l Swift_TestApp | grep crypt //查看该Mach-O文件有没加密加壳,0代表没加密。
 
    2、脱壳：摘掉可执行文件的壳程序。还原出本来的可执行文件。有硬脱壳和动态脱壳的方法。
            硬脱壳：直接执行解密算法，还原可执行文件。
            动态脱壳：从内存中取出运行中的可执行文件。
 
            脱壳工具：Clutch(越狱放在手机里面)、dumpdecrypt（去github搜）
         
    3、hook应用程序去广告：也就是修改App的代码里面的方法实现。
            通过reveal工具(可视化)查看app的源码头文件,获取方法的信息 --> 安装ldid签名工具 --> 安装thoes
            --> 用thoes里的nic.pl指令创建tweak工程 --> 修改tweak工程里的xm文件 --> 通过tweak工程将app的源码修改方法的实现
            --> tweak工程的makefile指令会把修改后的源码重新生成deb包(越狱的包) --> 安装deb包到手机上。
            linux命令工具：thoes命令(去github下载，放到手机里)
 
        reveal软件：可视化查看源码的UI。
        ldid签名工具：对应xcode的codesign工具，thoes工具会用到它来签名deb包。
        thoes工具：安装到MAC上的命令工具，是tweak工程的运行和编译环境。
        tweak工程：是一个脚本可执行文件，输入是ipa包，输出是注入了hook代码的ipa包，相当于破解了的ipa包。
        hook代码：你在tweak工程里面写的源代码(Tweak.xm文件)，用的是tweak的语法(类似javascript)。
 
 */

//MARK: - tweak工程
/**
    1、tweak工程：是一个脚本可执行文件，输入是ipa包，输出是注入hook代码到ipa包的动态库中。相当于破解了的ipa包。
       SpringBoard软件：其实就是iPhone的桌面，桌面也是一个软件，万物皆软件。
       tweak工程的原理：
            1.编写Tweak代码
                $ make：编译Tweak代码为动态库(*.dylib)
                $ make package： 将dylib打包为deb文件。
                $ make install：将deb文件传送到手机上，通过Cydia安装deb
            2.插件(deb包)将会安装在手机的/Library/MobileSubstrate/DynamicLibraries文件夹中
                2.1、*.dylib文件：编译后的Tweak代码。
                2.2、*.plist文件：存放着需要hook的APP ID
            3.当打开APP时：
                3.1、Cydia Substrate（Cydia 已自动安装的插件）会让App去加载读经的edylib。
                3.2、修改App内存中的代码逻辑，去执行dylib中的函数代码。
            4.所以，theos的tweak并不会对App原来的可执行文件进行修改，仅仅是修改了内存中的代码逻辑。
 
      Tweak工程的语法(也叫logos语法)：http://iphonedevwiki.net/index.php/Logos
      Theos的环境变量配置：http://iphonedevwiki.net/index.php/Theos
      Tweak工程的目录结构：https://github.com/theos/theos/wiki/Structure
 
    2、越狱的本质是在iOS系统调用动态库的时候，插入中间代码，或者插入其他动态库。正常的App是不被允许使用动态库的，动态库仅仅iOS系统自身控制调用，越狱就是打破这一限制。
       源代码编译成汇编之后，汇编层面会去调用iOS系统的动态库。
 */

//MARK: - iOS命令行工具开发
/**
    1、命令行工具就是一个软件，一个可执行文件，跟app差不多。
    2、签名： 给可执行文件签上一定的权限，让它可以访问其他app的可执行文件。(这里的仅仅是权限的签名，其他的签名功能不是这里讨论的，例如加密签名这些)。
            .entitlements文件，其实就是xml文件，就是用来描述可执行文件的权限的配置文件。
            用ldid工具查看权限，加入权限。可以抄袭springboard桌面的权限。
    3、其实就是读取mach-0源文件，解析二进制代码。
    4、logos语法，其实就是用来写Tweak工程的语言。
 */

//MARK: - iOS签名机制
/**
    1、在iPhone的沙盒中，app有一个_CodeSignature文件夹，该文件夹保存了一些与app可执行文件相关的签名信息。签名信息会校验可执行文件是否被修改或者破坏。
            encrypt:加密，decrypt：解密，plaintext：明文，ciphertext：密文。
        签名基础知识：加密解密(对称密码DES、公钥密码RSA) --> 单向散列函数(MD4、SHA-1、) --> 数字签名 --> 证书 --> iOS签名机制。
 
        密钥：用于加密明文，解密密文。有多种密钥。例如：对称密码、公钥密码(非对称密码)、
             加密解密都用同一个密钥来操作的，就叫做对称密码。加密用一种密钥，解密用另一种密钥的，叫做非对称密码。
             公钥密码(RSA)：  公钥：公开发布的密钥。用于加密明文。虽然也有解密的功能。
                            私钥：私人持有的密钥。用于解密密文。虽然也有加密的功能。
        混合密码系统：
            因为非对称加密解密速度比较慢，所以就需要同时使用对称和非对称密码。
            发送者对 对称密码 进行公钥加密，发送者用 对称密码 对数据量大的明文进行加密 --> 接收者用私钥解密出 对称密码 ，接收者用 对称密码 解密数据量大的密文。
            HTTPS、SSL就是用了混合密码系统。
 
        单向散列函数(MD4、MD5、SHA-1、SHA-2、SHA-3)：
            单向散列函数可以根据消息的内容计算出散列值，而且散列值的位数时固定的，无论消息内容有多大。单向是指只能 消息-->散列值 ，无法 散列值 --> 消息，所以只能用于校验。
            MAC系统默认提供了MD5函数。直接在终端使用md5命令。
 
        数字签名(确保数据来源，目的是验证)：
            验证消息是否被篡改、伪装、来源。--- 刚好和公钥密码算法的流程反过来。
            数字签名流程：生成签名(发送者用签名密钥) --> 验证签名(接收者用验证密钥)
            保证消息确实是发送者发送的：用发送者的私钥进行签名；接收者用公钥进行解密。接收者用解密出来的信息(散列值)和明文发过来的信息(做散列值)做对比。
            中间人攻击：中间人拦截了 接收者 和 发送者 的公钥，冒名顶替 接收者 或者 发送者，在中间冒名顶替传递他们的通信。所以必须要确保公钥是来自接收者，而非中间人。
 
        证书(确保公钥来自官方)：
            可以解决中间人攻击。公钥证书(Public-Key Certificate, PKC)。认证机构(Certificate Authority,CA)。
            个人发布公钥 --> (个人注册)通过CA施加签名验证 --> CA生成个人相关的PKC --> 接收者下载PKC --> 接收者用PKC加密/解密消息内容。
                KPC里面包括了：个人姓名、邮箱、公钥等信息。
                CA就是相当于一种官方机构，用于确认“公钥确实属于此人”，有很多种CA组织或者公司。所以CA通过对个人注册进行收费赚钱。
                中间人无法替代CA来传递证书，因为CA是通过自己的私钥对PKC进行加密，中间人没有CA的私钥。
 
    2、iOS签名机制：
        2.1、保证安装到用户手机上的APP都是经过Apple官方允许的。
            Apple签名App的流程(xcode已经帮你自动化完成)：
            1.生成CertificateSigningRequest.cerSigningRequest文件。
            2.获得ios_development.cer\ios_distribution证书文件。
            3.注册device、添加App ID。
            4.获得*.mobileprovison文件。
 
            开发的MAC设备：mac公钥、mac密钥。
            Apple官方：apple私钥。
            iPhone真机：apple公钥。
 
            app源码 --> Mac电脑私钥签名 --> 签名后的ipa包。
            Mac电脑公钥 --> 被Apple私钥签名 --> 生成Apple认证的证书 --> Mac得到证书 --> 证书再被Apple私钥签名 --> 生成mobile provision(散列值) --> 再次被合进去ipa包。
            iPhone真机上的apple公钥 --> 验证ipa的mobile provision没被篡改 --> apple公钥解密出Mac的公钥 --> 用Mac的公钥验证ipa源码没被篡改。
            （Apple签名后的mobileprovision文件包含 MAC的公钥证书、devices、app id、entitlements等信息、devices、app id等信息是在MAC的公钥证书里的)
 
            MAC设备上的公钥：CertificateSigningRequest.cerSigningRequest文件，就是Mac电脑钥匙串上申请的请求证书。
            MAC电脑上的证书(KPC)：在Apple官网上上传Mac的公钥，Apple官网用私钥生成证书后，用Mac电脑下载下来就是了,然后用Mac电脑安装这个证书(.cer文件)，就可以在钥匙串访问了。
            生成mobileprovision文件：在Apple官网上申请，输入你的KPC、App ID、devices等信息，然后Apple官网生成mobileprovision文件供你下载。
 
            注意：通过Appstroe下载的app是没有mobileprovision文件的，因为已经证明该App是官方的了，只要用apple公钥再验证一下源码没被篡改就可以了。
                 所以mobileprovision文件除了验证App的官方性之外，还有一个很大的功能是向开发者收费。
 
            p12文件：所谓的p12文件，其实就是Mac电脑上的私钥、证书副本，用于团队开发。
 
    3、iOS重签名：
        3.1、也就是对原来的ipa包进行重签名，重签名可以让自己开发的ipa包也能安装到别人的未越狱手机上，该功能需要apple账号付费。
             越狱手机安装app可以无视签名，但是非越狱手机必须经过签名验证，而且app包必须要经过脱壳的才可以重签名。
            重签名是付费开发者账号对app的证书进行一个重签名，也要在mobileprovision里面添加别人的手机device。
            在Mac终端 --> (付费账号的证书ID)用codesign命令扩大ipa包的MAC公钥证书的权限 --> 在Apple官网申请添加了其他设备的mobileprovision文件  --> 修改mobileprovision文件就是用新的mobileprovision文件的entitlements文件替换原来mobileprovision文件里的entitlements文件，对它进行权限扩大。
 
            总的来说，就是我已经生成了ipa包，我不想重新打包新的ipa包，但是我有ipa里面的Mac公钥证书，所以我就要替换掉原来ipa包里mobileprovision文件的权限，也就是重签名了。 也就是上面的一系列步骤，对MAC公钥权限扩大，扩大原来ipa包里的mobileprovision文件的权限。
 
            (证书id查看、提取entitlements文件用security命令、codesign命令操作mobileprovision文件等操作)
 
            iOS系统两个常用的环境变量： @excutable_path 代表可执行文件所在的目录。 @loader_path 代表当前动态库在iOS系统中的目录。
 
            非越狱手机非法添加app的动态库，那些动态库也需要重签名。
 */


class TestReverse_VC: UIViewController {
    
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
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
