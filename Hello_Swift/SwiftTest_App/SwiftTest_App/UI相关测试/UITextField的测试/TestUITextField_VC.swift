//
//  TestUITextField_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/16.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试UITextField的VC

import UIKit

class TestUITextField_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试的UI组件
    private var eventTextFieldView:TestTextFileldEvent_View =  TestTextFileldEvent_View() //测试textfield的事件传递
    private var keyBoardTextField:KeyBoardTextField = KeyBoardTextField()//测试 替换 弹起的键盘
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试UITextField的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TestUITextField_VC的\(#function)方法")
        eventTextFieldView.resignFirstResponder()
    }

}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestUITextField_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、添加测试事件传递的textField
            print("     (@@ 添加测试事件传递的textField")
            if eventTextFieldView.isDescendant(of: self.view) {
                return
            }else{
                eventTextFieldView.layer.borderWidth = 0.5
                eventTextFieldView.layer.borderColor = UIColor.red.cgColor
                self.view.addSubview(eventTextFieldView)
                eventTextFieldView.snp.makeConstraints { make in
                    make.top.equalTo(collectionView.snp.bottom).offset(40)
                    make.height.equalTo(80)
                    make.width.equalToSuperview().multipliedBy(0.9)
                    make.centerX.equalToSuperview()
                }
            }
            
        case 1:
            //TODO: 1、添加测试更换键盘的textField
            print("     (@@  添加测试更换键盘的textField")
            if keyBoardTextField.superview == nil {
                self.view.addSubview(keyBoardTextField)
                keyBoardTextField.snp.makeConstraints({ make in
                    make.center.equalToSuperview()
                    make.height.equalTo(45)
                    make.width.equalTo(350)
                })
            }
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
            print("     (@@ 移除所有测试的控件")
            keyBoardTextField.removeFromSuperview()
            eventTextFieldView.removeFromSuperview()
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestUITextField_VC{
   
    //MARK: 0、swift读取.plist文件，获取应用程序程序包中资源文件路径，也就是获取工程目录的路径。
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
extension TestUITextField_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        /// 测试用view替代弹起的键盘的textfield
        keyBoardTextField.backgroundColor = .white
        keyBoardTextField.layer.borderWidth = 0.5
        keyBoardTextField.layer.borderColor = UIColor.black.cgColor
        
        
    }
    
}


//MARK: - 设计UI
extension TestUITextField_VC {
    
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
extension TestUITextField_VC: UICollectionViewDelegate {
    
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
    遇到问题：
        1、如果在自定义view中定义的textfield，键盘收不起的问题。
        2、textfield自定义键盘，键盘为pickerview时，选中项被遮挡住的问题。
 */

