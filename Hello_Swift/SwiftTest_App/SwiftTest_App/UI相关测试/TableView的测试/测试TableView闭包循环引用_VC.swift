//
//  TestTableViewCellBlock_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/16.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试tableView的里面cell的循环引用问题的VC

class TestTableViewCellBlock_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试的View
    ///测试闭包循环引用的tableView,tag = 1000
    private var blockTableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TestTableView_Cell.self, forCellReuseIdentifier: "TestTableView_Cell_ID")

        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        tableView.bounces = true
        tableView.separatorStyle = .none
        
        let tHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        tHeaderView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        tableView.tableHeaderView = tHeaderView
        
        return tableView
    }()
    private var playerViewDict = Dictionary<IndexPath,UIView>() //存储播放过的视频播放器，目前用于存放开始页面
    private var preAudioView:TestTableView_SubView?   //前一个播放音频的View
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "测试功能"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestView()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestTableViewCellBlock_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            print("     (@@")
            break
        case 1:
            print("     (@@")
        case 2:
            print("     (@@")
        case 3:
            print("     (@@")
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
extension TestTableViewCellBlock_VC{
    
}


//MARK: - 工具方法
extension TestTableViewCellBlock_VC: UITableViewDelegate ,UITableViewDataSource {
    
    //MARK: 设置cell的UI
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "TestTableView_Cell_ID", for: indexPath) as! TestTableView_Cell
        var curSubView:TestTableView_SubView!
        if let curView = playerViewDict[indexPath] {
            curSubView = curView as? TestTableView_SubView
        }else{
            
            curSubView = TestTableView_SubView()
            playerViewDict[indexPath] = curSubView
            print("创建的TestTableView_SubView：\(String(describing: curSubView))")
            //TODO: Block是一个对象，或者说是一个结构体，存在于堆空间中，这个就是block与block宿主之间的循环引用问题。
            curSubView.togglePlayAction = {
                [weak self] _ in
                if let preView = self?.preAudioView {
                    if preView == curSubView {    //点击了同一个view
                        print("点击了同一个view")
                        return
                    }
                }
                self?.preAudioView = curSubView   //设置标志器
            }
            
            
            switch indexPath.row {
            case 0:
                curSubView.backgroundColor = .red
                cell.contentView.backgroundColor = UIColor(red: 60/255.0, green: 60/255.0, blue: 60/255.0, alpha: 1.0)
                break
            case 1:
                curSubView.backgroundColor = .blue
                cell.contentView.backgroundColor = UIColor(red: 120/255.0, green: 120/255.0, blue: 120/255.0, alpha: 1.0)
                break
            case 2:
                curSubView.backgroundColor = .yellow
                cell.contentView.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
                break
            default:
                break
            }
        }
        
        (cell as! TestTableView_Cell).addAudioView(subView: curSubView)
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    /// 初始化你要测试的view
    func initTestView(){
        view.addSubview(blockTableView)
        blockTableView.delegate = self
        blockTableView.dataSource = self
        blockTableView.backgroundColor = .gray
        blockTableView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(400)
        }
    }
    
    
}


//MARK: - 设计UI
extension TestTableViewCellBlock_VC {
    
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
extension TestTableViewCellBlock_VC: UICollectionViewDelegate {
    
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
}

