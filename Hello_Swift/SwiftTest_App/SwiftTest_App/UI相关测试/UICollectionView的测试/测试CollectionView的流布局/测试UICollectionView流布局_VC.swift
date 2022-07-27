//
//  测试UICollectionView流布局的VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/30.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//  测试UICollectionView流布局的VC.swift
// MARK: - 笔记
/**
    1、初始化UICollectionView时，就需要在初始化参数中传入layout对象。
    2、cell必须注册，然后代理方法中才会根据id创建，不能在代理方法中自己新建cell对象。
    3、cell必须自定义，系统的cell没有任何子控件。
 
    4、UICollectionView的各个组件之间的关系：
        UICollectionView 是一个view，主要是显示在手机上。
 
        UICollectionViewDataSource 是数据源协议，你在这个协议的方法里告诉UIKit你的UICollectionView内容有多少，多少个item、header之类的。
        
        UICollectionViewDelegate 是一个行为代理协议，UICollectionView发生的行为都是UIKit通过该协议告知你，然后你为这些行为提供内容。
 
        UICollectionViewFlowLayout 是一个流对象，你在该对象的方法和属性里，告诉UIKit你UICollectionView的内容打算怎么布局，尺寸大小的设置和变化等。
 
        UICollectionViewDelegateFlowLayout 是额外的行为协议，用于补充说明section的尺寸行为这些。
 
 */

import UIKit

class TestUICollectionViewLayout_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试的组件
    private var flowCollView:UICollectionView!  //测试流布局的collection view
    private var collViewDelegate=TestFlowCollViewDelegate()  //作为collection view的delegate
    private var collViewDataSource=TestCollViewDataSource() //作为collection view的DataSource
    
    /// 流布局对象
    private let flowLayout:TestUICollectionViewFlowLayout = {   // lazy var 是使用之后才会执行，直接var(或let)代码块，则是在初始化的时候就执行，都是只执行一次。
        let layout = TestUICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 60) ///item的尺寸，默认是(50,50)
        layout.minimumLineSpacing = 20    /// item 上下之间的 横间距（一排item之间）
        layout.minimumInteritemSpacing = 10   /// item 左右之间的 竖间距 (item相互之间)
        layout.scrollDirection = .horizontal    /// 流水布局的方向，水平方向是 从左到右 布局，item的坐标是从上到下，从左到右。但是会被contentSize限制。
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)  //每个section的内边距，优先级比代理设置的优先级低。
         return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试UICollectionView流布局的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestUICollectionViewLayout_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试流布局
            /**
                1、UICollectionView在初始化的时候就要传入流布局对象。
                2、UICollectionView的cell必须要先注册才能使用。
                3、如果collection view的delegate对象有遵循UICollectionViewDelegateFlowLayout协议，那么Collection View就会从该协议的实现方法中获取和更新UI布局。
                    如果CollectionView的delegate对象没有遵循UICollectionViewDelegateFlowLayout协议，那么CollectionView就可以初始化时传入UICollectionViewFlowLayout对象，
                    然后CollectionView就会从UICollectionViewFlowLayout对象的属性中获取相关的UI尺寸信息，所以你要赋值给UICollectionViewFlowLayout对象的属性。
                
                4、在从UICollectionViewFlowLayout对象中获取布局信息的顺序是：
                    2.1、首先调用prepare()，所以你要重写prepare()方法，在里面设置好UICollectionViewFlowLayout对象的属性， 提供给CollectionView参考。
                    2.2、UICollectionViewFlowLayout对象也会作为UICollectionViewFlowLayout对象的一个内含绑定属性(默认的)。
             */
            print("     (@@  0、测试流布局")
            if flowCollView != nil {
                print("已经初始化flowCollView")
                return
            }
            /// 初始化的时候就要传入 布局对象。
            flowCollView = UICollectionView(frame: CGRect.init(x: 15, y: 215, width: 350, height: 300), collectionViewLayout: flowLayout)
            flowCollView.delegate = collViewDelegate    //行为代理
            flowCollView.dataSource = collViewDataSource    //数据源代理
            flowCollView.contentSize = CGSize.init(width: 400, height: 900)
            flowCollView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            flowCollView.layer.borderWidth = 1.5
            flowCollView.layer.borderColor = UIColor.gray.cgColor
            flowCollView.showsVerticalScrollIndicator = true    //显示y滚动器
            flowCollView.showsHorizontalScrollIndicator = true    //显示x滚动器
            
            /// 必须要注册cell才能使用，这与tableview有所区别
            flowCollView.register(TestFlowCollectionView_Cell.self, forCellWithReuseIdentifier: "FlowCollectionView_Cell_ID")
            
            self.view.addSubview(flowCollView)
        case 1:
            //TODO: 1、
            print("     (@@ \(flowLayout.minimumInteritemSpacing)");
        case 2:
            //TODO: 2、
            print("     (@@ ")
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
extension TestUICollectionViewLayout_VC{
   
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
extension TestUICollectionViewLayout_VC{
    
    /// TODO: 初始化你要测试的view
    func initTestViewUI(){
       
        
    }
    
}


//MARK: - 设计UI
extension TestUICollectionViewLayout_VC {
    
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
extension TestUICollectionViewLayout_VC: UICollectionViewDelegate {
    
    /// 设置有多少个section
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

