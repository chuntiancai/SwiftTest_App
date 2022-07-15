//
//  MultiBtns_ScrollView.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/1.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 含有多个按钮的ScrollView，横向滑动按钮

import CoreGraphics


class MultiBtns_ScrollView: UIView{
    
    //MARK: - 对外属性
    var btnTitleArr:[String] = [String](){   //按钮的标题
        didSet{
            /// 移除所有按钮
            for btn in btnArr {
                if btn.superview != nil { btn.removeFromSuperview()}
            }
            btnArr.removeAll()
            
            //计算scroview的contentsize
            var contentSize = CGSize(width: 10, height: self.bounds.height)
            /// 添加按钮,按钮的tag从1000开始
            for index in 0 ..< btnTitleArr.count {
                
                let btnTitle = btnTitleArr[index]
                let btn = UIButton()
                btn.tag = 1000 + index
                btn.layer.borderWidth = 1.0
                btn.layer.borderColor = UIColor.brown.cgColor
                btn.layer.masksToBounds = true
                
                ///设置按钮标题
                btn.setTitle(btnTitle, for: .normal)
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.titleLabel?.font = btnTitleFont
                
                btn.backgroundColor = .white
                if index == curBtnIndex {   ///初始化选中按钮
                    btn.isSelected = true
                    btn.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)  /// 缩放选中的按钮
                }
                
                ///按钮的动作方法
                btn.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
                
                
                let btnFitSize = btn.sizeThatFits(CGSize.init(width: 88, height: 34))
                /// 计算按钮的占用的size
                let btnPlaceSize = CGSize(width: btnFitSize.width + titleEdgeInset.left + titleEdgeInset.right + btnInterSpacing / 2,
                                     height: btnFitSize.height + titleEdgeInset.top + titleEdgeInset.bottom)
                /// 计算按钮实际的size
                let btnSize = CGSize(width: btnPlaceSize.width - btnInterSpacing / 2,
                                     height: btnFitSize.height + titleEdgeInset.top + titleEdgeInset.bottom)
                btn.layer.cornerRadius = btnSize.height / 2  /// 设置按钮的圆角

                ///计算scrollView的contentsize
                contentSize.width += btnPlaceSize.width
                self.baseScrollView.contentSize = contentSize
                
                
                /// 添加btn
                self.baseScrollView.addSubview(btn)
                btn.snp.makeConstraints { make in
                    make.centerX.equalTo(contentSize.width - btnPlaceSize.width / 2)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(btnSize.height)
                    make.width.equalTo(btnSize.width)
                }
                
                /// 设置选中的背景图片
                btn.setBackgroundImage(normalBtnBgImage, for: .normal)
                btn.setBackgroundImage(seletedBtnBgImage, for: .selected)
                
                print("按钮的最合适尺寸：\(btnFitSize)")
                btnArr.append(btn)
            }
            self.baseScrollView.contentSize.width += 10
            
        }
    }
    
    /// 设置选中按钮
    var curBtnIndex:Int = 0 {
        didSet{
            if curBtnIndex >= btnTitleArr.count || curBtnIndex < 0 {
                print(" \(#function) 设置按钮的索引错误～")
                curBtnIndex = oldValue
                return
            }
            
            let curBtn = btnArr[curBtnIndex]
            curBtn.isSelected = true
            self.baseScrollView.bringSubviewToFront(curBtn)
            curBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)   /// 缩放选中的按钮
            
            if curBtnIndex != oldValue {
                btnArr[oldValue].isSelected = false   //前一个按钮
                btnArr[oldValue].transform = .identity  //还原缩放
            }
            
            //设置点中按钮后，按钮滑动到中间，然后最前面和最后面的按钮点了也不用滑动
            let curMidX = curBtn.center.x
            let boundWidth = baseScrollView.bounds.width
            let offsetX = curMidX - boundWidth / 2  ///计算设置 当前按钮居中 时，x的偏移值应该是多少。
            
            UIView.animate(withDuration: 0.5) {
                
                /// 如果偏移移过了原点，恢复到零点，因为最首的几个button不需要偏移
                if offsetX <= 0 {
                    self.baseScrollView.contentOffset = .zero
                    return
                }
                /// 如果偏移到了最后几个button的位置，则不需要偏移
                if offsetX >= self.baseScrollView.contentSize.width - boundWidth {
                    self.baseScrollView.contentOffset = CGPoint.init(x: self.baseScrollView.contentSize.width - boundWidth , y: 0)
                    return
                }
                self.baseScrollView.contentOffset = CGPoint.init(x: offsetX, y: 0)//滑动到矩形中间
                /**
                 /// 如果按钮中点不超过视图中点，不滑动
                 if curMidX <= boundWidth/2 {
                     self.baseScrollView.contentOffset = .zero
                     
                 }else if curMidX > boundWidth / 2 && curMidX < (self.baseScrollView.contentSize.width - boundWidth / 2) {
                     ///如果按钮的中点位移超过视图中点，则滑动按钮到视图中点
                     self.baseScrollView.contentOffset = CGPoint.init(x: curMidX - boundWidth / 2 , y: 0)//滑动到矩形中间
                     
                 }else if curMidX >= (self.baseScrollView.contentSize.width - boundWidth / 2) {
                     ///如果按钮靠近最后，直接滑动动到最后
                     self.baseScrollView.contentOffset = CGPoint.init(x: self.baseScrollView.contentSize.width - boundWidth , y: 0)
                 }
                 */
                
            }
            
        }
    }
    var btnClickAction:((_ btnIndex:Int)->Void)?    //点击按钮的闭包
    
    // MARK: 按钮的UI设计
    /// 设置选中按钮的背景图片
    var seletedBtnBgImage:UIImage? = nil {
        didSet{
            for btn in btnArr {
                btn.setBackgroundImage(seletedBtnBgImage, for: .selected)
            }
        }
    }
    /// 设置正常状态按钮的背景图片
    var normalBtnBgImage:UIImage? = nil {
        didSet{
            for btn in btnArr {
                btn.setBackgroundImage(normalBtnBgImage, for: .normal)
            }
        }
    }
    
    ///按钮标题的外边距，其实是设置sizeThatFits之后外加的边距
    var titleEdgeInset:UIEdgeInsets = UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)   /// 标题距离 按钮边缘 的内边距
    var btnInterSpacing:CGFloat = 20  /// 按钮之间的间距
    var btnTitleFont:UIFont = .systemFont(ofSize: 14)
    
    //MARK: UI组件
    var bgView = UIView()   //背景的View
    var baseScrollView = UIScrollView() //背景ScrollView
    
    //MARK: 计算属性
    /// 当前点击的按钮
    var curBtn:UIButton? {
        get{
            if curBtnIndex < btnTitleArr.count {
                return btnArr[curBtnIndex]
            }else{
                return nil
            }
        }
    }
    
    //MARK: - 内部属性
    private var btnArr:[UIButton] = [UIButton]()    //按钮的数组,暂存按钮

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        if frame == .zero { //避免计算snpkit时没有值。
            self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 46)
        }
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        print("MultiBtns_ScrollView 的\(#function) 方法")
    }
    
}

//MARK: - 设置UI
extension MultiBtns_ScrollView{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(baseScrollView)
        baseScrollView.delegate = self
        baseScrollView.backgroundColor = .clear
        baseScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - 动作方法
@objc extension MultiBtns_ScrollView{
    
    /// 点击按钮的动作方法
    /// - Parameter sender: 点击了的按钮
    func clickBtnAction(_ sender:UIButton){
        
        sender.isSelected = true
        curBtnIndex = sender.tag - 1000 //设置选中按钮
        print("点击了第\(sender.tag - 1000)个按钮")
        /// 执行点击的闭包
        if btnClickAction != nil {
            btnClickAction!(curBtnIndex)
        }
        
    }
    
    
}

//MARK: - 遵循UIScrollViewDelegate协议，计算位移
extension MultiBtns_ScrollView:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("MultiBtns_ScrollView 的  \(#function) 方法～ \(scrollView)")
    }
    
}




// MARK: - 笔记
/**
 
 */
