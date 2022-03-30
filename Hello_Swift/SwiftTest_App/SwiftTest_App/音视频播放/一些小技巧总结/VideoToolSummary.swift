//
//  VideoToolSummary.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/23.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 关于音视频的实用方法总结

import UIKit
import AVFoundation

class VideoToolSummary {
    
    
    //MARK: 获取视频缩略图,获取视频帧截图
    func getThumbnailImage(videoUrl: URL,second: Float64) -> UIImage {
        let asset = AVURLAsset(url: videoUrl)

        let avImgGen = AVAssetImageGenerator(asset: asset)
        avImgGen.appliesPreferredTrackTransform = true
        
        let cmTime = CMTimeMakeWithSeconds(second, preferredTimescale: 600);
        
        var actualTime = CMTime()
        
        guard let cgImg:CGImage = try? avImgGen.copyCGImage(at: cmTime, actualTime: &actualTime)  else {
            return UIImage()
        }
        
        let curImg = UIImage.init(cgImage: cgImg)
        
        return curImg;
    }
    
    
}
