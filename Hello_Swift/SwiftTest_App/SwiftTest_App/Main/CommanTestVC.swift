//
//  CommanTestVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/21.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试的VC

import UIKit
import AVFoundation

class CommanTestVC: UIViewController {

    ///UI组件
    private var baseCollView: UICollectionView!
    private var imgView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "测试功能"
        
        setNavigationBarUI()
        setBtnUI()
    }


}







//MARK: - 设计UI
extension CommanTestVC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        
        //去掉导航栏的下划线，导致子页面的布局是从导航栏下方开始，即snpkit会以导航栏下方为零坐标
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false    //去掉透明，即去掉毛玻璃效果
        
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func setBtnUI(){
        let uiBtn = UIButton()
        uiBtn.setTitle("点击获取视频缩略图", for: .normal)
        uiBtn.setTitleColor(.black, for: .normal)
        uiBtn.titleLabel?.font = .systemFont(ofSize: 12)
        uiBtn.backgroundColor = .gray
        uiBtn.layer.borderWidth = 0.5
        uiBtn.layer.cornerRadius = 8.0
        uiBtn.addTarget(self, action: #selector(clickBtn1), for: .touchUpInside)
        view.addSubview(uiBtn)
        uiBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(40)
            make.width.equalTo(160)
        }
        
        imgView = UIImageView()
        imgView.backgroundColor = .green
        view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(200)
        }
    }
}

//MARK: - 动作方法
@objc extension CommanTestVC {
    
    //获取视频缩略图
    func clickBtn1(){
        let url = URL.init(string: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4")!
        let img = getThumbnailImage(videoUrl: url)
        self.imgView.image = img
        
    }
        
}

//MARK: - 工具方法
extension CommanTestVC{
    
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    //获取视频缩略图
    func getThumbnailImage(videoUrl: URL) -> UIImage {
        let asset = AVURLAsset(url: videoUrl)

        let avImgGen = AVAssetImageGenerator(asset: asset)
        
        avImgGen.appliesPreferredTrackTransform = true
        
        let cmTime = CMTimeMakeWithSeconds(0.2, preferredTimescale: 600);
        
        var actualTime = CMTime()
        
        guard let cgImg:CGImage = try? avImgGen.copyCGImage(at: cmTime, actualTime: &actualTime)  else {
            return UIImage()
        }
        
        let curImg = UIImage.init(cgImage: cgImg)
        
//        CGImageRelease(cgImg);
        
        return curImg;
    }
    
}
