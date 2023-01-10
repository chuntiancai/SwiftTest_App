//
//  TestXcode_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/10.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试xcode工具的VC
// MARK: - 笔记
/**
    1、点击 product --> profile --> 进入instrument --> 选择你要测试的性能。--> 左上角选择真机 --> 点击红色录制按钮 --> 查看运行数据。
 
    2、插件的安装路径:
        1.旧版本路径：/Users/用户名/Library/Application Support/Developer/Shared/Xcode/Plug-ins
        2.新版本路径：/Users/用户名/Library/Developer/Xcode/Plug-ins
 */
// MARK: - 动态调试
/**
    1、动态调试是指：将程序运行起来，通过打断点、打印等方式，查看参数、返回值、函数调用流程等。
    2、动态调试原理：
        xcode上的lldb程序与iPhone上的debugserver程序进行通信，debug server与app进行通信，从而调试app。
        局限：xcode只能调试通过xcode自己安装到iphone上的app。破解：在mac终端启动lldb，通过越狱连接到iphone的debug server上进行调试。
        GCC编译器:xcode以前的编译器。开源的
        LLVM编译器:xcode现在的编译器。xcode自己的，基于GCC。
        GDB调试器:xcode以前的调试器。开源的。
        LLDB调试器:xcode现在的调试器。xcode自己的，基于GDB。
        debugserver:iphone系统上安装的程序，用于连接xcode的lldb来进行调试。iphone第一次与xcode连接时，xcode就自动安装到iphone上。
 
    3、LLDB指令：
        LLDB指令格式：<命令名称> [<子命令名称> [子命令名称 ...]] <命令动作> [-可选项 [可选项的值]] [参数1 [参数2...]]
        linux指令格式的说明，[]中括号里面的参数是可以省略的，<>尖括号里的参数有时是可以省略的。不用刻意区分是子命令还是动作。
        3.1、常用指令：
             帮助指令：help + <命令> + <命令动作>
             打印指令：po $x0 //加上$符号之后，可以打印寄存器x0的值。
             x命令：格式化打印内存的值。
                   x/数量-格式-字节大小 内存地址                //读取内存中的值
                       x/3xw 0x00000000fe150e
                       x/4xg      --b,h,w,g对应1,2,4,8个字节；x代表十六进制。
 
             表达式指令，可以在执行中添加OC执行语句：expression + OC语句
                        例如：expr (void) NSLog(@"balhbalh")，&0,&1这样的符号,是指对象的一个引用. 在控制台上可以用这个符号来操作对应的对象。
                        p指令也可以实现expr的效果。po指令可以实现 expr -O -- 执行语句 的效果。
             打印堆栈信息的指令，thread backtrace 或者 bt 指令。
                        frame表示栈帧，一帧表示一个函数调用。0表示最新的执行帧。
             函数返回的指令：thread return + 返回值。 直接改变当前方法调用的返回值，不再执行断点后面的代码。
             查看方法体里变量的指令：frame variable + [变量名]。直接查看当前方法栈帧里变量的值。
             继续(continue)：执行完当前断点，继续当前进程。指令：thread continue、continue、c。
             步入(step in)：断点进入到方法体里执行。(单步)指令：thread step-in、step、s。
             步出(step out)：执行完当前的方法体，并执行到断点之后的位置。thread step-out、finish。
             步过(step over)：直接执行完当前的方法语句，执行到下一行语句前。thread step-over、next、n。
                             si、ni和s、n类似，只是si、ni是汇编指令级别的单步。instruction level，指令级别。
             打断点：breakpoint set -n 某方法。设置关于这个方法的符号断点，在调用这个方式时，程序都会暂停。
                        例如：br set -n touchesBegan:withEvent:
                   br l。列出当前工程的所有断点信息.
                   br set -r 正则表达式。通过正则表达式来打断点。
                   breakpoint command add -F "python文件名"."python方法名" n。给第n个断点添加导入的 python 文件中的方法调用。执行完脚本后停止在断点位置。
 
             内存断点：一旦有代码修改了监听的内存位置，断点停止在修改内存的代码处。
                    watchpoint set variable 变量名。监听改变量的内存地址，并且打上内存断点。
 
             模块查找：image list。查看当前app运行时，执行的模块(镜像)。
                     image lookup -t 某个类型。查看某个类型的信息。例如：image lookup -t UIView。
                     image lookup -a 内存地址。查看某个内存地址对应的源码。程序崩溃的时候，很有用。
                     image lookup -a 符号或者函数名。查找某个符号或者函数的所有源码位置。
 
    4、Mach-O文件的虚拟内存(ASLR)：
        ASLR：Address Space Layout Randomization，地址空间布局随机化，iOS4.3开始引入了ASLR技术。
             是一种针对缓冲区溢出的安全保护技术，通过对堆、栈、共享库映射等线性区布局的随机化。就是每次加载进内存的虚拟地址的首地址是随机的，不是固定从0开始。
             通过增加攻击者预测目的地址的难度，防止攻击者直接定位攻击代码位置，达到阻止溢出攻击的目的的一种技术。
             函数的真实内存地址 = Mach-O文件描述的地址 + ASLR产生的随机首地址 + _PAGEZERO的大小。

        Mach-O文件中的Load Commands段的选项：
            (_PAGEZERO段)
            VM Address：虚拟内存的开始地址。
            VM Size：虚拟内存的大小。
            File Offset：在Mach-O文件中占据的位置。
            File Size：在Mach-O文件中占据的大小。有可能在Mach-O文件是不占空间的，而是在VM中才分配空间。
            (_TEXT段)
                存放函数代码。
            (_DATA段)
                存放全局变量。
            (_LINKEDIT段)

        NULL指针指向_PAGEZERO区域，安全区域。
 */
