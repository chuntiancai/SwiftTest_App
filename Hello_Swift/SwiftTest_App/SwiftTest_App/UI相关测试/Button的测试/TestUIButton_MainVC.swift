//
//  TestUIButton_MainVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/9/13.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试Button的VC
// MARK: - 笔记
/**
    1、button的一个事件可以同时绑定多个方法。
    2、UIButton的状态，其实是UIControl的状态，不是单单为UIButton设计的：
 
        1.highlighted
            1> 【当按住按钮不松开】或者用代码【button.highlighted = YES】时就能达到这种状态
            2> 这种状态下的按钮【可以】接收点击事件,显示为【highlighted】状态下的文字颜色和图片。高亮和选中可以共存，然后这种共存状态就是normal。

        2.disabled
            1> 【button.enabled = NO】时就能达到这种状态
            2> 这种状态下的按钮【无法】接收点击事件,显示为【Disabled】状态下的文字颜色和图片

        3.selected
            1> 【button.selected = YES】时就能达到这种状态，需要通过代码手动设置。
            2> 这种状态下的按钮【可以】接收点击事件,显示为【selected】状态下的文字颜色和图片
        
        4.normal
            1> 除开UIControlStateHighlighted、UIControlStateDisabled、UIControlStateSelected 以外的其他情况， 都是normal状态,包括以上几种状态的叠加状态都会【显示】为normal状态下的文字颜色和图片
            2> 这种状态下的按钮【可以】接收点击事件,但是如果是由【button.enabled = NO】状态和其它状态叠加则不可点击
        
        5.focused
            1> 这个更常用于文本输入框的情况，就是文本输入框的获取到鼠标光标时的状态。如果你有鼠标放在按钮上，那么按钮也是这个状态。
            
        所有状态都可以通过代码手动设置
 
 */

class TestUIButton_MainVC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    private let textBtn = TestButton()  //测试上图下文
    private let statusBtn = TestStatusButton()  //测试按钮状态的按钮

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试Button的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestUIButton_MainVC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试按钮的状态
            print("     (@@  0、测试按钮的状态")
            statusBtn.setImage(UIImage(named: "buttonStatus_normal"), for: .normal)
            statusBtn.setImage(UIImage(named: "buttonStatus_disabled"), for: .disabled)
            statusBtn.setImage(UIImage(named: "buttonStatus_highlighted"), for: .highlighted)
            statusBtn.setImage(UIImage(named: "buttonStatus_focused"), for: .focused)
            statusBtn.setImage(UIImage(named: "buttonStatus_selected"), for: .selected)
        case 1:
            //TODO: 1、
            print("     (@@ ")
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
extension TestUIButton_MainVC{
   
    
}


//MARK: - 工具方法
extension TestUIButton_MainVC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        self.view.addSubview(textBtn)
        textBtn.layer.borderColor = UIColor.brown.cgColor
        textBtn.layer.borderWidth = 1.0
        textBtn.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.height.equalTo(60)
            make.width.equalTo(100)
            make.left.equalToSuperview().offset(20)
        }
        
        
        self.view.addSubview(statusBtn)
        statusBtn.layer.borderColor = UIColor.brown.cgColor
        statusBtn.layer.borderWidth = 1.0
        statusBtn.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.height.equalTo(60)
            make.width.equalTo(100)
            make.left.equalTo(textBtn.snp.right).offset(20)
        }
    }
    
}


//MARK: - 设计UI
extension TestUIButton_MainVC {
    
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
extension TestUIButton_MainVC: UICollectionViewDelegate {
    
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



