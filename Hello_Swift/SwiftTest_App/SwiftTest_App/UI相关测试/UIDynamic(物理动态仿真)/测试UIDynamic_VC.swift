//
//  测试UIDynamic_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/14.
//  Copyright © 2022 com.mathew. All rights reserved.
//

import UIKit

//测试UIDynamic的VC
// MARK: - 笔记
/**
    1、UIDynamic隶属于UIKit框架，可以理解为一种物理引擎，用于模拟和仿真现实生活中的物理现象。
        UIView默认已经遵守了UIDynamicItem协议，因此任何UI控件都能做物理仿真。
        UICollectionViewLayoutAttributes类默认也遵守UIDynamicItem协议。
        
        例如愤怒的小鸟，桌球游戏等等。仿真的行为如下：
        UIGravityBehavior：重力行为
        UICollisionBehavior：碰撞行为
        UISnapBehavior：捕捉行为
        UIPushBehavior：推动行为
        UIAttachmentBehavior：附着行为
        UIDynamicItemBehavior：动力元素行为
 
    2、使用步骤如下：
        （1）创建一个物理仿真器（顺便设置仿真范围）。     一个仿真器控制所有的行为，可以是多个行为的组合。
        （2）创建相应的物理仿真行为（顺便添加物理仿真元素）。
        （3）将物理仿真行为添加到物理仿真器中 --> 开始仿真。
 
 */

