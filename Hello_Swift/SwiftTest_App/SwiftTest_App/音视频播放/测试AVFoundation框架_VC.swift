//
//  测试AVFoundation框架_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2023/2/10.
//  Copyright © 2023 com.mathew. All rights reserved.
//
//测试AVFoundation的VC
// MARK: - 笔记
/**
    AVFoundation音视频框架：
    1、，所有与视频音频相关的软硬件控制都在这个框架里面，包括audiovisual assets, control device cameras, process audio, and configure system audio interactions。
    2、AVKit框架是基于AVFoundation框架的进一步封装，用于搭建apple的视频播放界面。AVFoundation的底层框架是core Audio、core Video、core Animation这些。
    3、AVFoundation框架里的常用类：
        > AVPlayer 用于播放音视频。
        > AVPlayerItem 音视频的对象。可以是本地资源，也可以是url资源。
        > AVPlayerLayer 播放显示视频的图层界面。需要添加到View的layer上。
        > AVPlayerViewController 他会帮你去创建显示视频的图层 有调节控件。
 
        AVPlayer(视频播放器) ->去播放AVPlayerItem视频播放的元素 ->展示播放的视图AVPlayerLayer
 
    4、renderSize和naturalSize的区别是：
        naturalSize是视频的原来大小，renderSize是渲染视频时的画布大小，视频会根据画布进行分辨率的放大缩小调整。
        如果你的画布小，视频尺寸大，那么你的视频就会填满整个画布。
        如果你的画布大，视频尺寸小，那么视频就会填充自己的分辨率来适配大的画布，就会变得很小。(因为手机屏幕大小是不变的，画布是可以很大的，视频相对缩小)
        所以renderSize设置为视频大小的话，手机会自动为你调整。如果设置为过大的尺寸的话，就会把视频变得很小播放。
 
    5、视频的轨道的仿射矩阵是 以视频的左上角 为锚点进行缩放旋转的。
 
 */
import AVFoundation
import MobileCoreServices
import Photos

class TestAVFoundation_VC: UIViewController,UINavigationControllerDelegate {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]
    var firstAsset: AVAsset?
    var firstVideoTrack:AVAssetTrack!   //音频轨道
    var secondAsset: AVAsset?

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试AVFoundation的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
        pickAVAsset()
    }
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestAVFoundation_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestAVFoundation_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、选择视频资源。
            /**
                1、从相册选择视频资源，需要遵守协议，并在回调方法中赋值。
             */
            print("     (@@ 0、选择视频资源。")
            pickAVAsset()
        case 1:
            //TODO: 1、测试修改视频的方向和画布。
            /**
            1、renderSize和naturalSize的区别是：
                naturalSize是视频的原来大小，renderSize是渲染视频时的画布大小，视频会根据画布进行分辨率的放大缩小调整。
                如果你的画布小，视频尺寸大，那么你的视频就会填满整个画布。
                如果你的画布大，视频尺寸小，那么视频就会填充自己的分辨率来适配大的画布，就会变得很小。(因为手机屏幕大小是不变的，画布是可以很大的，视频相对缩小)
                所以renderSize设置为视频大小的话，手机会自动为你调整。如果设置为过大的尺寸的话，就会把视频变得很小播放。
             2、视频的轨道的仿射矩阵是 以视频的左上角 为锚点进行缩放旋转的。
             */
            print("     (@@ 1、测试修改视频的方向和画布。")
            
            //1、 媒体资源的组合对象,用于组合AVAsset。
            let composition = AVMutableComposition()
//            composition.naturalSize = firstVideoTrack.naturalSize
            
            //2、通过AVMutableComposition创建空的视频轨道的合成对象
            guard let videoTrackComposition: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: .video,
                                                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))else
            {
                print("通过AVMutableComposition创建空的视频合成轨道对象,失败！")
                return
            }
            
            /// 在空的视频合成轨道对象中添加源视频的轨道信息
            do {
                try videoTrackComposition.insertTimeRange(CMTimeRangeMake(start: .zero, duration: firstAsset!.duration),
                                                          of: firstVideoTrack, at: .zero)
            } catch let err {
                print("添加轨道信息错误：\(err)")
            }
            
           
            //3、 视频图层编辑指令对象
            let videoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrackComposition)
            /// 获取视频的方向矩阵。
            let transform = firstVideoTrack.preferredTransform
            /// 假设视频方向是垂直拍摄。
            var isPortrait = false
            /// 假设home键的方向为在右边
            var assetOrientation = UIImage.Orientation.right
            let tfA = transform.a
            let tfB = transform.b
            let tfC = transform.c
            let tfD = transform.d
            if tfA == 0 && tfB == 1.0 && tfC == -1.0 && tfD == 0 {
                //垂直拍摄
                print("垂直拍摄")
                assetOrientation = .right
                isPortrait = true
            } else if tfA == 0 && tfB == -1.0 && tfC == 1.0 && tfD == 0 {
                //倒立拍摄
                print("倒立拍摄")
                assetOrientation = .left
                isPortrait = true
            } else if tfA == 1.0 && tfB == 0 && tfC == 0 && tfD == 1.0 {
                //Home键右侧水平拍摄
                print("Home键右侧水平拍摄")
                assetOrientation = .up
            } else if tfA == -1.0 && tfB == 0 && tfC == 0 && tfD == -1.0 {
                //Home键左侧水平拍摄
                print("Home键左侧水平拍摄")
                assetOrientation = .down
            }
            //FIXME: 调整视频的方向，这里先是翻转180度。
            let fixUpsideDownMatrix = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
            videoLayerInstruction.setTransform(firstVideoTrack.preferredTransform.concatenating(fixUpsideDownMatrix), at: .zero)
            
            //4、视频合成的指令对象，用于容纳视频图层编辑指令对象。
            let videoCompositionInstruction:AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
            videoCompositionInstruction.timeRange = CMTimeRangeMake(start: .zero, duration: firstAsset!.duration)
            videoCompositionInstruction.layerInstructions = [videoLayerInstruction]
            
            //5、视频组合对象,用于组合视频的AVAsset。用于填充视频导出器。
            let videoComposition:AVMutableVideoComposition = AVMutableVideoComposition()
            videoComposition.instructions = [videoCompositionInstruction]   /// 填写视频编辑合成的指令对象。
            videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
