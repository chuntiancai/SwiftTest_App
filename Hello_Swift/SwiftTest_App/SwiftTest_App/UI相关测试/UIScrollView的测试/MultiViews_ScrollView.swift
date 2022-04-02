//
//  MultiViews_ScrollView.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/1.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 含有多个view的ScrollView，横向滑动子View

class MultiViews_ScrollView: UIView {
    
    //MARK: - 对外属性
    var viewsArr:[UIView] = [UIView](){   //子View的标题
        didSet{
            /// 移除原来的所有子View
            for view in oldValue {
                if view.superview != nil { view.removeFromSuperview()}
            }
            
            /**
                计算baseScrollView的contentsize，baseScrollView在添加子View时，不会调用MultiViews_ScrollView的layoutsubviews方法，
                而是调用baseScrollView的layoutsubviews方法。所以要在这里计算好baseScrollView的contentsize。
             */
            let contentSize = CGSize(width: self.bounds.width * CGFloat(viewsArr.count), height: self.bounds.height) //禁止垂直滑动
            self.baseScrollView.contentSize = contentSize
            
            /// 添加子View,子View的tag从1000开始
            for index in 0 ..< viewsArr.count {
                let view = viewsArr[index]
                view.tag = 1000 + index
                
                /// 添加view
                self.baseScrollView.addSubview(view)
                view.snp.makeConstraints { make in
                    ///这个不会在当前的MultiViews_ScrollView的layoutsubviews方法里计算，而是baseScrollView的layoutsubviews方法里。
                    make.left.equalTo(baseScrollView.bounds.width * CGFloat(index))
                    make.top.equalToSuperview()
                    make.height.equalToSuperview()
                    make.width.equalToSuperview()
                }
                
            }
            
            
        }
    }
    
    /// 设置选中子View
    var curViewIndex:Int {
        /// 设置则移动scrollview,获取则通过scrollView的位移返回
        set{
            if newValue >= viewsArr.count || newValue < 0 {
                print(" \(#function) 设置子View的索引\(newValue)错误～")
                return
            }
            
            let curView = viewsArr[newValue]
            
            //滑动 当前view到 视图中间
            let curMidX = curView.frame.midX
            let boundWidth = baseScrollView.bounds.width
            UIView.animate(withDuration: 0.5) {
                self.baseScrollView.contentOffset = CGPoint.init(x: curMidX - (boundWidth / 2), y: 0)//滑动到矩形中间
            }
            
        }
        get{
            /// 通过计算scrollView的位移，放回当前的View，向下取整
            let boundWidth = baseScrollView.bounds.width
            let curIndex:Int = Int(ceil(self.baseScrollView.contentOffset.x / boundWidth))
            return curIndex
        }
    }
    
    //MARK: 对外暴露的闭包
    ///子View滑动的闭包
    var scrollToViewAction:((_ curIndex:Int,_ curView:UIView?)->Void)?
    
    
    //MARK: UI组件
    var bgView = UIView()   //背景的View
    let baseScrollView: UIScrollView = UIScrollView() //容器scrollview
    
    //MARK: 计算属性
    /// 当前展示的子View
    var currentView:UIView? {
        get{
            if curViewIndex < viewsArr.count {
                return viewsArr[curViewIndex]
            }else{
                return nil
            }
        }
    }
    
    //MARK: - 内部属性

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
        print("MultiViews_ScrollView 的\(#function) 方法")
        //计算scroview的contentsize,重新布局时，应该重新计算snpkit的。
        let contentSize = CGSize(width: self.bounds.width * CGFloat(viewsArr.count), height: self.bounds.height) //禁止垂直滑动
        self.baseScrollView.contentSize = contentSize
    }
    
}

//MARK: - 设置UI
extension MultiViews_ScrollView{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        self.addSubview(baseScrollView)
        baseScrollView.isPagingEnabled = true
        baseScrollView.delegate = self
        baseScrollView.alwaysBounceVertical = false
        baseScrollView.backgroundColor = .clear
        baseScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - 动作方法
@objc extension MultiViews_ScrollView{
    
    /// 滑动手势识别器的动作方法
    /// - Parameter sender: 滑动识别器
    func panGestureAction(_ sender:UIPanGestureRecognizer){
        print("MultiViews_ScrollView 的 \(#function) 方法～")
    }
    
}

//MARK: - 遵循UIScrollViewDelegate协议，计算位移
extension MultiViews_ScrollView:UIScrollViewDelegate {
    
    /// 正在滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    /// 已经停止滑动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        /// 执行滑动view的闭包
        if scrollToViewAction != nil {
            scrollToViewAction!(curViewIndex,currentView)
        }
        print("scrollView滑动到了：\(curViewIndex)个view")
        
        /// 点击头部状态栏滑动到顶部
        for view in viewsArr {
            if view.isKind(of: UIScrollView.self){
                if view == currentView {
                    (view as? UIScrollView)?.scrollsToTop = true
                }else{
                    (view as? UIScrollView)?.scrollsToTop = false
                }
            }
        }
        
        
    }
    
}

//MARK: - 遵循UIGestureRecognizerDelegate协议，处理View的手势识别。(识别器和view的手势识别是一样的识别过程)
//extension MultiViews_ScrollView:UIGestureRecognizerDelegate {
//
//    /// 是否接受多个手势同步识别
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        print("MultiViews_ScrollView 的 \(#function) 方法 ~")
//        return true
//    }
//
//}

// MARK: - 笔记
/**
 
 */

