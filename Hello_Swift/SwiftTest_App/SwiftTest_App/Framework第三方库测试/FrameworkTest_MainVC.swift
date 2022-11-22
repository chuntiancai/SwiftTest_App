//
//  FrameworkTest_MainVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/26.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试Framework的VC
// MARK: - 笔记
/**
    基础知识：
    1、静态库：.a文件或者.framework文件。链接时，静态库会被完整地复制到可执行文件中，多个可执行文件就有多份冗余拷贝。目标程序没有外部依赖，可以直接运行。
    2、动态库：.dylib文件或者.framework文件。链接时不复制，由系统维护，程序运行时由系统动态加载到内存，供程序调用，系统只加载一次，多个程序共用，节省内存。
              苹果不允许动态库的App上架。
              所以.framework文件既可能是静态库，也可能是动态库。
 
    3、Swift不支持制作.a的静态库,因此只能制作.framework的静态库。
       Framework: 一种打包方式，简单将二进制文件、头文件和其他一些信息聚合在一起。
                 系统级别: Dynamic Framework, 系统提供的framework都是动态库，比如UIKit.framework，系统的framwork不需要拷贝目标程序。
                 用户级别：Static Framwork和Dynamic Framework（Embeded Framework)。
                 static Framwork： 二进制文件+头文件+资源文件。
                 Embeded Framework： 用户可以制作的动态库，受到iOS平台的沙盒机制和签名机制限制，具有部分动态特性。
                                     可以在Extension可执行文件和APP可执行文件中执行，不能在不同app进程中共享，而且需要拷贝到目标程序。
 
    4、模拟器CPU架构和真机的CPU架构师不一样的，所以静态库不能共用于真机与模拟器。
       模拟器CPU以前是x86系列，但是真机都是arm系列，所以静态库要适配不同CPU架构。
       在终端：lipo -info .a文件 ；//该命令可以看.a文件支持的cpu架构。
 
       静态库项目工程： xcode -> Targets -> build setting -> architecture -> build active architect only -> 设置NO
                     也就是不要 编译成仅仅适合当前架构的 可执行文件。就是要编译成适合所有cpu架构的可执行文件。看一下英文的意思啊。
 
       可以通过： lipo -create 真机.a 模拟器.a -output 合并.a
                命令合并模拟器和真机的静态库，但是有个缺点，此时的合并库是两者的大小相加，体积太大。
 
    5、生成发布版本的库：xcode运行目标图标上 -> 点击下拉列表 -> Edit scheme -> Profile -> Release 或者 debug。
       测试版本包含冗余符号信息，便于调试。发布版本则是瘦身的可执行文件。
 
    6、xcode制作静态库不显示Products目录：
        1、选择 FrameworkTest.xcodeproj， 右键显示包内容。
        2、打开project.pbxproj。
        3、按照下面方式修改文件并保存：
            搜索productRefGroup，将productRefGroup上面一行的mainGroup的值，复制给productRefGroup，再保存一下，Xcode就自动刷新出来了。
            Tips: 虽然 mainGroup 和 productRefGroup 对应的value值是一样的，但是这样操作之后确实会出现Products文件夹，应该不是XCode编译器的问题。
 

 
    ==================
    自己制作framework使用：
    1、xcode -> file -> new project -> framework -> 创建完成一个framwork工程。
        1.1、把.Framework文件拖进项目工程的目录中，在项目的TARGETS -> General -> Embedded Binaries -> +  中添加.Framework文件。
        1.2、在framework工程中，资源文件需要存放在bundle里面。例如：图片这些。
 
    2、在需要使用到Framework的代码源文件中，import "你的framework"。
 
    3、测试静态库：
        1、Target -> + -> 直接在Target下添加一个framework，它会自动生成文件夹和.framework文件，然后你就可以边写边测了。
 
 
    ===================================
    测试自己制作的cocoapod私有库：

       1、首先你要配置安装好cocoapod的环境，然后就可以使用cocoapod命令了。
       
       2、通过命令创建cocoapod私有库：
           $ cd 合适的目录（最好是空文件夹）
           $ pod lib create yourLibName（库名字）//这里会生成一系列必要文件，包括yourLibName.podspec文件，熟悉之后可以手动生成添加。
       
       3、描述信息：在yourLibName.podspec文件中，描述你的库的信息、xcode工程信息等。例如它们的github地址、编译文件、依赖关系等等。
       
       4、上传文件：将yourLibName.podspe和xcode项目工程文件一同上传到yourLibName.podspe中描述的仓库地址上，并打上tag。
                 （tag 和yourLibName.podspec中s.version 的保持一致）

 */


import FrameworkMake_Test   //引进你制作的framework
import ctc_podspec  //引进自己制作的cocoapod私有库
//import ctchStaticLib    //引进静态库.a文件

class FrameworkTest_MainVC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "测试Frameworkd的MainVC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
        
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension FrameworkTest_MainVC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            print("     (@@测试自制的framework中的方法")
            let frameW = FrameworkTestClass()
            frameW.testFramwork(name: "～～你好呀")
            frameW.addNmae(name: "～～添加的名字呀")
            break
        case 1:
            print("     (@@测试自制的cocoapod的私有库")
            let testPod = TestCocoPodClass()
            testPod.addNmae(name: "帅爆了")
        case 2:
        //TODO: 2、测试.a文件，静态库
            /**
                1、测了，swift制作不了.a文件。虽然framwork是.a和其他文件的集成。
             */
            print("     (@@2、测试.a文件，静态库")
//            let cLib = ctchStaticLib()
            
            
            
        case 3:
            print("     (@@")
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
extension FrameworkTest_MainVC{
    
}


//MARK: - 工具方法
extension FrameworkTest_MainVC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension FrameworkTest_MainVC {
    
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
        
        baseCollView.backgroundColor = UIColor.cyan
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension FrameworkTest_MainVC: UICollectionViewDelegate {
    
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

