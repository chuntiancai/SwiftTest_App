//
//  TestCoreAnimation_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/22.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试核心动画的VC
// MARK: - 笔记
/**
    1、Core Animation 框架是mac和iOS系统通用的框架，它的执行过程是在后台，所以不会阻塞主线程。
    2、使用步骤：
            1、首先得有一个CALayer。
            2、初始化一个CAAnimation对象，并设置一些动画相关的属性。
            3、通过调用方法，添加CAAnimation对象到CALayer中，这样就能执行动画了。
            添加动画后，动画结束后，默认回到原来的位置,因为动画完成后，CAAnimation默认会移除自身。
 
    3、你也可以通过动画事务CATransaction来实现隐式动画效果。
    
    4、CAKeyframeAnimation类是可以多个属性同时动画，CABasicAnimation类是单个属性的动画效果，都继承CAPropertyAnimation类。
    
    5、如果KVC的属性不知道是啥，那就去api文档里面找，会有对应的说明。
    
    6、Core Animation可以设置代理，所以你就可以监听动画的进度。
        1、核心动画技术并没有去修改UIView的frame属性，所以它是一个假象，和形变一样，只是个属性。UIView的动画，则会修改UIView的frame值。
        2、核心动画技术，只作用于layer层，并不影响view层。
        
        3、当不需要和用户进行交互时，使用核心动画
        4、当需要做路径动画时，使用核心动画。
        5、当做转场动画时，使用核心动画。UIView也有转场动画，UIView.transition方法。
            
    7、动画的旋转、缩放等都是以锚点座位参考点的。
 
    8、Core Animation维护的是Layer的呈现树，GPU或者硬件会根据呈现树的值来渲染动画。而我们平时代码创建的View的layer，或者直接的Layer属于模型树，顾名思义， 就是用来存储画面数据的，而每一个UI刷新周期，呈现树就回从模型树中复制数值，然后GPU从呈现树里那到数值渲染到屏幕上。
 
    9、我还是不知道为什么Transaction里设置单纯layer的属性就可以动画，而设置view的layer的属性就不可以动画。但是UIView.animate方法里设置view的属性，却又可以动画， 是因为子layer的代理是view，然后所以就可以动画？
        ：是因为UIKit禁止了事务动画，而CAlayer是属于Quartz框架。所以UIKit只能是普通动画，而不能是事务动画。UIView是beginAnimations这些方法。
 
    10、CAReplicatorLayer可以对自己的子layer进行复制。
 */

class TestCoreAnimation_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    var redView = UIView()
    var imgView = UIImageView() //测试转场动画的图片view。
    var imgInt = 0
    
    let layersView = UIView() //测试音量条效果layer的容器view
    let grainView = GrainAnimate_View() //测试粒子效果的容器view
    let springView = SpringAnimate_View() //测试弹粘性效果的容器view

    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试CoreAnimation"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestCoreAnimation_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、添加动画的基本步骤
            print("     (@@  添加动画的基本步骤")
            /// 1、创建动画对象。
            let anim = CABasicAnimation()
            /// 2、设置属性值。
            anim.keyPath = "position.y"
            anim.toValue = 400
            anim.isRemovedOnCompletion = false  //完成后不移除动画
            anim.fillMode = .forwards   //设置动画完成时的状态
            anim.autoreverses = true    //复原过程
            /// 3、添加动画。
            redView.layer.add(anim, forKey: nil)
            break
        case 1:
            //TODO: 1、测试Layer的隐式动画效果，使用事务
            print(" (@@ 测试Layer的隐式动画效果")
            /// 也可以通过CATransaction事务的方式关闭默认的隐式动画效果。
            CATransaction.begin()   //开启事务
//            CATransaction.setDisableActions(true)   //关闭隐式动画
            CATransaction.setAnimationDuration(2.0) //设置动画时间
            redView.layer.position = CGPoint(x: 300, y: 550)    //我也不知道为什么没有动画效果？：因为UIKit禁止里事务动画，只能普通动画
            CATransaction.commit()  //提交事务
        case 2:
            //TODO: 2、测试动画的多个属性效果（CAKeyframeAnimation也是关键路径动画）
            print("     (@@ 测试动画的多个属性效果")
            let keyAnim = CAKeyframeAnimation()
            keyAnim.keyPath = "transform.rotation"  //弧度，角度是以顺时针，锚点，y轴方向计算的。
            keyAnim.values = [-Double.pi/10,Double.pi/10]
            keyAnim.duration = 2
            keyAnim.isRemovedOnCompletion = false
            keyAnim.fillMode = .forwards
            keyAnim.autoreverses = true
            keyAnim.repeatCount = 5
            redView.layer.add(keyAnim, forKey: nil)
        case 3:
            //TODO: 3、测试沿着路径动画
            print("     (@@ 测试沿着路径动画")
            let keyAnim = CAKeyframeAnimation()
            /// 创建动画路径
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 60, y: 150))
            path.addLine(to: CGPoint(x: 240, y: 200))
            path.addQuadCurve(to: CGPoint(x: 260, y: 420), controlPoint: CGPoint(x:150, y: 300))
            
            /// 添加路径到动画中
            keyAnim.keyPath = "position"
            keyAnim.path = path.cgPath
            
            keyAnim.isRemovedOnCompletion = false
            keyAnim.fillMode = .forwards
            keyAnim.duration = 5
            redView.layer.add(keyAnim, forKey: nil)
        case 4:
            //TODO: 4、测试转场动画(过渡)
            print("     (@@ 测试转场动画(过渡)")
            imgInt += 1
            if imgInt > 4 {  imgInt = 0  }
            imgView.image = UIImage(named: "labi0\(imgInt)")
            
            let anim = CATransition()   //过渡动画对象
            /// 过渡类型
            anim.type = .push
            anim.duration = 2
            
            imgView.layer.add(anim, forKey: nil)
            
        case 5:
            //TODO: 5、测试同时执行多个动画（CAAnimationGroup），动画组
            print("     (@@ 测试同时执行多个动画,动画组")
            imgView.isHidden = true
            /// 使用动画组CAAnimationGroup
            let animGroup = CAAnimationGroup()
            
            let anim1 = CABasicAnimation()
            anim1.keyPath = "position.y"
            anim1.toValue = 400
            
            let anim2 = CABasicAnimation()
            anim2.keyPath = "transform.scale"
            anim2.toValue = 0.5
            
            animGroup.animations = [anim1,anim2]
            animGroup.isRemovedOnCompletion = false
            animGroup.fillMode = .forwards
            animGroup.duration = 2