// MARK: - LLVM
/**
    1、LLVM项目是模块化、可重用的编译器，同时也包含了工具链，是一个大集合。可以百度一下LLVM的官网。LLVM是一种架构、一个项目。
        你也可以编写一些编译器的插件，集合到编译器里面，修改编译器的一些行为。
        xocode里的编译器就是LLVM的，然后代码规范提示、编译报错这些，就是编译器提供的功能，其实xcode就是集成了编译器。
        编译器：
            传统编辑器原理：源代码 --> 编译器的前端部分(fronted) --> 语法分析、语义分析、生成中间代码 --> 编译器的优化器(Optimizer) --> 中间代码的优化 -->
                         编译器的后端(Backed) --> 生成机器代码(二进制)。    //GCC、Clang
 
            LLVM：其实就是新增了跨平台的中间代码的优化器，跨平台是指跨编译器平台(GCC、Clang)，也就是通过通过GCC、GHC等编译生成的前端代码，都可以通过LLVM架构生成LLVM架构的中间代码。
                  LLVM的中间代码有个专有名词：LLVM IR。然后LLVM通过LLVM IR中间代码编译成不同机器平台的后端机器代码(例如x86、arm)。
 
            Clang：其实就是一个前端编译器，属于LLVM的一个子项目，用于前端编译C/C++/Objective-C。 Clang体积更小，占用内存更小、某些平台下速度更快。
 
        Xcode使用的就是LLVM架构、前端编译器是Clang。
 
        词法分析：把源代码的每一个关键字、符号、单词等区分成一个一个的token、为下一步识别作铺垫。
        语法分析(AST,Abstract Syntax Tree)：根据词法分析的token，一层一层剥析函数内部，给每一个token说明用途意义，一层一层地就形成了树状结构，所以是语法树。
        中间代码：优化器根据语法树生成中间代码、便于编译后端阅读。.bc文件、.ll文件都是中间代码的文件，只是格式不一样而已，作用是一样。类似汇编文件，有的架构就是汇编文件。
 
        工具：libclang、libTooling可以进行语法树分析、语言转换等功能。
 
    2、代码混淆，对代码的类名、方法名、代码逻辑等进行混淆，是应用加固方法的一种，加固的意思就是防止被破解、盗版、注入等手段。
       源码层面混淆：可以用宏定义，在编译的时候，把方法名替换成宏的符号，这样别人逆向的时候就不容易看出方法名是啥意思了。
       第三方工具ios-classguard(老旧):也是在源码的层面进行混淆、对可执行文件中的类名、方法名、属性名进行替换。生成一个头文件给你，你导入工程引用就可以，其实就是宏定义。
            
 
 */


class TestXcode_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试xcode工具的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestXcode_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试动态调试
            print("     (@@ 0、测试动态调试")
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
extension TestXcode_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestXcode_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestXcode_VC {
    
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
extension TestXcode_VC: UICollectionViewDelegate {
    
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
