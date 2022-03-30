//
//  JFZAccelerationTipsView.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/13.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//  加速指示的文字提醒View

import UIKit

class HYAccelerationView: UIView {
    
    /// 加速度
    var speedLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        return lab
    }()
    
    /// 加速指示
    private var imgView: UIImageView = {
       let imgView = UIImageView(image: UIImage(named: "hy_video_acceleration", in: JFZ_PLAYER_SOURCE_BUNDLE, compatibleWith: nil))
        return imgView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        
        let backView = UIView()
        backView.layer.cornerRadius = 20
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(40)
        }
        
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(40)
        }
        
        addSubview(speedLab)
        speedLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    //旋转动画
    func startRotation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        //旋转半圈
        anim.toValue = CGFloat.pi
        //角度追加
        anim.isCumulative = true
        anim.repeatCount = 10000
        anim.duration = 0.5
        imgView.layer.add(anim, forKey: "rotation")
    }
    
    //停止旋转
    func stopRotation() {
        imgView.layer.removeAnimation(forKey: "rotation")
    }

}

