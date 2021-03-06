//
//  测试TableView的contengInset与刷新.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/14.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试TableView的contengInset与刷新的VC
// MARK: - 笔记
/**
    1、手动调用reloadRows方法之后，会回调cellForRowAt方法，但是要在cell可见的时候才会去回调，不可见的时候不会回调。
 
 */


class TestTableViewcontentInset_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    var tableDataDict = [0:["张三","李四","王武"],1:["蜡笔小新","小白","美伢","小葵","广治","娜娜子"]]{
        didSet{
//            testTableView.reloadData()
        }
    }
    /// 被测试的tableview
    private var testTableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TestTableView_Cell.self, forCellReuseIdentifier: "TestTableViewcontentInset_CELL_ID")
        
        /// 常见属性
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(red: 238/255.0, green: 234/255.0, blue: 232/255.0, alpha: 1.0)
        tableView.bounces = true
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试tableview属性的vc"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}

//MARK: - 遵循UIScrollViewDelegate协议
extension TestTableViewcontentInset_VC:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UITableView.self) {
            let table:UITableView = scrollView as! UITableView
            print("这是tableview的contentOffset:\(table.contentOffset)---contentInset：\(table.contentInset)")
            if table.contentOffset.y > 680 {
                let offsetY = table.contentOffset.y - 680
                if offsetY < 300 {
                    table.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: offsetY, right: 0)
                }
            }
        }
    }
    
}

//MARK: - 遵循tableview的协议
extension TestTableViewcontentInset_VC:UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataArr:[String]? = tableDataDict[section]
        return dataArr?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableDataDict.keys.count
    }
    
    //MARK: 设置cell的UI，cell的常见属性
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewcontentInset_CELL_ID", for: indexPath)
        ///右边箭头的样式
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = tableDataDict[indexPath.section]?[indexPath.row]
        
        /// cell里面的imageView，textlabel，detailTextLabel是属于cell的contentView的子view，不是cell的直接子view。
    
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //MARK: section 的header和footer的关系
    /**
     结果：
     1、当delegate的section header的view和height有冲突时，以设置高度的heightForHeaderInSection方法为准， viewForHeaderInSection的高度无效。
     2、必须实现了viewForHeaderInSection的代理方法，heightForHeaderInSection代理方法的设置才有效，否则无效。
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestTableViewcontentInset_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、设置tableview的contentInset
            print("     (@@  设置tableview的contentInset")
            testTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 400, right: 0)
            break
        case 1:
            //TODO: 1、更新tableview的数据源
            print("     (@@ 延时2秒更新数据源")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                [weak self] in
                self?.tableDataDict[1] = ["三国演义","关羽","刘备","张飞","孔明","赵云"]
            }
        case 2:
            //TODO: 2、测试调用reloadRows方法之后，会不会回调cellForRowAt方法
            print("     (@@ 测试调用reloadRows方法之后，会不会回调cellForRowAt方法")
            testTableView.reloadRows(at: [IndexPath.init(row: 4, section: 1)], with: .automatic)
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
            print("这是tableview的contentOffset:\(testTableView.contentOffset)\n---contentInset：\(testTableView.contentInset)\n---contentSize:\(testTableView.contentSize)")
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
extension TestTableViewcontentInset_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestTableViewcontentInset_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        view.addSubview(testTableView)
        ///设置代理
        testTableView.delegate = self
        testTableView.dataSource = self
        testTableView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.height.equalTo(400)
        }
    }
    
}




//MARK: - 设计UI
extension TestTableViewcontentInset_VC {
    
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

//MARK: - 遵循CollectionView的协议,UICollectionViewDelegate
extension TestTableViewcontentInset_VC: UICollectionViewDelegate {
    
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

