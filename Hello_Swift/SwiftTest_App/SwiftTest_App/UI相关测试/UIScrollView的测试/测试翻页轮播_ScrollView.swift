//
//  测试翻页轮播_ScrollView.swift
//  SwiftTest_App
//
//  Created by mathew on 2023/6/27.
//  Copyright © 2023 com.mathew. All rights reserved.
//
// 测试用三张图翻页轮播
// MARK: - 笔记
/**
    1、想办法获取当前真正显示的页的view。
    2、找出当前view的后一个view。(找出前一个view)
    3、把当前View的后一个view放到后面。(放到前面)
    4、同时把roundViewArr的数组也同步滚动。因为是通过数组下标来定位当前的view。
       所以你用scrollView来重新放置view的位置的时候，也需要同时更新数组的位置。
 
    5、暂时还没兼容少于3个view时的数组
 
 */


class Test_PageRoundScorllView: UIScrollView {
    
    //MARK: 对外属性
    var scrollToPageBlock:((_ curPage:Int)->Void)?  //滑动到了第几页
    
    //MARK:  内部属性
    private var isRounding = false  //是否正在滚动，用于禁止多次点击，或者过快调用滑动方法
    private var roundViewArr = [UIView]()   //用于轮播的View
    private var isFirstInitLayout = true   //尺寸是否已经计算出来

    //MARK:  复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("Test_PageRoundScorllView初始化啦～")
        initDefaultUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //初始化布局约束
        if self.bounds.width > 0 {
            if isFirstInitLayout {
                isFirstInitLayout = false
                self.contentSize = CGSize(width: self.bounds.width * CGFloat(roundViewArr.count), height: 0)
                for index in 0 ..< roundViewArr.count {
                    let curView = roundViewArr[index]
                    curView.frame = self.bounds
                    let positionX = self.bounds.width * CGFloat(index) + self.bounds.width * 0.5
                    let positionY = curView.center.y
                    curView.center = CGPoint(x: positionX,y: positionY)
                }
                self.contentOffset = CGPoint(x: self.bounds.width,y: 0)
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension Test_PageRoundScorllView{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
        self.isPagingEnabled = true
        self.backgroundColor = UIColor.gray
        self.delegate = self
        self.bounces = false
    }
    
    
    
}

//MARK: - 遵循UIScrollViewDelegate协议。
extension Test_PageRoundScorllView:UIScrollViewDelegate {
    
    
    //手指松开后，停止加速时
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let curPage = Int(scrollView.contentOffset.x  / self.bounds.width)
        let curView = roundViewArr[curPage]
        print("手指松开后，停止加速时,当前页：\(curPage) -- tag:\(curView.tag)")
        if curPage == 0 {
           goToFirstPage(pageView: curView)
        }else if curPage == roundViewArr.count - 1 {
           goToLastPage(pageView: curView)
        }
        if scrollToPageBlock != nil {
            scrollToPageBlock!(curView.tag - 1000)
        }
    }
    
    // 没有用手指，滑动切动画结束后，用于点击的时候
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("没有用手指，停止滑动,动画结束时")
        isRounding = false
        
        let curPage = Int(scrollView.contentOffset.x  / self.bounds.width)
        let curView = roundViewArr[curPage]
        print("手指松开后，停止加速时,当前页：\(curPage) -- tag:\(curView.tag)")
        if curPage == 0 {
           goToFirstPage(pageView: curView)
        }else if curPage == roundViewArr.count - 1 {
           goToLastPage(pageView: curView)
        }
        if scrollToPageBlock != nil {
            scrollToPageBlock!(curView.tag - 1000)
        }
        
    }
    
    
}


//MARK: UI逻辑
extension Test_PageRoundScorllView{
    
    //滑动到最后一页
    private func goToLastPage(pageView:UIView){
        
        let positionX = self.bounds.width * CGFloat(roundViewArr.count - 2) + self.bounds.width * 0.5
        let positionY = pageView.center.y
        pageView.center = CGPoint(x: positionX,y: positionY)
        goLeftArr()
        for index in 0 ..< roundViewArr.count {
            let curView = roundViewArr[index]
            let positionX = self.bounds.width * CGFloat(index) + self.bounds.width * 0.5
            let positionY = curView.center.y
            curView.center = CGPoint(x: positionX,y: positionY)
        }
        self.contentOffset = CGPoint(x: self.bounds.width * CGFloat(roundViewArr.count - 2), y: 0)
    }
    
    //滑动到第一页
    private func goToFirstPage(pageView:UIView){
        let positionX = self.bounds.width * 1.5
        let positionY = pageView.center.y
        pageView.center = CGPoint(x: positionX,y: positionY)
        goRightArr()
        for index in 0 ..< roundViewArr.count {
            let curView = roundViewArr[index]
            let positionX = self.bounds.width * CGFloat(index) + self.bounds.width * 0.5
            let positionY = curView.center.y
            curView.center = CGPoint(x: positionX,y: positionY)
        }
        self.contentOffset = CGPoint(x: self.bounds.width, y: 0)
    }
    
    //数组向右滚动
    private func goRightArr(){
        if let view  = roundViewArr.last {
            roundViewArr.removeLast()
            roundViewArr.insert(view, at: 0)
        }

    }
    
    //数组向左滚动
    private func goLeftArr(){
        if let view  = roundViewArr.first {
            roundViewArr.removeFirst()
            roundViewArr.append(view)
        }
    }
    
}
//MARK: - 对外方法
extension Test_PageRoundScorllView {
    
    //设置轮播的view数组
    func setupViewArr(arr:[UIView]){
        if arr.count < 3 {
            let _ = self.subviews.map { $0.removeFromSuperview()}
            self.contentSize = .zero
            print("传入数组的个数少于3")
            return
        }
        for view in roundViewArr {
            view.removeFromSuperview()
        }
        roundViewArr.removeAll()
        roundViewArr = arr
        goRightArr()    //数组向右滚动一次
        self.contentSize = CGSize(width: self.bounds.width * CGFloat(roundViewArr.count), height: 0)
        for index in 0 ..< roundViewArr.count {
            let curView = roundViewArr[index]
            curView.tag = index + 1000 - 1
            curView.frame = self.bounds
            self.addSubview(curView)
            let positionX = self.bounds.width * CGFloat(index) + self.bounds.width * 0.5
            let positionY = curView.center.y
            curView.center = CGPoint(x: positionX,y: positionY)
        }
        roundViewArr.first?.tag = roundViewArr.count - 1 + 1000
        let startX = roundViewArr.count == 1 ? 0 : self.bounds.width
        self.contentOffset = CGPoint(x: startX,y: 0)
    }
    
    
    
    //向右滚动一页
    func goRight(){
        if isRounding || roundViewArr.isEmpty { return }
        isRounding = true
        let curX = self.contentOffset.x  + self.bounds.width
        let targetPoint = CGPoint(x: curX , y: 0)
        self.setContentOffset(targetPoint, animated: true)

//        if let lastView = roundViewArr.last {
//            goToLastPage(pageView: lastView)
//        }
        
    }
    
    //向左滚动一页
    func goLeft(){
        if isRounding || roundViewArr.isEmpty { return }
        isRounding = true
        let curX = self.contentOffset.x - self.bounds.width
        let targetPoint = CGPoint(x: curX , y: 0)
        self.setContentOffset(targetPoint, animated: true)
    }
    
}
