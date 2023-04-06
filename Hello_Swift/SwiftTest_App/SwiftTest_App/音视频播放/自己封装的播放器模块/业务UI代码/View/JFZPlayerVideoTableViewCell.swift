//
//  JFZPlayerVideoTableViewCell.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/14.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 播放视频的CELL

import UIKit

class JFZPlayerVideoTableViewCell: UITableViewCell {
    
    //MARK: - 对外属性
    /// 标题
    var title:String?{
        didSet{
            titleLab.text = title
        }
    }
    
    ///当前cell绑定的播放源配置
    var playerConfig:JFZAudioVideoModel?{
        didSet{
            if playerConfig == nil {
                return
            }
            /**
             // 封面图处理
             if let imgStr = playerConfig!.imageUrlStr, imgStr != "" {
                 if let placeHoldImg = UIImage(named: imgStr) {
                     let imgView = UIImageView(image: placeHoldImg)
                     self.videoCoverView  = imgView
                 } else if let imgUrl = URL(string: imgStr) {    //网络下载图片
                     let data = try? Data(contentsOf: imgUrl)
                     if let imageData = data {
                         let image = UIImage(data: imageData)
                         let imgView = UIImageView(image: image)
                         self.videoCoverView  = imgView
                     }
                 }
             }
             */

        }
    }
    let  baseVideoView = UIView()   //承载视频播放器
    let  videoCoverView = UIView()  //封面的View
    
    //MARK: - 内部属性
    private var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .gray
        lab.font = UIFont.systemFont(ofSize: 16)
        return lab
    }()
    
    
    

    //MARK: - 复写方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        clipsToBounds = true
        createUI()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    
    ///cell准备被复用的时候
    override func prepareForReuse() {
        super.prepareForReuse()
//        print("JFZPlayerVideoTableViewCell 准备被复用:\(self.classForCoder)")
        for subV in baseVideoView.subviews {
            subV.removeFromSuperview()
        }
    }
    
    /// 告知UIKit响应者是否在自己的子孙后代中
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        print("JFZPlayerVideoTableViewCell 的 point(inside")
        return super.point(inside: point, with: event)
    }
    
    /// 向下寻找点击者
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        print("JFZPlayerVideoTableViewCell 的 hitTest(_ point:")
        return super.hitTest(point, with: event)
    }
    

}
//MARK: - 设置UI
extension JFZPlayerVideoTableViewCell {
    
    /// 创建基本的UI
    private func createUI() {
        let screenWidth = UIScreen.main.bounds.width
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(19)
            make.leading.equalTo(19)
        }
        
        baseVideoView.backgroundColor = .gray
        contentView.addSubview(baseVideoView)
        baseVideoView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(43)
            make.height.equalTo(193.5)
            make.width.equalTo(screenWidth * (345/375.0))
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(videoCoverView)
        videoCoverView.snp.makeConstraints { make in
            make.edges.equalTo(baseVideoView.snp.edges)
        }
        videoCoverView.isHidden = true
        
    }
}

//MARK: - 对外提供的方法
extension JFZPlayerVideoTableViewCell {
    
    /// 添加视频view到cell中
    /// - Parameter subView: 被添加的视频View
    func addVideoView(subView:UIView?){
        if let subV = subView {
            videoCoverView.isHidden = true
            for subV in baseVideoView.subviews {
                subV.removeFromSuperview()
            }
            baseVideoView.addSubview(subV)
            subV.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            bringSubviewToFront(baseVideoView)
        }
    }
    
    /// 添加封面到cell中
    func addCoverView(coverView:UIView?){
        if let subV = coverView {
            videoCoverView.isHidden = false
            for sView in videoCoverView.subviews {
                sView.removeFromSuperview()
            }
            
            videoCoverView.addSubview(subV)
            subV.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            bringSubviewToFront(videoCoverView)
        }
        
    }
    
}
