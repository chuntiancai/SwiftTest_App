//
//  TestUILabel_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/15.
//  Copyright © 2021 com.mathew. All rights reserved.
//

//测试UILabel的VC

import UIKit

class TestUILabel_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    var gradientView = GradientTestLabelView()  //测试渐变色的文字
    var lineSpaceLabel = UILabel()  //测试行间距
    var lineSpaceNum:CGFloat = 20   //行间距的值。
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试UILabel的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestUILabel_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、
            print("     (@@  测试文字的渐变颜色")
            gradientView.name = "测试渐变颜色"
            break
        case 1:
            //TODO: 1、
            lineSpaceNum += 1
            print("     (@@ 测试label的行间距+1:=\(lineSpaceNum)")
            lineSpaceLabel.setValue(lineSpaceNum, forKey: "lineSpacing")
            lineSpaceLabel.layoutIfNeeded()
        case 2:
            //TODO: 2、
            lineSpaceNum -= 1
            print("     (@@ 测试label的行间距-1:=\(lineSpaceNum)")
            lineSpaceLabel.setValue(lineSpaceNum, forKey: "lineSpacing")
            lineSpaceLabel.layoutIfNeeded()
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
extension TestUILabel_VC{
   
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
extension TestUILabel_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        self.view.addSubview(gradientView)
        gradientView.backgroundColor = .gray
        gradientView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(80)
        }
        gradientView.isHidden = true
        
        lineSpaceLabel.textColor = .blue
        lineSpaceLabel.numberOfLines = 0
        lineSpaceLabel.layer.borderWidth = 1.0
        lineSpaceLabel.layer.borderColor = UIColor.black.cgColor
        lineSpaceLabel.font = .systemFont(ofSize: 16)
//        lineSpaceLabel.setValue(20, forKey: "lineSpacing")
        lineSpaceLabel.text = "这是测试字体的行距呀，这是测试字体的行距呀，这是测试字体的行距呀，这是测试字体的行距呀，这是测试字体的行距呀。"
        self.view.addSubview(lineSpaceLabel)
        lineSpaceLabel.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(80)
        }
        
    }
    
}


//MARK: - 设计UI
extension TestUILabel_VC {
    
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
extension TestUILabel_VC: UICollectionViewDelegate {
    
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
    1、
 */
