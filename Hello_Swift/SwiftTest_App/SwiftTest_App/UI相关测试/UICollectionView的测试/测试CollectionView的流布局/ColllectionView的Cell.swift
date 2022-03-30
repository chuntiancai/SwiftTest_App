//
//  ColllectionView的Cell.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/12/2.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试流布局的Collection View的Cell

class TestFlowCollectionView_Cell: UICollectionViewCell {
    
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
        let label = UILabel()
        label.text = "布局的Cell"
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        label.font = .systemFont(ofSize: 16)
        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
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

