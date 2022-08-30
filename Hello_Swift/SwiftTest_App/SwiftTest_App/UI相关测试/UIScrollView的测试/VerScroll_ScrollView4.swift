//
//  VerScroll_ScrollView4.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/29.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 在售页面，背景的ScrollView，主要是实现顶部上下滑动刷新交互，底部有UIScrollView的交互，增加了可以隐藏的渐变逻辑。
/**
    1、delegate已经设置为自身，用于控制ContentOffset。
        主要是通过gestureRecognizerShouldBegin、scrollViewDidScroll方法来控制。
 */

class JFZOnSale_BgScrollView: UIScrollView {
    
    //MARK: - 对外属性
    weak var btmScrollView:UIScrollView?
    var topContentHeight:CGFloat = 80   ///顶部跟随滑动内容的高度
    var btmScrollViewContentOffset:CGPoint = .zero    //底部scrollView固定时的Offset
    var isBtmScrollTop = true   //判断底部的scroview是否滑动了顶部
    var beMaskedView:UIView? {  //JFZOnSale_BgScrollView需要被渐变隐藏的子View
        didSet{
            if let curView = beMaskedView {
                if curView.superview != self {
                    print("要被mask的view不是JFZOnSale_BgScrollView的子view")
                    return
                }else{
                    oldValue?.mask = nil
                    var maskRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    if curView.bounds != .zero {
                        maskRect = curView.bounds
                    }
                    maskingView = UIView(frame: maskRect)
                    maskingView?.backgroundColor = .yellow
                    curView.mask = maskingView
                }
            }else{
                oldValue?.mask = nil
                maskingView = nil
            }
        }
    }
    private var maskingView:UIView? //作为掩板的view
    
    //MARK: - 内部属性
    private let panGesture = UIPanGestureRecognizer()   //用于处理与底部tableView之间的交互
    private var panStartPoint:CGPoint = .zero  /// 记录每一小段识别平移手势启动时刻的点
    

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
        //TODO: 设置手势识别器
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 设置UI
extension JFZOnSale_BgScrollView{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
        self.delegate = self
        // 平移手势识别器
        self.panGestureRecognizer.addTarget(self, action: #selector(viewPanGestureAction(_:)))
        panGesture.delegate = self
    }
    
    
}

//MARK: - 遵循手势识别器的协议 -- UIGestureRecognizerDelegate
@objc extension JFZOnSale_BgScrollView: UIGestureRecognizerDelegate{
    
    // 多个手势可以同时触发
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //是否应该识别手势
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isBegin = super.gestureRecognizerShouldBegin(gestureRecognizer)
        print("是否应该滑动：\(isBegin)")
        if gestureRecognizer == self.panGestureRecognizer {
            if let gesture = gestureRecognizer as? UIPanGestureRecognizer {
                let movePoint = gesture.translation(in: self)
                print("gesture的方向是：\(movePoint)")
                //向下滑动
                if movePoint.y >= 0 {
                    if !isBtmScrollTop { return false } //底部scrollView没到顶部，不响应
                    
                }else{
                    // 向上滑动
                    // bgScrollView已经滑动到顶部，bgScrollView不再识别,给0.5的误差
                    if self.contentOffset.y - topContentHeight >= -0.5 {
                        print("向上滑动，不给begin")
                        return false
                    }
                }
                if btmScrollView?.isDecelerating ?? false { return false }   //tableview还在自己滚动中，不响应
            }
        }
        return isBegin
    }
    
    // 当view识别到滑动手势时动作方法
    func viewPanGestureAction(_ sender : UIPanGestureRecognizer){
        /// 获取平移的点，是相对于开始时刻的总平移量的值，至少有两个时刻才有平移可言，一直平移，就一直相对于最开始时刻点下的点。
        let point = sender.translation(in: self)
        if sender.state == .began { panStartPoint = .zero }
//       print("手势滑动时：\(point) --panStartPoint: \(panStartPoint)")
        /// 记录每一小段识别平移手势启动时刻的点
        let beginPoint = panStartPoint
        panStartPoint = point
        // 向上滑动
        if point.y - beginPoint.y < 0 { //向上滑动,注意等于零是需要判断是否需要置btmScrollView?.contentOffset为零的
//            print("向上滑动")
            // bgScrollView已经滑动到顶部，bgScrollView不再识别,给0.5的误差
            if self.contentOffset.y - topContentHeight >= -0.5 {
                sender.state = .ended   //结束识别
                return
            }else{
                // bgScrollView还没滑动到顶部
                // 但需要tableView也到顶部的时候，才设置tableview固定不动
//                print("设置为.zero时：y: \(self.contentOffset.y) --topContentHeight:\(topContentHeight)")
                if isBtmScrollTop { btmScrollView?.contentOffset = btmScrollViewContentOffset }
            }
        }
        
    }
    
}

//MARK: - 遵循UIScrollViewDelegate协议
extension JFZOnSale_BgScrollView:UIScrollViewDelegate {
    
    // 开始滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 达到滑动停止的距离
        if self.contentOffset.y >= topContentHeight {
            self.contentOffset = CGPoint(x: 0, y: topContentHeight)
        }
        
        // 设置渐变隐藏的View
        if maskingView != nil {
            if self.contentOffset.y <= 0 {
                maskingView!.frame = beMaskedView!.bounds
            }else{
                let progress = self.contentOffset.y / topContentHeight
                let maskY = topContentHeight * progress
                let maskHeight = topContentHeight * (1 - progress)
                maskingView!.frame = CGRect(x: 0, y: maskY, width: beMaskedView!.bounds.width, height: maskHeight)
            }
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
}

