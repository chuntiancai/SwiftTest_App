//
//  TestSectionTableView_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/9/10.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试tableView 的section样式的VC

import UIKit

class TestSectionTableView_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    /// 测试section样式的tableView,tag = 1000
    private lazy var sectionTableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tag = 1000
//        tableView.register(JFZMyAssetDataValueCell.self, forCellReuseIdentifier: "SectionTableView_Cell_ID")

        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(red: 220/255.0, green: 230/255.0, blue: 240/255.0, alpha: 1.0)
        tableView.bounces = true
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        let tHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
//        tHeaderView.backgroundColor = .red
//        tableView.tableHeaderView = tHeaderView
        tableView.tableHeaderView?.isHidden = true
        
        
        return tableView
    }()
    
    //TODO:测试的UI组件
    let secHeader = TableSectionHeader()    //测试table 的section的header的高度
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
extension TestSectionTableView_VC{
   
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
//MARK: - tableview的代理方法, UITableViewDataSource,UITableViewDelegate
extension TestSectionTableView_VC: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
          return 3
        }else{
            return 3
        }
    }
    //MARK: 设置section的header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("©TableViewDelegate© 这是设置section 的 header的view的\(#function)方法 ")
        if section == 1{
            return secHeader
        }
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //TODO: section 的header和footer的关系
        /**
         结果：
         1、当delegate的section header的view和height有冲突时，以设置高度的heightForHeaderInSection方法为准， viewForHeaderInSection的高度无效。
         2、必须实现了viewForHeaderInSection的代理方法，heightForHeaderInSection代理方法的设置才有效，否则无效。
         */
        print("©TableViewDelegate© 这是设置section 的 header高度的\(#function)方法 ")
        if section == 1 {
            return 54
        }else {
//            return UIScreen.main.bounds.width * 12.5 / 125.0
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.width * 8.0 / 125.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return screenWidth * 62.0 / 125.0
            }
            if indexPath.row == 1 {
                return screenWidth * 105.0 / 125.0
            }
            if indexPath.row == 2 {
                return screenWidth * 25.5 / 125.0
            }
        }else {
            return screenWidth * 53 / 125.0
        }
        return screenWidth * 53 / 125.0
    }
    
    
    
    //MARK: 设置Cell的UI
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell =  UITableViewCell()
        if indexPath.section == 0 {
            /**
             section == 0 的cell都是向下偏移15个点留出间隔
             */
            switch indexPath.row {
            case 0: //测试cell中label的自适应高度
                return labelCell
            case 1:
                break
            case 2:
                break
            default:
                break
            }
        }else {
            switch indexPath.row {
            case 0:
                break
            case 1:
                break
            case 2:
                break
            default:
                break
            }
            
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
}


//MARK: - 工具方法
extension TestSectionTableView_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        sectionTableView.layer.borderWidth = 2
        sectionTableView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(sectionTableView)
        sectionTableView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(400)
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

// MARK: - 笔记
/**
 
 */

