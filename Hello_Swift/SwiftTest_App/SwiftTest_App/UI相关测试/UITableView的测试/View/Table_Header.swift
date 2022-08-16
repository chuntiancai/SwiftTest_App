//
//  Table_Header.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/16.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试tableView的header
// MARK:  笔记
/**
 
 */

class Table_Header: UIView {
    
    //MARK:  对外属性
    var title:String = ""{
        didSet{
            titleLabel.text = title
        }
    }
    
    //MARK:  内部属性
    let titleLabel:UILabel = {
        let label = UILabel()
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.gray.cgColor
        label.text = "table 的 header"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    //MARK:  复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension Table_Header{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
}

//MARK: - 动作方法
@objc extension Table_Header{
    
}

//MARK: -
extension Table_Header{
    
}



