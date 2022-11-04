//
//  TestQuartz2D_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/15.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试Quartz2D绘图技术的VC
// MARK: - 笔记
/**
    1、Quartz2D属于iOS的Core Graphics框架，iOS中大部分控件的内容都是通过Quartz2D画出来的，Quartz2D很重要的一个价值是：自定义view（自定义UI控件）。
    2、CGContext类是图形上下文，它的作用是，保存绘图信息、绘图状态、决定输出目标等等，就是一个绘制图形的环境类。(语境)
       相同的一套绘图序列，指定不同的Graphics Context，就可将相同的图像绘制到不同的目标上。（也就是一套上下文只对应一幅绘图？：是的）
       CGContext可以设置为几种语境，所以绘制不同的图时，要关闭当前语境，开新的语境，也就是不能直接切换。
       Quartz2D提供了以下几种类型的Graphics Context：
            Bitmap Graphics Context
            PDF Graphics Context
            Window Graphics Context
            Layer Graphics Context
            Printer Graphics Context
    3、利用Quartz2D技术绘制图形到view上，也只能绘制到view上。
        绘制view的步骤：
            新建一个类，继承自UIView。
            实现- (void)drawRect:(CGRect)rect方法，然后在这个方法中取得跟当前view相关联的图形上下文(CGContext)。
            在CGContext的语境下，利用贝塞尔曲线等技术类 来绘制相应的图形内容。
            利用CGContext 将绘制的所有内容渲染显示到view上面。
 
    4、每开启一次上下文，都记得必须关闭一次上下文。draw方法里不用是因为默认帮你关闭了.
 
    5、View生成图片，必须用view的layer的渲染方式绘制进上下文当中，不能用layer的draw方式，我也不知道为什么。

 
 */

