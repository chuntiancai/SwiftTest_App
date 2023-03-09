//
//  手势识别器间的交互_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/18.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试手势识别器的的VC
// MARK: - 笔记
/**
    1、一个view可以绑定多个UIGestureRecognizer，识别的顺序是后添加先识别，如果要确定识别器之间的顺序，可以调用识别器的require(toFail:)方法。
        注意：识别器之间的依赖关系，仅存于父子关系中，如果两个识别器是两个同层次的子View，那么不会产生依赖关系，因为在各自的子view中就已经处理了识别过程。
             当是父子关系的时候，子view的手势识别需要经过父view的touchBegan方法之后才生效，所以就可以产生依赖关系，内部处理好了的。
             依赖关系也可以是一个view里面的多个手势识别器之间。
 
    2、手势识别器之间的关系：
       require(toFail:)方法是建立两个识别器之间的关系，意思是 “调用者识别器 等 参数识别器 失败之后再起作用”。
 
       shouldRequireFailure(of: )是用来被子类复写的，意思是： “互斥时，调用者识别器的类 可以被 参数识别器的类 的状态置为 失败”。
       shouldBeRequiredToFail(by: )是用来被子类复写的，意思是： ”调用者识别器的类 可以把 参数识别器的类 的状态置为 失败“。
       这就是类级别的失败要求(a class-wide failure requirement)。
 
       代理协议(UIGestureRecognizerDelegate)管理手势识别器之间的关系：
 
            协议方法：gestureRecognizerShouldBegin(_: ) 返回false的话，把当前识别器的状态置为fail。
 
            协议方法：gestureRecognizer(_:shouldRequireFailureOf:) 当前识别器是否应该把别的识别器置为失败状态。
                    该方法在当前识别器每次尝试识别手势的时候就被调用。
 
            协议方法：gestureRecognizer(_:shouldRequireFailureOf:) 当前识别器是否应该被别的识别器置为失败状态。
                    该方法在当前识别器每次尝试识别手势的时候就被调用。
 
    3、UIGestureRecognizerDelegate的方法是用于处理 手势还没开始识别前，让哪个识别器生效。
       如果是要识别了之后再让识别器失效，或者暂时失效，则可以通过判断gesture的translation来获取位移坐标，然后设置gesture的状态为failed来使当前识别器无效。
 
 */

class TestGestureInteract_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    private let bgView = UIView()
    private var redScrollView = UIScrollView()  //红色的ScrollView，包含了绿色的ScrollView
    private var blueScrollView = UIScrollView()
    let redView : TestGesture_View = {
        let view = TestGesture_View()
        view.backgroundColor = .red.withAlphaComponent(0.7)
        return view
    }()
    let blueView : TestGesture_View = {
        let view = TestGesture_View()
        view.backgroundColor = .blue.withAlphaComponent(0.7)
        return view
    }()
    
    
    //MARK: 测试组件
    var gesture1:UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.name = "gesture1"
        return gesture
    }()
    
    var gesture2:UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.name = "gesture2"
        return gesture
    }()
    var isRelation:Bool = false //识别器之间是否产生依赖关系
    
    var curTouch: UITouch?  //当前识别的touch事件。
    var curEvent:UIEvent?   //当前的事件容器。
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试手势识别器间的交互VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("这是TestGestureInteract_VC的touchesBegan方法～")
        
    }
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestGestureInteract_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试手势之间的依赖关系
            /**
                1、手势识别器通过require(toFail:)建立起依赖关系，调用者依赖于参数识别器的失败状态。
                    参数识别器通过ShouldBegin代理方法(返回false)，设置自己的状态为fail。
                    识别器之间的view必须是父子关系，或者同一个view。兄弟关系无法产生依赖，因为还没经过同一个中枢时，兄弟view各自就已经把识别过程消耗掉了。
             
                2、只有两个识别器在识别同一个手势的时候，才会产生关系，如果不是在识别同一个手势，那就没有依赖的必要。
             */
            print("     (@@  0、测试手势识别器的状态")
            let _ = bgView.subviews.map { $0.removeFromSuperview()}
            
            //蓝色view
            blueView.isUserInteractionEnabled = true
            blueView.frame = CGRect(x: 20, y: 20, width: 320, height: 400)
            gesture2.addTarget(self, action: #selector(gesAction2(_:)))
            gesture2.delegate = self
            blueView.addGestureRecognizer(gesture2)
            
            //红色view
            redView.isUserInteractionEnabled = true
            redView.frame = CGRect(x: 20, y: 20, width: 280, height: 200)
            gesture1.addTarget(self, action: #selector(gesAction1(_:)))
            gesture1.delegate = self
            redView.addGestureRecognizer(gesture1)
            
            bgView.addSubview(blueView)
            blueView.addSubview(redView)
            
            
        case 1:
            //TODO: 1、控制依赖关系
            print("     (@@ 1、控制依赖关系：\(isRelation) ")
            //gesture1依赖于gesture2的失败状态。
            gesture1.require(toFail: gesture2)
            isRelation = !isRelation
            print("设置之后：\(isRelation)")
        case 2:
            //TODO: 2、测试父view识别器与子scrollView的panGestureRecognizer的系。
            print("     (@@ 2、测试父view识别器与子scrollView的panGestureRecognizer的系。")
            self.view.addGestureRecognizer(gesture1)
            gesture1.delegate = self
            gesture1.addTarget(self, action: #selector(gesAction1(_:)))
            
        case 3:
            //TODO: 3、测试去掉识别器之间的依赖关系
            print("     (@@ 3、测试去掉识别器之间的依赖关系")
            gesture1.require(toFail: UITapGestureRecognizer())
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
            //TODO: 10、打印识别器信息
            print("     (@@ 10、打印识别器信息")
            print("gesture1是：\(gesture1)\n")
            print("gesture2是：\(gesture2)\n")
        case 11:
            print("     (@@")
        case 12:
            print("     (@@")
        default:
            break
        }
    }
    
}
//MARK: - 动作方法
@objc extension TestGestureInteract_VC{
   
