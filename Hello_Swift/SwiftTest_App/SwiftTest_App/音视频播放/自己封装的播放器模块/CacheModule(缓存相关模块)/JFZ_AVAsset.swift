//
//  JFZ_AVAsset.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/10.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 管理AVAsset的下载，遵循AVAssetResourceLoaderDelegate代理拦截下载，用于缓存

import AVFoundation

class JFZ_AVAsset:NSObject {
    //MARK: 对外属性
    var avAsset: AVURLAsset!
    
    //MARK: 内部属性
    private var url: URL!
    
    
    init(url: URL) {
        super.init()
        self.url = url
        avAsset = AVURLAsset.init(url: url)
        avAsset.resourceLoader.setDelegate(self, queue: .main)
        initAVAsset()
    }
    
}

//MARK: - 内部工具方法
extension JFZ_AVAsset{
    
    /// 初始化AVAsset的配置
    func initAVAsset(){
        
        let assetKeysRequiredToPlay = [
            "playable", //当前视频资产是否可播放的key
            "hasProtectedContent"   //是否有受保护内容，有则不可以播放
        ]
        /// 使用异步线程，避免加载AVURLAsset的key造成主线程堵塞
        avAsset.loadValuesAsynchronously(forKeys: assetKeysRequiredToPlay) {
             
            /// 这个 completion handler是在随机线程中执行的，所以要在主线程中统一维护状态。
            DispatchQueue.main.async { [weak self] in
                
                if let isValidate = self?.validateValues(forKeys: assetKeysRequiredToPlay, forAsset: (self?.avAsset)!),isValidate {
                    print("可以播放视频：")
                }else{
                    print("AVURLAsset验证无效，不能播放～～")
                }
            }
        }
        
    }
    
    // 验证AVAsset的可用性
    private func validateValues(forKeys keys: [String], forAsset newAsset: AVAsset) -> Bool {
        for key in keys {
            var error: NSError?
            if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
                print("不可以播放的吖")
                return false
            }
        }
        
        if !newAsset.isPlayable || newAsset.hasProtectedContent {
            print("不可以播放的啦")
            return false
        }
        return true
    }
    
}

//MARK: - 遵循AVAssetResourceLoaderDelegate协议，管理AVAsset的下载
extension JFZ_AVAsset:AVAssetResourceLoaderDelegate{
    
    /// url必须是经过自定义加密的，不可以是常用的http://这些开头，因为这里只会因为不能识别url才会回调，也就是这里是给你解密url的
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        print("  @@这是AVAssetResourceLoaderDelegate的shouldWaitForLoadingOfRequestedResource方法～")
        return true
    }
    
    
}