class TestQuartz2D_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    
    //MARK: 测试组件
    let drawView = Quartz_View()    // 在view的draw方法内绘制图形
    let fontView = Quartz_Font_View()
    let qImgView = Quartz_Img_View()
    let logImgView = UIImageView()
    var startPoint:CGPoint = .zero  //截屏选中区域的开始点
    var choseView:UIView = UIView() //截屏选中的区域，用一个view来显示透明度
    var gesturePView = UIView() //手势密码的绘图
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试Quartz2D绘图"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestQuartz2D_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试在draw方法中绘制图形
            print("     (@@  测试在draw方法中绘制图形")
            drawView.isHidden = false
            var shapeEnumRawValue:Int = drawView.drawShape.rawValue
            shapeEnumRawValue += 1
            if shapeEnumRawValue > Quartz_View.PaintShape.Arc.rawValue {
                shapeEnumRawValue = 0
            }
            drawView.drawShape = Quartz_View.PaintShape.init(rawValue: shapeEnumRawValue)!
            drawView.setNeedsDisplay()  //在下一个UI周期更新View的内容，此时系统会再次调用view的draw方法。
            break
        case 1:
            //TODO: 1、更新drawView弧度的百分比
            print("     (@@ 更新drawView弧度的百分比")
            drawView.isHidden = false
            drawView.arcProgress += 0.09
            if drawView.arcProgress > 1.0 {
                drawView.arcProgress = 0.0
            }
        case 2:
            //TODO: 2、绘制文字图形
            print("     (@@ 绘制文字图形")
            fontView.isHidden = false
            
        case 3:
            //TODO: 3、绘制图片
            print("     (@@ 绘制图片")
            qImgView.isHidden = false
            qImgView.isStopDiapaly = true
            
        case 4:
            //TODO: 4、绘制加水印的图片。
            print("     (@@ 绘制加水印的图片。")
            logoImgFunc()
        case 5:
            //TODO: 5、图片裁剪出圆形部分。
            print("     (@@ 图片裁剪出圆形部分")
            clipCircleImgFunc()
        case 6:
            //TODO: 6、截屏
            print("     (@@ 截屏")
            getScreenShot()
        case 7:
            //TODO: 7、区域截屏，截图
            print("     (@@ 区域截屏")
            getPartScreenShot()
        case 8:
            //TODO: 8、擦除图片区域
            /**
                1、其实设计思路就是在添加图片到context中，在context擦去部分，然后再把擦除后的图片返回。
             */
            print("     (@@擦除图片区域")
            clearImgRect()
        case 9:
            //TODO: 9、手势密码
            print("     (@@ 绘制手势密码")
            drawGesturePassword()
        case 10:
            print("     (@@")
        case 11:
            print("     (@@")
        case 12:
            print("     (@@ 对context做形变")
            /// 不知道为什么无效
            drawView.isHidden = false
            drawView.contextTransForm += 1
            if drawView.contextTransForm > 2 {
                drawView.contextTransForm = 0
            }
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestQuartz2D_VC{
   
    //MARK: 4、给图片加水印
    func logoImgFunc(){
        /// 1、加载图片
        /// 2、开启图片绘制的上下文，上下文大小与图片原始大小一致。
        /// 3、添加图片到上下文当中。
        /// 4、把logo文字添加到上下文当中。
        /// 5、从上下文中生成一张图片
        /// 6、关闭上下文。
        let img = UIImage(named: "labi03")
        UIGraphicsBeginImageContextWithOptions(img!.size, false, 0) //开启上下文
        img?.draw(at: .zero)
        let attStr = NSAttributedString.init(string: "蜡笔蜡笔小新",
                                             attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                                                          NSAttributedString.Key.foregroundColor : UIColor.red.cgColor])
        attStr.draw(at: CGPoint.init(x: 10, y: 10))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext() //关闭上下文
        logImgView.image = newImg
        logImgView.isHidden = false
    }
    
    //MARK: 5、图片裁剪出圆形部分。
    func clipCircleImgFunc(){
        let img = UIImage(named: "labi01")
        UIGraphicsBeginImageContextWithOptions(img!.size, false, 0) //开启上下文
        let context = UIGraphicsGetCurrentContext()
        ///0、 绘制边框。绘制图片描边的边框。边框宽度为7.0.
        let bPath1 = UIBezierPath.init(ovalIn: CGRect.init(x: img!.size.width/2, y: img!.size.height/2, width: 207, height: 207))
        UIColor.blue.set()
        context?.addPath(bPath1.cgPath)
        context?.fillPath()
        
        /// 1、绘制圆形区域
        let bPath2 = UIBezierPath.init(ovalIn: CGRect.init(x: img!.size.width/2, y: img!.size.height/2, width: 200, height: 200))
        bPath2.addClip() /// 取 当前上下文区域 与 UIBezierPath路径包围区域 的交集，也就是路径的包围区域作为可见的绘制区域，其余区域为不可见(透明)。
        img?.draw(at: .zero)
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext() //关闭上下文
        logImgView.image = newImg
        logImgView.isHidden = false
    }
    
    //MARK: 6、截屏
    func getScreenShot(){
        // 把当前view生成一张图片。
        /// 1、开启一个位图的上下文。
        /// 2、把当前view绘制到上下文中，必须要使用view的渲染方式才能把veiw绘制到上下文当中。
        /// 3、从上下文当中生成一张图片
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0) //开启上下文
        guard let context = UIGraphicsGetCurrentContext() else { return  }
        self.view.layer.render(in: context) /// 把view的layer层渲染到上下文中。
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()//关闭上下文
        logImgView.image = newImg
        logImgView.isHidden = false
        
    }
    
    //MARK: 7、区域截屏
    /// 利用 拖动 手势识别器来确定选中的区域。
    func getPartScreenShot(){
        self.view.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureAction(_:)))
        self.view.addGestureRecognizer(pan)
        choseView.isHidden = true
        choseView.alpha = 0.5
        choseView.backgroundColor = .white
        self.view.addSubview(choseView)
        
        
    }
    
    /// 获取 选中的局部区域 的拖动手势 动作方法
    /// - Parameter sender: 拖动手势识别器
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer){
        ///1、通过手势识别器设置选中的区域
        ///2、通过图片上下文截取选中的区域生成图片。
        choseView.isHidden = false
        
        var movePoint:CGPoint = .zero
        var curRect:CGRect = .zero

        if sender.state == .began {
            self.startPoint = sender.location(in: self.view)
        }
        /// 计算选中的区域
        if sender.state == .changed {
            movePoint = sender.location(in: self.view)
            curRect = CGRect.init(x: startPoint.x, y: startPoint.y, width: movePoint.x - startPoint.x, height: movePoint.y - startPoint.y)
            choseView.frame = curRect
        }
        
        /// 根据选中的区域和图片上下文生成图片
        if sender.state == .ended {
            choseView.isHidden = true
            UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0)
            let context = UIGraphicsGetCurrentContext()
            let bPath = UIBezierPath.init(rect: choseView.frame)    //这个区域不要选错了
            bPath.addClip()
            context?.addPath(bPath.cgPath)
            self.view.layer.render(in: context!)
            let newImg = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
//            let cgImg = newImg?.cgImage?.cropping(to: CGRect.init(x: 0, y: 0, width: choseView.frame.size.width, height: choseView.frame.size.height))
            logImgView.image = newImg
        }
    }
    
    //MARK: 8、擦除图片区域
    /// 利用 拖动 手势识别器来确定选中的区域。
    func clearImgRect(){
        logImgView.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(clearPanAction(_:)))
        logImgView.addGestureRecognizer(pan)
    }
    
    /// 擦除的动作方法
    @objc func clearPanAction(_ sender:UIPanGestureRecognizer){
        
        /// 计算选中的区域
        let movePoint = sender.location(in: self.logImgView)
        let curRect = CGRect.init(x: movePoint.x - 5, y: movePoint.y - 5, width: 10, height: 10)
        
        /// 根据选中的区域和图片上下文生成图片
        UIGraphicsBeginImageContextWithOptions( self.logImgView.frame.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        self.logImgView.layer.render(in: context!)  //把原来的图片渲染到上下文中
        context?.clear(curRect) //清除掉你选中的区域
        let newImg = UIGraphicsGetImageFromCurrentImageContext()    //生成新的图片
        UIGraphicsEndImageContext()
        logImgView.image = newImg
    }
    
    //MARK: 9、绘制手势密码
    func drawGesturePassword(){
        
        /// 手势密码的view
        gesturePView.backgroundColor = .lightGray
        gesturePView.isUserInteractionEnabled = true
        self.view.addSubview(gesturePView)
        gesturePView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(300)
        }
        
        /// 3*3的九宫格
        let colum = 3   //3列
        let btnWidth:CGFloat = 50   //按钮的宽高
        let spaceMargin:CGFloat = (300 - CGFloat(btnWidth * CGFloat(colum))) / CGFloat(colum + 1)    //每行每列中间有四条间隙
        for index in 0 ..< 9 {
            
            let curColum = CGFloat(index % colum)    //当前列
            let curRow = CGFloat(index / colum)  //当前行
            
            let curX:CGFloat = spaceMargin + spaceMargin * curColum + btnWidth * curColum
            let curY:CGFloat = spaceMargin + spaceMargin * curRow + btnWidth * curRow
            
            let curBtn = UIButton.init(frame: CGRect.init(x: curX, y: curY, width: btnWidth, height: btnWidth))
            curBtn.isUserInteractionEnabled = false //设置按钮不可以点击，用代码来处理事件
            curBtn.setImage(UIImage(named: "shoushimima_off"), for: .normal)
            curBtn.setImage(UIImage(named: "shoushimima_on"), for: .selected)
            curBtn.tag = 1000 + index
            gesturePView.addSubview(curBtn)
        }
        
        /// 添加平移手势
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(passwordPanAction(_:)))
        gesturePView.addGestureRecognizer(pan)
        
    }
    
    /// 手势密码的平移手势
    @objc func passwordPanAction(_ sender: UIPanGestureRecognizer ){
        let tapP = sender.location(in: gesturePView)    //找到点击的点
        for index in 1000 ... 1008 {
            let btn  = gesturePView.viewWithTag(index) as! UIButton
            let curP = gesturePView.convert(tapP, to: btn)
            if btn.bounds.contains(curP) {
                btn.isSelected = true
            }
        }
    }
    
}


//MARK: - 设置测试的UI
extension TestQuartz2D_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        // 在view的draw方法内绘制图形
        drawView.backgroundColor = .lightGray
//        drawView.isHidden = true
        self.view.addSubview(drawView)
        drawView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(300)
        }
        
        // 在view的draw方法内绘制文字
        fontView.backgroundColor = .lightGray
        fontView.isHidden = true
        self.view.addSubview(fontView)
        fontView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(30)
            make.centerX.equalToSuperview().offset(20)
            make.height.width.equalTo(300)
        }
        
        // 在view的draw方法内绘制图片
        qImgView.backgroundColor = .lightGray
        qImgView.isHidden = true
        self.view.addSubview(qImgView)
        qImgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(30)
            make.centerX.equalToSuperview().offset(20)
            make.height.width.equalTo(300)
        }
        
        // 绘制水印、截取图片的view
        logImgView.isHidden = true
        logImgView.layer.borderWidth = 2.0
        logImgView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(logImgView)
        logImgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(300)
        }
        
    }
    
}


//MARK: - 设计UI
extension TestQuartz2D_VC {
    
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
extension TestQuartz2D_VC: UICollectionViewDelegate {
    
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



