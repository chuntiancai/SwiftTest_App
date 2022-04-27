//
//  plist文件测试_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//  测试plist文件的读取


class TestPlistFile_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试plist文件"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestPlistFile_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、写入文件到App中
            /// 这会是写入到编译打包后的app中，而不是还未编译的xcode的目录下
            print("     (@@  写入到xcode目录下")
            let bundlePath = Bundle.main.bundlePath //主bundle
            let filePath = bundlePath + "/TestPlist.plist"
            let nameDict:NSDictionary = ["name":"张三","age":18,"sex":"man"]
            do {
                let isSuccess: () = try nameDict.write(to: URL.init(fileURLWithPath: filePath))
                print("写入了吗？：\(isSuccess)")
            } catch let err {
                print("写入错误：\(err)")
            }
            
            break
        case 1:
            //TODO: 1、写到沙盒中
            /**
                1、直接整个写入沙盒可以写入成功
             */
            print("     (@@ 写到沙盒中")
            /// 第三个参数true，表示是否展开完整路径，否则字符串是用～来代替当前路径，是相对路径，不是完整路径字符串。
            let docPathArr = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            for filePath in docPathArr {
                /// 好的叭，就只有Documents一个文件夹
                print("doc目录下的所有路径：\(filePath)")
            }
            let docPath = docPathArr.first ?? ""
            let filePath = docPath + "/testPlist.plist"
            let nameDict:NSDictionary = ["name":"张三","age":18,"sex":"man"]
            do {
                let isSuccess:() = try nameDict.write(to: URL.init(fileURLWithPath: filePath))
                print("写入了吗？：\(isSuccess)")
            } catch let err {
                print("写入错误：\(err)")
            }
        case 2:
            //TODO: 2、 在xcode目录下已经有plist文件，先读取路径，后写入。(追加失败)
            /**
                1、我也不知道为什么没有写入?因为你没有创建文件，没有用文件流打开文件吗？
             */
            print("     (@@ 在xcode目录下已经有plist文件，先读取，后写入")
            let filePath = Bundle.main.path(forResource: "NamePlistFile.plist", ofType: nil) ?? ""
            let nameDict:NSDictionary = ["name":"wangwu","age":16,"sex":"woman"]
            do {
                let isSuccess: () = try nameDict.write(to: URL.init(fileURLWithPath: filePath))
                print("写入了吗？：\(isSuccess)")
            } catch let err {
                print("写入错误：\(err)")
            }
        case 3:
            //TODO: 3、读取xcode中的plist文件
            /**
                1、可以读取出来
             */
            print("     (@@ 读取xcode中的plist文件")
            let filePath = Bundle.main.path(forResource: "TestPlistFile.plist", ofType: nil) ?? ""
            if let personArr = NSArray.init(contentsOf: URL.init(fileURLWithPath: filePath)) {
                for item in personArr {
                    if let itemDict:[String:Any] = item as? [String:Any] {
                        print("取出的item是：\(String(describing: itemDict["name"]))--\(String(describing: itemDict["age"]))--\(String(describing: itemDict["sex"]))")
                    }
                    
                }
            }
            
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
extension TestPlistFile_VC{
   
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
extension TestPlistFile_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestPlistFile_VC {
    
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
extension TestPlistFile_VC: UICollectionViewDelegate {
    
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
    1、plist，p是property的意思，list就是列表，就是属性列表文件的意思。只能是字典或数组。
    2、在plist文件中，不能保存自定义的对象。
 
 */