//            animGroup.autoreverses = true
            redView.layer.add(animGroup, forKey: nil)
            
        case 6:
            //TODO: 6、测试Layer的缩放动画，根据锚点，复制因子layer
            print("     (@@ 测试Layer的缩放动画，根据锚点")
            hideOtherView(curView: layersView)
            
            /// 专门用于复制别的layer的layer。
            let repL = CAReplicatorLayer()
            repL.backgroundColor = UIColor.gray.cgColor
            repL.frame = layersView.bounds
            layersView.layer.addSublayer(repL)
            
            /// 复制的数量(包括被复制的本身)
            repL.instanceCount = 7
            ///对复制出来的layer做形变，每一个复制出来的layer都是相对上一个layer做形变，下面是平移形变
            repL.instanceTransform = CATransform3DMakeTranslation(50, 0, 0)
            repL.instanceDelay = 0.9    //设置被复制的layer的每个动画延时。
            
            /// 音量条layer(用于被复制)
            let redLayer = CALayer()
            redLayer.backgroundColor = UIColor.red.cgColor
            redLayer.anchorPoint = CGPoint.init(x: 0, y: 1) //设置锚点
            redLayer.frame = CGRect.init(x: 0, y: 0, width: 30, height: 80)
            redLayer.position = CGPoint(x: 0, y: repL.bounds.height)
            repL.addSublayer(redLayer)
            
            /// 为被复制的layer添加动画，其实就是给复制因子layer添加动画，就会影响到克隆体里。
            let anim = CABasicAnimation()
            anim.duration = 1.0
            anim.keyPath = "transform.scale.y"
            anim.toValue = 0
            anim.repeatCount = MAXFLOAT
            anim.autoreverses = true
            redLayer.add(anim, forKey: nil)
            
        case 7:
            //TODO: 7、测试粒子效果
            print("     (@@ 测试粒子效果")
            hideOtherView(curView: grainView)
        case 8:
            //TODO: 8、测试弹粘性效果
            print("     (@@ 测试弹粘性效果")
            hideOtherView(curView: springView)
        case 9:
            //TODO: 9、测试无限滚动动画
            print("     (@@9、测试无限滚动动画")
            let infinityView = InfinityLoop_View()
            self.view.addSubview(infinityView)
            infinityView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.65)
                make.height.equalTo(10)
            }
            hideOtherView(curView: infinityView)
            
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
extension TestCoreAnimation_VC{
   
    //MARK: 0、
    
    /// 隐藏其他的view
    func hideOtherView(curView:UIView?){
        for subV in self.view.subviews {
            subV.isHidden = true
        }
        curView?.isHidden = false
        baseCollView.isHidden = false
    }
    
}


//MARK: - 设置测试的UI
extension TestCoreAnimation_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        /// 红色view，测试基本的动画。
        redView.backgroundColor = .red
        self.view.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        /// 图片view，用于测试转场动画。
        imgView.backgroundColor = .brown
        self.view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(200)
        }
        
        /// 测试layer音量条的容器view
        self.view.addSubview(layersView)
        layersView.isHidden = true
        layersView.layer.borderWidth = 1.0
        layersView.layer.borderColor = UIColor.cyan.cgColor
        layersView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.width.equalTo(350)
            make.height.equalTo(300)
            make.centerX.equalToSuperview()
        }
        
        ///测试粒子效果的容器View
        self.view.addSubview(grainView)
        grainView.isHidden = true
        grainView.backgroundColor = UIColor.white
        grainView.layer.borderWidth = 1.0
        grainView.layer.borderColor = UIColor.cyan.cgColor
        grainView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        ///测试弹粘性效果的容器View
        self.view.addSubview(springView)
        springView.isHidden = true
        springView.backgroundColor = UIColor.white
        springView.layer.borderWidth = 1.0
        springView.layer.borderColor = UIColor.cyan.cgColor
        springView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
}


//MARK: - 设计UI
extension TestCoreAnimation_VC {
    
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
extension TestCoreAnimation_VC: UICollectionViewDelegate {
    
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


