//
//  TestTableViewDelegateLifeCycle_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/1.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试tableView代理的执行顺序，生命周期的VC
//MARK: - 笔记
/**
    UITableViewDelegate方法的执行顺序：
        ∆～numberOfSections方法～∆ 设置有多少个section
        ∆～numberOfRowsInSection方法～∆ 设置每个section多少个row
        (一轮之后，又继续下面的一轮)
        ∆～cellForRowAt方法～∆ 设置每个Cell的UI
        ∆～heightForRowAt方法～∆ 设置每个row的高度
 
    1、首先询问有多少个section
    2、然后询问每个section有多少个row，有多少个section，就询问多少次。
    3、设置每一个cell的UI
    4、询问每一个cell的高度，这个section有多少个cell，就询问多少次cell的高度。
 
 
 */


class TestTableViewDelegateLifeCycle_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试的View
    ///测试闭包循环引用的tableView,tag = 1000
    private var myTableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TableView_LifeCycle_Cell.self, forCellReuseIdentifier: "TableView_LifeCycle_Cell_ID")

        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1)
        tableView.bounces = true
        tableView.separatorStyle = .singleLine
        
        let tHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        tHeaderView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        tableView.tableHeaderView = tHeaderView
        
        return tableView
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 212/255.0, green: 208/255.0, blue: 206/255.0, alpha: 1.0)
        self.title = "测试tableView代理的执行顺序，生命周期的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestView()
    }

    /// 初始化你要测试的view
    func initTestView(){
        view.addSubview(myTableView)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(400)
        }
    }
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestTableViewDelegateLifeCycle_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试调用myTableView.reloadRows(at indexPaths:,)方法之后的顺序
            /**
             如果indexPaths的cell现在是可见的：
                1、它会去询问每一个section有多少个row。   //numberOfRowsInSection:
                2、询问当前可见的cell的高度。   //heightForRowAt:
                3、调用indexPaths的cell的cellForRowAt: 设置cellUI方法。     //cellForRowAt:
                4、调用indexPaths的cell的willDisplay: 将要显示cell方法。         //willDisplay:
                5、调用indexPaths的cell的didEndDisplaying: 结束显示cell的方法。         //didEndDisplaying:
                
                所以，你不能在cellForRowAt:、willDisplay: 、didEndDisplaying: 方法中调用reloadRows方法。
             
             如果indexPaths的cell现在是不可见的：
                1、去询问每一个section有多少个row。 回调tableView(_:numberOfRowsInSection:)
                2、询问当前可见的cell的高度。   回调tableView(_::)
                3、没了，结束了。
             */
            print("     (@@ 0、测试调用myTableView.reloadRows(at indexPaths:,)方法之后的顺序")
            myTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        case 1:
            //TODO: 1、
            print("     (@@ 1、")
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
extension TestTableViewDelegateLifeCycle_VC{
    
}


//MARK: - TableView的代理方法，UITableViewDelegate ,UITableViewDataSource
extension TestTableViewDelegateLifeCycle_VC: UITableViewDelegate ,UITableViewDataSource {
    
    //MARK: 1 、设置有多少个section
    func numberOfSections(in tableView: UITableView) -> Int {
        print("∆～\(#function)方法～∆ 设置有多少个section")
        return 3
    }
    
    //MARK: 2、设置每个section多少个row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("∆～\(#function)方法～∆ 设置第\(section)个section多少个row")
        return 7
    }
    
    //MARK: 3、设置每个Cell的UI
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("∆～\(#function)～∆ 设置每个Cell的UI：\(indexPath)")
        let curCell = tableView.dequeueReusableCell(withIdentifier: "TableView_LifeCycle_Cell_ID", for: indexPath) as! TableView_LifeCycle_Cell
        curCell.titleStr = "\(indexPath)"
        return curCell
    }
    
    //MARK: 4、设置每个row的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("∆～\(#function)方法～∆ 设置每个row的高度：\(indexPath)")
        return 60
    }
    
    //MARK: 5、当cell即将显示时调用。
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("∆～\(#function)～∆ 当cell即将显示时调用：\(indexPath)")
        /// 对即将出现的cell做动画。如果你想让进来的时候就动画，那就要在viewWillAppear中reload table的数据。
        if indexPath.row == 2 {
            /// 1、先移出屏幕外，然后再动画移回来。
            cell.transform = CGAffineTransform.init(translationX: self.view.bounds.width, y: 0)
            UIView.animate(withDuration: 0.5) {
                /// 让cell复位
                cell.transform = .identity
            }
        }
    }
    
    //MARK: 6、当cell结束显示时调用，已经看不见的时候调用
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("∆～\(#function)～∆ 当cell结束显示时调用：\(indexPath)")
    }
    
    //MARK: 点击了哪一行
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("∆～\(#function)～∆ 点击了第\(indexPath)行")
    }
    
    //MARK: 取消了点击哪一行，跟点击哪一行是对应的。
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("∆～\(#function)～∆ 取消点击第\(indexPath)行")
    }
    
    
    
    
    
}


//MARK: - 设计UI
extension TestTableViewDelegateLifeCycle_VC {
    
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
        
        baseCollView.backgroundColor = UIColor.cyan
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
    
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestTableViewDelegateLifeCycle_VC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collDataArr.count
    }
    ///设置item的UI
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
}

