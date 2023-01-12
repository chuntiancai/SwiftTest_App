//
//  测试KVC的VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/13.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试KVC的VC，keyPath的使用。

// MARK: - 笔记
/**
    1、KVC的主要应用是可以访问对象的私有属性，准确来说是可以访问对象的所有属性。
    2、被操作的对象(非结构体)，必须要在其属性变量前加上@objc关键字，声明是@objc类型的属性，哪怕是在类名前加上@objc关键字都不行，必须是属性前。
    3、setValue(, forKey:)方法和setValue(,forKeyPath: )方法的区别是，forKeyPath可以链式访问更一层的属性， forkey只能访问当前对象的属性(手写字符串)。 (swift和oc均可用) setValue方法会对value自动进行类型转换。
    4、xib文件内部的联系其实也是通过KVC的方法进行连接。
    5、swift结构体的的KVC访问只能通过swift的KVC语法糖(\Person.name)去访问。
    6、#keyPath(KVC_Person.name)语法糖返回的是属性字符串，与手写字符串是一样的。
    7、通过KVC修改属性的值，会触发KVO发布通知。
    
    总结：swift结构体只能通过语法糖(\Person.name)去访问，student[keyPath: \Person.name]方式读写，其余都是NSObject的类访问方式了。
         语法糖#keyPath(KVC_Person.name)只能访问公共变量。
         setValue(,forKeyPath: )既可以访问共有变量，也可以访问私有变量，但是变量必须是加上@objc前缀。
 
    KVC的应用：
    1、访问私有变量。OC和swift可以通过setValue的方式访问私有变量，公共变量swift还有个语法糖：\Person.name         这个样子就是写出keypath的对象(可链式)，私有变量还没找到是怎么操作。
    2、字典转模型，模型转字典也可以。
    3、取出数组中所有模型的某个属性。
    4、重写系统方法的两个思路：一是添加额外的功能。二是删除原来的功能。
 */


class TestKVC_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    var personA = KVC_Person(PName: "zhangsan", PAge: 17)
    var personB = KVC_Person(PName: "lisi", PAge: 18)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试KVC功能"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestKVC_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试KVC修改对象的私有属性。
            print("     (@@  测试KVC修改对象的私有属性。")
            print("personA是:\(personA)")
            print("personB是:\(personB)")
            print("======修改私有属性后===========")
            ///setValue(, forKey:)方法和setValue(,forKeyPath: )方法的区别是， forKeyPath可以链式访问更一层的属性，forkey只能访问当前对象的属性。
            personA.setValue("张三", forKey: "name")
            personA.setValue("小强", forKeyPath: "dog.name")
            personB.setValue("李四", forKey: "name")
            personB.setValue("28", forKey: "age")
            personB.setValue("16000", forKey: "money")
            print("personA是:\(personA)")
            print("personB是:\(personB)")
            break
        case 1:
            //TODO: 1、测试KVC字典转模型
            print("     (@@ 测试KVC字典转模型")
            let personDict:[String : Any] = ["name":"wangwu","age":27,"money":20000000.17,"dog":KVC_Dog(PName: "xiaogou", PAge: 3)]
            let person = KVC_Person(PName: "王五", PAge: 26)
            print("字典转模型前：\(person)")
            person.setValuesForKeys(personDict)
            print("字典转模型后：\(person)")
            
            let nameKeyPath = #keyPath(KVC_Person.name)
            person.setValue("赵六", forKeyPath: nameKeyPath)
            print("使用#keyPath语法糖访问模型:\(person)")
            
            let nameKeyPath2 = \KVC_Person.name
            person[keyPath: nameKeyPath2] = "孙七"
            print("用swift的\\KVC_Person.name语法糖：\n\(person)")
            
            
            
        case 2:
            //TODO: 2、测试KVC访问结构体
            print("     (@@ 测试KVC访问结构体")
            var student = KVC_Student(PName: "胖虎", PAge: 11)
            print("KVC访问结构体前：\(student)")
//            student[keyPath: "name"] = "静香"
            let nameKeyPath = \KVC_Student.name
            student[keyPath: nameKeyPath] = "静香"
            
            
            
        case 3:
            //TODO: 3、获取对象中的属性
            print("     (@@ 3、获取对象中的属性。")
            var ivarCount:UInt32 = 0
            let p0 = KVC_Person()
            print("实例。self：\(p0.self) ---类。self：\(KVC_Person.self)")
            
            /// 获取 属性结构体 的链表，地址。
            let ivarList:UnsafeMutablePointer<Ivar>? = class_copyIvarList(KVC_Person.self , &ivarCount)
            print("属性的个数：\(ivarCount)")
            if let ivarList = ivarList {
                for i in 0 ..< ivarCount{
                    
                    /// 获取描述属性的结构体
                    let ivar0:Ivar = ivarList[Int(i)]
                    print("获取到属性链表指针的元素数据是：\(ivar0)")
                    
                    /// 获取 属性的名字 的指针
                    let namePoint:UnsafePointer<CChar> = ivar_getName(ivar0)!
                    
                    /// 获取 属性的名字 字符串
                    let name = String(cString: namePoint)
                    print("获取到的属性名字是：\(String(describing: name))")
                    
                    /// 获取 属性的类型名字字符串 的指针，指向空字符串地址，swift已经无法获取到属性的类型了，OC可以。
                    let ivarTypePoint:UnsafePointer<CChar> = ivar_getTypeEncoding(ivar0)!
                    
                    /// 获取 属性的类型名字字符串，swift已经不可以，可以尝试通过xcode断点碰碰运气。
                    let ivarTypeName = String(cString: ivarTypePoint)
                    print("获取到的属性类型名字是：\(String(describing: ivarTypeName))")
                    
                }
               
            }
            
            print("获取到的属性列表地址：\(String(describing: ivarList))")
            
        case 4:
            //TODO: 4、测试swift关联对象
            print("     (@@ 4、测试swift关联对象")
            personA.wife = "纯宝宝～"
            print("wife:\(personA.wife)")
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
extension TestKVC_VC{
   
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
extension TestKVC_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestKVC_VC {
    
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
extension TestKVC_VC: UICollectionViewDelegate {
    
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


