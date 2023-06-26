//
//  TestSelector_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/10/18.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试swift的selector语法的VC
// MARK: - 笔记
/**
 1、测试调用Selector执行带有参数的方法
     1、测试带有参数的方法的selector时，需要用闭包类型声明selector。
     2、方法的参数类型必须是对象。如果是Int这些基本类型，则会错乱。具体为什么错乱，我还没找到原因
        let selector = #selector(testActionParam as (Int,String)->Void)
        self.perform(selector, with: NSInteger(17), with: "haha1")
 
        let selector2 = Selector.init("testActionParam::")
        self.perform(selector2, with: 18, with: "haha2")
 
        let selector3 = #selector(self.testActionParam(_:_:)) //也可以这样写
        self.perform(selector3, with: 19, with: "haha3")
 
 */

class TestSelector_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试swift的selector语法"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestSelector_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试selctor的构造与调用,用perform方法调用selector
            print("     (@@  测试selctor的构造与调用,用perform方法调用selector")
            let person = Person.init(sex: "女——woman")
            let selector = Selector.init(("sayYourSex"))
            let retValue = person.perform(selector).retain().takeRetainedValue()  //解包方法的返回值
            print("返回值是：\(retValue)")
            break
        case 1:
            //TODO: 1、测试NSClassFromString方法，通过字符串获得具体类信息
            print("     (@@ 测试NSClassFromString方法，通过字符串获得具体类信息。")
            //FIXME: 探索构造器有参数该怎么调用
            let plistName =  Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
            let clsName = plistName + ".Person"
            let clsType = NSClassFromString(clsName) as! Person.Type
            let clsInstance = clsType.init()
            print("clsType的值是：\(clsType)")
            print("clsInstance的值是：\(clsInstance)")
            let sex = clsInstance.sayYourSex()
            print("调用的sex：\(sex)")
            /**
            在OC中，typeof( XXX ) 是动态根据XXX的来判断XXX的真实类型，所以下面的语句其实相当于是 __weak * UIViewController wSelf = self
             __weak typeof(self) wSelf = self
            */
        case 2:
            //TODO: 2、测试调用Selector执行带有参数的方法
            /**
                1、测试带有参数的方法的selector时，需要用闭包类型声明selector。
                2、方法的参数类型必须是对象。如果是Int这些基本类型，则会错乱。具体为什么错乱，我还没找到原因
            
             */
            print("     (@@ 测试调用Selector执行带有参数的方法")
            let selector = #selector(testActionParam as (Int,String)->Void)
            self.perform(selector, with: NSInteger(17), with: "haha1")
            
            let selector2 = Selector.init("testActionParam::")
            self.perform(selector2, with: 18, with: "haha2")
            
            let selector3 = #selector(self.testActionParam(_:_:)) //也可以这样写
            self.perform(selector3, with: 19, with: "haha3")
            
            let cat = TestSelector_Animal() //对象的方法必须是OC的
            let selector4 = #selector(TestSelector_Animal.eat)
            cat.perform(selector4)
            
        case 3:
            //TODO: 3、
            print("     (@@ ")
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
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestSelector_VC{
   
    func test0(){
        
    }
    
    func test1(){
        
    }
    
    func test2(){
        
    }
    
}


//MARK: - 工具方法
@objc extension TestSelector_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
    ///
    /// - Parameters:
    ///   - parm1: 参数一
    ///   - parm2: 参数二
    func testActionParam(_ parm1: Int,_ parm2: String){
        print("调用Selector执行带有参数的方法：参数一：\(parm1),参数二：\(parm2)")
    }
    
}


//MARK: - 设计UI
extension TestSelector_VC {
    
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
extension TestSelector_VC: UICollectionViewDelegate {
    
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



