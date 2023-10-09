//
//  TestUILabel_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/15.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试UILabel的VC
//MARK: - 笔记
/**
    1、调用sizeToFit()方法，只针对特定的View起作用，例如label一开始你没有设置frame，然后你就添加到view上去了，然后你这时候调用label的sizeToFit()方法， 就可以计算出这个label的位置和尺寸了，这个方法只是为没有设置frame的view计算最适合的尺寸，然后放到位置上，没什么卵用。
    2、
 */

class TestUILabel_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    var gradientView = GradientTestLabelView()  //测试渐变色的文字
    var lineSpaceLabel = UILabel()  //测试行间距
    var lineSpaceNum:CGFloat = 20   //行间距的值。
    
    var adaptLabel = TestAdaptSize_Label()  //测试label的文字自适应高度，宽度。
    var gradientLabel = GradientFontTestLabel() //测试渐变色字体的label
    
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
            //TODO: 0、测试文字的渐变色
            print("     (@@  测试文字的渐变颜色")
            let _ = self.bgView.subviews.map { $0.removeFromSuperview() }
            self.bgView.addSubview(gradientView)
            gradientView.backgroundColor = .gray
            gradientView.snp.makeConstraints { make in
                make.top.equalTo(baseCollView.snp.bottom).offset(20)
                make.width.equalToSuperview()
                make.height.equalTo(80)
            }
            gradientView.name = "测试渐变颜色"
            break
        case 1:
            //TODO: 1、测试label的行距
            lineSpaceLabel.isHidden = false
            lineSpaceNum += 1
            print("     (@@ 测试label的行间距+1:=\(lineSpaceNum)")
            
            lineSpaceLabel.setValue(lineSpaceNum, forKey: "lineSpacing")
            lineSpaceLabel.layoutIfNeeded()
        case 2:
            //TODO: 2、测试label的行距-1
            lineSpaceNum -= 1
            print("     (@@ 测试label的行间距-1:=\(lineSpaceNum)")
            lineSpaceLabel.setValue(lineSpaceNum, forKey: "lineSpacing")
            lineSpaceLabel.layoutIfNeeded()
        case 3:
            //TODO: 3、测试Label的自适应高度、宽度。
            print("     (@@ 测试Label的自适应高度、宽度")
            let _ = self.bgView.subviews.map { $0.removeFromSuperview() }
            self.bgView.addSubview(adaptLabel)
            adaptLabel.text = "label的自适应尺寸"
            adaptLabel.layer.borderWidth = 1.0
            
            adaptLabel.layer.borderColor = UIColor.red.cgColor
            self.view.addSubview(adaptLabel)
            adaptLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.width.equalTo(200)
            }
        case 4:
            //TODO: 4、测试Label的自适应intrinsicContentSize。
            print("     (@@ 改变label的文字")
            adaptLabel.font = .systemFont(ofSize: 20)
            adaptLabel.numberOfLines = 0
            adaptLabel.name = "自适应-自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应"
            let btn = UIButton()
            btn.titleLabel?.textColor = .black
            btn.setTitle("自适应按钮", for: .normal)
            print("btn 的 intrinsicContentSize :\(btn.intrinsicContentSize)")
            btn.setTitle("自适应按钮-自适应按钮", for: .normal)
            print("btn 的 intrinsicContentSize :\(btn.intrinsicContentSize)")
        case 5:
            //TODO: 5、测试Label的sizeToFit()方法
            print("     (@@ 测试Label的sizeToFit()方法")
            let curView = UIView()
            curView.layer.borderWidth = 1.0
            curView.layer.borderColor = UIColor.red.cgColor
            self.view.addSubview(curView)
            curView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.width.equalTo(250)
            }
            adaptLabel.text = "测试sizeToFit()方法-测试sizeToFit()方法-测试sizeToFit()方法"
            adaptLabel.textColor = .black
            curView.addSubview(adaptLabel)
//            adaptLabel.name = "自适应-自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应自适应"
            
        case 6:
            //TODO: 6、测试Label的sizeToFit()方法
            print("     (@@")
            adaptLabel.sizeToFit()
        case 7:
            //TODO: 7、测试渐变色label
            print("     (@@测试渐变色label")
            
            let _ = self.bgView.subviews.map { $0.removeFromSuperview() }
            gradientLabel.text = "开始-测试渐变色label测试渐变色label测试渐变色label测试渐变色label-结束"
            gradientLabel.layer.borderColor = UIColor.red.cgColor
            gradientLabel.layer.borderWidth = 1.0
            gradientLabel.numberOfLines = 0
            self.bgView.addSubview(gradientLabel)
            gradientLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(100)
            }
            
            
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
        
        /// 内容背景View，测试的子view这里面
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
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
        lineSpaceLabel.isHidden = true
        
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

