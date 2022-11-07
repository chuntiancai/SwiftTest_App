//
//  TestQRCode_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/31.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试二维码的VC
// MARK: - 笔记
/**
    1、二维码简介：
        用平面图形记录数据符号信息，即图形存储数据。
    2、生成二维码：
            需要导入CoreImage框架，用于过滤图片。用到CIFilter类，这是Core Image中一个比较核心的有关滤镜使用的类。
            滤镜的使用是可以叠加的，我们可以使用多种滤镜处理同一个图像。
            输出图像的生产过程需要我们通过设置一些参数来实现，而这些参数的设置和检索都是利用键/值对的形式进行操作的。
    3、
 
 
 */

import CoreImage
import AVFoundation //摄像头用到。

class TestQRCode_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    let imgView = UIImageView() //展示二维码的图片view。
    let qrCodeScanLine = UIImageView(image: UIImage(named: "qrcode_scanline"))  //动画的扫描横线
    let textView = UITextView() //展示二维码数据的文本view。
    
    lazy var session : AVCaptureSession = AVCaptureSession()    //摄像头输入输出中间桥梁(会话)
    let metadataOutput = AVCaptureMetadataOutput()//摄像头扫描到的原数据的输出对象
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试二维码的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestQRCode_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestQRCode_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试生成二维码。
            /**
             步骤：
             1、主要是通过系统CoreImage框架的CIFilter类来生成二维码图片，但是生成的是CIImage?图片，需要转换为UIImage。
             2、先恢复滤镜CIFilter的默认设置，然后再通过KVC的方式设置CIFilter的属性、数据。
             3、CIFilter更加属性和传入的数据，生成CIImage图片。
             4、生成的二维码图片分辨率太小，则需要通过CGAffineTransform进行放大。
             5、利用UIGraphicsBeginImageContext图片上下文来绘制二维码中的头像，头像建议不能超过二维码的1/20，否则会影响读码。
             
             扩展：
             */
            print("     (@@ 0、测试生成二维码。")
            // 1. 创建二维码滤镜
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            // 1.1 恢复滤镜默认设置
            filter?.setDefaults()
            
            // 2. 设置滤镜输入数据,KVC
            let inputStr =  "生成二维码的测试数据，123456"
            let data = inputStr.data(using: .utf8)
            filter?.setValue(data, forKey: "inputMessage")
            
            /// 2.2 设置二维码的纠错率，L：7%的字码可以被修正，M：15%，Q：25%，H：30% //越高图像越密集，扫描时间越长。
            filter?.setValue("M", forKey: "inputCorrectionLevel")
            
            // 3. 从二维码滤镜里面, 获取结果图片
            var image:CIImage? = filter?.outputImage
            print("image type:\(type(of: image))")
            
            
            // 借助这个方法, 处理成为一个高清图片
            let transform = CGAffineTransform(scaleX: 20, y: 20)
            image = image?.transformed(by: transform)
            
            /// 3.1 图片处理,CGImage转换为UIImage。 (23.0, 23.0)
            var resultImage:UIImage = UIImage(ciImage: image!)
            
            
            // 前景图片
            let centerImage = UIImage(named: "labi09")  //可以选择设置放在二维码中国的头像。
            
            if centerImage != nil {
                let size = resultImage.size
                // 1. 开启图形上下文
                UIGraphicsBeginImageContext(size)
                
                // 2. 绘制大图片
                resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                
                // 3. 绘制小图片
                let width: CGFloat = 80
                let height: CGFloat = 80
                let x: CGFloat = (size.width - width) * 0.5
                let y: CGFloat = (size.height - height) * 0.5
                centerImage!.draw(in: CGRect(x: x, y: y, width: width, height: height))
                
                // 4. 取出结果图片
                resultImage = UIGraphicsGetImageFromCurrentImageContext()!
                
                // 5. 关闭上下文
                UIGraphicsEndImageContext()
            }
            
            // 4. 显示图片
            imgView.image = resultImage
            
            
            
        case 1:
            //TODO: 1、识别图片里的二维码。
            /**
             步骤：
                1、把需要识别的图片转换为CIImage。
                2、创建二维码探测器CIDetector，也可以用来人脸识别。
                3、获取CIDetector识别图片后的特征数据,CIFeature数组。
                4、CIFeature数组的元素转换为CIQRCodeFeature，取出图片中二维码的信息。
                    
             基础：
                1、UIImage的坐标原点是在左下角，CIQRCodeFeature的坐标系是参考UIImage的，所以要做坐标系的转换。
                2、我也不知道为什么要真机才能识别。
             */
            print("     (@@ 1、识别图片里的二维码。")
            
            // 1、 获取需要识别的图片,我在这里是直接截屏当前View的图片。
           
            imgView.image = UIImage(named: "qrcode_test")
            imgView.contentMode = .scaleAspectFill
            imgView.snp.remakeConstraints { make in
                make.top.equalTo(10)
                make.width.equalTo(380)
                make.height.equalTo(220)
                make.centerX.equalToSuperview()
            }
            
            let image:UIImage! = imgView.image
            if image == nil { print("没有获取到view图片"); return}
            let imageCI = CIImage(image: image) //UIImage转换为CIImage；
            
            // 2、开始识别
            /// 2.1. 创建一个二维码探测器，不仅可以探测二维码，也可以人脸识别。
            let dector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
            
            /// 2.2. 直接探测二维码特征
            let features:[CIFeature] = dector!.features(in: imageCI!)
            
            var result = [String]()
            for feature in features {
                let qrFeature = feature as! CIQRCodeFeature
                result.append(qrFeature.messageString!)  //特征的文字信息。
                
                print("识别到的二维码特征:\(qrFeature.messageString!)")
                // 根据一个图片的特征, 以及图片, 来绘制图片中二维码的边框。
                let size = image.size
                
                // 1. 开启图形上下文
                UIGraphicsBeginImageContext(size)
                
                // 2. 绘制大图片
                image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                
                // 转换 图形上下文 的坐标系(上下颠倒)
                let context = UIGraphicsGetCurrentContext()
                context!.scaleBy(x: 1, y: -1)
                context!.translateBy(x: 0, y: -size.height) ///转换原点坐标的位置。
                
                // 3. 绘制路径
                let bounds = feature.bounds //二维码特征的bounds
                let path = UIBezierPath(rect: bounds)
                UIColor.red.setStroke()
                path.lineWidth = 6
                path.stroke()
                
                // 4. 取出结果图片
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                // 5. 关闭上下文
                UIGraphicsEndImageContext()
                
                // 描绘好边框的图片
                imgView.image = resultImage
                
            }
            
            
            // 结果字符串
            textView.text = result.reduce("", { (pre:String, next:String) in
                return pre + "\n" + next
            })
            
            
        case 2:
            //TODO: 2、测试二维码的扫描的动画。
            /**
                1、snpkit的动画效果，必须调用view.layoutIfNeeded()方法，来立马赋值给约束。
             */
            print("     (@@ 2、测试二维码的扫描的动画。")
            imgView.image = UIImage(named: "qrcode_border")
            imgView.addSubview(qrCodeScanLine)
            imgView.clipsToBounds = true
            qrCodeScanLine.snp.makeConstraints { make in
                make.height.equalToSuperview()
                make.bottom.equalTo(self.imgView.snp.top).offset(0)
                make.left.right.equalToSuperview()
            }
            self.view.layoutIfNeeded()  //调用该方法，给snpkit赋值，不然snpkit没有值。
            
            UIView.animate(withDuration: 2, delay: 0, options: [.repeat,.curveEaseIn]) {
                self.qrCodeScanLine.snp.updateConstraints { make in
                    make.bottom.equalTo(self.imgView.snp.top).offset(self.imgView.bounds.size.height * 2)
                }
                self.view.layoutIfNeeded()
            } completion: { isfinish in
                print("动画完成了。")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
                print("动画停止了。")
                self.qrCodeScanLine.layer.removeAllAnimations()
            }
            
            
        case 3:
            //TODO: 3、测试二维码扫描功能。
            /**
             步骤：
             0、先在info.plist请求摄像头的权限，key：NSCameraUsageDescription。
             1、创建输入设备(摄像头)：获取摄像头设备AVCaptureDevice，创建输入对象AVCaptureDeviceInput。摄像头作为输入的输入设备。
             
             2、创建输出设置(元数据)： 创建输出对象、设置输出对象的代理(在代理中获取扫描到的数据)、设置输出数据的类型。
             
             3、创建捕捉会话：将输入、输出都添加到会话中。
                 会话主要用于连接摄像头的输入与输出，是桥梁作用。
             
             4、添加预览图片(方便用于查看)：创建图层,将图片添加到View图层中。
             
             5、设置输出对象的有效识别区域，注意：摄像头是横屏，右上角为原点的。(镜像对称的问题)
                rectOfInterest属性：是相对输出图像大小的比例，而不是相对设备或者预览图层AVCaptureVideoPreviewLayer的比例。
                                   输出图像大小又是由AVCaptureVideoPreviewLayer的videoGravity属性决定的，类似UIview的contentMode。
                                   由于是相对于输出图像大小的比例，所以要转换成像素比例，这就涉及到videoGravity和分辨率了。
                                   然后默认坐标系是横屏的，你扫描是竖屏，所以还要再将坐标系选装90度。
             
                metadataOutputRectOfInterestForRect方法：
                                   这是输出对象AVCaptureOutput的方法，目的在于将摄像头捕获到的图像的坐标系，转换为元数据输出对象的坐标系。
             
             
             */
            print("     (@@ 3、测试二维码扫描功能。")
            
            //1.获取输入设备（摄像头）
            guard let device = AVCaptureDevice.default(for: .video) else {
                print("获取摄像头失败。")
                return
            }
            
            //2.根据输入设备创建输入对象
            guard let deviceInput:AVCaptureDeviceInput = try? AVCaptureDeviceInput(device: device) else {
                print("创建输入对象失败。")
                return
            }
            
            //3.创建原数据的输出对象
