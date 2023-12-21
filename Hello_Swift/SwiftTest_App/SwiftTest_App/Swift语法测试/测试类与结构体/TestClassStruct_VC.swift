//
//  TestClassStruct_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/7/4.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试类与结构体的VC
// MARK: - 笔记
/**
    1、
        X 代表类,是X.self的简写。是实例对象的类型
        x 代表类的实例对象。
        X.self 代表实例对象的类对象
        X.Type 代表类对象的类型，代表 类X 的元类型(类信息)
        AnyClass 是AnyObject.Type的别名，是类对象的类型
        Self(大写) 代表只能源文件内部使用的类对象。
 
    2、
        X.classForCoder() 是获取类对象。
        x.classForCoder  也是获取类对象。
        class_getName(X.self)   通过类对象获取类对象的名字，返回的是C语言的字符串
        object_getClassName(x)   通过实例获取类对象的名字，返回的是C语言的字符串
 
 
 */

class TestClassStruct_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试类、结构体VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestClassStruct_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试类对象初始化实例对象。
            print("     (@@ 0、测试类对象初始化实例对象。 ")
            let dog = TestClass_Dog.self.init()
            var animalType:TestClass_Animal.Type?
            animalType = TestClass_Cat.self
            let animal = animalType!.init()
            print("名字是：\(dog.name)")
            print("动物是：\(animal.name)")
            
            print("实例的classForCoder是：\(dog.classForCoder)")
            print("类的classForCoder()是：\(TestClass_Dog.classForCoder())")
            let classForCoder: AnyClass = TestClass_Dog.classForCoder()
            print("classForCoder是：\(classForCoder)")
            
        
            let typeofx = type(of: dog)
            let typeofX = type(of: TestClass_Dog.self)
            print("typeofx是：\(typeofx)")
            print("typeofX是：\(typeofX)")

            //通过类对象获取类对象的名字，返回的是C语言的字符串
            let class_getName = class_getName(TestClass_Dog.self)
            let class_getNameStr:String = String(cString: class_getName)
            print("class_getNameStr的名字是：\(class_getNameStr)")
            
            //通过实例获取类对象的名字，返回的是C语言的字符串
            let object_getClassName = object_getClassName(dog)
            let object_getClassNameStr:String = String(cString: object_getClassName)
            print("object_getClassName的名字是：\(object_getClassNameStr)")
        case 1:
            //TODO: 1、
            print("     (@@ ")
        case 2:
            //TODO: 2、
            print("     (@@ ")
        case 3:
            //TODO: 3、
            print("     (@@ ")
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
extension TestClassStruct_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestClassStruct_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestClassStruct_VC {
    
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
extension TestClassStruct_VC: UICollectionViewDelegate {
    
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



