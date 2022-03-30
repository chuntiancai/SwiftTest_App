//
//  TestCALayer_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/18.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试CALayer的VC

class TestCALayer_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    var redView = UIView()
    var imgView = UIImageView()
    let blueLayer = CALayer()   //测试隐式动画的layer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试CALayer的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestCALayer_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、通过layer设置阴影
            print("   (@@  通过layer设置阴影")
            redView.layer.shadowColor = UIColor.blue.cgColor
            redView.layer.shadowOpacity = 1.0   //设置阴影的不透明度
            redView.layer.shadowOffset = CGSize(width: 20, height: 15)
            redView.layer.shadowRadius = 3.0    //模糊半径，也就是从阴影的圆角那里开始模糊，一坨发散开，反正就是设置圆角的半径作为模糊的参考
            /**
             redView.layer.shadowRadius += 1.0
             redView.layer.shadowRadius -= 1.0
             */
            
            /// 设置边框
            redView.layer.borderWidth = 20
            redView.layer.borderColor = UIColor.yellow.cgColor
            
            /// 设置圆角
            redView.layer.cornerRadius = 10
            
            
            /// 切除超过根层Layer的内容,但是这样就没有阴影这些效果了。
            redView.layer.masksToBounds = true
            
            break
        case 1:
            //TODO: 1、测试layer的3D形变
            /**
                1、x轴向右，y轴向下，z轴朝向使用者(也就是你)
             */
            print(" (@@ 测试layer的3D形变")
            
            UIView.animate(withDuration: 1.5) {
                ///初始化参数传入的是单位向量，用于确定方向，也就是数学中的单位向量。以图片的中心为原点。
//                self.imgView.layer.transform = CATransform3DMakeRotation(CGFloat.pi , 1.0, 1.0, 0)
                
                /// 通过KVC来设置transform属性，把结构体转换为对象。KVC一般是用来做快速选择，平移，缩放，因为要访问transform的私有属性。
                /// 设置translation.x\transform.rotation.x这些私有属性的时候，要用forKeyPath方法，而不是forKey。KVC设置transform可以成功。
//                let value = NSValue.init(caTransform3D: CATransform3DMakeRotation(CGFloat.pi , 1.0, 0.0, 0.0))
//                self.imgView.layer.setValue(value, forKey: "transform")
                self.imgView.layer.setValue(Double.pi / 4,forKeyPath: "transform.rotation.y")
            }
            
        case 2:
            //TODO: 2、测试layer的position和anchorPoint属性
            /**
                1、layer的position属性是参考父view坐标系的，绑定了Layer里的某一个点。设置position属性，就是把layer的这个点，移动到父view中position的值的位置。
                2、上面1说的position是Layer中的一个点，这个点就是由Layer的anchorPoint属性决定的，也是锚点，它的丈量是0～1，也就是按比例来计算定位Layer中的点。
                   anchorPoint是参考Layer自身坐标系的，但是是按照0～1的比例来丈量，不是精确到坐标系的每一点来丈量。anchorPoint默认值是(0.5,0.5)。
             */
            print(" @@ 测试layer的position和anchorPoint属性")
            redView.layer.anchorPoint = CGPoint(x: 0, y: 0)
            redView.layer.position = CGPoint.init(x: 20, y: self.view.bounds.midY)
            
        case 3:
            //TODO: 3、测试Layer的隐式动画效果
            print(" (@@ 测试Layer的隐式动画效果")
//            blueLayer.position = CGPoint(x: 200, y: 450)
//            blueLayer.bounds = CGRect.init(x: 0, y: 0, width: 100, height: 120)
            /// 可以通过CATransaction事务的方式关闭默认的隐式动画效果。
            CATransaction.begin()   //开启事务