//            let metadata  Output = AVCaptureMetadataOutput()
            
            //4.设置代理监听输出对象输出的数据，在主线程中刷新
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            //5.创建会话（桥梁）
            //        let session = AVCaptureSession()
            
            //6.添加输入和输出到会话
            if session.canAddInput(deviceInput) && session.canAddOutput(metadataOutput) {
                print("添加输入、输出到会话中")
                session.addInput(deviceInput)
                session.addOutput(metadataOutput)
            }else{
                print("添加输入输出失败")
                return
            }
            
            //7.告诉输出对象要输出什么样的数据(二维码还是条形码),必须要在输出添加到会话之后, 才可以设置, 不然,崩溃
            metadataOutput.metadataObjectTypes = [.qr,.code128, .code39, .code93, .code39Mod43, .ean8, .ean13, .upce, .pdf417, .aztec]
            
            
            //8.创建预览图层
            let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame =  imgView.bounds
            imgView.layer.insertSublayer(previewLayer, at: 0)
//
//            let kScreenHeight = UIScreen.main.bounds.size.height
//            let kScreenWidth = UIScreen.main.bounds.size.width
//            //9.设置有效扫描区域(默认整个屏幕区域)（每个取值0~1, 以屏幕右上角为坐标原点）
//            let rect = CGRect(x: imgView.frame.minX / kScreenWidth, y: imgView.frame.minY / kScreenHeight,
//                              width: imgView.frame.width / kScreenWidth, height: imgView.frame.height / kScreenHeight)
//            metadataOutput.rectOfInterest = rect
            
            
            //10. 开始扫描
            session.startRunning()
            let interestRect = metadataOutput.metadataOutputRectConverted(fromOutputRect: previewLayer.frame)
            print("捕获到的图像坐标系，转换为有效坐标系：\(interestRect)")
