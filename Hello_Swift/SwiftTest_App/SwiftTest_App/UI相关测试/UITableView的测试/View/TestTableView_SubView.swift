//
//  TestTableView_SubView.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/16.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试tableView的中循环引用的问题
import UIKit

class TestTableView_SubView: UIView {
    //MARK: - 对外属性
    /// - Tag: 用于回调外界的属性
    var togglePlayAction:((_ isToPlay:Bool)->Void)?  //点击了播放按钮
    
    
    //MARK: - 内部属性
    private let testBtn = UIButton()

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViewUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("TestTableView_SubView 销毁了～～")
    }
}

//MARK: -
extension TestTableView_SubView{
    
}

//MARK: - 设置UI
extension TestTableView_SubView{
    func initSubViewUI(){
        self.addSubview(testBtn)
        testBtn.backgroundColor = .brown
        testBtn.addTarget(self, action: #selector(clickTestBtnAction), for: .touchUpInside)
        testBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
}

//MARK: - 动作方法
@objc extension TestTableView_SubView{
    func clickTestBtnAction(sender: UIButton){
        print("点了self的btn动作方法：self:\(self)-----btn:\(sender)")
        if togglePlayAction != nil {
            togglePlayAction!(false)
        }
    }
}

//MARK: -
extension TestTableView_SubView{
    
}

