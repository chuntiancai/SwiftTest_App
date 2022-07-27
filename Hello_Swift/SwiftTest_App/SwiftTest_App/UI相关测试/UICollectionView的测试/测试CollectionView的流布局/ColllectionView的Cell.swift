//
//  ColllectionView的Cell.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/12/2.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试流布局的Collection View的Cell

import UIKit

class TestFlowCollectionView_Cell: UICollectionViewCell {
    
    //MARK: UI控件
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.shadowColor = UIColor.gray
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowRadius = 16
        label.layer.shadowOpacity = 0.8
        label.layer.borderColor = UIColor.brown.cgColor
        label.layer.borderWidth = 1.0
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    lazy var bgImageView:UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - 设置UI
extension TestFlowCollectionView_Cell{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
        self.contentView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: -
extension TestFlowCollectionView_Cell{
    
}

//MARK: -
extension TestFlowCollectionView_Cell{
    
}

//MARK: -
extension TestFlowCollectionView_Cell{
    
}

// MARK: - 笔记
/**
 
 */

