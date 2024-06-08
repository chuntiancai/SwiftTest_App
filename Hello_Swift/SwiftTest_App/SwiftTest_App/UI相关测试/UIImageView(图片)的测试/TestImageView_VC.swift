//
//  TestImageView_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/13.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试图片相关的功能VC

// MARK: - 图片的渲染流程
/**
    1、图片从硬盘到屏幕的加载渲染流程：
            读取文件->计算Frame->图片解码->解码后纹理图片位图数据通过数据总线交给GPU->GPU获取图片Frame->顶点变换计算->光栅化
            ->根据纹理坐标获取每个像素点的颜色值(如果出现透明值需要将每个像素点的颜色*透明度值)->渲染到帧缓存区->渲染到屏幕
 
        1.当我们+imageWithContentsOfFile: 方法从磁盘中加载一张图片，这个时候的图片并没有解压缩，此时图片是JPG、或者是PNG格式的数据，
            这些格式是一种压缩格式，也就是完整的图片数据是需要包括每个像素点的位图数据的，而JPG这些格式则是对图片的所有数据进行了压缩。
 
        2.创建一个 UlImage 实例只会加载 Data Buffer，将图像显示到屏幕上才会触发解码，也就是 Data Buffer 解码为 Image Buffer，
            Image Buffer 也关联在 Ullmage 上，Ullmage 关联的图像是否已解码对外部是不透明的。(完整的图像数据信息)
        
            解码就是从 Data Buffer 生成 Image Buffer 的过程。 而Image Buffer 之后会上传到 GPU 成为 Frame Buffer。
            所以CGImage是解码后的位图数据，而不是将要渲染的帧缓存数据。
            当时你可以开线程单独对图片的压缩数据进行解压，然后使用解压后的数据来显示到屏幕上，这样就可以减少解压造成的性能消耗过大问题。
 
        3.渲染流程是通过GPU来操作的：
            GPU获得CPU的解压数据和frame坐标信息之后，就会对解压后的数据转换成硬件能过理解的数据信息，也就是frame Buffer，这个过程是在GPU中
            完成的，GPU 以每秒 60 次的速度使用 Frame Buffer 更新屏幕。
             1.GPU获取获取图片的坐标
             2.将坐标交给顶点着色器(顶点计算) //就是计算图片的关键几个顶点位置信息。
             3.将图片光栅化(获取图片对应屏幕上的像素点)    //是将矢量图形数据转换为由像素表示的栅格图像，三维图形数据转换为二维屏幕上的像素表示。
             4.片元着色器计算(计算每个像素点的最终显示的颜色值)
             5.从帧缓存区中渲染到屏幕上 //GPU处理完的位图数据，会先放在帧缓存里，然后通过帧缓存给到显示器进行显示。
 
    2、屏幕卡顿的本质：
        手机使用卡顿的直接原因，就是掉帧，屏幕刷新频率必须要足够高才能流畅。对于 iPhone 手机来说，屏幕最大的刷新频率是 60 FPS，一般只要保证 50 FPS 就已经是较好的体验了。但是如果掉帧过多，导致刷新频率过低，就会造成不流畅的使用体验。

        屏幕卡顿的根本原因：CPU 和 GPU 渲染流水线耗时过长，导致掉帧。
        也是就我已经要显示下一帧图片的了，但是下一帧的数据还没计算好，因为垂直同步锁定，导致现在还是显示上一帧的数据，所以造成了卡顿。
 
        Vsync 与双缓冲的意义：强制同步屏幕刷新，以掉帧为代价解决屏幕撕裂问题。
 
        三缓冲的意义：合理使用 CPU、GPU 渲染性能，减少掉帧次数。就是用三层帧缓存给显示器来渲染，不要显示器傻傻地等一个帧缓存数据。
 
    3、与GPU相关的框架API：
        GPU Driver(接近APP的抽象接口)--> OpenGL(接近硬件的接口) --> Core Graphics、Core Animation、Core Image(扩展硬件的三个框架)
        上面的三个层次的框架是一种大概的封装关系(都是软件框架)，有可能相互调用，并不是严格的包裹封装，只是提供了不同的便利性。
 
        也就是Core Graphics、Core Animation、Core Image是对OpenGL标准的整理组合分类的封装，以专一地实现不同的图形处理功能。
        
        GPU Driver：GPU Driver 是直接和 GPU 交流的代码块，直接与 GPU 连接，所有框架最终都会通过 OpenGL 连接到 GPU Driver。
 
        OpenGL：是一个提供了 2D 和 3D 图形渲染的 API，也就是一套标准。OpenGL 之上扩展出很多东西，如 Core Graphics 等最终都依赖于 OpenGL。
                OpenGL的高效实现（利用了图形加速硬件）一般由显示设备厂商提供，而且非常依赖于该厂商提供的硬件。
 
        Core Graphics：Core Graphics 是一个强大的二维图像绘制引擎，是 iOS 的核心图形库，常用的比如 CGRect 就定义在这个框架下。

        Core Animation：本质上可以理解为一个复合引擎，主要职责包含：渲染、构建和实现动画(不仅仅是动画)，几乎所有iOS的东西都是它绘制出来的。

        Core Image：Core Image 是一个高性能的图像处理分析的框架，它拥有一系列现成的图像滤镜，能对已存在的图像进行高效的处理。
        
        Metal标注：Metal 类似于 OpenGL ES，也是一套第三方标准，具体实现由苹果实现。
                  Core Animation、Core Image、SceneKit、SpriteKit 等等渲染框架都是构建于 Metal 之上的。
 
 */

