//
//  TestSoryboard_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/5.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试跳转到Soryboard的VC
// MARK: - 笔记
/**
    1、 //通过代码加载storyboard，UIStoryboard初始化参数的name是storyboard再在工程目录中的名字，而不是在storyboard文件中的名字。
        //storyboard文件中的名字就是Storyboard ID，这个表示这个Storyboard本身，也是Storyboard绑定的VC的ID，通过这个来初始化Storyboard的VC
         let storyBoard = UIStoryboard.init(name: "mainStoryTest", bundle: nil)
         let mainStoryVC = storyBoard.instantiateViewController(withIdentifier: "TestStory_VC_ID")
 */


class TestSoryboard_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试跳转到Soryboard的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestSoryboard_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、从storyboard加载VC
            print("     (@@  ")
            //通过代码加载storyboard，UIStoryboard初始化参数的name是storyboard再在工程目录中的名字，而不是在storyboard文件中的名字。
            //storyboard文件中的名字表示这个Storyboard本身。而Storyboard文件的属性中有个Storyboard ID， 这个就是Storyboard绑定的VC的ID，通过这个来初始化Storyboard的VC
            let storyBoard = UIStoryboard.init(name: "testStory", bundle: nil)
            let mainStoryVC = storyBoard.instantiateViewController(withIdentifier: "TestStory_VC_ID")
            pushNext(viewController: mainStoryVC)
            break
        case 1:
            //TODO: 1、测试storyboard的导航VC
            let storyBoard = UIStoryboard.init(name: "naviVCStoryTest", bundle: nil)
            let naviVC = storyBoard.instantiateViewController(withIdentifier: "naviVCStoryTest_ID")
            
            //添加一个window
            let app = UIApplication.shared.delegate as! AppDelegate
//            app.firstWindow.becomeKey()
            app.firstWindow.rootViewController = naviVC
            app.firstWindow.makeKeyAndVisible()
            print("     (@@ ")
        case 2:
            //TODO: 2、
            print("     (@@ ")
        case 3:
            //TODO: 3、
            print("     (@@ ")
        case 5:
            print("     (@@")
        case 6:
            print("     (@@")
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestSoryboard_VC{
   
    
}


//MARK: - 设置测试的UI
extension TestSoryboard_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestSoryboard_VC {
    
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
extension TestSoryboard_VC: UICollectionViewDelegate {
    
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


