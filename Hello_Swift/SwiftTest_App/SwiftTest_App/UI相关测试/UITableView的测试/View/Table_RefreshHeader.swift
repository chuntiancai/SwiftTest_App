//
//  Table_RefreshHeader.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/17.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试tableView的下拉刷新的控件
// MARK:  笔记
/**
    1、一般不用tableHeader来作为刷新控件，而是在contentInset里面添加一个subview，因为tableHeader可以用来放置广告。
*/
enum MyTableRefreshHeader_Status {
    case none
    case refreshing
    case finshed
    case failed
}

class Table_RefreshHeader: UIView {
    
    //MARK:  对外属性
    var title:String = ""{
        didSet{
            titleLabel.text = title
        }
    }
    
    var status:MyTableRefreshHeader_Status = .none {
        didSet{
            
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
extension Table_RefreshHeader{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
}

//MARK: - 动作方法
@objc extension Table_RefreshHeader{
    
}

//MARK: -
extension Table_RefreshHeader{
    
}