    //MARK: 0、gesture1的动作方法
    func gesAction1(_ sender: UIPanGestureRecognizer){
        print("gesture1的动作方法：\(#function)")
//        sender.ignore(curTouch!, for: <#T##UIEvent#>)
        let point = sender.translation(in: sender.view)
        print("gesture1 的 \(point) 移动点 --\(sender.state.rawValue)")
        
    }
    
    //MARK: 1、gesture2的动作方法
    func gesAction2(_ sender: UIPanGestureRecognizer){
        print("gesture2的动作方法：\(#function)")
        let point = sender.translation(in: sender.view)
        print("gesture2 的 \(point) 移动点 --\(sender.state.rawValue)")
        sender.state = .failed
    }
    
}


//MARK: - 设置测试的UI
extension TestGestureInteract_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        redScrollView.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        redScrollView.contentSize = CGSize.init(width: 350, height: 1200)
        redScrollView.showsVerticalScrollIndicator = true
        redScrollView.bounces = false
        redScrollView.delegate = self
        bgView.addSubview(redScrollView)
        redScrollView.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.width.equalTo(350)
            make.centerX.equalToSuperview()
            make.height.equalTo(480)
        }
        
        let rLabel = UILabel()
        rLabel.textColor = .white
        rLabel.text = "红色的顶部"
        rLabel.font = .systemFont(ofSize: 32)
        redScrollView.addSubview(rLabel)
        rLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        let rLabel2 = UILabel()
        rLabel2.textColor = .white
        rLabel2.text = "红色的底部"
        rLabel2.font = .systemFont(ofSize: 32)
        redScrollView.addSubview(rLabel2)
        rLabel2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(1150)
        }
        
        blueScrollView.backgroundColor = .blue.withAlphaComponent(0.8)
        blueScrollView.bounces = true
        blueScrollView.tag = 1234
//        blueScrollView.panGestureRecognizer.require(toFail: redScrollView.panGestureRecognizer)
        blueScrollView.delegate = self
        blueScrollView.contentSize = CGSize.init(width: 280, height: 800)
        blueScrollView.showsVerticalScrollIndicator = true
        redScrollView.addSubview(blueScrollView)
        blueScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.width.equalTo(280)
            make.centerX.equalToSuperview()
            make.height.equalTo(350)
        }
        
        let bLabel = UILabel()
        bLabel.textColor = .white
        bLabel.text = "蓝色的顶部"
        bLabel.font = .systemFont(ofSize: 30)
        blueScrollView.addSubview(bLabel)
        bLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        let bLabel2 = UILabel()
        bLabel2.textColor = .white
        bLabel2.text = "蓝色的底部"
        bLabel2.font = .systemFont(ofSize: 30)
        blueScrollView.addSubview(bLabel2)
        bLabel2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(750)
        }
    }
    
}

