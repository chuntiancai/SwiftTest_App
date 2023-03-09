//
//  UILifeCycleVC_1.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/23.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试UI的生命周期


class UILifeCycleVC_1: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、添加一个View","1、移除一个view","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .bottom
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试功能View的生命周期"
        
        setNavigationBarUI()
        setCollectionViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension UILifeCycleVC_1: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            print("     (@@添加一个view")
            let curView = TestLifeCycleView()
            curView.tag = 12345
            curView.backgroundColor = .cyan
//            view.frame = CGRect.init(x: 0, y: 160, width: 400, height: 300)
            self.view.addSubview(curView)
            curView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(200)
                make.height.equalTo(100)
            }
            
            break
        case 1:
            print("     (@@移除一个View")
            let curView = self.view.viewWithTag(12345)
            curView?.removeFromSuperview()
            
        case 2:
            print("     (@@ 重新设置snpkit")
            let curView = self.view.viewWithTag(12345)
//            if let consArr = curView?.constraints {
//                for cons in consArr {
//                    curView?.removeConstraint(cons)
//                }
//            }
//
            curView?.snp.remakeConstraints({ make in
                make.left.equalToSuperview().offset(10)
                make.centerY.equalToSuperview().offset(20)
                make.width.equalTo(120)
                make.height.equalTo(60)
            })
            
        case 3:
            print("     (@@旋转view")
            let curView = self.view.viewWithTag(12345)
            curView?.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2)
            print("旋转后")
            break
        case 4:
            print("     (@@ 复原view的矩阵变换")
            let curView = self.view.viewWithTag(12345)
            curView?.transform = CGAffineTransform.identity
            break
            
        case 5:
            //TODO:测试view的阴影
            print("     (@@测试view的阴影")
            let curView = TestShadowView()
            self.view.addSubview(curView)
            curView.snp.remakeConstraints({ make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(20)
                make.width.equalTo(375)
                make.height.equalTo(300)
            })
            
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
        case 13:
            print("     (@@")
        case 14:
            print("     (@@")
        case 15:
            print("     (@@")
        case 16:
            print("     (@@")
        case 17:
            print("     (@@")
        case 18:
            print("     (@@")
        case 19:
            print("     (@@")
        case 20:
            print("     (@@")
        case 21:
            print("     (@@")
        case 22:
            print("     (@@")
        case 23:
            print("     (@@")
        case 24:
            print("     (@@")
        default:
            break
        }
    }
    
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

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension UILifeCycleVC_1: UICollectionViewDelegate {
    
}

//MARK: - 工具方法
extension UILifeCycleVC_1{
    
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}


//MARK: - 设计UI
extension UILifeCycleVC_1 {
    
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

