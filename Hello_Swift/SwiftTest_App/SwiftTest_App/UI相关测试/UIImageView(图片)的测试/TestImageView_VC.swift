//
//  TestImageView_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/13.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试图片相关的功能VC

class TestImageView_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    let imgView1 = UIImageView()
    
    let image1 = UIImage(named: "labi09")!
    
    let turnImgV = UIImageView(image: UIImage(named: "labi10"))
    let turnImgV2 = UIImageView(image: UIImage(named: "labi10"))
    let turnBgView = UIView()   //手势识别器的view，用于控制两张图片的重叠手势
    let turnGradient = CAGradientLayer()    //下半部分图片的渐变颜色
    
    let imgInvertView = TestImgInvert_View()    //图片倒影的View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试图片功能"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestImageView_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        let imgWidth = image1.size.width
        let imgheight = image1.size.height
        
        switch indexPath.row {
        case 0:
            //TODO: 0、拉伸一个像素，用于保护纯色背景的四个角。默认是平铺的拉伸方式，也就是用没被保护的像素去平铺拉伸的部位。
            print("     (@@  只留出一个像素被平铺拉伸")
            /// 只留出一个像素被拉伸
            let curImg = image1.resizableImage(withCapInsets: UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20), resizingMode: .tile)
            imgView1.image = curImg
            break
        case 1:
            //TODO: 1、保护且拉伸的方式进行缩放。
            print("     (@@ 保护且拉伸的方式进行缩放")
            ///其实和上面平铺的方式是一样的，只是封装了而已，默认rightCap = width - LeftCap - 1，同理可得bottomCap
            let curImg = image1.stretchableImage(withLeftCapWidth: Int(imgWidth)/2, topCapHeight: Int(imgheight)/2)
            imgView1.image = curImg
        case 2:
            //TODO: 2、把图片转换成二进制流，输出到文件路径中。
            print("     (@@ 图片输出到文件路径")
            /// compressionQuality参数是指图片的压缩质量，0.0～1.0。
            let imgData = image1.jpegData(compressionQuality: 1.0)
            //            let imgData2 = image1.pngData()
            do {
                try imgData?.write(to: URL.init(fileURLWithPath: "/Users/mac/Desktop/dataImg.jpg"))
            } catch let err {
                print("输出图片二进制流发生错误：\(err)")
            }
            
        case 3:
            //TODO: 3、图片保存到手机相册
            /**
             1、注意该方法的参数，selector的写法是必须满足那三个方法参数的写法，而且要用类名来调用selector方法。
             */
            print("     (@@ 图片保存到手机相册")
            UIImageWriteToSavedPhotosAlbum(image1, self, #selector(TestImageView_VC.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
        case 4:
            //TODO: 4、从手机相册中选择照片。
            print("     (@@ 从手机相册中选择照片")
            let imgVC = UIImagePickerController()
            imgVC.sourceType = .photoLibrary    //选择照片来源
            imgVC.delegate = self   //在代理中回传选中的照片
            self.present(imgVC, animated: true) {
                print("选中的回调方法")
            }
        case 5:
            //TODO: 5、裁剪指定区域的图片。裁剪图片。
            print("     (@@ 裁剪指定区域的图片。")
            let orgImage = UIImage(named: "labi03")!
            imgView1.image = orgImage
            
            ///像素分辨率，也就是像素和点的比例是多少。
            let pixScale = UIScreen.main.scale
            
            let cropWidth:CGFloat = 100 * pixScale
            let cropHeight:CGFloat = 50 * pixScale
            
            /// cropping是用C语言实现的，使用的坐标是像素坐标。而ios使用的坐标是点坐标，所以要进行坐标系的转换。
            let cropImg = (orgImage.cgImage?.cropping(to: CGRect.init(x: 0, y: 0, width: cropWidth, height: cropHeight)))!
            let turnImgV = UIImageView(image: UIImage(cgImage: cropImg))
            self.view.addSubview(turnImgV)
            turnImgV.snp.makeConstraints { make in
                make.top.equalTo(imgView1.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
            }
            
        case 6:
            //TODO: 6、UIImageView只显示部分图片，测试图片重叠动画
            print("     (@@ UIImageView只显示部分图片。图片重叠")
            imgView1.isHidden = true
            turnImgV.isHidden = false
            turnImgV2.isHidden = false
            
            //接收手势的view，用于控制两张图片的翻转效果。
            self.view.addSubview(turnBgView)
            turnBgView.snp.makeConstraints { make in
                make.top.equalTo(baseCollView.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
                make.width.equalTo(300)
                make.height.equalTo(400)
            }
            let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panImgAction(sender:)))
            turnBgView.addGestureRecognizer(pan)
            
            //设置下半部分图片的渐变颜色
            turnGradient.frame = turnImgV2.bounds
            
            /// 设置渐变颜色
            turnGradient.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
            turnGradient.opacity = 0   //渐变透明度。
            
            /// 设置渐变方向,还是比例坐标
            turnGradient.startPoint = CGPoint.init(x: 0.5, y: 0)
            turnGradient.endPoint = CGPoint.init(x: 0.5, y: 1)
            /// 设置一个渐变到另一个渐变的位置，也是比例位置。
            turnGradient.locations = [0.0,1.0]
            turnImgV2.layer.addSublayer(turnGradient)
            
        case 7:
            //TODO: 7、测试图片的倒影效果
            print("     (@@ 测试图片的倒影效果")
            hideOtherView(curView: imgInvertView)
            if let repL = imgInvertView.layer as? CAReplicatorLayer {
                repL.instanceCount = 2  //复制份数
                repL.instanceTransform = CATransform3DMakeRotation(CGFloat.pi, 1.0, 0, 0)   //复制品的形变，围绕锚点进行翻转。
                /// 阴影效果,只是把颜色调一下
                repL.instanceRedOffset -= 0.1
                repL.instanceGreenOffset -= 0.1
                repL.instanceBlueOffset -= 0.1
                repL.instanceAlphaOffset -= 0.1
            }
        case 8:
            //TODO: 8、根据颜色来生成图片，颜色图片
            print("     (@@ 根据颜色来生成图片，颜色图片")
            let alphaColor = UIColor.red.withAlphaComponent(0.6).cgColor
            /// 描述图片的矩形
            let rect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)
            /// 开启位图的上下文
            UIGraphicsBeginImageContext(rect.size)
            /// 获取位图的上下文
            let context = UIGraphicsGetCurrentContext()
            /// 使用color填充上下文
            context?.setFillColor(alphaColor)
            /// 渲染上下文
            context?.fill(rect)
            /// 从上下文中获取图片
            let colorImg = UIGraphicsGetImageFromCurrentImageContext()
            
            ///结束上下文
            UIGraphicsEndImageContext()
            imgView1.image = colorImg
            
        case 9:
            //TODO: 9、下载图片
            print("     (@@ 下载图片")
            let imgUrl = URL.init(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic%2Fa8%2F72%2Fbf%2Fa872bf8e093a8fe1e24d8594c4e0e28a.jpeg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1651112150&t=d6f195ca84b39a914da82bd3a472c7ed")
            var imgData = Data()
            do {
                imgData = try Data(contentsOf: imgUrl!)
            } catch let err {
                print("下载图片出错：\(err)")
            }
            
            let img = UIImage(data: imgData)
            imgView1.image = img
            
        case 10:
            print("     (@@")
        case 11:
            print("     (@@")
        case 12:
            print("     (@@ 重置形变")
            turnImgV.transform = .identity
        default:
            break
        }
    }
    
    
}