//            metadataOutput.rectOfInterest  = interestRect
            
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
//MARK: - 遵循摄像头输入输出的协议，AVCaptureMetadataOutputObjectsDelegate协议
extension TestQRCode_VC: AVCaptureMetadataOutputObjectsDelegate{
    
   //TODO:扫描到结果之后回调。
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print("扫描到二维码结果回调的代理方法：\(#function)")
        //1. 取出扫描到的数据: metadataObjects
        //2. 以震动的形式告知用户扫描成功
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        //3. 关闭session
        session.stopRunning()

        //4. 遍历结果
        var resultArr = [String]()
        for result in metadataObjects {
            //转换成机器可读的编码数据
            if let code = result as? AVMetadataMachineReadableCodeObject {
                resultArr.append(code.stringValue ?? "")
            }else {
                resultArr.append(result.type.rawValue)
            }
        }
        
        let restr = resultArr.reduce("", { (pre:String, next:String) in
            return pre + " " + next
        })
        textView.text = restr
        //5. 将结果
        print("扫描结果：\(resultArr)")
    }
    
    // 扫描到结果之后调用
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        print("扫描到二维码结果回调的代理方法：\(#function)")
        
    }
    
    
}


//MARK: - 设置测试的UI
extension TestQRCode_VC{
    
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
        
        //TODO: 初始化UI，一个图片，一个文本的控件。
        bgView.addSubview(imgView)
        imgView.layer.borderColor = UIColor.brown.cgColor
        imgView.layer.borderWidth = 1.0
        imgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(38)
            make.height.width.equalTo(180)
            make.centerX.equalToSuperview()
        }
        
        bgView.addSubview(textView)
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1.0
        textView.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(38)
            make.height.equalTo(200)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
    }
    
}


//MARK: - 设计UI
extension TestQRCode_VC {
    
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
extension TestQRCode_VC: UICollectionViewDelegate {
    
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