class TestUIDynamic_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    let box1:UIImageView = UIImageView(image: UIImage(named: "uidynamic_box"))
    let box2 = UIImageView(image: UIImage(named: "uidynamic_box"))      //盒子UI2
    
    // MARK: 1. 创建物理仿真器(让仿真元素执行, 仿真行为; 球 滚动)
    lazy var animator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self.bgView)
    }()
    
    // bgview的点击手势识别器，主要是获取点击的point。
    lazy var tapGesture:UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapBgViewAction(_:)))
        bgView.addGestureRecognizer(tap)
        return tap
    }()
    
    lazy var snapBehavior:UISnapBehavior = {    //捕捉
        let behavior = UISnapBehavior(item: box2, snapTo: CGPoint(x: 200, y: 200))
        return behavior
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试UIDynamic的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestUIDynamic_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestUIDynamic_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、初始化UI。
            print("     (@@ 0、初始化UI。")
            bgView.backgroundColor = UIColor(patternImage: UIImage(named: "uidynamic_bg")!)
            bgView.addSubview(box1)
            box1.center = CGPoint(x: 80, y: 80)
            bgView.addSubview(box2)
            box2.center = CGPoint(x: 160, y: 120)
            let _ = self.tapGesture
            
        case 1:
            //TODO: 1、为view添加碰撞行为。
            print("     (@@ 1、为view添加碰撞行为。")
            // 创建碰撞物理仿真行为
            let behavior = UICollisionBehavior(items: [box1, box2])
            
            // 是否限制子view物理行为在边框内发生。
            behavior.translatesReferenceBoundsIntoBoundary = true
            
            // 碰撞模式
    //        Items  只碰撞元素
    //        Boundaries  自碰撞边界
    //        Everything: 啥玩意都碰撞
            behavior.collisionMode = .everything
            
            // 设置边界的内边距
            behavior.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 5))
            
            // 添加一个边界,相当于添加了一条斜杆。
            let startPoint = CGPoint(x: 0, y: 160)
            let endPoint = CGPoint(x: bgView.bounds.width, y: bgView.bounds.height - 60)
            let lineShape = CAShapeLayer()
            lineShape.strokeColor = UIColor.red.cgColor
            lineShape.lineWidth = 6
            let linePath = UIBezierPath()
            linePath.move(to: startPoint)
            linePath.addLine(to: endPoint)
            lineShape.path = linePath.cgPath
            bgView.layer.addSublayer(lineShape)
            
            behavior.addBoundary(withIdentifier: NSString(string: "ctch_Boundary"), from: startPoint, to: endPoint)
            
            // 设置碰撞代理, 监听碰撞事件
            behavior.collisionDelegate = self
            
            // 添加碰撞行为到仿真器, 开始执行
            animator.addBehavior(behavior)
            
        case 2:
            //TODO: 2、 为view添加重力行为。
            /**
                1、重力行为添加后就发生。
                2、不添加重力行为的view，相当于在真空中受力。
                3、只有添加到仿真器中的view才有行为的能力。
             */
            print("     (@@ 2、 为view添加重力行为。")
            // 2. 仿真行为
            let behavior = UIGravityBehavior(items: [box1])

            // 设置重力行为的方向(速度)，这是矢量，既有大小，也有方向。
            behavior.gravityDirection = CGVector(dx: 100, dy: 100)
            // 0代表向右的正方向，顺时针角度
            behavior.angle = Double.pi / 4
            behavior.magnitude = 2  //重力量级
            
            // 3. 把仿真行为添加到仿真器里面
            animator.addBehavior(behavior)
        
        case 3:
            //TODO: 3、为view添加捕捉行为。
            /**
                1、就是把view移动到你设置的点，相当于吸星大法。
             */
            print("     (@@ 3、为view添加捕捉行为。")
            // 如果想要多次执行捕捉行为, 那么必须在之前移除已经添加的捕捉行为
            
            if animator.behaviors.contains(snapBehavior) {
                print("移除捕捉行为")
                animator.removeBehavior(snapBehavior)
            }else{
                print("添加捕捉行为")
                // 1. 创建捕捉行为
                snapBehavior.damping = 1.0  //力的阻尼
                
                // 2. 添加行为到仿真器, 开始执行
                animator.addBehavior(snapBehavior)
            }
            
            
        case 4:
            //TODO: 4、为view添加推行为。
            print("     (@@ 4、为view添加推行为。")
            // 1. 创建推行为
    //        case Continuous  一直推
    //        case Instantaneous 推一次
            let behavior = UIPushBehavior(items: [box1], mode: .instantaneous)
            behavior.magnitude = 2.0    //阻尼
            
            let xRandom = Int(arc4random() % 10 ) - 5
            let yRandom = Int(arc4random() % 10)
            
            // 1.1 设置推的方向,受力方向。矢量，有大小，有方向。力 = 质量 * 加速度
            behavior.pushDirection = CGVector(dx: xRandom, dy: -yRandom)
            
            
            // 2. 添加行为到仿真器, 开始执行行为
            animator.addBehavior(behavior)
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
//MARK: - 测试的方法UICollisionBehaviorDelegate
@objc extension TestUIDynamic_VC{
   
    //MARK: 0、点击bgview的动作方法
    func tapBgViewAction(_ tapGesture: UITapGestureRecognizer){
        print("tapGesture:\(tapGesture.location(in: bgView))")
        // 设置捕捉行为的捕捉点
        
        
        let tapPoint = tapGesture.location(in: bgView)
        snapBehavior.snapPoint = tapPoint
        
    }
    
}

//MARK: - 遵循仿真行为的代理协议，- UICollisionBehaviorDelegate
@objc extension TestUIDynamic_VC: UICollisionBehaviorDelegate{
   
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        print("开始碰撞, 元素-元素", p)
    }
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print("开始碰撞, 元素-边界", identifier ?? "", p)
    }
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item1: UIDynamicItem, with item2: UIDynamicItem) {
        print("结束碰撞, 元素-元素")
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
         print("开始碰撞, 元素-边界", identifier ?? "")
    }
}


//MARK: - 设置测试的UI
extension TestUIDynamic_VC{
    
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
    
}


//MARK: - 设计UI
extension TestUIDynamic_VC {
    
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
extension TestUIDynamic_VC: UICollectionViewDelegate {
    
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