//MARK: - 选择手机相册照片的代理协议--UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension TestImageView_VC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("选中照片后的 \(#function) 代理方法")
        print("选中的照片是：\(String(describing: info[UIImagePickerController.InfoKey.originalImage]))")
        /// 把照片写到mac电脑的桌面。
        if let img:UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            do {
                let imgData = img.pngData()
                try imgData?.write(to: URL.init(fileURLWithPath: "/Users/mac/Desktop/模拟器的图片.jpg"))
            } catch let err {
                print("写出照片时发生错误：\(err)")
            }
        }
        picker.dismiss(animated: true) {
            print("移除选中照片的pickerVC")
        }
        
    }
}

//MARK: - 测试的方法，动作方法。
@objc  extension TestImageView_VC{
    
    // MARK: 写入手机相册必须绑定的 动作方法 格式
    func saveImage(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        print("保存图片到相册的 \(#function) 方法 -- image:\(image) -- error:\(String(describing: didFinishSavingWithError))")
    }
   
    // MARK: 翻动图片的手势动作
    /// 两张图片都会进入到该方法，但是只操作上半部分的图片，下半部分提供上半垂直之后的角度。
    func panImgAction(sender: UIPanGestureRecognizer){
        
        let curView = sender.view
        ///获取移动的偏移量。
        let transP = sender.translation(in: curView)
        print("拖动了图片：\(transP.x) --- \(transP.y)")
        ///让上部的图片开始旋转，是根据弧度进行旋转的。
        let angle = transP.y / 400 * CGFloat.pi //400是turnBgView高度
        
        /// 设置渐变颜色由透明到显示
        turnGradient.opacity = Float(transP.y / 400)
        
        /// 以锚点为中心进行旋转的，所以你要设置锚点。默认是逆时针旋转的，所以就要设置为负角度。
//        turnImgV?.layer.transform = CATransform3DMakeRotation(-angle, 1, 0, 0)
        
        //重置矩阵，实现近大远小的效果
        var transform = CATransform3DIdentity
        /// 你可以百度CATransform3D的m11到m44的含义
        transform.m34 = -1/400.0  //m34是眼睛离屏幕的距离(透视效果),数值越小，表示你离屏幕的距离越近，图像自然就越大。这是三阶矩阵中的元素。
        
        if abs(angle) >= CGFloat.pi {
            /// 上半部分图片复位
            ///usingSpringWithDamping参数：弹性系数，越小弹性越大
            /// initialSpringVelocity：初始弹簧速度
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn) {
                [weak self] in
                self?.turnGradient.opacity = 0
                self?.turnImgV.layer.transform = CATransform3DIdentity
            } completion: { flag in }
            
        }else {
            turnImgV.layer.transform = CATransform3DRotate(transform, -angle, 1, 0, 0)
        }
        
    }
    
}


