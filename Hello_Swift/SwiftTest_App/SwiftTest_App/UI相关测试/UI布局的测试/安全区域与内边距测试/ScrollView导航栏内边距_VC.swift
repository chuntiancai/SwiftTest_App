//
//  ScrollView导航栏内边距_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/5/12.
//  Copyright © 2022 com.mathew. All rights reserved.
//

//  测试导航栏VC下，VC的安全内边距对ScrollView的影响。
//MARK: - 笔记
/**
    1、因为Scrollview的contentInset又是参考safeAreaInsets属性的，所以修改了additionalSafeAreaInsets后 影响到了safeAreaInsets属性，
       从而影响到了Scrollview的 contentInset属性，所以影响到了scrollView的内容布局。
 
    2、导航栏的外观：
            scrollView滑动时显示standardAppearance。
            scrollView处于顶部时显示scrollEdgeAppearance。
            默认是使用standardAppearance，没有scrollEdgeAppearance时，scrollEdgeAppearance使用standardAppearance的值。
            有scrollEdgeAppearance时，默认使用scrollEdgeAppearance。(因为一般scrollView都处于顶部，没有scrollView也是使用scrollEdgeAppearance)
    
 */
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
                make.height.equalTo(300)
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
                make.height.equalTo(100)
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
                make.height.equalTo(160)
                make.width.equalTo(60)
            }
            
            let yellowView = UIView()
            yellowView.tag = 1002
            yellowView.backgroundColor = .yellow
            pinkView.addSubview(yellowView)
            yellowView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.height.equalTo(120)
                make.width.equalTo(40)
            }
            
        case 3:
            //TODO: 3、测试scrollEdgeAppearance对Scrollview的影响。
            /**
                1、scrollview.contentInsetAdjustmentBehavior属性的默认值是.automatic，这个是contentInset的调整行为的意思。
                    在.automatic模式下，scrollview的contentInset会自动跟随navigationVC的safe area insets进行调整。
             
                2、当scrollview的content滑动到导航栏下方时，navigationBar就把scrollEdgeAppearance设置的样式应用到navigationBar上。
                    如果你没有设置scrollEdgeAppearance的值，那么scrollEdgeAppearance默认套用standardAppearance的值。
                    注意：导航栏透明的情况下，显示的是window的背景，导航栈是直接先把底下的VC暂时先移除，把当前要显示的VC放到window上的。
             */
            print("     (@@ 测试scrollEdgeAppearance对Scrollview的影响。")
            guard let naviBar = self.navigationController?.navigationBar else{ return}
            if #available(iOS 13.0, *) {
                let standAppearance = naviBar.standardAppearance
                let scroAppearance = naviBar.scrollEdgeAppearance
//                print("\(standAppearance) \n-- \(scroAppearance)")
                scroAppearance?.configureWithOpaqueBackground()
                scroAppearance?.backgroundColor = UIColor.red
                scroAppearance?.backgroundEffect = UIBlurEffect(style: .regular)
                
            } else {
                print("不是iOS 13.0版本")
            }
        case 4:
            //TODO: 4、复原standardAppearance(透明)，但是不是设置新对象，因为赋值需要等下一个页面才生效。
            /**
                1、standardAppearance.configureWithTransparentBackground()等系列函数是恢复naviBar的Appearance里的属性的默认值。
                    注意，是恢复属性的值，而不是赋值新的Appearance对象。
                2、
             */
            print("     (@@4、恢复standardAppearance为透明")
            guard let naviBar = self.navigationController?.navigationBar else{ return}
            if #available(iOS 13.0, *) {
                naviBar.standardAppearance.configureWithTransparentBackground()
                naviBar.isTranslucent = false
                print("透明的standardAppearance：\(naviBar.standardAppearance)")
                let scrAppearence = UINavigationBarAppearance()
                scrAppearence.backgroundColor = UIColor.yellow
                naviBar.scrollEdgeAppearance = scrAppearence
                naviBar.standardAppearance.backgroundColor = UIColor.blue
                naviBar.scrollEdgeAppearance?.configureWithOpaqueBackground()
            } else {
                print("不是iOS 13.0版本")
            }
        case 5:
            print("     (@@ 5、默认的standardAppearance")
            if #available(iOS 13.0, *) {
                guard let naviBar = self.navigationController?.navigationBar else{ return}
                naviBar.standardAppearance.configureWithDefaultBackground()
                print("默认的standardAppearance：\(naviBar.standardAppearance)")
                naviBar.scrollEdgeAppearance?.backgroundColor = UIColor.yellow
                naviBar.standardAppearance.backgroundColor = UIColor.blue
            }
        case 6:
            print("     (@@ 6、不透明的standardAppearance")
            if #available(iOS 13.0, *) {
                guard let naviBar = self.navigationController?.navigationBar else{ return}
                self.navigationController?.navigationBar.standardAppearance.configureWithOpaqueBackground()
                print("不透明的standardAppearance：\(naviBar.standardAppearance)")
            }
        case 7:
            print("     (@@")
            let VC = UIViewController()
            VC.title = "测试"
            VC.view.backgroundColor = .red
            self.navigationController?.pushViewController(VC, animated: true)
        case 8:
            print("     (@@打印standardAppearance")
            if #available(iOS 13.0, *) {
                guard let naviBar = self.navigationController?.navigationBar else{ return}
                print("打印standardAppearance：\(naviBar.standardAppearance)\n\n")
                print("打印scrollEdgeAppearance：\(String(describing: naviBar.scrollEdgeAppearance))\n\n")
            }
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
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:300, width:UIScreen.main.bounds.size.width,height:200),
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
            make.bottom.equalToSuperview().offset(-40)
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
