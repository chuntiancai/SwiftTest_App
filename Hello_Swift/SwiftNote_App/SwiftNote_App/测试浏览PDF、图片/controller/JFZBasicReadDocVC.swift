//
//  JFZBasicReadDocVC.swift
//  SwiftNote_App
//
//  Created by 蔡天春 on 2021/6/26.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 线下浏览PDF的基类

import UIKit

class JFZBasicReadDocVC: UIViewController {
    //MARK: - 对外属性
    var titleArr = [String]()
    var viewArr = [UIView]()
    
    var clickBtnAction: ((_ at:Int)->Void)? //点击了头部按钮的block
    
    //MARK: - 内部属性
    private let titleScrollView = UIScrollView()    //顶部按钮的横向滑动视图
    private let browseScrollView = UIScrollView()   //下方浏览的横向滑动视图
    private var curBtnTag = 1000    //设置当前点击的button
    private let btnBgColor = UIColor.init(red: 196/255.0, green: 148/255.0, blue: 93/255.0, alpha: 1)

    //MARK: - 复写方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "浏览PDF"
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = .bottom
        setBaseScorllViewUI()
    }
    
    ///计算顶部每个button的约束布局，设置titlsScrollView的contentSize的宽度。
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var sizeWidth: CGFloat = 10
        for index in 0..<titleArr.count {
            let curBtn = titleScrollView.viewWithTag(1000 + index)
            if curBtn != nil {
                ///找出每个button的宽度约束
                for constraint in curBtn!.constraints {
                    if constraint.firstAttribute == .width {
                        constraint.constant += 10
                        sizeWidth += constraint.constant + 10
                    }
                }
            }
        }
        let contentSize = sizeWidth > SCREEN_WIDTH ? sizeWidth : SCREEN_WIDTH
        titleScrollView.contentSize = CGSize.init(width: contentSize, height: 48)
    }
    

}

//MARK: - 设置UI
extension JFZBasicReadDocVC{
    
    /// 设计基本的滑动视图，顶部的按钮横向滑动视图，下方的浏览View的滑动视图。
    private func setBaseScorllViewUI(){
        
        ///设置按钮的scrollView
        self.view.addSubview(titleScrollView)
        titleScrollView.backgroundColor = .white
//        titleScrollView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1.0)
        titleScrollView.frame = .zero
        if titleArr.count > 0 {
            titleScrollView.delegate = self
            titleScrollView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.height.equalTo(48)
                make.width.equalToSuperview()
                make.left.equalToSuperview()
            }
            var preBtn:UIButton!
            for tag in 0 ..< titleArr.count{
                let curBtn = UIButton()
                curBtn.tag = tag + 1000
                curBtn.addTarget(self, action: #selector(btnClickAction(sender:)), for: .touchUpInside)
                curBtn.setTitle(titleArr[tag], for: .normal)
                curBtn.setTitleColor(btnBgColor, for: .normal)
                curBtn.setTitleColor(.white, for: .selected)
                curBtn.backgroundColor = .white
                curBtn.layer.cornerRadius = 15
                curBtn.layer.borderColor = btnBgColor.cgColor
                curBtn.layer.borderWidth = 0.8
                titleScrollView.addSubview(curBtn)
                if tag == 0 {
                    curBtn.isSelected = true
                    curBtn.backgroundColor = btnBgColor
                    curBtn.snp.makeConstraints { (make) in
                        make.centerY.equalToSuperview()
                        make.height.equalTo(30)
                        make.left.equalToSuperview().offset(10)
                    }
                }else{
                    curBtn.snp.makeConstraints { (make) in
                        make.centerY.equalToSuperview()
                        make.height.equalTo(30)
                        make.left.equalTo(preBtn.snp.right).offset(10)
                    }
                }
                preBtn = curBtn
            }
        }
        let upLineView = UIView()
        upLineView.backgroundColor = UIColor.init(red: 145/255.0, green: 145/255.0, blue: 145/255.0, alpha: 1.0)
        self.view.addSubview(upLineView)
        upLineView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }
        let downLineView = UIView()
        downLineView.backgroundColor = UIColor.init(red: 145/255.0, green: 145/255.0, blue: 145/255.0, alpha: 1.0)
        self.view.addSubview(downLineView)
        downLineView.snp.makeConstraints { make in
            make.top.equalTo(titleScrollView.snp.bottom).offset(-1)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }

        
        ///设置下方浏览的scrollView
        self.view.addSubview(browseScrollView)
        browseScrollView.delegate = self
        browseScrollView.isPagingEnabled = true
        browseScrollView.backgroundColor = .white
        browseScrollView.isScrollEnabled = false
        let sizeWidth = viewArr.count > 0 ? SCREEN_WIDTH * CGFloat(viewArr.count) : SCREEN_WIDTH
        browseScrollView.contentSize = CGSize.init(width: sizeWidth, height: SCREEN_HEIGHT)
        browseScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(titleScrollView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        if viewArr.count > 0 {
            for index in 0 ..< viewArr.count {
                let curView = viewArr[index]
                if curView.superview != nil {
                    curView.removeFromSuperview()
                }
                curView.backgroundColor = UIColor.init(red: 145/225.0, green: 145/255.0, blue: 145/255.0, alpha: 1.0)
                browseScrollView.addSubview(curView)
                curView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.width.equalTo(SCREEN_WIDTH)
                    make.left.equalToSuperview().offset(SCREEN_WIDTH * CGFloat(index))
                    make.height.equalToSuperview()
                }
                
            }
        }
        
    }
    
}

//MARK: - 动作方法
@objc extension JFZBasicReadDocVC{
    /// 点击按钮的动作方法，按钮以tag进行区分
    func btnClickAction(sender:UIButton){
        sender.isSelected = true
        sender.backgroundColor = btnBgColor
        let preBtn = titleScrollView.viewWithTag(curBtnTag) as? UIButton
        preBtn?.isSelected = false
        preBtn?.backgroundColor = .white
        curBtnTag = sender.tag
        let curIndex = sender.tag - 1000
        if clickBtnAction != nil {  //回调点击的方法
            clickBtnAction!(curIndex)
        }
        browseScrollView.contentOffset = CGPoint.init(x: SCREEN_WIDTH * CGFloat(curIndex), y: 0)
    }
}

//MARK: - 遵循scrollView的代理协议
extension JFZBasicReadDocVC: UIScrollViewDelegate{
    
}

//MARK: - 内部工具方法
extension JFZBasicReadDocVC{
    
}
