//
//  测试数组排序.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/5/25.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试数组排序的语法
// MARK: - 笔记
/**
    1、sort函数的理解是，是否按s1在前，s2在后的顺序排序。true就是按照，false就是反过来。
    peopleArr.sort(by: {(s1: Sort_People, s2: Sort_People) -> Bool in return s1.age > s2.age })
 
    2、数组和数组之间的传递得看元素是什么，如果元素是基本数据类型，包括string，那就是值传递，直接copy。
       如果是元素是对象，那就是元素的引用传递，不会copy元素内容，而是copy元素的地址。
 
 */


class TestArraySort_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    lazy var peopleArr:[Sort_People] = {
        var arr = [Sort_People(PName: "张", PAge: 12),Sort_People(PName: "李四", PAge: 15),Sort_People(PName: "赵", PAge: 7),Sort_People(PName: "孙", PAge: 16),
                   Sort_People(PName: "王", PAge: 28),Sort_People(PName: "钱", PAge: 5),Sort_People(PName: "陈", PAge: 42),Sort_People(PName: "朱", PAge: 15)]
        return arr
        
    }()
    
    var strArr0 = [String]()
    var strArr1 = [String]()
    
    var pArr0:[Sort_People] = [Sort_People]()
    var pArr1:[Sort_People] = [Sort_People]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试数组排序VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestArraySort_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试sort函数
            print("     (@@  测试sort函数")
            //1. 使用sort方法和闭包对数组进行排序
            
            /// sort函数的理解是，是否按s1在前，s2在后的顺序排序。true就是按照，false就是反过来。
            peopleArr.sort(by: {(s1: Sort_People, s2: Sort_People) -> Bool in return s1.age > s2.age })
            print("排序后\(peopleArr)")
            
            /// 升序是指小的在前，大的在后
            peopleArr.sort(by: {(s1: Sort_People, s2: Sort_People) -> Bool in return s1.age < s2.age })
            print("升序排序后\(peopleArr)")

        /**
         //2. 可以不用指定参数类型，编译器会帮我们判断
         peopleArr.sort(by: {(s1, s2) in
         return s1.name > s2.name
         })
         
         //3. 可以省略参数名，直接根据数字来引用参数
         peopleArr.sort(by: {
         return $0.name > $1.name
         })
         
         //4. 如果闭包只有一行代码，可以省略return
         peopleArr.sort(by: {
         $0.name > $1.name
         })
         
         //5. 如果闭包是函数调用的最后一个参数，可以将闭包放到括号外面，提高代码的可读性
         peopleArr.sort(){
         $0.name > $1.name
         }
         
         //6. 换行也是可选的，代码可以继续简洁
         peopleArr.sort(){$0.name > $1.name}
         */
            
        case 1:
            //TODO: 1、测试数组是值传递还是地址传递。
            print("     (@@ 测试数组是值传递还是地址传递。")
            strArr0 = ["张三","李四","王五","赵六"]
            strArr1 = strArr0
            print("strArr0:\(strArr0),\n strArr1:\(strArr1)")///Unmanaged.passUnretained(self as! AnyObject).toOpaque()
            print("strArr0地址:\(String(format: "%p", strArr0)),\n strArr1地址:\(String(format: "%p", strArr1))")
            strArr1[1] = "阿猫"
            print("修改后：strArr0:\(strArr0),\n strArr1:\(strArr1)")
            print("修改后：strArr0地址:\(String(format: "%p", strArr0[0])),\n strArr1地址:\(String(format: "%p", strArr1[0]))")
            
            
            pArr0 = [Sort_People(PName: "张", PAge: 12),
                     Sort_People(PName: "李四", PAge: 15),
                     Sort_People(PName: "赵", PAge: 7),
                     Sort_People(PName: "孙", PAge: 16)]
            pArr1 = pArr0
            pArr1[2].name = "阿狗"
            print("pArr0:\(pArr0), --- pArr1:\(pArr1)")
            
            
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
extension TestArraySort_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestArraySort_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestArraySort_VC {
    
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
extension TestArraySort_VC: UICollectionViewDelegate {
    
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

