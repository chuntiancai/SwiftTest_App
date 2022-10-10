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
    1、把.Framework文件拖进项目工程的目录中，在项目的TARGETS -> General -> Embedded Binaries -> +  中添加.Framework文件。
    2、在需要使用到Framework的源文件中，import "你的framework"
 
    测试自己制作的cocoapod私有库：

       1、首先你要配置安装好cocoapod的环境，然后就可以使用cocoapod命令了。
       
       2、通过命令创建cocoapod私有库：
           $ cd 合适的目录（最好是空文件夹）
           $ pod lib create yourLibName（库名字）//这里会生成一系列必要文件，包括yourLibName.podspec文件，熟悉之后可以手动生成添加。
       
       3、描述信息：在yourLibName.podspec文件中，描述你的库的信息、xcode工程信息等。例如它们的github地址、编译文件、依赖关系等等。
       
       4、上传文件：将yourLibName.podspe和工程文件一同上传到yourLibName.podspe中描述的仓库地址上，并打上tag （和yourLibName.podspec中s.version 的保持一致）

 */


import FrameworkMake_Test   //引进你制作的framework
import ctc_podspec  //引进自己制作的cocoapod私有库

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
            print("     (@@")
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
        case 13:
            print("     (@@")
        case 14:
            print("     (@@")
        case 15:
            print("     (@@")
        case 16:
            print("     (@@")
        case 17:
            print("     (@@")
        case 18:
            print("     (@@")
        case 19:
            print("     (@@")
        case 20:
            print("     (@@")
        case 21:
            print("     (@@")
        case 22:
            print("     (@@")
        case 23:
            print("     (@@")
        case 24:
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

