//
//  测试文字的渐变色.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/29.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试文字的渐变色的view，使用mask属性。字体渐变色

import UIKit

class GradientTestLabelView: UIView {
    //MARK: - 对外属性
    var name:String = "产品名称"{    //个股名称
        didSet{
            nameLabel.text = name
            print("nameLabel的frame：\(nameLabel.frame)")
            graidentView.frame = nameLabel.frame
            
            nameLabel.frame = CGRect.init(x: 0, y: 0, width: graidentView.frame.width, height: graidentView.frame.height)
            graidentView.mask = nameLabel
            print("文字的高度：\(nameLabel.intrinsicContentSize.height)")
            
        }
    }
    
    //MARK: - 内部属性
    let nameLabel = UILabel()
    let graidentView = UIView() //渐变颜色的view

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("\n字体渐变色 在layoutSubviews中label的frame：\(nameLabel.frame)")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("\n字体渐变色 在draw方法中label的frame：\(nameLabel.frame)")
    }
    
}

//MARK: - 设置UI
extension GradientTestLabelView{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        ///个股名称label
        nameLabel.numberOfLines = 0
        nameLabel.text = name
        nameLabel.layer.borderWidth = 1.0
        nameLabel.layer.borderColor = UIColor.black.cgColor
        nameLabel.textColor = .white
        nameLabel.textAlignment = .left
        nameLabel.font = .systemFont(ofSize: 20)
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(250)
        }
        
        /// 渐变颜色的背景view
        graidentView.frame = CGRect(x: 25, y: 30, width: 300, height: 10)
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.97, green: 0.83, blue: 0.64, alpha: 1).cgColor, UIColor(red: 0.9, green: 0.66, blue: 0.45, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = graidentView.bounds
        graidentView.layer.addSublayer(gradient)
        self.addSubview(graidentView)
//        graidentView.backgroundColor = .red
        graidentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(nameLabel.snp.width)
            make.height.equalTo(nameLabel.snp.height)
        }
//        graidentView.mask = nameLabel
        
    }
}

//MARK: -
extension GradientTestLabelView{
    
}

//MARK: -
extension GradientTestLabelView{
    
}

//MARK: -
extension GradientTestLabelView{
    
}

// MARK: - 笔记
/**
    1、mask属性的使用是，定义了宿主对象的可显示的内容，mask属性就是宿主view的不透明通道，也就是mask属性中的不透明颜色的内容就是宿主对象的可显示的内容轮廓。
      mask属性中的透明颜色就是遮挡宿主对象的显示内容，注意，mask属性的布局是相对于宿主的坐标系，而不是mask属性的父view，mask的父view是无效的。
      mask属性不要使用snpkik，不然不知道具体尺寸在什么时候算出来，比较麻烦，虽然是在layoutsubview方法中算出来，但是取出来就比较麻烦。
    2、
 */

