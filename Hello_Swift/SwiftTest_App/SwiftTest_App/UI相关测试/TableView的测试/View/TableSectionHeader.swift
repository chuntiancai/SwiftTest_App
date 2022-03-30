//
//  TableSectionHeader.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/15.
//  Copyright © 2021 com.mathew. All rights reserved.
//

import UIKit

class TableSectionHeader: UIView {
    //MARK: - 对外属性
    var title:String = "" {
        didSet{
            titleLabel.text = title
        }
    }
    
    var contentText = "因业务调整该品类不计入" {      //右侧副标题的文本
        didSet{
            let attrString = NSMutableAttributedString(string: "* \(contentText)")
            let attr: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 12),.foregroundColor: UIColor(red: 0.88, green: 0.13, blue: 0.13, alpha: 1)]
            attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
            let strSubAttr1: [NSMutableAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12),.foregroundColor: UIColor(red: 0.88, green: 0.13, blue: 0.13,alpha:1)]
            attrString.addAttributes(strSubAttr1, range: NSRange(location: 0, length: 2))
            let strSubAttr2: [NSMutableAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12),.foregroundColor: UIColor(red: 0.6, green: 0.6, blue: 0.6,alpha:1)]
            attrString.addAttributes(strSubAttr2, range: NSRange(location: 2, length: 14))
            textLabel.attributedText = attrString
        }
    }
    
    //MARK: - 内部属性
    private let titleLabel = UILabel()  //标题
    private let textLabel = UILabel()   //右侧的副标题文本
    private let yellowBarBgView = UIView()  //黄色的条状背景图

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension TableSectionHeader{
    /// 设置默认的UI
    func setDefaultUI(){
        
        let screenWidth = UIScreen.main.bounds.width
        
        /// 黄色条形背景图
        yellowBarBgView.frame = CGRect(x: 0, y: 0, width: screenWidth * 72 / 375.0, height: screenWidth * 10 / 375.0)
//        yellowBarBgView.image = UIImage(named: "MyAsset_header_bg_bar")
//        yellowBarBgView.contentMode = .scaleAspectFill
        // fillCode
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [UIColor(red: 0.97, green: 0.83, blue: 0.64, alpha: 1).cgColor,UIColor(red: 246/255.0, green: 251/255.0, blue: 253/255.0, alpha: 0).cgColor]
        bgLayer1.locations = [0, 1]
        bgLayer1.frame = yellowBarBgView.bounds
        bgLayer1.startPoint = CGPoint(x: 0.0, y: 0.5)
        bgLayer1.endPoint = CGPoint(x: 1, y: 0.5)

        yellowBarBgView.layer.addSublayer(bgLayer1)
        self.addSubview(yellowBarBgView)
        yellowBarBgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(screenWidth * 3.8 / 125.0)
            make.left.equalToSuperview().offset(screenWidth * 20 / 375.0)
            make.height.equalTo(screenWidth * 10 / 375.0)
            make.width.equalTo(screenWidth * 72 / 375.0)
        }
        
        // 标题label
        titleLabel.textAlignment = .left
        titleLabel.text = "- - - -"
        titleLabel.font =  UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = .black
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(yellowBarBgView.snp.bottom).offset(-5)
            make.left.equalTo(yellowBarBgView.snp.left)
            make.height.equalTo(screenWidth * 18 / 375.0)
        }
        
        
        
    }
    
}

//MARK: -
extension TableSectionHeader{
    
}

//MARK: -
extension TableSectionHeader{
    
}

//MARK: -
extension TableSectionHeader{
    
}


