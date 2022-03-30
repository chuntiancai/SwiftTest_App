//
//  JFZReadImgTableCell.swift
//  SwiftNote_App
//
//  Created by chuntiancai on 2021/6/30.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 用于装载一个Image的table cell

import UIKit

class JFZReadImgTableCell: UITableViewCell {

    //MARK: - 对外属性
    var url:URL?{
        didSet{
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                imgView.image = image
//                imgView.contentMode = .scaleAspectFill
            }catch let error as NSError {
                print("加载图片错误",error)
            }
        }
    }
    
    
    //MARK: - 内部属性
    private let imgView = UIImageView()


    //MARK: - 复写方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(imgView)
        imgView.contentMode = .scaleAspectFit
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
