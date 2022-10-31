//
//  TestQRCode_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/31.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试二维码的VC
// MARK: - 笔记
/**
    1、二维码简介：
        用平面图形记录数据符号信息，即图形存储数据。
    2、生成二维码：
            需要导入CoreImage框架，用于过滤图片。用到CIFilter类，这是Core Image中一个比较核心的有关滤镜使用的类。
            滤镜的使用是可以叠加的，我们可以使用多种滤镜处理同一个图像。
            输出图像的生产过程需要我们通过设置一些参数来实现，而这些参数的设置和检索都是利用键/值对的形式进行操作的。
 
 
 */

import CoreImage
class TestQRCode_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    let imgView = UIImageView() //展示二维码的图片view。
    let textView = UITextView() //展示二维码数据的文本view。
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试二维码的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestQRCode_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestQRCode_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试生成二维码。
            print("     (@@ 0、测试生成二维码。")
            
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
extension TestQRCode_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestQRCode_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        /// 内容背景View，测试的子view这里面
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        //TODO: 初始化UI，一个图片，一个文本的控件。
        bgView.addSubview(imgView)
        imgView.layer.borderColor = UIColor.brown.cgColor
        imgView.layer.borderWidth = 1.0
        imgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(38)
            make.height.width.equalTo(180)
            make.centerX.equalToSuperview()
        }
        
        bgView.addSubview(textView)
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1.0
        textView.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(38)
            make.height.equalTo(200)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
    }
    
}


//MARK: - 设计UI
extension TestQRCode_VC {
    
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
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 0, right: 5)
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
extension TestQRCode_VC: UICollectionViewDelegate {
    
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
