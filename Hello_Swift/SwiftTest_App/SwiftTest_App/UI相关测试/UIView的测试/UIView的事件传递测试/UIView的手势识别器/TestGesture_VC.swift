//
//  TestGesture_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试手势识别的VC
// MARK: - 笔记
/**
    1、手势识别器可以插入view的触摸事件，所以你可以不用自定义view，也不用复写view的touchBegan方法，而是给view赋值一个手势识别器就可以了。
        UIGestureRecognizer是一个基类，需要你自定义具体类来实现你的需求，但是你也可以使用系统提供的一些UIGestureRecognizer的具体类，例如平移，捏合这些手势。
        UIGestureRecognizer的触摸事件 会插入 在 UIview的touchesBegan(_:with:) 方法 和 touchesCancelled(_:with:) 方法 之间。
 
    2、UIview的gestureRecognizers是一个数组，用于管理当前view绑定的每一个手势识别器。
 
    3、UIGestureRecognizer也有代理协议，可以通过代理协议来管理UIGestureRecognizer的手势识别事件。
 
    4、平移手势识别器的平移点，是相对于最开始时刻的总偏移量，不是每段的偏移量，所以需要重置偏移值，因为transform有个方法是计算每段平移累加的。
 
    5、捏合手势识别器的缩放倍数，也是相对于最开始点击时刻的总放大倍数,不是每段的放大倍数，和平移手势类似，所以需要重置倍数，因为transform有个方法是每段倍数累加的。
 
    6、如果要支持多个手势识别器，那么必须实现代理方法来判断识别器，然后在代理方法中判断让哪个识别器起作用。
 
 */

class TestGesture_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    var gestureView:TestGesture_View = TestGesture_View()
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试手势识别的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestGesture_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试 UIView的 点击手势 识别器。
            print("     (@@  添加 点击手势 识别器。")
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
            tapGesture.delegate = self
            gestureView.addGestureRecognizer(tapGesture)
            break
        case 1:
            //TODO: 1、测试 UIView的 长按手势 识别器。
            /**
                1、当长按并且移动手指时，长按识别器的动作方法，会一直被调用。 即便view的touchesCancelled(_:with:)执行后，如果手指移动Aciton方法也会一直被执行。
                2、所以你可以判断手势识别器的状态，来实现对应的需求。
             */
            print("     (@@ 添加 长按手势 识别器")
            let longGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longTapAction(_:)))
            longGesture.delegate = self
            gestureView.addGestureRecognizer(longGesture)
        case 2:
            //TODO: 2、测试 UIView的 轻扫手势 识别器。
            print("     (@@ 添加 轻扫手势 识别器。")
            /**
                1、就是轻轻扫动一些view的手势。
                2、默认是往右轻扫，你可以修改 识别器的direction属性，从而改变轻扫的方向。
             */
            let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeAction(_:)))
            swipeGesture.delegate = self
            swipeGesture.direction = [.down,.up]
            gestureView.addGestureRecognizer(swipeGesture)
            
        case 3:
            //TODO: 3、测试 拖动 手势识别器。
            print("     (@@ 测试 拖动 手势识别器。")
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
            gestureView.addGestureRecognizer(panGesture)
        case 4:
            //TODO: 4、测试 捏合 手势识别器。
            print("     (@@ 测试 捏合 手势识别器")
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
            gestureView.addGestureRecognizer(pinch)
        case 5:
            //TODO: 5、测试 旋转 手势识别器。
            print("     (@@ 测试 旋转 手势识别器")
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotateAction(_:)))
            gestureView.addGestureRecognizer(rotate)
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
@objc extension TestGesture_VC{
   
    /// 点击手势的动作方法
    func tapAction(_ sender:UIGestureRecognizer){
        print("点击手势识别器 的 \(#function) 方法")
    }
    
    /// 长按手势的动作方法
    func longTapAction(_ sender:UIGestureRecognizer){
        /**
         public enum State : Int {
             case possible = 0

             case began = 1

             case changed = 2

             case ended = 3

             case cancelled = 4

             case failed = 5

             public static var recognized: UIGestureRecognizer.State { get }
         }
         */
        print("长按手势识别器 的 \(#function) 方法 --- 状态：\(sender.state.rawValue)")
        
    }
    
    /// 轻轻扫动手势 的动作方法
    func swipeAction(_ sender:UISwipeGestureRecognizer){
        print("轻轻扫动手势 的 \(#function) 方法 --- 状态：\(sender.direction)")
    }
    
    /// 拖动手势 识别器的动作方法
    func panAction(_ sender:UIPanGestureRecognizer){
//        print("拖动手势识别器 的 \(#function) 方法 --- 状态：\(sender.state.rawValue)")
        /// 获取平移的点，是相对于开始时刻的总平移量的值，至少有两个时刻才有平移可言，一直平移，就一直相对于最开始时刻点下的点。
        let point = sender.translation(in: self.gestureView)
        print("拖动手势识别器 的 \(point) 移动点")
        /// 移动view，这个是累加
        self.gestureView.transform = self.gestureView.transform.translatedBy(x: point.x, y: point.y)
        sender.setTranslation(.zero, in: self.gestureView)///设置手势识别器的平移点相对于开始时刻是零。
    }
    
    /// 捏合手势 识别器的动作方法
    func pinchAction(_ sender:UIPinchGestureRecognizer){
        print("捏合手势识别器 的 \(#function) 方法 ")
        print("缩放倍数：\(sender.scale)")
        self.gestureView.transform = self.gestureView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
    
    /// 旋转手势 识别器的动作方法
    func rotateAction(_ sender:UIRotationGestureRecognizer){
        print("旋转手势识别器 的 \(#function) 方法 ")
        self.gestureView.transform = self.gestureView.transform.rotated(by: sender.rotation)
        sender.rotation = 0 //重置旋转角度
    }
    
}


//MARK: - 设置测试的UI
extension TestGesture_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        gestureView.backgroundColor = .red
        gestureView.isUserInteractionEnabled = true
        self.view.addSubview(gestureView)
        gestureView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
    }
    
}


//MARK: - 设计UI
extension TestGesture_VC {
    
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
extension TestGesture_VC: UICollectionViewDelegate {
    
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


//MARK: - 遵循手势识别 UIGestureRecognizerDelegate 协议
extension TestGesture_VC: UIGestureRecognizerDelegate {
    
    // 控制Gesture的开始
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("UIGestureRecognizerDelegate 的 \(#function) 方法")
        return true
    }
    
    /// 是否支持多个手势识别器起作用。控制Gesture是否可以同时识别
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        print("UIGestureRecognizerDelegate 的 \(#function) 方法")
        return true
    }
    
    // 控制自身的Gesture和其他Gesture的失败
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        print("UIGestureRecognizerDelegate 的 \(#function) 方法")
        return true
    }
    
    // 控制自身的Gesture和其他Gesture的失败
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        print("UIGestureRecognizerDelegate 的 \(#function) 方法")
        return true
    }
    
    /// 是否允许手势识别器接收 触摸事件。控制Gesture是否接受touch
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
        print("UIGestureRecognizerDelegate 的 \(#function) 方法")
        return true
    }
    
    // 控制Gesture是否接受press
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool{
        print("UIGestureRecognizerDelegate 的 \(#function) 方法")
        return true
    }
    
    // 控制Gesture是否接受event
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool{
        print("UIGestureRecognizerDelegate 的 \(#function) 方法")
        return true
    }
    
}
    