//            CATransaction.setDisableActions(true)   //关闭隐式动画
            CATransaction.setAnimationDuration(2.0) //设置动画时间
            blueLayer.position = CGPoint(x: 300, y: 550)
            CATransaction.commit()  //提交事务
        
        case 4:
            //TODO: 4、测试Layer的字典功能
            /**
                1、图层没有一个myName属性;'myName'属性是我附加给layer的。现在，我可以通过获取各自的“myName”键的值后确定这些层
             */
            print(" (@@ 测试Layer的字典功能")
            redView.layer.setValue("layer名字", forKey: "myName")
            let myName = redView.layer.value(forKey: "myName")
            print("从字典里取出的名字是：\(String(describing: myName))")
        case 5:
            //TODO: 5、测试更换View的根Layer
            print("     (@@ 测试更换View的根Layer")
            let layerView = TestCALayer_View()
            print(" 更换后：\(layerView.layer)")
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
            //TODO: 12、复原layer的3D形变
            print(" @@ 复原layer的3D形变")
            imgView.layer.transform = CATransform3DIdentity //复原
            imgView.isHidden = true
            redView.isHidden = true
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestCALayer_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestCALayer_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        /// 查看layer的属性
        redView.backgroundColor = .red
        self.view.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        /// 查看layer的3d形变
        self.view.addSubview(imgView)
        imgView.backgroundColor = .brown
        imgView.image =  UIImage(named: "labi05")
        imgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(120)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(160)
        }
        
        /// 测试Layer的隐式动画。
        blueLayer.backgroundColor = UIColor.blue.cgColor
        blueLayer.frame = CGRect.init(x: 100, y: 320, width: 80, height: 80)
        self.view.layer.addSublayer(blueLayer)
        
        
    }
    
}


//MARK: - 设计UI
extension TestCALayer_VC {
    
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
extension TestCALayer_VC: UICollectionViewDelegate {
    
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
    背景知识：1、CALayer是在QuartzCore框架中，CGImage、CGColor是在CoreGraphics框架中，UIImage、UIColor是在UIKit框架中。
               QuartzCore和CoreGraphics框架是MAC OS和iOS两个平台通用的，而UIKit是只能iOS平台使用。
               为了保证可移植性，QuartzCore不能使用UIKit框架里的东西。但是UIKit可以使用QuartzCore框架里面的东西。
               UIView比CALayer多了事件处理的功能，UIView内部其实就是封装了CALayer。但是涉及到动画这些，直接用CALayer，性能更高，更灵活。
    
    1、在创建UIView对象时，UIView内部会先创建一个Layer，Layer也就是图层，当UIView需要被显示到屏幕上时，会调用UIView的draw方法，并将内容绘制到Layer上，绘图完毕之后， 系统会将图层的拷贝到屏幕上，于是就完成了UIView的显示。
      也就是UIView并不具有显示显示的功能，是它内部的图层才有显示功能。
 
    2、边框的宽度，是向内扩张的，也就是不会大于view的frame。
 
    3、UIImageView的一些Layer属性对UIImageView里面的图片不起作用的原因是，UIImageView的图片并不是直接添加到UIImageView的Layer上，而是把图片存放在Layer的contents属性上。
 
    5、UIView内部还有一层mask层，初始化的大小是和根层Layer的大小一样的。当根层Layer的大小发生变化时，mask层的大小是跟随根层Layer变化的，所以这也是Layer的masksToBounds属性的原理。就是超过mask层的内容都被裁掉。
        mask层的 alpha通道 用作 遮罩效果，也就是mask层的不透明部分是可见部分，但是mask层默认是不显示的，是用于过滤当前layer的背景与内容的辅助作用。 作为mask的layer是不支持自身有mask的， 也就是不支持mask的mask这种关系。
    
    6、通过NSValue类，可以把结构体转换为对象。
 
    7、每一个UIView内部都默认关联一个CALayer，这个Layer我们称之为root Layer。其余我们手动添加上的Layer就叫做非root layer，所有我们手动添加到UIview的非root layer，当我们对它的某一些属性进行修改时，都会产生动画效果，而这种动画效果也就叫做隐式动画，这些属性也叫做可动画属性(Animatable Properties)。
    例如：bounds\backgroundColor\position等属性。你可以看一下api的注释，上面会说Animatable。
        可以通过CATransaction事务的方式关闭默认的隐式动画效果。
        只有非root layer才有隐式动画效果，相对于显式动画而言。
        如果在UIView中，要让这些属性产生动画效果，就需要用到动画事务来提交对这些属性的修改，这是显式动画了。
 
    8、所有的旋转、缩放，都是围绕着Layer的锚点进行的。
 
    9、CALayer还有字典的功能，例如Layer没有一个myName属性;'myName'属性是我setValue附加给layer的，但是现在，我可以通过获取各自的“myName”键的值。
 
    10、layer的transform改变了view的frame，但是并没有改变view的center。
    
 */

