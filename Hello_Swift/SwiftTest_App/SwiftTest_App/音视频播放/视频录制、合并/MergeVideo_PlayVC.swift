//
//  MergeVideo_PlayVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2023/2/21.
//  Copyright © 2023 com.mathew. All rights reserved.
//测试视频合并的 播放视频的VC
// MARK: - 笔记
/**
 1、
 
 */

import AVKit
import MobileCoreServices

class MergeVideo_PlayVC: UIViewController {
    
    var playBtn:UIButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brown
        playBtn.setTitle("播放", for: .normal)
        playBtn.titleLabel?.textColor = UIColor.red
        playBtn.addTarget(self, action: #selector(playVideo(_:)), for: .touchUpInside)
        self.view.addSubview(playBtn)
        playBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
    }
    
    @objc func playVideo(_ sender: AnyObject) {
        //开始预览相册，从中挑选视频。
        MergeVideo_VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MergeVideo_PlayVC: UIImagePickerControllerDelegate {
     
    // 从相册选择视频，并且附带媒体信息
    func imagePickerController( _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        // 1、挑选类型为视频的媒体类型。
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String, mediaType == (kUTTypeMovie as String),
              let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        else { return }
        
        // 2、展示视频播放页面。
        dismiss(animated: true) {
            //3
            let player = AVPlayer(url: url)
            let vcPlayer = AVPlayerViewController()
            vcPlayer.player = player
            self.present(vcPlayer, animated: true, completion: nil)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension MergeVideo_PlayVC: UINavigationControllerDelegate {
    
}