//            videoComposition.renderSize = CGSize( width: UIScreen.main.bounds.width,  height: UIScreen.main.bounds.height)
            videoComposition.renderSize = CGSize( width: firstVideoTrack.naturalSize.width,  height: firstVideoTrack.naturalSize.height)

            //6、创建媒体导出会话，导出编辑后的视频对象。
            /// 导出器的信息都是用编辑对象来填充。
            guard let exportSession = AVAssetExportSession( asset: composition, presetName: AVAssetExportPresetMediumQuality)
            else { print("创建视频导出器失败！");return }
            
            /// 获取存储文件的路径
            guard let documentDirectory = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask).first
            else {  print("获取相册路径失败！"); return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            let date = dateFormatter.string(from: Date())
            let url = documentDirectory.appendingPathComponent("mergeVideo1-\(date).mov")
            
            
            /// 设置导出器属性，填写相关信息。
            exportSession.outputURL = url
            exportSession.outputFileType = AVFileType.mp4
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.videoComposition = videoComposition
            
            /// 异步执行 导出资产 的动作。
            exportSession.exportAsynchronously {
                
                DispatchQueue.main.async
                {
                    [weak self] in
                    
                    print("导出会话的状态：\(exportSession.status.rawValue)")
                    /// 已经导出了合成视频
                    guard exportSession.status == AVAssetExportSession.Status.completed,
                          let outputURL = exportSession.outputURL
                    else { print("上一个视频导出会话还没结束！");return }
                    
                    // Ensure permission to access Photo Library
                    if PHPhotoLibrary.authorizationStatus() != .authorized {
                        PHPhotoLibrary.requestAuthorization { status in
                            print("申请相册访问权限")
                            if status == .authorized { self?.saveVideoToPhotos(outputURL)  }
                        }
                    } else {
                        /// 把合成视频保存到相册
                        self?.saveVideoToPhotos(outputURL)
                    }
                }
            }
            
                
        case 2:
            //TODO: 2、
            print("     (@@ 2、")
        case 3:
            //TODO: 3、
            print("     (@@ 3、")
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
            //TODO: 打印测试信息。
            print("     (@@10、打印测试信息。")
            //naturalSize可以理解为源视频的大小
            print("naturalSize: \(firstVideoTrack.naturalSize)")
            print("preferredTransform: \(firstVideoTrack.preferredTransform)")
            
            
//            print("videoAsset的轨道数组：\(tracks)")
           
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
extension TestAVFoundation_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestAVFoundation_VC{
    
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
extension TestAVFoundation_VC {
    
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

// MARK: - UIImagePickerControllerDelegate ，选择相册资源的回调协议
extension TestAVFoundation_VC: UIImagePickerControllerDelegate{
    
    /// 选择相册资源之后的回调方法。
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        dismiss(animated: true, completion: nil)
        /// 获取视频资产
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String, mediaType == (kUTTypeMovie as String),
              let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        else { return }
        
        let avAsset = AVAsset(url: url)
        print("加载了视频:\(url.lastPathComponent)")
        firstAsset = avAsset
        for curTrack in avAsset.tracks
        {
            if curTrack.mediaType == .video {
                firstVideoTrack = curTrack
                print("videoAsset的视频轨道：\(firstVideoTrack!)")
            }
        }
        
    }
    
    /// 保存媒体资源到相册的指定位置。
    func saveVideoToPhotos(_ toUrl:URL)
    {
        let changes: () -> Void = {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: toUrl)
        }
        PHPhotoLibrary.shared().performChanges(changes) { saved, error in
            DispatchQueue.main.async {
                let success = saved && (error == nil)
                let title = success ? "Success" : "Error"
                let message = success ? "视频保存成功" : "保存视频失败"
                
                let alert = UIAlertController( title: title,  message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "OK",  style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestAVFoundation_VC: UICollectionViewDelegate {
    
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
    
    /// 弹窗从相册挑选资源
    func pickAVAsset(){
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .savedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = self
        /// 弹窗浏览手机上的媒体
        self.present(mediaUI, animated: true, completion: nil)
    }
}
