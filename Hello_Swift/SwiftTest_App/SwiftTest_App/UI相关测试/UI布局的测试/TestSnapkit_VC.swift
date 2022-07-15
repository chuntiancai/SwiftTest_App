//
//  TestSnapkit_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/6.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试Snapkit的VC

class TestSnapkit_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    private let redView = UIView()
    private let blueView = UIView()
    private let brownView = UIView()
    var widthConstraint:NSLayoutConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试Snapkit的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestSnapkit_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试移除被参考的view后，Snpkit约束的变化。
            /**
                1、移除被参考的view之后，其他的view的位置大小会发生变化。
             */
            print("     (@@  隐藏redView")
//            redView.removeFromSuperview()
            widthConstraint = NSLayoutConstraint.init(item: redView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
            UIView.animate(withDuration: 2) {
                [weak self] in
                self?.widthConstraint.constant = 0
                self?.widthConstraint.isActive = true
                self?.view.layoutIfNeeded()
            }
            
            break
        case 1:
            //TODO: 1、重新添加被参考的view，参考该view的其他view的约束不会从新计算，因为之前的View已经被移除了。约束也消失了，只能所有的view都从新计算了。
            print("     (@@ 添加redview")
            self.view.addSubview(redView)
            redView.snp.remakeConstraints { make in
                make.top.equalTo(baseCollView.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(20)
                make.width.equalTo(80)
                make.height.equalTo(50)
            }
            self.view.updateConstraints()
            self.blueView.updateConstraints()
            self.view.layoutIfNeeded()
        case 2:
            //TODO: 2、测试动态修改约束，更新view的布局。
            print("     (@@ ")
            UIView.animate(withDuration: 2) {
                [weak self] in
                self?.widthConstraint.constant = 100
                self?.view.layoutIfNeeded()
            }
            
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
extension TestSnapkit_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestSnapkit_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        redView.backgroundColor = .red
        self.view.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        
        blueView.backgroundColor = .blue
        self.view.addSubview(blueView)
        blueView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20).priority(998)
            make.left.equalTo(redView.snp.right).offset(20).priority(999)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        brownView.backgroundColor = .brown
        self.view.addSubview(brownView)
        brownView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.left.equalTo(blueView.snp.right).offset(20).priority(999)
            make.left.equalTo(redView.snp.right).offset(20).priority(998)
            make.left.equalToSuperview().offset(20).priority(997)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
    }
    
}


//MARK: - 设计UI
extension TestSnapkit_VC {
    
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
extension TestSnapkit_VC: UICollectionViewDelegate {
    
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
    1、移除被参考的view后，Snpkit约束会从新计算，然后参考该view的其他view，会从新调整位置和尺寸。
    
    2、可以通过手写约束的方式，来实现snpkit的动态修改布局，这样就不用直接修改frame的值。
    
    
 */

