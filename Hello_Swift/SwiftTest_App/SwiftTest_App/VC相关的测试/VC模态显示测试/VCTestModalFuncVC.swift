//
//  VCTestModalFuncVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/26.
//  Copyright © 2021 com.mathew. All rights reserved.
//

// 测试VC的生命周期

import UIKit

class VCTestModalFuncVC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 复写的方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .bottom
        self.view.backgroundColor = .white
        self.title = "测试VC的模态显示"
        
        setNavigationBarUI()
        setCollectionViewUI()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("VCTestModalFuncVC touchesBegan")
    }
    
    override func addChild(_ childController: UIViewController) {
        print("VCTestModalFuncVC addChild")
        super.addChild(childController)
    }
    
    override var presentedViewController: UIViewController?{
        get{
            print("VCTestModalFuncVC presentedViewController :\(String(describing: super.presentingViewController))")
            return super.presentingViewController
        }
    }

}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension VCTestModalFuncVC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            print("     (@@模态显示一个VC")
            let curVC = TestModalVC()
            curVC.view.backgroundColor = .blue
            curVC.view.tag = 10086
//            self.view.addSubview(curVC.view)
//            curVC.view.snp.makeConstraints { make in
//                make.center.equalToSuperview()
//                make.height.width.equalTo(100)
//            }
            curVC.modalPresentationStyle = .overCurrentContext
            curVC.modalTransitionStyle = .crossDissolve
//            curVC.preferredContentSize = CGSize.init(width: 200, height: 100)
//            curVC.modalTransitionStyle = .partialCurl
            self.present(curVC, animated: true) {
                [weak self] in
                print("self 的层次结构：\(self?.children)")
                print("self?.presentingViewController：\(self?.presentingViewController)")
                print("self?.presentedViewController：\(self?.presentedViewController)")
                print("curVC.presentingViewController：\(curVC.presentingViewController)")
                print("curVC.presentedViewController：\(curVC.presentedViewController)")
                print("present completation~~~")
            }
            curVC.view.superview?.frame = CGRect.init(x: 0, y: 300, width: 300, height: 200)
            print("创建一个VC完毕")
            break
        case 1:
            print("     (@@show一个VC")
            let curVC = TestModalVC()
            curVC.view.backgroundColor = .blue
            curVC.view.tag = 10086
            self.view.addSubview(curVC.view)
            curVC.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.width.equalTo(100)
            }
            self.show(curVC, sender: nil)
            break
        case 2:
            print("     (@@ 重新设置snpkit")
            
        case 3:
            print("     (@@旋转view")
            break
        case 4:
            print("     (@@ 复原view的矩阵变换")
            break
            
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
extension VCTestModalFuncVC: UICollectionViewDelegate {
    
}

//MARK: - 工具方法
extension VCTestModalFuncVC{
    
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}


//MARK: - 设计UI
extension VCTestModalFuncVC {
    
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
//        layout.headerReferenceSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: 130)
        layout.itemSize = CGSize.init(width: 80, height: 80)
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:SCREEN_HEIGHT / 2),
                                             collectionViewLayout: layout)
        baseCollView.backgroundColor = UIColor.cyan
        baseCollView.delegate = self
        baseCollView.dataSource = self
        // register cell
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        baseCollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.left.equalToSuperview()
        }
        
    }
}
