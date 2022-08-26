//
//  测试UIView的VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/24.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试UIView的VC
// MARK: - 笔记
/**
    1、UIAppearance协议主要是用来返回类型本身，也就是相当于获取UIView的元类型，但是UIAppearance协议还提供了获取某类型View视图下的所有子View的方法，因为操作的是类，所以这种一般用于全局设置。这种是对一类对象的默认全局外观样式设置，它对设置时机有要求。通常需要在UIWindow的viewlayout之前。错过了时机后，设置是没有效果的。
    所以可以用来设置UINavigationBar这种影响全局的UI组件。
 
    2、 UIScreen, UIWindow, UIViewController, UIPresentationController, UIView都遵循了UITraitEnvironment协议，而该协议的传递值的方式 就是通过它们的traitCollection属性来进行。UITraitCollection主要是描述了当前的UI环境，设备类型，紧凑型还是宽松型布局(长就是宽松，短就是紧凑)、布局方向、对比度这些。
 
    3、view的tintColor属性是描述线条轮廓的一种颜色,该颜色默认具有传递性,默认状态下最底部的视图的tintcolor会一直往上面的视图传递(父传子)。描述镂空里面的线条颜色。
 
    4、addSubview方法，首先去判断子view原来有没有父view，如果有，则把原来的父view移除，然后添加到当前view中。
 
    5、viewWithTag递归向下查找，包括自身，自身默认是0。
 */


class TestUIView_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    let redView = UIView()
    var changeY:CGFloat = 0;
    let maskView = UIView()  //测试UIView的mask属性
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试UIView的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestUIView_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试UIView的appearance协议(方法)。
            /**
                1、UIAppearance协议主要是用来返回类型本身，也就是相当于获取UIView的元类型，是一种影响元类型的全局设置。
             */
            print("     (@@  ")
            let curLabel = UILabel.appearance(for: UITraitCollection(layoutDirection: .leftToRight),
                                              whenContainedInInstancesOf: [type(of: UIView()),type(of: UIButton())])
            print("根据appearance获取到的label：\(curLabel)")
            print("当前VC的UI环境特征：\(self.traitCollection)")
            
            break
        case 1:
            //TODO: 1、测试UIView的内边距，也就是安全区域，安全边距
            /**
                1、safeAreaLayoutGuide用于获取自动布局约束的布局对象，内边距对象是UIView的safeAreaInsets属性，UIView的子view的布局是参考内边距对象的。
                   layoutGuide作为UI对象，只有添加到view中，即owningView不为nil，才能参与auto layout生成constraint。
                   layoutGuide作为UI对象与其它UI对象(layoutGuide或view)生成constraint时，在search closest common ancestor过程中，layoutGuide 参考view为其owningView。
                   layoutMarginsGuide是view自身固有layoutGuide，layoutMarginsGuide.layoutFrame与view.frame各边缘距离依赖view.layoutMargins。
             
                2、常规下，子view的布局都是参考父view的内边距开始布局的，但是受到导航栏，导航控制器，VC，tableview，scorllview一些隐含属性影响，也就变得不那么常规了，这些控件的属性会影响到内边距的布局是否有有效，是否修改了内边距等等。
                
                3、内边距只有当View已经添加到视图层的时候才是准确有效的，如果还没添加到视图层，则是不准确的。所以可以再view将要appear的时候再调整safeAreaInsets。VC的内边距是痛过additionalSafeAreaInsets属性来调整的，从而影响到VC的view的safeAreaInsets。
                
             */
            print("     (@@ 测试UIView的安全内边距")
            let layoutGuide = self.view.safeAreaLayoutGuide
            print("vc 的 view 是：  \(view!)")
            print("vc 的 view 的safeAreaLayoutGuide是：  \(layoutGuide)")
            print("vc 的 view 的safeAreaInsets是：  \(view.safeAreaInsets)")
        case 2:
            //TODO: 2、测试UIView的属性
            print("     (@@ 2、测试UIView的属性")
            let _ = self.bgView.subviews.map { $0.removeFromSuperview() }
            redView.backgroundColor = .red
            redView.layer.borderWidth = 5.0
            redView.layer.borderColor = UIColor.brown.cgColor
            
            self.view.addSubview(redView)
            redView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(200)
            }
            
        case 3:
            //TODO: 3、测试mask属性。
            /**
             1、mask属性的使用是，定义了宿主对象的可显示的内容，mask属性就是宿主view的不透明通道，也就是mask view中的不透明颜色的内容就是 宿主对象的可显示的内容轮廓。
              mask view 中的透明颜色就是遮挡宿主对象的显示内容，注意，mask view的布局是相对于宿主的坐标系，而不是mask view的父view，mask的父view是无效的。
              mask view不要使用snpkit，不然不知道具体尺寸在什么时候算出来，比较麻烦，虽然是在layoutsubview方法中算出来，但是取出来就比较麻烦。
             */
            print("     (@@ 3、测试mask属性。")
            if redView.mask == nil {
                maskView.frame = CGRect(x: 0, y: 0, width: redView.bounds.width, height: redView.bounds.height)
                maskView.backgroundColor = .blue
                redView.mask = maskView
            }
            print("mask view 的frame：\(maskView.frame) --bounds:\(maskView.bounds)")
            if maskView.bounds.height <= 0 {
               changeY = 10
            }
            if maskView.bounds.height >= redView.bounds.height{
               changeY = -10
            }
            let curHeight = maskView.bounds.height + changeY
            maskView.frame = CGRect(x: 0, y:redView.bounds.height - curHeight , width: redView.bounds.width, height: curHeight)
            
        case 4:
            //TODO: 4、
            print("     (@@ 4")
            
            
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
extension TestUIView_VC{
   
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
extension TestUIView_VC{
    
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
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
}


//MARK: - 设计UI
extension TestUIView_VC {
    
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
        baseCollView.snp.makeConstraints { make in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(200)
        }
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestUIView_VC: UICollectionViewDelegate {
    
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


