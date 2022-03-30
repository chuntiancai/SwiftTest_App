//
//  SectionTableView_Cell.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/9/10.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试含有section的tableView的cell

import UIKit

class SectionTableView_Cell: UITableViewCell {
    
    //MARK: - 对外属性
    /// 标题
    
    
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
        
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    
    ///cell准备被复用的时候
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    deinit {
        print("SectionTableView_Cell 测试tableView的cell 销毁了～")
    }
    
    //MARK: 设置UI
    // 对外方法
    
    // 对内方法

}