//MARK: - 遵循UIGestureRecognizerDelegate协议，手势识别。
extension TestGestureInteract_VC:UIGestureRecognizerDelegate {
    
    
    // 是否允许手势识别器接收 触摸事件。控制Gesture是否接受touch
    /**
        1、如果允许，接下来才会调用gestureRecognizerShouldBegin方法，否则不识别。控制当前view接不接受touch的场合使用的。
        2、所以你可以在这里控制gesture1返回true，gesture2返回false，从而控制控制器的识别。
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
        print("TestGestureInteract_VC 的 \(#function) touch 方法 -- \(gestureRecognizer.name ?? "") -- \(gestureRecognizer.classForCoder)")
        print("touch的类型：\(touch.type.rawValue) -- touch的当前坐标：\(touch.location(in: touch.view)) -- touch的上一个坐标：\(touch.previousLocation(in: touch.view))")
        return true
    }
    
    // 当前识别器是否应该开始识别。如果返回false，则当前控制器的状态被置为false，刚好其他的识别器依赖于当前识别器失败状态的，就可以开始识别了。
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("TestGestureInteract_VC 的 \(#function) 方法")
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            let pan = gestureRecognizer as! UIPanGestureRecognizer
            let point = pan.translation(in: pan.view)
            print("gestureRecognizerShouldBegin 的 \(point) 移动点 --\(pan.state)")
        }
        
        if  gestureRecognizer == gesture1 {
            print("当前识别器是gesture1")
        }
        if  gestureRecognizer == gesture2 {
            print("当前识别器是gesture2")
            if isRelation {
                print("gesture2 的 ShouldBegin 返回false，状态变为fail")
//                return false
            }
        }
        return true
    }
    
    /// 是否支持多个手势识别器起作用。控制Gesture是否可以同时识别
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        print("TestGestureInteract_VC 的 \(#function) 方法--\(gestureRecognizer.name ?? "") --其他识别器：\(otherGestureRecognizer.name ?? "系统的识别器")\n")
        return true
    }
    
    // 当view有多个识别器时，互斥时。是否被别的手势识别器置失败状态。是否依赖于别人
    /**
     1、这个方法返回YES，第一个手势和第二个互斥时，第一个会失效。
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        print("TestGestureInteract_VC 的 \(#function) 方法 --\(gestureRecognizer.name ?? "") --其他识别器：\(otherGestureRecognizer.name ?? "系统的识别器")\n")
        return false
    }
    
    // 当view有多个识别器时，是否被把的手势识别器置失败状态。是否被别人依赖。
    /**
     1、这个方法返回YES，第一个和第二个互斥时，第二个会失效。
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        print("TestGestureInteract_VC 的 \(#function) 方法 --\(gestureRecognizer.name ?? "") --其他识别器：\(otherGestureRecognizer.name ?? "系统的识别器")\n")
        return false
    }
    
    
    
    // 控制Gesture是否接受press
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool{
        print("TestGestureInteract_VC 的 \(#function) press 方法 -- \(gestureRecognizer.classForCoder)\(String(format: "%p", gestureRecognizer))")
        return true
    }
    
    // 控制Gesture是否接受event
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool{
        print("TestGestureInteract_VC 的 \(#function) event 方法 -- \(gestureRecognizer.classForCoder)\(String(format: "%p", gestureRecognizer))")
        return true
    }
    
    
}

//MARK: - 遵循UIScrollViewDelegate协议
extension TestGestureInteract_VC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //TODO: 2、测试父子scrollView的panGestureRecognizer的依赖关系。
        if scrollView == redScrollView {
            if redScrollView.contentOffset.y > 30 {
//                redScrollView.panGestureRecognizer.state = .failed
                return
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
}


//MARK: - 设计UI
extension TestGestureInteract_VC {
    
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
extension TestGestureInteract_VC: UICollectionViewDelegate {
    
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



