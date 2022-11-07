//
//  TestSqlite_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/11/7.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试数据库的VC
// MARK: - 笔记
/**
    步骤：
    1、导入数据库framework：
        project -> general -> framework,library.. -> sqlite 3.0 (xcode有提供，是ios系统的动态库)
    2、在SwiftTest_App-Bridging-Header.h头文件中，暴露"sqlite3.h" 头文件。
    3、在.swift源文件导入数据库的库，swift已经集成了。import SQLite3。
    4、定义一个指向SQlite3数据结构的指针OpaquePointer，通过该指针来操作数据库对象。
    5、通过SQlite3库的函数执行sql语句，操作数据库。
 
    ===================================
    基础知识：
    1、Sqlite就是一套数据库软件，就是一套程序，用于管理特定的数据库文件，也就是sqlite文件。
        简单点，就是一整套东西：管理软件，软件可识别的语言(DDL、DML、DQL)，数据库文件。
        所谓软件语言(DDL、DML、DQL)，就是不同场景下，输入的命令，软件接受命令，对文件或者环境执行操作。
 
    2、navicat是一个管理 数据库文件 的可视化集成软件。可以管理sql，oracle，sqlite等数据库文件。
        就是把命令语言变成了可视化操作，就是可以点图标就可以了。
 
    3、Sqlite的语言其实就和SQL语言差不多，所以你去复习SQL语言语法吧。
       sqlite语句不区分大小写，除了很个别的关键字。
 
    
 
 */

import SQLite3

class TestSqlite_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    var db: OpaquePointer? = nil    // 一个指向SQlite3数据结构的指针
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试数据库的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestSqlite_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestSqlite_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试打开数据库文件。
            /**
                1、首先要导入数据库的库，swift已经集成了。import SQLite3
                2、定义一个指向SQlite3数据结构的指针，通过该指针来操作数据库对象。
                3、打开数据库，即连接数据库对象和数据库实体。
                4、通过执行sql语言创建数据库和表。
             */
            print("     (@@ 0、测试打开数据库文件。")
            // 1. 打开数据库

            // SQlite3数据库文件的扩展名没有要求，是根据文件信息来识别是不是sqlite文件的，现在比较流行的后缀选择是.sqlite3、.db、.db3
            let fileName: String = "/Users/mathew/Desktop/ctchSqliteTest.sqlite3"

            /**
            *  sqlite3_open 使用这个函数打开一个数据库
            *  参数一: 需要打开的数据库文件路径
            *  参数二: 一个指向SQlite3数据结构的指针, 到时候操作数据库都需要使用这个对象
            *  功能作用: 如果需要打开数据库文件路径不存在, 就会创建该文件;如果存在, 就直接打开; 可通过返回值, 查看是否打开成功
            */
            if sqlite3_open(fileName, &db) != SQLITE_OK {
                print("打开数据库失败")
            }else {
                print("打开数据库成功")
                
                /// 创建数据库的表文件。
                let sql = "CREATE TABLE IF NOT EXISTS t_student(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, score REAL)"
                // 如果语句执行失败, 可以print下sql语句, 然后拷贝到Navicat工具中执行, 查看是否执行成功
                // 参数一: 数据库
                // 参数二: 需要执行的SQL语句
                // 参数三: 回调结果, 执行完毕之后的回调函数, 如果不需要置为NULL
                // 参数四: 参数三的第一个参数, 可以通过这个传值给回调函数 如果不需要置为NULL
                // 参数五: 错误信息, 通过传递一个地址, 赋值给外界, 如果不需要置为NULL
                let isTableOK = (sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK)
                
                if isTableOK {  print("创建表成功")  }else {  print("创建表失败")  }
            }
        case 1:
            //TODO: 1、测试封装sql插入语句。
            print("     (@@ 1、测试封装sql插入语句。")
            // 1. 创建SQL语句
            let tableName:String = "t_student"
            let columnNames:String = "name,score"

            let values:String = "\'张三\',\'61\'"

            let sql = "INSERT INTO \(tableName)(\(columnNames)) values (\(values))"
            
            // 2. 执行SQL语句
            let isOK =  (sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK)
            print("插入成功:\(isOK)")
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
extension TestSqlite_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestSqlite_VC{
    
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
extension TestSqlite_VC {
    
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
extension TestSqlite_VC: UICollectionViewDelegate {
    
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
