//
//  JFZPlayerAudioTableViewCell.swift
//  JFZFortune
//
//  Created by mathew on 2021/7/21.
//  Copyright © 2021 JinFuZi. All rights reserved.
//
// 播放音频的CELL

import UIKit

class JFZPlayerAudioTableViewCell: UITableViewCell {
    
    //MARK: - 对外属性
    /// 标题
    var title:String?{
        didSet{
            titleLab.text = title
        }
    }
    
    let  baseAudioView = UIView()   //承载音频播放器
    
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
        for subV in baseAudioView.subviews {
            subV.removeFromSuperview()
        }
    }
    
    //MARK: 设置UI
    private func createUI() {
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(19)
            make.leading.equalTo(UIScreen.main.bounds.width * (20/375.0))
        }
        
        contentView.addSubview(baseAudioView)
        baseAudioView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(43)
            make.height.equalTo(40)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }

}
