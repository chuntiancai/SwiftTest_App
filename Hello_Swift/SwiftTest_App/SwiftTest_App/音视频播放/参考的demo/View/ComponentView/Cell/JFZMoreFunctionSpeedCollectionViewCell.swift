//
//  JFZMoreFunctionSpeedCollectionViewCell.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/13.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 全屏播放，更多按钮，CollectionView的cell

import UIKit

class JFZMoreFunctionSpeedCollectionViewCell: UICollectionViewCell {
    
    /// 倍速展示
    var speedBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        createUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        contentView.addSubview(speedBtn)
        speedBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}

