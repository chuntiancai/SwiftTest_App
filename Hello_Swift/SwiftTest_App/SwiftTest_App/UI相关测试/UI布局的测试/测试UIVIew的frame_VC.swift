//
//  测试UIVIew的frame_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/7/13.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试UIView的frame和bounds

import UIKit

// MARK: - 笔记
/**
    1、layer的position属性是参考父view坐标系的，绑定了Layer里的某一个点。设置position属性，就是把layer的这个点，移动到父view中position的值的位置。
       position是Layer中的一个点，这个点就是由Layer的anchorPoint属性决定的，也是锚点，它的丈量是0～1，也就是按比例来计算定位Layer中的点。
       anchorPoint是参考Layer自身坐标系的，但是是按照0～1的比例来丈量，不是精确到坐标系的每一点来丈量。anchorPoint默认值是(0.5,0.5)。
 
 */

class TestUIViewFrame_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    lazy var superView:UIView = {   /// 作为被测试的父view
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.0
        return view
    }()
    
    lazy var subView:UIView = {  /// 作为被测试的子view
        let view = UIView()
        view.backgroundColor = .magenta
        view.layer.borderColor = UIColor.brown.cgColor
        view.layer.borderWidth = 1.0
        return view
    }()
    lazy var redView:UIView = {
        let view = UIView()
        view.backgroundColor = .red.withAlphaComponent(0.6)
        return view
    }()
    lazy var yellowView:UIView = {
        let view = UIView()
        view.backgroundColor = .yellow.withAlphaComponent(0.8)
        return view
    }()
    
    lazy var boundsView : TestBounds_View = {
        let curView = TestBounds_View()
        curView.layer.borderWidth = 2.0
        curView.layer.borderColor = UIColor.brown.cgColor
        self.view.addSubview(curView)
        curView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(80)
        }
        return curView
    }()
    
    
    //MARK: 标志器
    var xAxis:CGFloat = 0.0
    var yAxis:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试UIVIew的frame_VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestUIViewFrame_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试layer的position属性。
            /**
             1、layer的position属性是参考父view坐标系的，绑定了Layer里的某一个点。设置position属性，就是把layer的这个点，移动到父view中position的值的位置。
             2、上面1说的position是Layer中的一个点，这个点就是由Layer的anchorPoint属性决定的，也是锚点，它的丈量是0～1，也就是按比例来计算定位Layer中的点。
                anchorPoint是参考Layer自身坐标系的，但是是按照0～1的比例来丈量，不是精确到坐标系的每一点来丈量。anchorPoint默认值是(0.5,0.5)。
             
             
             */
            print("     (@@ 0、测试layer的position属性。")
            xAxis = xAxis > 200 ? 0 : xAxis + 10
            subView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            subView.layer.position = CGPoint(x: 10 + xAxis, y: 10)
            
            
        case 1:
            //TODO: 1、测试view的center属性。
            /**
             1、子view还没添加到父view的时候，子view的frame都是.zero。
             2、frame的扩展是从左上角到右下角的延伸，bounds是从中心向四周延伸，而center是子view的中心点在父view中的位置，是view层。而position是子layer在父layer中的位置，是layer层。
             3、frame延伸之后，center也会延伸，因为center是根据frame计算出来的。
             */
            print("     (@@ 1、测试view的center属性。")
            redView.center = self.view.center
            redView.frame.size = CGSize(width: 160, height: 80) /// 右下角延伸,同时redViewd的center也会延伸。
            self.view.addSubview(redView)
            
            yellowView.center = self.view.center
            yellowView.bounds.size = CGSize(width: 160, height: 80) /// 四周延伸
            self.view.addSubview(yellowView)
            
            print("self.view.bounds:\(self.view.bounds) --------redView.center:\(redView.center) ---- yellowView.center:\(yellowView.center)")
        case 2:
            
            //TODO: 2、测试view的frame、bounds属性。
            /**
             1、view的frame参考的是父view的坐标系，就是在父view中的位置和大小是多少。view的bounds是描述自己的坐标系，就是自己的坐标系有多大，是什么，是给子view参考用的。
                frame描述的是 view的可视范围 在父view坐标系中的位置和大小。
             2、bounds描述的是，view的可视范围在自身坐标系中的位置和大小，默认情况下和frame是重叠的，但是自身的坐标系是参考bounds的，所以原点默认从(0,0)开始。
                注意：view的自身坐标系也是无限大的，只是约束了坐标系的原点在哪里而已。
                     bounds的改变是指，可视范围原地不动，整个坐标系变动，因为自身坐标系是参考bounds的。
                     bounds的改变并不会带动当前view的背景颜色改变，但是可以带动内容的位置变动(就是子view)，因为子view是参考bounds的坐标体系进行布局的。
             
                相对性:可视范围相对于父控件位置永远不变。
                      可视范围相对于内容,位置改变。
             
             */
            print("     (@@ 2、测试view的frame属性。")
            superView.bounds.origin.y = superView.bounds.origin.y > 200 ? 0 : superView.bounds.origin.y + 10
            print("superView的bounds：\(superView.bounds)")
            
        case 3:
            
            //TODO: 3、测试view的bounds属性。
            /**
                1、如果有snpkit布局，改变frame无效。则只能通过ayer.bounds来改变位置和大小，layer.bounds.size也是有效。
                    可以通过移除snp.removeConstraints()约束来使得frame的改变有效。
                
             */
            print("     (@@ 3、测试view的bounds属性。")
            self.boundsView.isChangeBoundsSize = true
            
        case 4:
            print("     (@@")
            self.boundsView.setBoundSize()
            self.view.layoutIfNeeded()
        case 5:
            //TODO: 5、测试改变bounds
            print("     (@@ 5、测试改变bounds" )
            superView.layer.bounds.size = CGSize(width: 300, height: 150)
//            superView.snp.removeConstraints()
//            superView.frame = CGRect.init(x: 10, y: 400, width: 180, height: 180)
//            superView.center = CGPoint.init(x: 200, y: 600)
//            redView.frame = CGRect.init(x: 10, y: 450, width: 200, height: 200)
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
extension TestUIViewFrame_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestUIViewFrame_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        self.view.addSubview(superView)
        superView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp_bottom).offset(30)
            make.width.equalTo(150)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        superView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        
    }
    
}


//MARK: - 设计UI
extension TestUIViewFrame_VC {
    
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
extension TestUIViewFrame_VC: UICollectionViewDelegate {
    
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

