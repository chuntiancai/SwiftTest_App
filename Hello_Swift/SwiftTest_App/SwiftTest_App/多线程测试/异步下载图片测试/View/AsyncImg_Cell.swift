//
//  AsyncImg_Cell.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/29.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试异步下载图片的cell

class AsyncImg_Cell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 准备被复用时调用的方法。
    override func prepareForReuse() {
        
    }
    
}
//MARK: - 设置UI
extension AsyncImg_Cell{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
    }
}

//MARK: - 动作方法
@objc extension AsyncImg_Cell{
    
}

//MARK: -
extension AsyncImg_Cell{
    
}

// MARK: - 笔记
/**
 
 */

