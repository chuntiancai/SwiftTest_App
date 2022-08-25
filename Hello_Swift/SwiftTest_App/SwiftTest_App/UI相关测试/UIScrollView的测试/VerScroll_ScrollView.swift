//
//  VerScroll_ScrollView.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/24.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试竖直滚动的父ScrollView
// MARK:  笔记
/**
    1、需要设置UIScrollView的delegate为自身，在滑动到指定距离的时候，把子scrollview的isScrollEnabled置为true，此时子scrollview可以滑动，
       此时子scrollview可以正常滑动，从而系统默认的实现会识别到子view的手势，而父view的pan手势无效。
 
    2、需要复写UIview的gestureRecognizerShouldBegin方法，识别到pan手势，控制自身view的下滑无效，从而系统的默认实现会把下滑的手势留给子View的下滑。
        同时也在这里控制子view的isScrollEnabled置为false，从而系统的默认实现会把上滑的手势留给父View的上滑。
 
        下滑： 默认是子view先识别 -> 父view。
              但是下滑的时候，子view识别到顶部，故需要让位给父view识别。此时，父view也到顶部，于是 父view -> false 继续留给子view识别。
              在scrollViewDidScroll方法中，父view滑动到一定距离，子view的isScrollEnabled置为false。
 
        上滑： 默认是子view先识别 -> 父View。
              但是需要父view识别到一定距离再给子view识别，所以gestureRecognizerShouldBegin方法，要把子view的isScrollEnabled置为false。
        
 */

class VerScroll_ScrollView: UIScrollView {
    //MARK: - 对外属性
    var btmScrollView:UIScrollView?
    var topContentHeight:CGFloat = 40   ///顶部内容的高度
    
    //MARK: - 内部属性
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "VerScroll_ScrollView 顶部"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let btmLabel:UILabel = {
        let label = UILabel()
        label.text = "VerScroll_ScrollView 底部"
        label.font = .systemFont(ofSize: 20, weight: .medium)
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
    deinit {
        print("VerScroll_ScrollView 销毁了")
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
extension VerScroll_ScrollView{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        self.delegate = self
        
    }
    
    
}

//MARK: - 复写父类的方法
extension VerScroll_ScrollView  {
    
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isBegin = super.gestureRecognizerShouldBegin(gestureRecognizer)
//        print("这是VerScroll_ScrollView的 \(#function) 方法 -- \(isBegin) \n     -- gesture是:\(gestureRecognizer) ")
        print("VerScroll_ScrollView 的 \(#function) 方法返回的值：\(isBegin)")
        if gestureRecognizer == self.panGestureRecognizer {
            if let gesture = gestureRecognizer as? UIPanGestureRecognizer {
                let movePoint = gesture.translation(in: self)
                print("gesture的方向是：\(movePoint)")
                //向下滑动
                if (self.contentOffset.y <= 0 ) && movePoint.y >= 0 {
                    print("VerScroll_ScrollView 的 gesture返回了false")
                    return false
                }
                //向上滑动
                if self.contentOffset.y < topContentHeight  && movePoint.y <= 0{
                    btmScrollView?.isScrollEnabled = false
                }
            }
        }
        
        return isBegin
    }
    
    
}

//MARK: - 遵循UIScrollViewDelegate协议
extension VerScroll_ScrollView:UIScrollViewDelegate {
    
    // 开始滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.contentOffset.y >= topContentHeight {
            self.contentOffset = CGPoint(x: 0, y: topContentHeight)
            btmScrollView?.isScrollEnabled = true
        }
    }
}