//MARK: - CALayer的本质
/**
    1、CALayer 是显示的基础：存储 bitmap(位图)
        CALayer 有这样一个属性 contents，contents 提供了 layer 的内容，是一个指针类型，在 iOS 中的类型就是 CGImageRef。
        而CGImageRef就是位图数据的结构体，CGImage就是CGImageRef的别名。
        drawRect: 方法就是使用了CALayer.contents 中的CGImage位图数据进行绘制渲染的。
 
    2、CALayer 中的 contents 属性保存了由设备渲染流水线渲染好的位图 bitmap（通常也被称为 backing store），而当设备屏幕进行刷新时，
        会从 CALayer 中读取生成好的 bitmap，进而呈现到屏幕上
 
 */

//MARK: - UIView 与 CALayer 的关系
/**
    1、UIView相当于CALayer的管理者，或者说代理者，UIView负责内容的渲染以及，处理交互事件。而CALayer 的主要职责是管理内部的可视内容。
        UIiew主要负责，利用CALayer绘制与动画、负责自身布局与子 view 的管理、负责点击事件处理。
 
    2、当我们创建一个 UIView 的时候，UIView 会自动创建一个 CALayer，为自身提供存储 bitmap 的地方（也就是前文说的 backing store），
        并将自身固定设置为 CALayer 的代理。
        UIView 只对 CALayer 的部分功能进行了封装，而另一部分如圆角、阴影、边框等特效都需要通过调用 layer 属性来设置。
        CALayer 是 UIView 的属性之一，负责渲染和动画，提供可视内容的呈现。
        CALayer 不负责点击事件，所以不响应点击事件，而 UIView 会响应。
        CALayer 继承自 NSObject，UIView 由于要负责交互事件，所以继承自 UIResponder。
        为什么要将 CALayer 独立出来？为了职责分离，拆分功能，方便代码的复用
 */

//MARK: - 离屏渲染
/**
    1、离屏渲染就是 有一个和帧缓存器一样作用的离屏缓存器，用来存储将要渲染的位图数据(硬件)，缓存器里可以存储多个图层的位图硬件数据信息。
        然后在离屏渲染缓存器，对每个图层进行裁剪，叠加，加工之后，再把数据切换到帧缓存器中，让显示器进行显示。内容切换会需要更长的处理时间。
    
    2、为啥要用到离屏渲染？
        1.需要保存 渲染的中间状态 的一些特殊效果，比如阴影、圆角、蒙版。
            因为这些都是已经计算好渲染的数据之后，你还要进一步对原有的内容(每一层图层)进行加工，叠加处理。
        2.为了效率，可以将内容提前渲染保存在 Offscreen Buffer 中，达到复用的目的。例如手动光栅化。
            开启光栅化后，会触发离屏渲染，Render Server 会强制将 CALayer 的渲染位图结果 bitmap 保存下来，
            这样下次再需要渲染时就可以直接复用，从而提高效率。所以仅仅是需要重复利用的图层才有意义。
            离屏渲染缓存内容有时间限制，缓存内容 100ms 内如果没有被使用，那么就会被丢弃，无法进行复用
 
    3、离屏渲染的常见场景：
        使用了 mask 的 layer (layer.mask)
        需要进行裁剪的 layer (layer.masksToBounds / view.clipsToBounds)
        设置了组透明度为 YES，并且透明度不为 1 的 layer (layer.allowsGroupOpacity/layer.opacity)
        添加了投影的 layer (layer.shadow*)
        采用了光栅化的 layer (layer.shouldRasterize)
        绘制了文字的 layer (UILabel, CATextLayer, Core Text 等)
 */

