//
//  TestSubVC_MainVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/19.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试子VC的主VC

import UIKit

class TestSubVC_MainVC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(" TestSubVC_MainVC 的 viewDidLoad方法")
        self.view.backgroundColor = .white
        self.title = "测试子VC的主VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("@@ TestSubVC_MainVC 的 touchesBegan方法")
    }

}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestSubVC_MainVC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            print("     (@@ 添加subVC1，只添加子view")
            let subVC1 = TestSubVC_SubVC()
            subVC1.view = SubVC1_View()
            subVC1.view.backgroundColor = .red
            subVC1.view.tag = 10001
            subVC1.view.isUserInteractionEnabled = true
            let tapGusture = UITapGestureRecognizer.init(target: self, action: #selector(tapSubVC1_ViewAciton))
            subVC1.view.addGestureRecognizer(tapGusture)
            self.view.addSubview(subVC1.view)
            subVC1.view.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(300)
                make.height.width.equalTo(60)
                make.left.equalToSuperview().offset(20)
            }
            break
        case 1:
            print("     (@@ 添加subVC2,添加到VC的chlid中")
            let subVC2 = TestSubVC_SubVC2()
            subVC2.view.backgroundColor = .blue
            subVC2.view.tag = 10002
            self.addChild(subVC2)
            self.view.addSubview(subVC2.view)
            subVC2.view.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(350)
                make.height.width.equalTo(60)
                make.left.equalToSuperview().offset(100)
            }
        case 2:
            //TODO: 测试VC重写初始化方法
            print("     (@@ 测试VC重写初始化方法")
            let subVC3 = TestSubVC_SubVC3()
            subVC3.view.backgroundColor = .brown
            self.pushNext(viewController: subVC3)
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
extension TestSubVC_MainVC{
    
}


//MARK: - 工具方法
@objc extension TestSubVC_MainVC{
    func tapSubVC1_ViewAciton(){
        print("@@ 点击了 tapSubVC1的view的手势动作方法")
    }
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestSubVC_MainVC {
    
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
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestSubVC_MainVC: UICollectionViewDelegate {
    
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

//MARK: - 笔记
/**
    1、VC与VC的view是独立的，只不过VC是View的下一个响应者，VC的销毁不影响VC的View单独存在。VC的View可以自定义替换，只有在加载或者使用View的时候才会去调用View。
    2、VC会通过touchesBegan方法，将事件传递给子VC。而不是子VC传递给父VC。
    
 */
