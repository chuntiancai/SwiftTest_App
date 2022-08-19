//
//  TestSectionTableView_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/9/10.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试tableView 的section样式的VC
// MARK: - 笔记
/**
    1、.grouped样式的tableView的sectionheader、sectionfooter会跟随tableview的滑动而滑动。.plain的tableview不会跟随滑动。
        在ios15之后，.plain样式的tableView默认会给section增加一个留白sectionHeaderTopPadding，需要手动去掉。
        在ios15，.grouped样式下，会默认给tableHeaderView留一个20高度的空白，所以你要给一个高度0.01的view，来去掉这个空白，高度不能为0。
 
        
 */

class TestSectionTableView_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    /// 测试section样式的tableView,tag = 1000
    private lazy var myTableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tag = 1000
//        tableView.register(JFZMyAssetDataValueCell.self, forCellReuseIdentifier: "SectionTableView_Cell_ID")

        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(red: 220/255.0, green: 230/255.0, blue: 240/255.0, alpha: 1.0)
        tableView.bounces = true
        tableView.separatorStyle = .singleLine

        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
            tableView.fillerRowHeight = 0
            tableView.isPrefetchingEnabled = false
            tableView.allowsFocus = false
        }
        
        // table header view
        let tHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 20))
        tHeaderView.backgroundColor = .cyan
        tableView.tableHeaderView = tHeaderView
        
        // table footer view 设置高度为0.001，不然有20的留白间距。
        let tFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 0.001))
        tFooterView.backgroundColor = .brown
        tableView.tableFooterView = tFooterView

        return tableView
    }()
    
    //TODO:测试的UI组件
    let secHeader : TableSectionHeader = { //测试table 的section的header的高度
        let header = TableSectionHeader()
        header.layer.borderColor = UIColor.gray.cgColor
        header.layer.borderWidth = 1.0
        header.title = "这是 section的header"
        return header
    }()
    let labelCell = TestLabelInCell.init(style: .default, reuseIdentifier: "TestLabelInCell_ID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试tableView 的section样式的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestSectionTableView_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、
            print("     (@@  ")
            labelCell.productName = "你好呀"
            break
        case 1:
            //TODO: 1、
            print("     (@@ ")
            labelCell.productName = "测试自适应高度-测试自适应高度-测试自适应高度-测试自适应高度-测试自适应高度-测试自适应高度-测试自适应高度"
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
        case 7:
            print("     (@@")
        case 8:
            print("     (@@")
        case 9:
            print("     (@@")
        case 10:
            //TODO: 10、打印tableView的信息
            let pStr = """
                        tableView的信息：\(self.myTableView)
                        ---tableView.sectionHeaderHeight:\(myTableView.sectionHeaderHeight)
                        ---tableView.sectionFooterHeight:\(myTableView.sectionFooterHeight)
                        ---contentOffset:\(myTableView.contentOffset)
                        ---contentInset：\(myTableView.contentInset)
                        ---contentSize:\(myTableView.contentSize)
                        """
            print(pStr)
        case 11:
            print("     (@@")
        case 12:
            print("     (@@")
        default:
            break
        }
    }
    
}

//MARK: - tableview的代理方法, UITableViewDataSource,UITableViewDelegate
extension TestSectionTableView_VC: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
          return 3
        }else{
            return 4
        }
    }
    
    //TODO: section 的header和footer的关系
    /**
     1、当delegate的section header的view和height有冲突时，以设置高度的heightForHeaderInSection方法为准， viewForHeaderInSection的高度无效。
     2、必须实现了viewForHeaderInSection的代理方法，heightForHeaderInSection代理方法的设置才有效，否则无效。
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40

    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            return secHeader
        }
        let curView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 20))
        curView.backgroundColor = .red
        return curView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let curView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 30))
        curView.backgroundColor = .blue
        return curView
    }
    
    
    //MARK: 设置Cell的UI
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curCell:TestTableView_Cell = tableView.dequeueReusableCell(withIdentifier: "TestHeaderCell_ID")  as? TestTableView_Cell ?? TestTableView_Cell.init(style: .default, reuseIdentifier: "TestHeaderCell_ID")
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {return labelCell}//测试cell中label的自适应高度
        }
        curCell.title = "\(indexPath.section)-\(indexPath.row)"
        return curCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

//MARK: - 测试的方法
extension TestSectionTableView_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 工具方法
extension TestSectionTableView_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        myTableView.layer.borderWidth = 2
        myTableView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(myTableView)
        myTableView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(450)
        }
    }
    
}


//MARK: - 设计UI
extension TestSectionTableView_VC {
    
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
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.layer.borderWidth = 1.0
        baseCollView.layer.borderColor = UIColor.gray.cgColor
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestSectionTableView_VC: UICollectionViewDelegate {
    
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