/**
    1、拉伸图片，但是保护某些区域不被拉伸，用image的resizableImage方法，一般就拉伸最中间的一个像素而已。这个应用于纯色的背景图片就可以。这一个像素用于均匀填充拉伸区域(默认平铺)。
        1、平铺是直接copy没有被保护的区域的像素，像铺砖一样平铺到拉伸的区域。
        2、拉伸是将没有保护的区域的像素，同比拉长放大延伸到拉伸的区域。
 
    2、图片的类型可以根据图片的二进制流，的第一个字节的值来判断是jpg还是png这些。
 
    3、加载bundle里面的图片需要加上bundle的文件名，格式：bundle文件名/图片文件名
 
 */

import Photos

class TestImageView_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    let imgView1 = UIImageView()
    let image1 = UIImage(named: "labi09")!
    let image2 = UIImage(named: "labi11")!
    
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
             2、记得要在info.plist文件中申请访问相册的权限。
            
             2.保存图片到【相机胶卷】
             1> C语言函数UIImageWriteToSavedPhotosAlbum 【不支持自定义相册】
             2> AssetsLibrary框架 （旧，已丢弃）【支持自定义相册】
             3> Photos框架【支持自定义相册】
             
             3、Photos框架。暂时还没支持.webp格式的图片
                1.PHAsset : 一个PHAsset对象就代表相册中的一张图片或者一个视频
                    1> 查 : [PHAsset fetchAssets...]
                    2> 增删改 : PHAssetChangeRequest(包括图片\视频相关的所有改动操作)
                
                2.PHAssetCollection : 一个PHAssetCollection对象就代表一个相册。查询自己做，增删改都通过request去做。
                    1> 查 : [PHAssetCollection fetchAssetCollections...]
                    2> 增删改 : PHAssetCollectionChangeRequest(包括相册相关的所有改动操作)
                
                3.对相片\相册的任何【增删改】操作，都必须放到以下方法的block中执行
                    -[PHPhotoLibrary performChanges:completionHandler:]
                    -[PHPhotoLibrary performChangesAndWait:error:]
             
                4.PHAssetCollection这些东西只能通过类方法来获取，通过增删改查的对象来操作，而不能通过常规的数组字典这些数据结构体获取。
             
                5.每次增删改照片都要新开一个performChanges的block，所以保存照片到根相册是一个操作，添加照片到自定义相册又是另外一个操作。
             
             */
            print("     (@@ 图片保存到手机相册")
            
            // C语言函数，selector的写法是必须满足那三个方法参数的写法，而且要用类名来调用selector方法。
            // 错误信息：-[NSInvocation setArgument:atIndex:]: index (2) out of bounds [-1, 1]
            // 错误解释：参数越界错误，方法的参数个数和实际传递的参数个数不一致
            UIImageWriteToSavedPhotosAlbum(image1, self, #selector(TestImageView_VC.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
            
            //TODO: - Photos框架
            
            // 获取app的名字，查看info.plist的源代码找出字典的key,kCFBundleNameKey = "CFBundleName"
            // 注意C语言的string和swift字符串的转换。
            let appTitle:String = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
            print("获取到的app的名字：\(appTitle)")
            
            // 相册列表
            let results: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
            var phCollection:PHAssetCollection?
            
            // 获取相册列表中 的 自定义相册
            results.enumerateObjects { curCollection, index, isStop in
                print("遍历相册列表：\(index) -- \(isStop) --\(curCollection)")
                // 找到相册
                if curCollection.localizedTitle == appTitle { phCollection = curCollection }
            }

            let phStatus = PHPhotoLibrary.authorizationStatus()
            print("查询到的相册状态：\(phStatus)")
            // 检查相册的权限
            if #available(iOS 14, *) {
                // 如果用户已经做过权限的选择，那么直接执行block里面的代码。否则弹窗出给用户做权限选择
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    print("请求相册权限的结果：\(status.rawValue)")
                }
            } else {
                PHPhotoLibrary.requestAuthorization { status in
                    print("iOS 14之前请求相册权限：\(status.rawValue)")
                }
            }
            
            // 创建自定义相册
            if phCollection == nil {
                do {
                    var albumID:String!
                    // 会阻塞当前线程。
                    try PHPhotoLibrary.shared().performChangesAndWait {
                        print("创建自定义相册")
                        // 创建自定义相册，并获取相册的占位对象。同名的相册也会重复创建。
                        let phObjectPlaceholder = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: appTitle).placeholderForCreatedAssetCollection
                        // 获取相册占位对象的id
                        albumID = phObjectPlaceholder.localIdentifier
                    }
                    if albumID != nil {
                        // 根据相册的id获取到相册
                        phCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumID], options: nil).firstObject
                    }
                    
                } catch let err {  print("创建自定义相册的报错：\(err)") ; break}
            }
            
            // 保存照片到相册，对于照片的增删改操作都必须放在performChanges方法的闭包里面执行。
            var phAssetHolder:PHObjectPlaceholder!  /// 照片的占位对象
            var imgAssetID:String = ""
            
            // 直接存进相册app的根相册中。并获取照片的占位对象
            do {
                try PHPhotoLibrary.shared().performChangesAndWait({
                    print("保存照片到相册～")
                    /// 创建照片的asset，并且获取asset的id，只能通过id来获取到asset。placeholderForCreatedAsset是照片的占位对象。
                    phAssetHolder = PHAssetChangeRequest.creationRequestForAsset(from: self.image2).placeholderForCreatedAsset
                    imgAssetID = phAssetHolder.localIdentifier
                })
            } catch let err {  print("保存照片到相册，的报错：\(err)") }
            
            

            // 添加照片到自定义相册。每一次修改照片都要新开一个performChanges的block
            PHPhotoLibrary.shared().performChanges {
                /// 获取照片的asset
                let imgAsset = PHAsset.fetchAssets(withLocalIdentifiers: [imgAssetID], options: nil)

                /// 把照片的存进自定义相册中，但是照片的本质是在根相册的引用
                let phAssetReq = PHAssetCollectionChangeRequest(for: phCollection!)
                phAssetReq?.addAssets(imgAsset)
//                phAssetReq?.addAssets([phAssetHolder] as NSFastEnumeration)
//                phAssetReq?.insertAssets(imgAsset, at: IndexSet(integer: 0))
                
            } completionHandler: { isSuccess, error in
                print("添加照片到自定义相册成功了吗？：\(isSuccess) -- \(String(describing: error))")
            }

            
        case 4:
            //TODO: 4、从手机相册中选择照片。
            /**
                一、从相册里面选择图片到App中
                1.选择单张图片
                    UIImagePickerController (自带选择界面)、AssetsLibrary框架 (选择界面需要开发者自己搭建)、 Photos框架 (选择界面需要开发者自己搭建)
                
                2.选择多张图片(图片数量 >= 2)
                    AssetsLibrary框架 (选择界面需要开发者自己搭建)、 Photos框架 (选择界面需要开发者自己搭建)
                
                二、利用照相机拍一张照片到App
                    1> UIImagePickerController (自带选择界面)
                    2> AVCapture****，比如AVCaptureSeession
             
                三、用第三方库吧，关键字搜photo，然后语言选OC或者swift，一个一个下载下来看看
             */
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
            let cropImg = (orgImage.cgImage?.cropping(to: CGRect.init(x: 50, y: 100, width: cropWidth, height: cropHeight)))!
            let turnImgV = UIImageView(image: UIImage(cgImage: cropImg))
            self.bgView.addSubview(turnImgV)
            turnImgV.snp.makeConstraints { make in
                make.top.equalTo(imgView1.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
            }
            
            
            
            
            // 1.开启图形上下文
            // 比例因素:当前点与像素比例,0表示自适应
            UIGraphicsBeginImageContextWithOptions(orgImage.size, false, 0)
            // 2.描述裁剪区域,用路径来描述
            let path = UIBezierPath(ovalIn: CGRect(x: -1, y: -1, width: orgImage.size.width , height: orgImage.size.height))
            // 3.设置裁剪区域生效;
            path.addClip()
            // 4.画图片
            orgImage.draw(at: .zero)
            // 5.取出图片
            let drawImg = UIGraphicsGetImageFromCurrentImageContext()!
            // 6.关闭上下文
            UIGraphicsEndImageContext()
            
            //抗锯齿图片的本质就是在图片生成一个透明度为1的像素边框。现在的做法就是把边缘的一个像素留出来，然后再画一张延伸一个像素的同一个图片作为底部背景。
            ///1、留出一个像素空白，并且图片外延一个像素。即截取掉图片外延的一个像素。
            let antialiasRect = CGRect(x: 1.0, y: 1.0, width: drawImg.size.width - 2.0 , height: drawImg.size.height - 2.0)
            UIGraphicsBeginImageContext(antialiasRect.size)
            drawImg.draw(in: CGRect(x: -1.0, y: -1.0, width: drawImg.size.width , height: drawImg.size.height))
            let antialiasImg1 = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            /// 2、图片缩小一个像素渲染。最终的结果就是截取了图片外延的倒数第二个像素的边缘来填充图片的边缘。肉眼看不出是啥。
            UIGraphicsBeginImageContext(drawImg.size)
            antialiasImg1.draw(in: antialiasRect)
            let antialiasImg2 = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let turnImgV2 = UIImageView(image: drawImg)
            self.bgView.addSubview(turnImgV2)
            turnImgV2.snp.makeConstraints { make in
                make.top.equalTo(turnImgV.snp.bottom).offset(10)
                make.left.equalToSuperview().offset(5)
                make.height.width.equalTo(160)
            }
            
            let turnImgV3 = UIImageView(image: antialiasImg2)
            self.bgView.addSubview(turnImgV3)
            turnImgV3.snp.makeConstraints { make in
                make.top.equalTo(turnImgV.snp.bottom).offset(10)
                make.left.equalTo(turnImgV2.snp.right).offset(5)
                make.height.width.equalTo(160)
            }
            
        case 6:
            //TODO: 6、UIImageView只显示部分图片，测试图片重叠动画
            /**
                1、turnImgV2.layer.contentsRect
             */
            print("     (@@ UIImageView只显示部分图片。图片重叠")
            let _ = bgView.subviews.map { $0.removeFromSuperview() }
            
            //上面的图片
            /// 也是比例坐标，只显示部分图片内容。显示上半部分的图片。
            turnImgV.layer.contentsRect = CGRect.init(x: 0, y: 0, width: 1, height: 0.5)
            self.bgView.addSubview(turnImgV)
            self.bgView.addSubview(turnImgV2)
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
            
            //接收手势的view，用于控制两张图片的翻转效果。
            self.bgView.addSubview(turnBgView)
            turnBgView.snp.makeConstraints { make in
                make.top.equalTo(20)
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
            //TODO: 10、图片的渲染模式
            print("     (@@ 10、图片的渲染模式")
            let curImage = UIImage(named: "labi01")?.withRenderingMode(.alwaysOriginal)
            /// 设置为原始的渲染模式之后，图的的通明通道就不会被渲染成渲染色
            imgView1.image = curImage
        case 11:
           
            print("     (@@11、设置图片的抗锯齿")
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
        
        /// 内容背景View，测试的子view这里
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imgView1.layer.borderWidth = 1.0
        imgView1.layer.borderColor = UIColor.gray.cgColor
        imgView1.image = image1
        self.bgView.addSubview(imgView1)
        imgView1.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(240)
        }
        
        
        
        // 测试图片倒影的View
        self.bgView.addSubview(imgInvertView)
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



