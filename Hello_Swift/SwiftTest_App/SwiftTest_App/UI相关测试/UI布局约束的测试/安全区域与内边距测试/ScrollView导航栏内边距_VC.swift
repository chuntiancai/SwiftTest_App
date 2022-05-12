//
//  ScrollView导航栏内边距_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/5/12.
//  Copyright © 2022 com.mathew. All rights reserved.
//

///  测试导航栏VC下，VC的安全内边距对ScrollView的影响。
class TestSafeInset_SubVC2: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    let myScrollView = UIScrollView()   //用于测试内边距对scrollView的影响
    let pinkView = UIView()     //用于测试非scrollview的内边距影响
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "VC的安全内边距对ScrollView的影响"
        
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestSafeInset_SubVC2: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、设置导航VC的内边距、导航栏UI
            /**
                1、navigationController会根据navigationBar.isTranslucent、vc.edgesForExtendedLayout属性值 动态来调整子View(VC的view)的frame(上下移动)。
                2、SrcollView、tableView这些滚动视图的safeAreaInsets不受影响，因为UIKit对它们做了特殊处理，增加了contentInsetAdjustmentBehavior、和 adjustedContentInset属性，这两个属性决定了ScrollView的内容视图的布局起始点。
                    ScrollView的内容边距计算：adjustedContentInset = safeAreaInsets + contentInset 。
                    ScrollView的内容是从内容边距开始布局的，而contentInsetAdjustmentBehavior决定了adjustedContentInset是否生效。
             */
            print("     (@@  设置导航VC的内边距、导航栏UI")
            self.edgesForExtendedLayout = .all
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.setBackgroundImage(getColorImg(alpha: 0.3,.purple), for: .default)
            
        case 1:
            //TODO: 1、添加测试的ScrollView
            /**
                1、 影响链：vc.view.safeAreaInsets --> adjustedContentInset --> contentInsetAdjustmentBehavior --> contentInset
                        scrollView.contentInsetAdjustmentBehavior属性：决定了adjustedContentInset是否生效。
                        scrollView.adjustedContentInset属性：决定了contentVeiw的内容布局的起始位置。
             
                2、只是影响了scrollView里的contentView里的布局，并不影响到scrollView本身的frame。
                    注意，这并没有影响到scrollView的contentInset属性值，只是修改了adjustedContentInset的值，并对内容的布局作调整。
             
             */
            print("     (@@ 添加测试的ScrollView")
//            myScrollView.contentInsetAdjustmentBehavior = .never    //不根据view的内边距作内容调整
            myScrollView.layer.borderWidth = 1.0
            myScrollView.layer.borderColor = UIColor.brown.cgColor
            myScrollView.backgroundColor = .cyan
            myScrollView.showsVerticalScrollIndicator = true
            myScrollView.showsHorizontalScrollIndicator = true
            myScrollView.contentSize = CGSize.init(width: 450, height: 700)
            
            self.view.addSubview(myScrollView)
            myScrollView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(200)
                make.width.equalTo(300)
                make.centerX.equalToSuperview()
            }
            let redView = UIView()
            redView.tag = 1001
            redView.backgroundColor = .red
            redView.layer.borderWidth = 1.0
            redView.layer.borderColor = UIColor.blue.cgColor
            myScrollView.addSubview(redView)
            redView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.height.equalTo(80)
                make.width.equalTo(20)
            }
            
        case 2:
            //TODO: 2、添加非scrollView
            /**
                1、导航栏的布局起始点变化后，会修改VC的View的内边距，也会修改View所有层次的子View的safeAreaInsets，遍历影响。但是scrollView、tableview这些控件的 safeAreaInsets不受影响，因为它们是可滚动的视图，UIKit做了特殊处理。
                2、
             */
            print("     (@@ 添加非scrollView")
            pinkView.tag = 1001
            pinkView.backgroundColor = .systemPink
            pinkView.layer.borderWidth = 1.0
            pinkView.layer.borderColor = UIColor.brown.cgColor
            view.addSubview(pinkView)
            pinkView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.height.equalTo(80)
                make.width.equalTo(40)
            }
            
            let yellowView = UIView()
            yellowView.tag = 1002
            yellowView.backgroundColor = .yellow
            pinkView.addSubview(yellowView)
            yellowView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.height.equalTo(80)
                make.width.equalTo(40)
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
extension TestSafeInset_SubVC2{
   
    //TODO: 根据颜色来生成图片，颜色图片
    func getColorImg(alpha:CGFloat,_ color:UIColor = .orange) -> UIImage {
        let alphaColor = color.withAlphaComponent(alpha).cgColor
        /// 描述图片的矩形
        let rect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)
        /// 开启位图的上下文
        UIGraphicsBeginImageContext(rect.size)
        /// 获取位图的上下文
        let context = UIGraphicsGetCurrentContext()

        /// 使用color填充上下文
        context?.setFillColor(alphaColor)
        
        /// 渲染上下文
        context?.fill(rect)
        /// 从上下文中获取图片
        let colorImg = UIGraphicsGetImageFromCurrentImageContext()
        
        
        ///结束上下文
        UIGraphicsEndImageContext()
        return colorImg!
        
    }
    
}


//MARK: - 设置测试的UI
extension TestSafeInset_SubVC2{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestSafeInset_SubVC2 {
    
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 40)
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:UIScreen.main.bounds.size.height - 300 , width:UIScreen.main.bounds.size.width,height:200),
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
        baseCollView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalToSuperview()
        }
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestSafeInset_SubVC2: UICollectionViewDelegate {
    
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
    1、
 
 */
