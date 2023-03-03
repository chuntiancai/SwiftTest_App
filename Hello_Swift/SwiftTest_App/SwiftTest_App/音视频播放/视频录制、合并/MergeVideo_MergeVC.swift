//
//  MergeVideo_MergeVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2023/2/23.
//  Copyright © 2023 com.mathew. All rights reserved.
//
// 合并视频的VC

import MediaPlayer
import MobileCoreServices
import Photos

class MergeVideo_MergeVC: UIViewController,UINavigationControllerDelegate {
    
    var firstAsset: AVAsset?
    var secondAsset: AVAsset?
    var audioAsset: AVAsset?
    var loadingAssetOne = false
    
    var loadBtn = UIButton()
    var loadBtn2 = UIButton()
    var loadAudioBtn = UIButton()
    var mergeSaveBtn = UIButton()

    
    var activityMonitor: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 布置UI
        self.view.backgroundColor = .brown
        self.title = "合并视频的VC"
        self.view.addSubview(activityMonitor)
        activityMonitor.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        let btnArr = [loadBtn,loadBtn2,loadAudioBtn,mergeSaveBtn]
        for index in 0 ..< btnArr.count {
            let curBtn = btnArr[index]
            curBtn.titleLabel?.textColor = UIColor.black
            curBtn.titleLabel?.font  = .systemFont(ofSize: 22)
            self.view.addSubview(curBtn)
            curBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.height.equalTo(60)
                make.width.equalTo(200)
                make.top.equalToSuperview().offset(index * 70 + 80)
            }
        }
        loadBtn.setTitle("loadBtn1", for: .normal)
        loadBtn.addTarget(self, action: #selector(loadAssetOne(_:)), for: .touchUpInside)
        loadBtn2.setTitle("loadBtn2", for: .normal)
        loadBtn2.addTarget(self, action: #selector(loadAssetTwo(_:)), for: .touchUpInside)
        loadAudioBtn.setTitle("loadAudioBtn", for: .normal)
        loadAudioBtn.addTarget(self, action: #selector(loadAudio(_:)), for: .touchUpInside)
        mergeSaveBtn.setTitle("mergeSaveBtn", for: .normal)
        mergeSaveBtn.addTarget(self, action: #selector(merge(_:)), for: .touchUpInside)
    }
    
    //TODO: 导出合并的视频资产到手机
    /// 导出合并的视频资产到手机
    func exportDidFinish(_ session: AVAssetExportSession) {
        // Cleanup assets
        activityMonitor.stopAnimating()
        firstAsset = nil
        secondAsset = nil
        audioAsset = nil
        
        ///
        guard session.status == AVAssetExportSession.Status.completed,
              let outputURL = session.outputURL
        else { return }
        
        ///保存视频的闭包。
        let saveVideoToPhotos:() -> Void = {
            let changes: () -> Void = {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
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
        
        // Ensure permission to access Photo Library
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized { saveVideoToPhotos()  }
            }
        } else {
            saveVideoToPhotos()
        }
    }
    
    /// 判断是否可以保持媒体资源到相册
    func savedPhotosAvailable() -> Bool {
        guard !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        else { return true }
        
        let alert = UIAlertController(  title: "Not Available",  message: "No Saved Album found", preferredStyle: .alert)
        alert.addAction(UIAlertAction(  title: "OK", style: UIAlertAction.Style.cancel,  handler: nil))
        present(alert, animated: true, completion: nil)
        return false
    }
    
    @objc func loadAssetOne(_ sender: AnyObject) {
        if savedPhotosAvailable() {
            loadingAssetOne = true
            MergeVideo_VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
        }
    }
    
    @objc func loadAssetTwo(_ sender: AnyObject) {
        if savedPhotosAvailable() {
            loadingAssetOne = false
            MergeVideo_VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
        }
    }
    
    // TODO: 加载音频
    @objc func loadAudio(_ sender: AnyObject) {
        let mediaPickerController = MPMediaPickerController(mediaTypes: .any)
        mediaPickerController.delegate = self
        mediaPickerController.prompt = "Select Audio"
        present(mediaPickerController, animated: true, completion: nil)
    }
    
    // TODO: 合并视频
    @objc func merge(_ sender: AnyObject) {
        guard let firstAsset = firstAsset,
              let secondAsset = secondAsset
        else { return }
        
        activityMonitor.startAnimating()
        
        // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        // 创建资源集合composition及可编辑轨道
        let mixComposition = AVMutableComposition()
        
        // 2 - 创建两个空的视频合成轨道。Create two video tracks。kCMPersistentTrackID_Invalid 自动创建随机ID
        guard let firstTrack: AVMutableCompositionTrack = mixComposition.addMutableTrack( withMediaType: .video,
                                                            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        else { return  }
        
        do {
            //2.1 把源视频的轨道的时间信息放入到合成轨道对象中。
            try firstTrack.insertTimeRange( CMTimeRangeMake(start: .zero, duration: firstAsset.duration),
                                            of: firstAsset.tracks(withMediaType: .video)[0], at: .zero)
        } catch {
            print("Failed to load first track")
            return
        }
            /// 创建第二个视频的合成轨道对象。
        guard  let secondTrack: AVMutableCompositionTrack = mixComposition.addMutableTrack(
                                                                            withMediaType: .video,
                                                                            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        else { return }
        
        do {
            //2.2 把第二个源视频的轨道的时间信息放入到 第二个合成轨道对象中。
            try secondTrack.insertTimeRange( CMTimeRangeMake(start: .zero, duration: secondAsset.duration),
                of: secondAsset.tracks(withMediaType: .video)[0],
                at: firstAsset.duration)
            
        } catch {
            print("Failed to load second track")
            return
        }
        
       
        
        //3 - 视频图层编辑指令对象。用合成指令对象处理视频的帧的方向、裁剪等问题。
        let firstInstruction:AVMutableVideoCompositionLayerInstruction = MergeVideo_VideoHelper.videoCompositionInstruction( firstTrack,  asset: firstAsset)
        firstInstruction.setOpacity(0.0, at: firstAsset.duration)
        let secondInstruction = MergeVideo_VideoHelper.videoCompositionInstruction( secondTrack,  asset: secondAsset)
        
        
        // 4 - 视频合并的指令对象。Composition Instructions。
        /// - 把所有指令对象添加到总的指令对象中，并添加到组合对象中。Add all instructions together and create a mutable video composition。
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake( start: .zero, duration: CMTimeAdd(firstAsset.duration, secondAsset.duration))
        mainInstruction.layerInstructions = [firstInstruction, secondInstruction]
        
        /// 资产组合对象，主要用于合成
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainComposition.renderSize = CGSize( width: UIScreen.main.bounds.width,  height: UIScreen.main.bounds.height)
        
        // 5 - Audio track，音频轨道
        if let loadedAudioAsset = audioAsset {
            let audioTrack = mixComposition.addMutableTrack( withMediaType: .audio, preferredTrackID: 0)
            do {
                try audioTrack?.insertTimeRange(
                    CMTimeRangeMake( start: CMTime.zero, duration: CMTimeAdd( firstAsset.duration, secondAsset.duration)),
                    of: loadedAudioAsset.tracks(withMediaType: .audio)[0],
                    at: .zero)
            } catch {
                print("Failed to load Audio track")
            }
        }
        
        // 7 - Get path，获取存储文件的路径
        guard let documentDirectory = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask).first
        else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: Date())
        let url = documentDirectory.appendingPathComponent("mergeVideo-\(date).mov")
        
        // TODO: 创建资产导出的会话对象。
        guard let exporter = AVAssetExportSession( asset: mixComposition, presetName: AVAssetExportPresetMediumQuality)
        else { return }
        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = mainComposition
        
        // 9 - Perform the Export，异步执行 导出资产 的动作。
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                self.exportDidFinish(exporter)
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate ，选择相册资源的回调协议
extension MergeVideo_MergeVC: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        dismiss(animated: true, completion: nil)
        /// 获取视频资产
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String, mediaType == (kUTTypeMovie as String),
              let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        else { return }
        
        let avAsset = AVAsset(url: url)
        var message = ""
        if loadingAssetOne {
            message = "Video one loaded"
            firstAsset = avAsset
        } else {
            message = "Video two loaded"
            secondAsset = avAsset
        }
        let alert = UIAlertController(  title: "Asset Loaded", message: message,  preferredStyle: .alert)
        alert.addAction(UIAlertAction( title: "OK", style: UIAlertAction.Style.cancel,  handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}


// MARK: - MPMediaPickerControllerDelegate, 选择媒体资源协议
extension MergeVideo_MergeVC: MPMediaPickerControllerDelegate {
    func mediaPicker(
        _ mediaPicker: MPMediaPickerController,
        didPickMediaItems mediaItemCollection: MPMediaItemCollection
    ) {
        dismiss(animated: true) {
            let selectedSongs = mediaItemCollection.items
            guard let song = selectedSongs.first else { return }
            
            let title: String
            let message: String
            if let url = song.value(forProperty: MPMediaItemPropertyAssetURL) as? URL {
                self.audioAsset = AVAsset(url: url)
                title = "Asset Loaded"
                message = "Audio Loaded"
            } else {
                self.audioAsset = nil
                title = "Asset Not Available"
                message = "Audio Not Loaded"
            }
            
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: 处理视频信息的工具方法
enum MergeVideo_VideoHelper {
    
    
    //MARK: - 调整视频方向，并返回视频合成指令
    /**
     1、这里主要是调整视频轨道的方向，用到仿射矩阵，我也不是很懂矩阵相乘这些了。
     */
    static func videoCompositionInstruction( _ track: AVCompositionTrack, asset: AVAsset ) -> AVMutableVideoCompositionLayerInstruction {
        // 创建轨道的组合指令对象。layerInstruction 用于更改视频图层。
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        
        // 从资产中获取视频轨道对象。
        let assetTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        let transform = assetTrack.preferredTransform
        let assetInfo = orientationFromTransform(transform) //获取视频的方向
        
        var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width
        
        /// 垂直拍摄，但是不代表视频是垂直的。因为有的视频就是很恶心。
        if assetInfo.isPortrait {
            scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
            
            let scaleFactor = CGAffineTransform( scaleX: scaleToFitRatio,  y: scaleToFitRatio)
            /// 矩阵相乘，将第一个坐标系中所有的点映射到第二个坐标系中去。
//            instruction.setTransform( assetTrack.preferredTransform.concatenating(scaleFactor), at: .zero)
            instruction.setTransform( CGAffineTransform.identity, at: .zero)
        } else {
            let scaleFactor = CGAffineTransform( scaleX: scaleToFitRatio, y: scaleToFitRatio)
            var concat = assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(CGAffineTransform( translationX: 0,
                    y: UIScreen.main.bounds.width / 2))
            if assetInfo.orientation == .down {
                let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                let windowBounds = UIScreen.main.bounds
                let yFix = assetTrack.naturalSize.height + windowBounds.height
                let centerFix = CGAffineTransform( translationX: assetTrack.naturalSize.width, y: yFix)
                concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
            }
//            instruction.setTransform(concat, at: .zero)
            instruction.setTransform( CGAffineTransform.identity, at: .zero)
        }
        
        return instruction
    }
    
    //MARK: - 从仿射变换矩阵中获取图像的方向。
    /**
     1、UIImage.Orientation方向指的是拍摄时，感光传感器的方向，并非图片的方向。
        横屏逆时针旋转90度时，手机后摄像头的感光传感器为正方向，前置摄像头是镜像方向。正常拿着手机竖屏拍摄时，传感器为右方向。
     2、这里是返回资产的方向和给人看的手机方向。
     */
    static func orientationFromTransform(  _ transform: CGAffineTransform ) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
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
        return (assetOrientation, isPortrait)
    }
    
    //MARK: - 浏览并获取手机上的媒体
    /// 浏览并获取手机上的媒体
    static func startMediaBrowser( delegate: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate,
        sourceType: UIImagePickerController.SourceType ) {
            guard UIImagePickerController.isSourceTypeAvailable(sourceType)
            else { return }
            
            let mediaUI = UIImagePickerController()
            mediaUI.sourceType = sourceType
            mediaUI.mediaTypes = [kUTTypeMovie as String]
            mediaUI.allowsEditing = true
            mediaUI.delegate = delegate
            /// 弹窗浏览手机上的媒体
            delegate.present(mediaUI, animated: true, completion: nil)
        }
    
    
}
