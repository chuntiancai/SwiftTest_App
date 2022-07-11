//
//  TableView的测试.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/16.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试tableView生命周期的cell

import UIKit

class TableView_LifeCycle_Cell: UITableViewCell {
    
    //MARK: - 对外属性
    /// 标题
    var titleStr = "一二三四五六七八九十"{
        didSet{
            // TODO： 测试label的计算高度
//            print("label的之前的内容的高度：\(titleLab.intrinsicContentSize.height)")
            titleLab.text = titleStr
//            let attrStr = NSAttributedString.init(string: titleStr, attributes: [.font:UIFont.systemFont(ofSize: 16)])
//            let size = attrStr.boundingRect(with: CGSize(width: 240, height: 812), options: .usesLineFragmentOrigin, context: nil)
//            titleLab.sizeToFit()
//            let height  = titleLab.text
//            print("label的内容的高度：\(titleLab.intrinsicContentSize.height)---\(titleStr)")
//            print("label的计算的高度：\(size)")
        }
    }
    
    
    //MARK: - 内部属性
    private var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .gray
        lab.font = UIFont.systemFont(ofSize: 16)
        return lab
    }()
    //TODO: 测试cell里面的白色背景
    private let whiteBgView = UIView()  //白色背景
    

    //MARK: - 复写方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initDefaultUI()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    
    ///cell准备被复用的时候
    override func prepareForReuse() {
        super.prepareForReuse()
        print("TableView_LifeCycle_Cell 准备被复用的时候")
    }
    deinit {
        print("TableView_LifeCycle_Cell 测试tableView的cell 销毁了～")
    }
    
    /// 设置默认的UI
    func initDefaultUI(){
        //TODO: 测试cell的阴影
        let screenWidth = UIScreen.main.bounds.width
       
//        //给tableview的cell设置阴影
        self.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1)
//        self.layer.masksToBounds = false
//        self.contentView.layer.masksToBounds = false
//
//        whiteBgView.layer.shadowRadius = 24
        whiteBgView.layer.shadowOffset = CGSize.init(width: 10, height: 10)
        whiteBgView.layer.shadowColor =  UIColor.gray.cgColor
        whiteBgView.layer.shadowOpacity = 0.4
//        whiteBgView.layer.masksToBounds = false
        /// 白色背景图
        whiteBgView.backgroundColor = .white
        whiteBgView.layer.cornerRadius = 12
        self.contentView.addSubview(whiteBgView)
        whiteBgView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(2)
            make.width.equalTo(300)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        self.contentView.addSubview(titleLab)
        titleLab.textAlignment = .left
        titleLab.numberOfLines = 0
        titleLab.textColor = .black
        titleLab.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(240)
        }
    }

   

}

//MARK: 设置UI
extension TableView_LifeCycle_Cell {
    // 对外方法
    
    // 对内方法
}
