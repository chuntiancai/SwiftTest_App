//
//  TestTouchDeliver_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/28.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试View的触摸事件传递的VC，点击事件的传递
/**
    1、UIEvent是容器类，用于封装各种事件的容器，例如可能有touch事件、motion事件、remote-control事件、press事件等。
        随着你手指的滑动，UITouch会不断地更新自身的属性信息，譬如坐标x，y的值等。
        iOS中只有继承了UIResponder的类才能够接收并处理时间，其他类不可以。
 
    2、手势识别器接收事件的优先级高于view自身的手势识别。手势识别器会调用view自身的touchesCancelled方法，取消view来响应手势。
 
    3、有两条链：事件的寻找链 与 事件的响应链。
 
    4、一个手指对应一个UITouch对象。UITouch对象用于保存手指的相关信息，当手指移动时，系统会更新同一个UITouch对象，使该UITouch对象始终对应着该手指的触摸信息。
        UITouch对象包含的信息有：位置、事件、阶段。。。
        当手指离开屏幕时，系统会销毁对应的UITouch对象。
        UITouch的属性：touch所在的window、view、tapCount(点击次数)、timestamp(产生时间或更新时间)
        UITouch的方法：location(in view: UIView?)当前触摸的点位置，previousLocation(in view: UIView?)上一个触摸的点的位置。
 
    5、默认情况下，UIView的touchesBegan、touchesMoved等方法中的touches参数只有一个元素，除非你设置了UIview的isMultipleTouchEnabled为true。
 
    6、事件的拦截与转发：
        1.view拦截事件在自身，则在hitTest方法和point(inside:_)方法中返回自身，如果不想处理事件，则返回nil。
            拦截，不再往下分发事件，重写 touchesBegan 进行事件处理，不调用父类的 touchesBegan。
            拦截，继续往下分发事件，重写 touchesBegan 进行事件处理，同时调用父类的 touchesBegan 将事件往下传递；
        2.如果想把事件传递给别人，则调用别人的touchBegan方法。
            在自己的touchesBegan方法中直接调用下一个响应者的self.next?.touchesBegan(touches, with: event)。不再调用super.touchesBegan方法。
 
 */

class TestTouchDeliver_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "测试View的触摸事件传递的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        setTestViewUI() //设置测试的view
    }
    
    /// 触摸事件开始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TestTouchDeliver_VC 的 \(#function) 方法")
        super.touchesBegan(touches, with: event)
    }
    /// 触摸事件移动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TestTouchDeliver_VC 的 \(#function) 方法")
        super.touchesMoved(touches, with: event)
    }
    /// 触摸事件结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TestTouchDeliver_VC 的 \(#function) 方法")
        super.touchesEnded(touches, with: event)
    }
    /// 触摸事件取消
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TestTouchDeliver_VC 的 \(#function) 方法")
        super.touchesCancelled(touches, with: event)
    }
    
    /// 这些是加速事件的代理方法，比较少用
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("TestTouchDeliver_VC 的 \(#function) 方法")
        super.motionBegan(motion, with: event)
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestTouchDeliver_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            break
        case 1:
            print("     (@@")
        case 2:
            print("     (@@")
        case 3:
            print("     (@@")
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
    
    /// 设置测试的UI
    private func setTestViewUI(){
        
        let rView = TouchDeliver_View()
        rView.backgroundColor = .red
        self.view.addSubview(rView)
        rView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        
        let rsubView = TouchDeliver_SubView()
        rsubView.backgroundColor = .blue
        rsubView.tag = 1213
        rView.addSubview(rsubView)
        rsubView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(80)
        }
        
        let btnBgView = TouchDeliver_BtnBgView()
        btnBgView.backgroundColor = .magenta
        self.view.addSubview(btnBgView)
        btnBgView.snp.makeConstraints { make in
            make.top.equalTo(rView.snp.bottom).offset(10)
            make.left.equalTo(rView.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        
        let recBtn1 = TouchDeliver_Btn()
        recBtn1.tag = 1001
        recBtn1.setTitle("这是按钮1", for: .normal)
        recBtn1.backgroundColor = .darkGray
        recBtn1.addTarget(self, action: #selector(btn1Action(sender:)), for: .touchUpInside)
        btnBgView.addSubview(recBtn1)
        recBtn1.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(120)
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
        }
        
        let recBtn2 = TouchDeliver_Btn2()
        recBtn2.tag = 1002
        recBtn2.setTitle("这是按钮2", for: .normal)
        recBtn2.addTarget(self, action: #selector(btn2Action(sender:)), for: .touchUpInside)
        btnBgView.addSubview(recBtn2)
        recBtn2.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(120)
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-5)
        }
    }
    
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
    
}


//MARK: - 设计UI
extension TestTouchDeliver_VC {
    
    
    
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
//        layout.headerReferenceSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: 130)
        layout.itemSize = CGSize.init(width: 80, height: 40)
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:200),
                                             collectionViewLayout: layout)
        
        baseCollView.backgroundColor = UIColor.cyan
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
        baseCollView.delegate = self
        baseCollView.dataSource = self
        // register cell
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
    
    
    
}
//MARK: - 工具方法
extension TestTouchDeliver_VC{
    
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
//MARK: - 动作方法
@objc extension TestTouchDeliver_VC{
    
    func btn1Action(sender:UIButton) {
        print("按钮1 的动作方法")
    }
    
    func btn2Action(sender:UIButton) {
        print("按钮2 的动作方法")
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestTouchDeliver_VC: UICollectionViewDelegate {
    
}

