//
//  测试TableView的VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/18.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试tableview属性的vc，
// MARK: - 笔记
/**
    1、如果你的tableview的cell是一个普通的view ，那么你就单独给这个cell一个变量，然后也单独给这个cell一个reuseID，然后就可以不进复用池，从而导致复用的问题。
    2、动态tableview是根据数据源来动态设置section和cell的个数，静态table是固定section和cell的个数。我们一般使用的是动态tableview，所谓静态tableview，是只能在UITableViewCotroller中使用，一般也是在storyboard中使用而已了。
 
    3、如果tableview在复用池里面没有找到cell，则自动会去storyboard里面找。
 
    4、苹果为了确定tableview的contentsize，所以要知道所有cell的高度，所以就会每次都调用heightForRowAt代理方法。contentsize一开始的设计初衷是为了计算滚动条的高度。 UIKit会根据tableView.estimatedRowHeight的值来估算tableview的contentsize大小，设置tableView.estimatedRowHeight的值，会减少heightForRowAt代理方法的调用次数。 设置estimatedRowHeight的值后会出现cellForRowAt代理方法在heightForRowAt代理方法前被调用，因为有了估算的高度，但是等真正显示cell的时候，还是会调用heightForRowAt代理方法再显示。
 
    5、所以设置estimatedRowHeight的值，可以很大地提高性能。类似于懒加载cell高度。
    6、注册的cell会在所有代理方法调用之前就已经创建好cell对象放在复用池里面了，所以heightForRowAt代理方法调用前，是肯定有cell的了。
 
 
    cell的常见属性：
    1、cell里面的imageView，textlabel，detailTextLabel是属于cell的contentView的子view，不是cell的直接子view。
    2、cell设置contentView的目的是，为了侧滑删除这些UI的布局方便，可以统一管理用户自定义的view。
 
 
    tableview的刷新：
    1、tableView.reloadRows局部刷新方法，会刷新你传入的indexpath数组，但必须保证该section内的cell的个数不发生改变，只刷新cell里面的数据。
      插入或者删除cell，有对应的其他更新的方法。testTableView.insertRows方法和testTableView.deleteRows方法，记得同步数据源。
 
 */

class TestTableView_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    /// 被测试的tableview
    private var testTableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TestTableView_Cell.self, forCellReuseIdentifier: "TestTableView_Cell_ID")
        

        /// 常见属性
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(red: 238/255.0, green: 234/255.0, blue: 232/255.0, alpha: 1.0)
        tableView.bounces = true
        tableView.sectionIndexColor = .brown    //设置索引字体的颜色
        tableView.sectionIndexBackgroundColor = .cyan
        
        //MARK: tableview自动计算cell的高度(根据你设置的约束)，但我不知道snapkit设置的约束行不行。
        tableView.estimatedRowHeight = 44   //自动计算当前的估计高度，一般结合storyboard来使用
        tableView.rowHeight = UITableView.automaticDimension
        
        //MARK: 设置tableview编辑模式下可以多选
        tableView.allowsMultipleSelectionDuringEditing = true
        
        let tHeaderView = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        tHeaderView.text = "这是整个tableview的头部header"
        tHeaderView.textColor = .black
        tHeaderView.backgroundColor = UIColor.orange
        tableView.tableHeaderView = tHeaderView
        
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

//MARK: - 遵循tableview的协议
extension TestTableView_VC:UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    //MARK: 设置cell的UI，cell的常见属性
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "TestTableView_Cell_ID", for: indexPath)
        ///右边箭头的样式
        cell.accessoryType = .disclosureIndicator
        
        /// cell选中时的背景view
        let bgview = UIView()
        bgview.backgroundColor = .blue.withAlphaComponent(0.5)
        cell.selectedBackgroundView = bgview
        cell.selectionStyle = .default  //一定要设置selectionStyle才有选中的效果
        
        /// 隐藏tableview的分割线
        if indexPath.row == 2{
            cell.separatorInset = UIEdgeInsets.init(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: -UIScreen.main.bounds.width)
        }
        /// cell里面的imageView，textlabel，detailTextLabel是属于cell的contentView的子view，不是cell的直接子view。
    
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "第\(section)个section的头部"
    }
    
    //MARK: 设置每个section的索引标题
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        print("设置每个section的索引标题\(#function)")
        return ["索引0","索引1","索引2","索引3","索引4","索引5","索引6"]
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了第\(indexPath)个cell")
    }
    
    //MARK: - 测试tableview的侧滑删除、编辑
    ///实现该代理方法就是告知tableview提供侧滑删除功能。用户点击侧滑删除按钮，就会回调该方法。所以你要在这里同步处理数据源，增加或删除。
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        /// 编辑状态有插入和删除。
        print("当前的编辑状态是：\(editingStyle.rawValue)")
    }
    
    ///提供侧滑时，显示的删除文字是啥。
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除文字"
    }
    
    ///自定义侧滑时显示的按钮，可以提供多个按钮。自定义时，可以不用实现上面两个系统默认的代理方法，titleForDeleteConfirmationButtonForRowAt和commit editingStyle方法。
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("自定义侧滑时显示的按钮:\(indexPath)")
        let act1 = UITableViewRowAction.init(style: .normal, title: "动作1") { (rowaction, indexpath) in
            print("rowAction1的初始化闭包：\(rowaction)---\(indexPath);点击后回调执行")
        }
        let act2 = UITableViewRowAction.init(style: .destructive, title: "动作2") { (rowaction, indexpath) in
            print("rowAction2的初始化闭包：\(rowaction)---\(indexPath);点击后回调执行")
        }
        return [act1,act2]
    }
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestTableView_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、设置分割线
            print("     (@@  设置分割线")
            testTableView.separatorStyle = .singleLine
            testTableView.separatorColor = .blue
            testTableView.separatorInset = UIEdgeInsets.init(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: UIScreen.main.bounds.width)
            
            break
        case 1:
            //TODO: 1、设置tableview的索引条
            print("     (@@ ")
        case 2:
            //TODO: 2、 设置tableview的编辑模式,则变成侧滑进入编辑模式。设置为false则退出编辑模式。
            print("     (@@ 进入编辑模式:\(!testTableView.isEditing)")
            testTableView.isEditing = !testTableView.isEditing
//            testTableView.setEditing(true, animated: true)  //动画效果进入编辑模式
        case 3:
            //TODO: 3、获取编辑模式多选的cell的indexpath
            /// 记得同步更新数据源，不要遍历删除row，因为每删除一个row，其他row的indexpath会发生变化。
            print("     (@@ 获取编辑模式多选的cell的indexpath")
            let pathsArr = testTableView.indexPathsForSelectedRows
            print("选中的indexpath是：\(String(describing: pathsArr))")
            
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
extension TestTableView_VC{
   
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
extension TestTableView_VC{
    
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
extension TestTableView_VC {
    
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
        baseCollView.snp.makeConstraints { make in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(200)
        }
        
    }
}

//MARK: - 遵循CollectionView的协议,UICollectionViewDelegate
extension TestTableView_VC: UICollectionViewDelegate {
    
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