//MARK: - 设置测试的UI
extension TestImageView_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        imgView1.layer.borderWidth = 1.0
        imgView1.layer.borderColor = UIColor.gray.cgColor
        imgView1.image = image1
        self.view.addSubview(imgView1)
        imgView1.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(240)
        }
        
        //TODO: 做图片翻转重叠,只显示部分图片
        /// 也是比例坐标，只显示部分图片内容。显示上半部分的图片。
        turnImgV.layer.contentsRect = CGRect.init(x: 0, y: 0, width: 1, height: 0.5)
        self.view.addSubview(turnImgV)
        self.view.addSubview(turnImgV2)
        /// 只显示部分图片内容。显示下半部分的图片。
        turnImgV2.layer.contentsRect = CGRect.init(x: 0, y: 0.5, width: 1, height: 0.5)
        
        /// 以锚点为中心进行旋转的，所以你要设置锚点。设置锚点之后，view的frame回发生变化，因为view的布局本来是根据锚点和position进行计算的。
        turnImgV.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        turnImgV2.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        /// 手势的容器view
        turnImgV.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20 + 100)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        /// 因为锚点已经设置了，所以重叠是刚刚好。
        turnImgV2.snp.makeConstraints { make in
            make.edges.equalTo(turnImgV.snp.edges)
        }
        turnImgV.isHidden = true
        turnImgV2.isHidden = true
        
        // 测试图片倒影的View
        self.view.addSubview(imgInvertView)
        imgInvertView.layer.borderWidth = 1
        imgInvertView.layer.borderColor = UIColor.gray.cgColor
        imgInvertView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20 + 100)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(400)
        }
        imgInvertView.isHidden = true
        
    }
    
    /// 隐藏其他的view
    func hideOtherView(curView:UIView?){
        for subV in self.view.subviews {
            subV.isHidden = true
        }
        curView?.isHidden = false
        baseCollView.isHidden = false
    }
    
}


//MARK: - 设计UI
extension TestImageView_VC {
    
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
extension TestImageView_VC: UICollectionViewDelegate {
    
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
    1、拉伸图片，但是保护某些区域不被拉伸，用image的resizableImage方法，一般就拉伸最中间的一个像素而已。这个应用于纯色的背景图片就可以。这一个像素用于均匀填充拉伸区域(默认平铺)。
        1、平铺是直接copy没有被保护的区域的像素，像铺砖一样平铺到拉伸的区域。
        2、拉伸是将没有保护的区域的像素，同比拉长放大延伸到拉伸的区域。
 
    2、图片的类型可以根据图片的二进制流，的第一个字节的值来判断是jpg还是png这些。
 
 */

