//
//  VerScroll_ScrollView2.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/24.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试竖直滚动的父ScrollView2
// MARK:  笔记
/**
 
 */

class VerScroll_ScrollView2: UIScrollView {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "VerScroll_ScrollView2 顶部"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let btmLabel:UILabel = {
        let label = UILabel()
        label.text = "VerScroll_ScrollView2 底部"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
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
        
        if btmLabel.superview == nil {
            self.addSubview(btmLabel)
            btmLabel.frame = CGRect(x: 0, y: 0, width: 260, height: 30)
            btmLabel.center = CGPoint(x: self.bounds.midX, y: self.contentSize.height - 30)
        }
        
    }
}

//MARK: - 设置UI
extension VerScroll_ScrollView2 {
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
}

//MARK: - 动作方法
@objc extension VerScroll_ScrollView2 {
    
}

//MARK: - 复写父类的方法
extension VerScroll_ScrollView2 {
    
    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        print("这是VerScroll_ScrollView2 的 \(#function) 方法 -- \(touches)")
//        print("自身的位移～：\(self.contentOffset)")
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isBegin = super.gestureRecognizerShouldBegin(gestureRecognizer)
        print("这是VerScroll_ScrollView 2 的 \(#function) 方法 -- \(isBegin)")
        return isBegin
    }
}


